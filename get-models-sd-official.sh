#!/bin/false

# This file will be sourced in init.sh

# https://raw.githubusercontent.com/ai-dock/stable-diffusion-webui/main/config/provisioning/get-models-sd-official.sh

# Download Stable Diffusion official models

models_dir=/opt/stable-diffusion-webui/models
checkpoints_dir=${models_dir}/Stable-diffusion

# MajicMix_v7
model_file=${checkpoints_dir}/majicMIX_realistic.safetensors
model_url=https://civitai.com/api/download/models/176425

if [[ ! -e ${model_file} ]]; then
    printf "Downloading majicMIX_realistic...\n"
    wget -q -O ${model_file} ${model_url}
fi

# creampieElegance
model_file=${checkpoints_dir}/creampieElegance.safetensors
model_url=https://civitai.com/api/download/models/152585

if [[ ! -e ${model_file} ]]; then
    printf "Downloading creampieElegance LORA...\n"
    wget -q -O ${model_file} ${model_url}
fi

# creamipeAndHairyPussy
model_file=${checkpoints_dir}/creamipeAndHairyPussy.safetensors
model_url=https://civitai.com/api/download/models/18077

if [[ ! -e ${model_file} ]]; then
    printf "Downloading creamipeAndHairyPussy LORA...\n"
    wget -q -O ${model_file} ${model_url}
fi

# Pantyhose
model_file=${checkpoints_dir}/Pantyhose.safetensors
model_url=https://civitai.com/api/download/models/113135

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Pantyhose LORA...\n"
    wget -q -O ${model_file} ${model_url}
fi

# nudePantyhose
model_file=${checkpoints_dir}/nudePantyhose.safetensors
model_url=https://civitai.com/api/download/models/177649?type=Model&format=SafeTensor

if [[ ! -e ${model_file} ]]; then
    printf "Downloading nudePantyhose LORA...\n"
    wget -q -O ${model_file} ${model_url}
fi

