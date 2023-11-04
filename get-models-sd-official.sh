#!/bin/false

# This file will be sourced in init.sh

# https://raw.githubusercontent.com/ai-dock/stable-diffusion-webui/main/config/provisioning/default.sh
printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"

function download() {
    wget -q --show-progress -e dotbytes="${3:-4M}" -O "$2" "$1"
}
disk_space=$(df --output=avail -m $WORKSPACE|tail -n1)
webui_dir=/opt/stable-diffusion-webui
models_dir=${webui_dir}/models
sd_models_dir=${models_dir}/Stable-diffusion
extensions_dir=${webui_dir}/extensions
cn_models_dir=${extensions_dir}/sd-webui-controlnet/models
vae_models_dir=${models_dir}/VAE
upscale_models_dir=${models_dir}/ESRGAN
lora_models_dir=${models_dir}/Lora

printf "Downloading extensions..."
cd $extensions_dir

# Controlnet
printf "Setting up Controlnet...\n"
if [[ -d sd-webui-controlnet ]]; then
    (cd sd-webui-controlnet && \
        git pull && \
        micromamba run -n webui ${PIP_INSTALL} -r requirements.txt
    )
else
    (git clone https://github.com/Mikubill/sd-webui-controlnet && \
         micromamba run -n webui ${PIP_INSTALL} -r sd-webui-controlnet/requirements.txt
    )
fi

if [[ $XPU_TARGET != "CPU" && $WEBUI_FLAGS != *"--use-cpu all"* ]]; then
    # Dreambooth
    printf "Setting up Dreambooth...\n"
    if [[ -d sd_dreambooth_extension ]]; then
        (cd sd_dreambooth_extension && \
            git pull && \
            micromamba run -n webui ${PIP_INSTALL} -r requirements.txt
        )
    else
        (git clone https://github.com/d8ahazard/sd_dreambooth_extension && \
            micromamba run -n webui ${PIP_INSTALL} -r sd_dreambooth_extension/requirements.txt
        )
    fi
fi

# Dynamic Prompts
printf "Setting up Dynamic Prompts...\n"
if [[ -d sd-dynamic-prompts ]]; then
    (cd sd-dynamic-prompts && git pull)
else
    git clone https://github.com/adieyal/sd-dynamic-prompts.git
    micromamba run -n webui ${PIP_INSTALL} -U \
        dynamicprompts[attentiongrabber,magicprompt]~=0.29.0 \
        send2trash~=1.8
fi

# Face Editor
printf "Setting up Face Editor...\n"
if [[ -d sd-face-editor ]]; then
    (cd sd-face-editor && git pull)
else
    git clone https://github.com/ototadana/sd-face-editor.git
fi

# cut off
printf "Setting up Cut Off...\n"
if [[ -d sd-cut-off ]]; then
    (cd sd-cut-off && git pull)
else
    git clone https://github.com/hnmr293/sd-webui-cutoff
fi

# Image Browser
printf "Setting up Image Browser...\n"
if [[ -d stable-diffusion-webui-images-browser ]]; then
    (cd stable-diffusion-webui-images-browser && git pull)
else
    git clone https://github.com/yfszzx/stable-diffusion-webui-images-browser
fi

# Regional Prompter
printf "Setting up Regional Prompter...\n"
if [[ -d sd-webui-regional-prompter ]]; then
    (cd sd-webui-regional-prompter && git pull)
else
    git clone https://github.com/hako-mikan/sd-webui-regional-prompter.git
fi

# Ultimate Upscale
printf "Setting up Ultimate Upscale...\n"
if [[ -d ultimate-upscale-for-automatic1111 ]]; then
    (cd ultimate-upscale-for-automatic1111 && git pull)
else
    git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111
fi

# ADetailer
printf "Setting up Adetailer...\n"
if [[ -d Adetailer ]]; then
    (cd Adetailer && git pull)
else
    git clone https://github.com/Bing-su/adetailer.git
fi

#openpose editor

printf "openpose-editor...\n"
if [[ -d openpose-editor ]]; then
    (cd openpose-editor && git pull)
else
    git clone https://github.com/fkunn1326/openpose-editor.git
fi

