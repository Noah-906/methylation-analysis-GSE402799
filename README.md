# GSE40279
## DNA Methylation Analysis Pipeline


Analysis pipeline for the GSE40279 dataset, covering data download, preprocessing, normalization, differential methylation analysis and gene set enrichment analysis (GSEA) in relation to age and biological sex.

# Repository structure

```
.
├── README.md
├── scripts/
│   ├── beta_values_download.sh
│   ├── ...
│   └── (20 script files)
└── docs/
    ├── GSEA_parameters_setting.md
    └── index.html
```
  > **Note:** `index.html` is the flowchart of the pipeline.

# Pipeline

| Step | Description | Script |
|---|---|---|
| 1 | Beta values download from GEO portal and unzipping | `01_beta_values_download.sh` |
| 2 | Plotting beta values (beta values overview) | `02_beta_values_overview.R` |
| 3 | Manifest download and overview | `03_manifest_dowload.sh` |
| 4 | Load manifest in R to check how it behaves | `04_load_manifest.R` |
| 5 | Conversion table download (thought it was useful, turned out it was not) | `05_conversion_table_download.sh` |
| 6 | Age extraction | `06_age_extraction.sh` |
| 7 | Adjusting age table | `07_adjusting_age_table.R` |
| 8 | Plotting age distribution | `08_age_distribution.R` |
| 9 | Remove XX and XY probes | `09_remove_XX_XY_probes.R` |
| 10 | Check betas before BMIQ normalization | `10_check_betas_before_normalization.R` |
| 11 | BMIQ normalization | `11_probe_normalization.R` |
| 12 | Check betas after BMIQ normalization | `12_check_betas_after_normalization.R` |
| 13 | Biological sex and ethnicity extraction | `13_biological_sex_and_ethnicity_extraction.sh` |
| 14 | Generating a phenotype table with sample ID, age, biological sex and ethnicity | `14_phenotype_table.R` |
| 15 | Limma analysis (~ age + biological sex) | `15_limma_analysis.R` |
| 16 | Annotation update of results_age.rds and results_biological_sex.rds | `16_limma_results_annotation_updates.R` |
| 17 | Volcano plots of results_age.rds and results_biological_sex.rds | `17_volcano_plots_limma_results.R` |
| 18 | Violin plots | `18_violin_plots.R` |
| 19 | ANOVA and Tukey's HSD test | `19_anova_and_Tukey_HSD.R` |
| 20 | GSEA data preparation | `20_gsea_data_preparation.R` |