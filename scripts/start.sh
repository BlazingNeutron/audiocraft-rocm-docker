#!/bin/bash
export HSA_OVERRIDE_GFX_VERSION=11.0.0
export CUDA_VISIBLE_DEVICES=0
export AUDIOCRAFT_CACHE_DIR=/opt/audiocraft/.cache
python3 -m demos.musicgen_app