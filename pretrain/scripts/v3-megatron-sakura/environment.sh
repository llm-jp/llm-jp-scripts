#!/bin/bash
# Definitions of common environment variables.
# Usage: source environment.sh
set -euxo pipefail

export INSTALLER_PYTHON_VERSION=3.10.14
export INSTALLER_CUDA_VERSION_MAJOR=12
export INSTALLER_CUDA_VERSION_MINOR=1
export INSTALLER_CUDA_VERSION=$INSTALLER_CUDA_VERSION_MAJOR.$INSTALLER_CUDA_VERSION_MINOR
export INSTALLER_CUDNN_VERSION=8.9.4
export INSTALLER_HPCX_VERSION=2.17.1
export INSTALLER_NCCL_VERSION=2.20.5
export INSTALLER_PIP_VERSION=24.1.2
export INSTALLER_APEX_VERSION=24.04.01
export INSTALLER_FLASH_ATTENTION_VERSION=2.4.2
export INSTALLER_TRANSFORMER_ENGINE_VERSION=1.4
export INSTALLER_MEGATRON_TAG=nii-geniac
export INSTALLER_TOKENIZER_TAG=Release-ver3.0b1

module load cuda/$INSTALLER_CUDA_VERSION
module load /data/cudnn-tmp-install/modulefiles/$INSTALLER_CUDNN_VERSION
module load hpcx/${INSTALLER_HPCX_VERSION}-gcc-cuda${INSTALLER_CUDA_VERSION_MAJOR}/hpcx
module load nccl/$INSTALLER_NCCL_VERSION