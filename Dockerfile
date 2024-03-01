FROM ubuntu

RUN useradd --create-home -G sudo,video --shell /bin/bash rocm-user

RUN apt-get update -y && apt-get install ffmpeg -y 

RUN apt-get update && apt-get install wget git -y
RUN wget https://repo.radeon.com/amdgpu-install/6.0.2/ubuntu/jammy/amdgpu-install_6.0.60002-1_all.deb
RUN apt-get install ./amdgpu-install_6.0.60002-1_all.deb -y
RUN amdgpu-install -y --accept-eula --no-dkms --usecase=rocm
RUN apt-get install rocm -y
RUN apt-get update -y
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone https://github.com/facebookresearch/audiocraft.git && \
    chown rocm-user:rocm-user -R /opt/audiocraft
WORKDIR /opt/audiocraft

USER rocm-user

COPY scripts/requirements.txt requirements.txt
RUN pip install lmdb 
RUN pip install -r requirements.txt --extra-index-url https://download.pytorch.org/whl/rocm5.6

RUN mkdir .cache
RUN export AUDIOCRAFT_CACHE_DIR=/opt/audiocraft/.cache

USER root
COPY scripts/start.sh start.sh
RUN chmod +x start.sh

USER rocm-user

EXPOSE 7860

CMD [ "./start.sh" ]