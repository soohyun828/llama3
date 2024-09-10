#!/bin/bash

#SBATCH --job-name llama
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-gpu=12
#SBATCH --mem-per-gpu=60G
#SBATCH --time 4-00:00:0
#SBATCH --partition batch_ce_ugrad
#SBATCH -w moana-y6
#SBATCH -o /data/psh68380/repos/llama3/%A-%x.out
#SBATCH -e /data/psh68380/repos/llama3/%A-%x.err
echo $PWD
echo $SLURMD_NODENAME
current_time=$(date "+%Y%m%d-%H:%M:%S")

echo $current_time
export MASTER_PORT=12345
CUDA_VISIBLE_DEVICES="0,1"

torchrun --nproc_per_node 1 run_llama.py \
    --ckpt_dir Meta-Llama-3-8B-Instruct/ \
    --tokenizer_path Meta-Llama-3.1-8B-Instruct/tokenizer.model \
    --max_seq_len 1024 --max_batch_size 6

    
echo "Job finish"
exit 0