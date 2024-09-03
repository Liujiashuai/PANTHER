#!/bin/bash

gpuid=$1

# declare -a project_names=('GTEx-Normal_part_1' 'GTEx-Normal_part_10' 'GTEx-Normal_part_2' 'GTEx-Normal_part_3' 
#                  'GTEx-Normal_part_4' 'GTEx-Normal_part_5' 'GTEx-Normal_part_6' 'GTEx-Normal_part_7' 
#                  'GTEx-Normal_part_8' 'GTEx-Normal_part_9' 'TCGA-BLCA' 'TCGA-BR' 'TCGA-CESC' 'TCGA-COAD' 
#                  'TCGA-GBM' 'TCGA-HNSC' 'TCGA-LGG' 'TCGA-LIHC' 'TCGA-LUNG' 'TCGA-OV' 'TCGA-PRAD' 'TCGA-RCC')

declare -a project_names=('TCGA-THCA' 'TCGA-SARC' 'TCGA-LUAD' 'TCGA-LUSC' 
						'TCGA-BRCA' 'TCGA-BLCA' 'TCGA-PRAD' 'TCGA-STAD' 
						'TCGA-OV' 'TCGA-HNSC' 'TCGA-UCEC' 'TCGA-LIHC' 
						'TCGA-CESC' 'TCGA-SKCM' 'TCGA-GBM' 'TCGA-KIRC' 
						'TCGA-KIRP' 'TCGA-KICH' 'TCGA-LGG' 'TCGA-COAD' 
						'TCGA-ACC' 'TCGA-MESO' 'TCGA-PCPG' 'TCGA-CHOL' 
						'TCGA-UCS' 'TCGA-TGCT' 'TCGA-ESCA' 'TCGA-PAAD' 
						'TCGA-THYM' 'TCGA-READ' 'TCGA-UVM' 'TCGA-DLBC')

declare -a feat_paths=('TCGA-THCA' 'TCGA-SARC' 'TCGA-LUNG' 'TCGA-LUNG' 
						'TCGA-BR' 'TCGA-BLCA' 'TCGA-PRAD' 'TCGA-STAD' 
						'TCGA-OV' 'TCGA-HNSC' 'TCGA-UCEC' 'TCGA-LIHC' 
						'TCGA-CESC' 'TCGA-SKCM' 'TCGA-GBM' 'TCGA-RCC' 
						'TCGA-RCC' 'TCGA-RCC' 'TCGA-LGG' 'TCGA-COAD' 
						'TCGA-Rest' 'TCGA-Rest' 'TCGA-Rest' 'TCGA-Rest' 
						'TCGA-Rest' 'TCGA-Rest' 'TCGA-Rest' 'TCGA-Rest' 
						'TCGA-Rest' 'TCGA-Rest' 'TCGA-Rest' 'TCGA-Rest')			

# Loop through different folds
for i in "${!project_names[@]}"; do
	project_name="${project_names[$i]}"
	feat_name="${feat_paths[$i]}"
	split_dir="GTEx-TCGA-class/${project_name}"
	split_names="train"
    dataroot=("/data_nas2/pxb/CNX-PathLLM/GTEx-TCGA-Embeddings/${feat_name}")
	bash "./scripts/prototype/clustering.sh" $gpuid $split_dir $split_names "${dataroot[@]}"
done