if [[ $disk_space -ge 25000 ]]; then
    # MajicMix_v7
    model_file=${sd_models_dir}/majicMIX_realistic.safetensors
    model_url=https://civitai.com/api/download/models/176425

    if [[ ! -e ${model_file} ]]; then
        printf "Downloading majicMIX_realistic...\n"
        wget -q -O ${model_file} ${model_url}
    fi

    # creampieElegance
    model_file=${lora_models_dir}/creampieElegance.safetensors
    model_url=https://civitai.com/api/download/models/152585

    if [[ ! -e ${model_file} ]]; then
        printf "Downloading creampieElegance LORA...\n"
        wget -q -O ${model_file} ${model_url}
    fi

    # creamipeAndHairyPussy
    model_file=${lora_models_dir}/creamipeAndHairyPussy.safetensors
    model_url=https://civitai.com/api/download/models/18077

    if [[ ! -e ${model_file} ]]; then
        printf "Downloading creamipeAndHairyPussy LORA...\n"
        wget -q -O ${model_file} ${model_url}
    fi

    # Pantyhose
    model_file=${lora_models_dir}/Pantyhose.safetensors
    model_url=https://civitai.com/api/download/models/113135

    if [[ ! -e ${model_file} ]]; then
        printf "Downloading Pantyhose LORA...\n"
        wget -q -O ${model_file} ${model_url}
    fi

    # nudePantyhose
    model_file=${lora_models_dir}/nudePantyhose.safetensors
    model_url=https://civitai.com/api/download/models/177649?type=Model&format=SafeTensor

    if [[ ! -e ${model_file} ]]; then
        printf "Downloading nudePantyhose LORA...\n"
        wget -q -O ${model_file} ${model_url}
    fi

    # tutu's HiSilk (Aurora 5D Black Pantyhose)
    model_file=${lora_models_dir}/Aurora_5D_black_pantyhose.safetensors
    model_url=https://civitai.com/api/download/models/116547

    if [[ ! -e ${model_file} ]]; then
        printf "Downloading Aurora 5D Black Pantyhose LORA...\n"
        wget -q -O ${model_file} ${model_url}
    fi

    # tutu's HiSilk (Alice 8D White Pantyhose)
    model_file=${lora_models_dir}/Alice_8d_white_pantyhose.safetensors
    model_url=https://civitai.com/api/download/models/116600

    if [[ ! -e ${model_file} ]]; then
        printf "Downloading Alice_8d_white_pantyhose LORA...\n"
        wget -q -O ${model_file} ${model_url}
    fi

    # maxidress
    model_file=${lora_models_dir}/badbromaxidress.safetensors
    model_url=https://civitai.com/api/download/models/77748?type=Model&format=SafeTensor

    if [[ ! -e ${model_file} ]]; then
        printf "Downloading maxidress LORA...\n"
        wget -q -O ${model_file} ${model_url}
    fi

    # Orgasming Face
    model_file=${lora_models_dir}/edgOrgasm_v2.safetensors
    model_url=https://civitai.com/api/download/models/138273

    if [[ ! -e ${model_file} ]]; then
        printf "Downloading Orgasming Face LORA...\n"
        wget -q -O ${model_file} ${model_url}
    fi


    # LEOSAM's Film Grain 
    model_file=${lora_models_dir}/FilGrain.safetensors
    model_url=https://civitai.com/api/download/models/112969?type=Model&format=SafeTensor

    if [[ ! -e ${model_file} ]]; then
        printf "Downloading LEOSAM's Film Grain LORA...\n"
        wget -q -O ${model_file} ${model_url}
    fi

    # LEOSAM's Polaroid Photo 
    model_file=${lora_models_dir}/Polaroid.safetensors
    model_url=https://civitai.com/api/download/models/102533?type=Model&format=SafeTensor

    if [[ ! -e ${model_file} ]]; then
        printf "Downloading Polaroid Photo LORA...\n"
        wget -q -O ${model_file} ${model_url}
    fi
else
        printf "\nSkipping extra models (disk < 30GB)\n"
fi
printf "Downloading a few pruned controlnet models...\n"

model_file=${cn_models_dir}/control_canny-fp16.safetensors
model_url=https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_canny-fp16.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Canny...\n"
    download ${model_url} ${model_file}
fi

model_file=${cn_models_dir}/control_depth-fp16.safetensors
model_url=https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_depth-fp16.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Depth...\n"
    download ${model_url} ${model_file}
fi

model_file=${cn_models_dir}/control_openpose-fp16.safetensors
model_url=https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_openpose-fp16.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Openpose...\n"
    download ${model_url} ${model_file}
fi

model_file=${cn_models_dir}/control_scribble-fp16.safetensors
model_url=https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_scribble-fp16.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading Scribble...\n"
    download ${model_url} ${model_file}
fi

printf "Downloading VAE...\n"

model_file=${vae_models_dir}/vae-ft-ema-560000-ema-pruned.safetensors
model_url=https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading vae-ft-ema-560000-ema...\n"
    download ${model_url} ${model_file}
fi

model_file=${vae_models_dir}/vae-ft-mse-840000-ema-pruned.safetensors
model_url=https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading vae-ft-mse-840000-ema...\n"
    download ${model_url} ${model_file}
fi

model_file=${vae_models_dir}/sdxl_vae.safetensors
model_url=https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors

if [[ ! -e ${model_file} ]]; then
    printf "Downloading sdxl_vae...\n"
    download ${model_url} ${model_file}
fi

printf "Downloading Upscalers...\n"

model_file=${upscale_models_dir}/4x_foolhardy_Remacri.pth
model_url=https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth

if [[ ! -e ${model_file} ]]; then
    printf "Downloading 4x_foolhardy_Remacri...\n"
    download ${model_url} ${model_file}
fi

model_file=${upscale_models_dir}/4x_NMKD-Siax_200k.pth
model_url=https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth

if [[ ! -e ${model_file} ]]; then
    printf "Downloading 4x_NMKD-Siax_200k...\n"
    download ${model_url} ${model_file}
fi

model_file=${upscale_models_dir}/RealESRGAN_x4.pth
model_url=https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth

if [[ ! -e ${model_file} ]]; then
    printf "Downloading RealESRGAN_x4...\n"
    download ${model_url} ${model_file}
fi

printf "\nProvisioning complete:  Web UI will start now\n\n"


