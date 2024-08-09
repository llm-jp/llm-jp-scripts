#!/bin/bash
# Model conversion script for converting Megatron format checkpoints into Huggingface format
#
# Usage:
# On a cluster with SLURM:
#   Run `sbatch --partition {partition} convert.sh SOURCE_DIR TARGET_DIR`
# On a cluster without SLURM:
#   Run `bash convert.sh SOURCE_DIR TARGET_DIR TEMPORAL_DIR > logs/convert.out 2> logs/convert.err`
# - SOURCE_DIR: Megatron checkpoint directory including `iter_NNNNNNN`
# - TARGET_DIR: Output directory for the Hugging Face format
#
# This script requires 1 node on the `gpu` partition on the cluster.

#SBATCH --job-name=ckpt-convert
#SBATCH --partition=<FIX_ME>
#SBATCH --nodes=1
#SBATCH --gpus=1
#SBATCH --ntasks-per-node=8
#SBATCH --output=logs/%x-%j.out
#SBATCH --error=logs/%x-%j.err

set -e

MEGATRON_CHECKPOINT_DIR=${1%/}
HF_CHECKPOINT_DIR=$2

ENV_DIR=environment

source ${ENV_DIR}/scripts/environment.sh
source ${ENV_DIR}/venv/bin/activate

TOKENIZER_MODEL_DIR=${ENV_DIR}/src/llm-jp-tokenizer/hf/ver3.0/llm-jp-tokenizer-100k.ver3.0b2

ITER=$(echo $MEGATRON_CHECKPOINT_DIR | grep -oP 'iter_\K[0-9]+' | sed 's/^0*//')
if [[ -z "$ITER" || ! "$ITER" =~ ^[0-9]+$ ]]; then
  echo "Error: ITER is not a valid number. Exiting."
  exit 1
fi
FORMATTED_ITERATION=$(printf "%07d" $ITER)

TMP_DIR=${HOME}/ckpt_convert_$(date +%Y%m%d%H%M%S)
mkdir -p "${TMP_DIR}"
ln -s $(readlink -f $MEGATRON_CHECKPOINT_DIR) ${TMP_DIR}/iter_${FORMATTED_ITERATION}
echo $ITER > "${TMP_DIR}/latest_checkpointed_iteration.txt"

echo "Converting $MEGATRON_CHECKPOINT_DIR"

python ${ENV_DIR}/src/Megatron-LM/tools/checkpoint/convert.py \
  --model-type GPT \
  --loader mcore \
  --saver llama2_hf \
  --load-dir $TMP_DIR \
  --save-dir $HF_CHECKPOINT_DIR \
  --hf-tokenizer-path $TOKENIZER_MODEL_DIR \
  --save-dtype bfloat16 \
  --loader-transformer-impl "transformer_engine" \
  --megatron-path ${ENV_DIR}/src/Megatron-LM

cp ${TOKENIZER_MODEL_DIR}/* $HF_CHECKPOINT_DIR

rm -r $TMP_DIR
echo "Done"