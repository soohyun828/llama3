from llama import Llama
import argparse

# Copyright (c) Meta Platforms, Inc. and affiliates.
# This software may be used and distributed in accordance with the terms of the Llama 3 Community License Agreement.

from typing import List

import fire

from llama import Llama


def main(
    ckpt_dir: str,
    tokenizer_path: str,
    temperature: float = 0.7,
    top_p: float = 0.9,
    max_seq_len: int = 128,
    max_gen_len: int = 64,
    max_batch_size: int = 4,
):

    generator = Llama.build(
        # ckpt_dir=args.ckpt_dir,
        # tokenizer_path=args.tokenizer_path,
        ckpt_dir = "Meta-Llama-3-8B-Instruct",
        tokenizer_path = "Meta-Llama-3-8B-Instruct/tokenizer.model",
        max_seq_len=max_seq_len,
        max_batch_size=max_batch_size,
    )

    prompts: List[str] = [
        # For these prompts, the expected answer is the natural continuation of the prompt
        f"Please give me a long list of descriptors for action: air drumming, 4 descriptors in total.",
        "Spatio Descriptors are intended to capture static visual elements that can be discerned from a single image—such as settings and common objects.",
    ]
    results = generator.text_completion(
        prompts,
        max_gen_len=max_gen_len,
        temperature=temperature,
        top_p=top_p,
    )
    for prompt, result in zip(prompts, results):
        print(prompt)
        print(f"> {result['generation']}")
        print("\n==================================\n")


if __name__ == "__main__":
    # parser = argparse.ArgumentParser()
    # parser.add_argument("--ckpt_dir", type=str, default="Meta-Llama-3-8B-Instruct")
    # parser.add_argument("--tokenizer_path", type=str, default="Meta-Llama-3-8B-Instruct/tokenizer.model")
    # parser.add_argument("--label_file", type=str, default="/data/psh68380/repos/Video-CBM_/data/kinetics400_classes.txt")
    # parser.add_argument("--answers_file", type=str, default="/data/psh68380/repos/LLaVA/GPT_result")
    # parser.add_argument("--N_s", type=int, default=4, choices=[2, 4, 8])
    # parser.add_argument("--descriptor_type", choices=['spatio', 'temporal'], type=str, default="spatio")
    # args = parser.parse_args()
    fire.Fire(main)
    
    