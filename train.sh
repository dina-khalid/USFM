#!/bin/bash

#SBATCH --job-name=usfm_ft_fold0
#SBATCH --account=st-ilker-1-gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --gpus=2
#SBATCH --mem=64G
#SBATCH --time=2-00:00:00
#SBATCH --mail-user=sdina@student.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --output=usfm_thyroid_fold0_%j.out
#SBATCH --error=usfm_thyroid_fold0_%j.err


echo "=== Loading USFM environment ==="
source /home/sdina/miniconda3/etc/profile.d/conda.sh
conda activate USFMM
echo "=== Environment loaded ==="

echo "ACTIVE ENV: $CONDA_DEFAULT_ENV"
echo "Python path: $(which python)"
python -V



##############################
### USFM TRAINING SETTINGS ###
##############################

export batch_size=1
export num_workers=4
export devices=2
export dataset=Thyroid_USFM_fold0
export epochs=400
export pretrained_path=/home/sdina/dinascratch/USFM/USFM_latest.pth
export task=Seg
export model=Seg/SegVit

echo "=== Starting USFM fine-tuning on dataset: $dataset ==="

python main.py \
    experiment=task/$task \
    data=Seg/$dataset \
    data="{batch_size:$batch_size, num_workers:$num_workers}" \
    model=$model \
    model.model_cfg.backbone.pretrained=$pretrained_path \
    train="{epochs:$epochs, accumulation_steps:1}" \
    L="{devices:$devices}" \
    tag=USFM

echo "=== Training completed ==="
