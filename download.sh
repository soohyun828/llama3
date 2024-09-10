#!/bin/bash

# Copyright (c) Meta Platforms, Inc. and affiliates.
# This software may be used and distributed according to the terms of the Llama 2 Community License Agreement.

####
## NOTE: For downloading Llama 3.1 please refer to https://github.com/meta-llama/llama-models/tree/main/models/llama3_1#download
####

# set -e

# read -p "Enter the URL from email: " PRESIGNED_URL
# echo ""
# read -p "Enter the list of models to download without spaces (8B,8B-instruct,70B,70B-instruct), or press Enter for all: " MODEL_SIZE
# TARGET_FOLDER="."             # where all files should end up
# mkdir -p ${TARGET_FOLDER}

# if [[ $MODEL_SIZE == "" ]]; then
#     MODEL_SIZE="8B,8B-instruct,70B,70B-instruct"
# fi

# echo "Downloading LICENSE and Acceptable Usage Policy"
# wget --continue ${PRESIGNED_URL/'*'/"LICENSE"} -O ${TARGET_FOLDER}"/LICENSE"
# wget --continue ${PRESIGNED_URL/'*'/"USE_POLICY"} -O ${TARGET_FOLDER}"/USE_POLICY"

# for m in ${MODEL_SIZE//,/ }
# do
#     if [[ $m == "8B" ]] || [[ $m == "8b" ]]; then
#         SHARD=0
#         MODEL_FOLDER_PATH="Meta-Llama-3-8B"
#         MODEL_PATH="8b_pre_trained"
#     elif [[ $m == "8B-instruct" ]] || [[ $m == "8b-instruct" ]] || [[ $m == "8b-Instruct" ]] || [[ $m == "8B-Instruct" ]]; then
#         SHARD=0
#         MODEL_FOLDER_PATH="Meta-Llama-3-8B-Instruct"
#         MODEL_PATH="8b_instruction_tuned"
#     elif [[ $m == "70B" ]] || [[ $m == "70b" ]]; then
#         SHARD=7
#         MODEL_FOLDER_PATH="Meta-Llama-3-70B"
#         MODEL_PATH="70b_pre_trained"
#     elif [[ $m == "70B-instruct" ]] || [[ $m == "70b-instruct" ]] || [[ $m == "70b-Instruct" ]] || [[ $m == "70B-Instruct" ]]; then
#         SHARD=7
#         MODEL_FOLDER_PATH="Meta-Llama-3-70B-Instruct"
#         MODEL_PATH="70b_instruction_tuned"
#     fi

#     echo "Downloading ${MODEL_PATH}"
#     mkdir -p ${TARGET_FOLDER}"/${MODEL_FOLDER_PATH}"

#     for s in $(seq -f "0%g" 0 ${SHARD})
#     do
#         wget --continue ${PRESIGNED_URL/'*'/"${MODEL_PATH}/consolidated.${s}.pth"} -O ${TARGET_FOLDER}"/${MODEL_FOLDER_PATH}/consolidated.${s}.pth"
#     done

#     wget --continue ${PRESIGNED_URL/'*'/"${MODEL_PATH}/params.json"} -O ${TARGET_FOLDER}"/${MODEL_FOLDER_PATH}/params.json"
#     wget --continue ${PRESIGNED_URL/'*'/"${MODEL_PATH}/tokenizer.model"} -O ${TARGET_FOLDER}"/${MODEL_FOLDER_PATH}/tokenizer.model"
#     wget --continue ${PRESIGNED_URL/'*'/"${MODEL_PATH}/checklist.chk"} -O ${TARGET_FOLDER}"/${MODEL_FOLDER_PATH}/checklist.chk"
#     echo "Checking checksums"
#     CPU_ARCH=$(uname -m)
#     if [[ "$CPU_ARCH" == "arm64" ]]; then
#       (cd ${TARGET_FOLDER}"/${MODEL_FOLDER_PATH}" && md5 checklist.chk)
#     else
#       (cd ${TARGET_FOLDER}"/${MODEL_FOLDER_PATH}" && md5sum -c checklist.chk)
#     fi
# done



########################## llama 3.1 ############################
#!/usr/bin/env bash

# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the terms described in the LICENSE file in
# top-level folder for each specific model found within the models/ directory at
# the top-level of this source tree.

# Copyright (c) Meta Platforms, Inc. and affiliates.
# This software may be used and distributed according to the terms of the Llama 3.1 Community License Agreement.

set -e

