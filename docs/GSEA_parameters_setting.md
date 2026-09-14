# GSEA parameters setting

The enrichment analysis was performed for both **age_GSEA.rnk** and **biological_sex_GSEA.rnk**. Specifically, a *pre-ranked GSEA* was performed because the input files were already ranked.

The analysis was run separately using the following four gene sets:
- c2.cp.biocarta.v2026.1.Hs.symbols.gmt
- c5.go.bp.v2026.1.Hs.symbols.gmt
- h.all.v2026.1.Hs.symbols.gmt
- c2.cp.kegg_legacy.v2026.1.Hs.symbols.gmt


with the following parameters:

- Collapse/Remap to gene symbols: No_Collapse
- Collapsing mode for probe set => 1 gene: Abs_max_of_probes

All the other parameters were left at their default settings.