read -p "Enter the URL from email: " PRESIGNED_URL
ALL_MODELS_LIST="meta-llama-3.1-405b,meta-llama-3.1-70b,meta-llama-3.1-8b,meta-llama-guard-3-8b,prompt-guard"
printf "\n **** Model list ***\n"
for MODEL in ${ALL_MODELS_LIST//,/ }
do
    printf " -  ${MODEL}\n"
done
read -p "Choose the model to download: " SELECTED_MODEL
printf "\n Selected model: ${SELECTED_MODEL} \n"

SELECTED_MODELS=""
if [[ $SELECTED_MODEL == "meta-llama-3.1-405b" ]]; then
    MODEL_LIST="meta-llama-3.1-405b-instruct-mp16,meta-llama-3.1-405b-instruct-mp8,meta-llama-3.1-405b-instruct-fp8,meta-llama-3.1-405b-mp16,meta-llama-3.1-405b-mp8,meta-llama-3.1-405b-fp8"
elif [[ $SELECTED_MODEL == "meta-llama-3.1-70b" ]]; then
    MODEL_LIST="meta-llama-3.1-70b-instruct,meta-llama-3.1-70b"
elif [[ $SELECTED_MODEL == "meta-llama-3.1-8b" ]]; then
    MODEL_LIST="meta-llama-3.1-8b-instruct,meta-llama-3.1-8b"
elif [[ $SELECTED_MODEL == "meta-llama-guard-3-8b" ]]; then
    MODEL_LIST="meta-llama-guard-3-8b-int8-hf,meta-llama-guard-3-8b"
elif [[ $SELECTED_MODEL == "prompt-guard" ]]; then
    SELECTED_MODELS="prompt-guard"
    MODEL_LIST=""
fi

if [[ -z "$SELECTED_MODELS" ]]; then
    printf "\n **** Available models to download: ***\n"
    for MODEL in ${MODEL_LIST//,/ }
    do
        printf " -  ${MODEL}\n"
    done
    read -p "Enter the list of models to download without spaces or press Enter for all: " SELECTED_MODELS
fi

TARGET_FOLDER="."             # where all files should end up
mkdir -p ${TARGET_FOLDER}

if [[ $SELECTED_MODELS == "" ]]; then
    SELECTED_MODELS=${MODEL_LIST}
fi

printf "Downloading LICENSE and Acceptable Usage Policy\n"
wget --continue ${PRESIGNED_URL/'*'/"LICENSE"} -O ${TARGET_FOLDER}"/LICENSE"
wget --continue ${PRESIGNED_URL/'*'/"USE_POLICY.md"} -O ${TARGET_FOLDER}"/USE_POLICY.md"

for m in ${SELECTED_MODELS//,/ }
do

    ADDITIONAL_FILES=""
    TOKENIZER_MODEL=1
    PTH_FILE_CHUNK_COUNT=0
    if [[ $m == "meta-llama-3.1-405b-instruct-mp16" ]]; then
        PTH_FILE_COUNT=15
        PTH_FILE_CHUNK_COUNT=2
        MODEL_PATH="Meta-Llama-3.1-405B-Instruct-MP16"
    elif [[ $m == "meta-llama-3.1-405b-instruct-mp8" ]]; then
        PTH_FILE_COUNT=7
        PTH_FILE_CHUNK_COUNT=4
        MODEL_PATH="Meta-Llama-3.1-405B-Instruct-MP8"
    elif [[ $m == "meta-llama-3.1-405b-instruct-fp8" ]]; then
        PTH_FILE_COUNT=7
        PTH_FILE_CHUNK_COUNT=3
        MODEL_PATH="Meta-Llama-3.1-405B-Instruct"
        ADDITIONAL_FILES="fp8_scales_0.pt,fp8_scales_1.pt,fp8_scales_2.pt,fp8_scales_3.pt,fp8_scales_4.pt,fp8_scales_5.pt,fp8_scales_6.pt,fp8_scales_7.pt"
    elif [[ $m == "meta-llama-3.1-405b-mp16" ]]; then
        PTH_FILE_COUNT=15
        PTH_FILE_CHUNK_COUNT=2
        MODEL_PATH="Meta-Llama-3.1-405B-MP16"
    elif [[ $m == "meta-llama-3.1-405b-mp8" ]]; then
        PTH_FILE_COUNT=7
        PTH_FILE_CHUNK_COUNT=4
        MODEL_PATH="Meta-Llama-3.1-405B-MP8"
    elif [[ $m == "meta-llama-3.1-405b-fp8" ]]; then
        PTH_FILE_COUNT=7
        PTH_FILE_CHUNK_COUNT=3
        MODEL_PATH="Meta-Llama-3.1-405B"
        ADDITIONAL_FILES="fp8_scales_0.pt,fp8_scales_1.pt,fp8_scales_2.pt,fp8_scales_3.pt,fp8_scales_4.pt,fp8_scales_5.pt,fp8_scales_6.pt,fp8_scales_7.pt"
    elif [[ $m == "meta-llama-3.1-70b-instruct" ]]; then
        PTH_FILE_COUNT=7
        MODEL_PATH="Meta-Llama-3.1-70B-Instruct"
    elif [[ $m == "meta-llama-3.1-70b" ]]; then
        PTH_FILE_COUNT=7
        MODEL_PATH="Meta-Llama-3.1-70B"
    elif [[ $m == "meta-llama-3.1-8b-instruct" ]]; then
        PTH_FILE_COUNT=0
        MODEL_PATH="Meta-Llama-3.1-8B-Instruct"
    elif [[ $m == "meta-llama-3.1-8b" ]]; then
        PTH_FILE_COUNT=0
        MODEL_PATH="Meta-Llama-3.1-8B"
    elif [[ $m == "meta-llama-guard-3-8b-int8-hf" ]]; then
        PTH_FILE_COUNT=-1
        MODEL_PATH="Meta-Llama-Guard-3-8B-INT8-HF"
        ADDITIONAL_FILES="generation_config.json,model-00001-of-00002.safetensors,model-00002-of-00002.safetensors,model.safetensors.index.json,special_tokens_map.json,tokenizer_config.json,tokenizer.json"
        TOKENIZER_MODEL=0
    elif [[ $m == "meta-llama-guard-3-8b" ]]; then
        PTH_FILE_COUNT=0
        MODEL_PATH="Meta-Llama-Guard-3-8B"
    elif [[ $m == "prompt-guard" ]]; then
        PTH_FILE_COUNT=-1
        MODEL_PATH="Prompt-Guard"
        ADDITIONAL_FILES="model.safetensors,special_tokens_map.json,tokenizer_config.json,tokenizer.json"
        TOKENIZER_MODEL=0
    fi

    printf "\n***Downloading ${MODEL_PATH}***\n"
    mkdir -p ${TARGET_FOLDER}"/${MODEL_PATH}"

    if [[ $TOKENIZER_MODEL == 1 ]]; then
        printf "Downloading tokenizer\n"
        wget --continue ${PRESIGNED_URL/'*'/"${MODEL_PATH}/tokenizer.model"} -O ${TARGET_FOLDER}"/${MODEL_PATH}/tokenizer.model"
    fi

    if [[ $PTH_FILE_COUNT -ge 0 ]]; then
        for s in $(seq -f "%02g" 0 ${PTH_FILE_COUNT})
        do
            printf "Downloading consolidated.${s}.pth\n"
            if [[ $PTH_FILE_CHUNK_COUNT -gt 0 ]]; then
                start=0
                chunk_size=27000000001
                for chunk_count in $(seq 1 $PTH_FILE_CHUNK_COUNT)
                do
                    end=$((start+chunk_size-1))
                    curl ${PRESIGNED_URL/'*'/"${MODEL_PATH}/consolidated.${s}.pth"} -o ${TARGET_FOLDER}"/${MODEL_PATH}/part.${chunk_count}.pth" -H "range: bytes=${start}-${end}"
                    cat ${TARGET_FOLDER}"/${MODEL_PATH}/part.${chunk_count}.pth" >> ${TARGET_FOLDER}"/${MODEL_PATH}/consolidated.${s}.pth"
                    rm ${TARGET_FOLDER}"/${MODEL_PATH}/part.${chunk_count}.pth"
                    start=$((end+1))
                done
            else
                wget --continue ${PRESIGNED_URL/'*'/"${MODEL_PATH}/consolidated.${s}.pth"} -O ${TARGET_FOLDER}"/${MODEL_PATH}/consolidated.${s}.pth"
            fi
        done
    fi

    for ADDITIONAL_FILE in ${ADDITIONAL_FILES//,/ }
    do
        printf "Downloading $ADDITIONAL_FILE...\n"
        wget --continue ${PRESIGNED_URL/'*'/"${MODEL_PATH}/${ADDITIONAL_FILE}"} -O ${TARGET_FOLDER}"/${MODEL_PATH}/${ADDITIONAL_FILE}"
    done

    if [[ $m != "prompt-guard" &&  $m != "meta-llama-guard-3-8b-int8-hf" ]]; then
        printf "Downloading params.json...\n"
        wget --continue ${PRESIGNED_URL/'*'/"${MODEL_PATH}/params.json"} -O ${TARGET_FOLDER}"/${MODEL_PATH}/params.json"
    fi
done