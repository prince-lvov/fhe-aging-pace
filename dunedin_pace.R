devtools::install_github("danbelsky/DunedinPACE", build_vignettes = FALSE)
library(DunedinPACE)

beta_raw <- read.table("data/GSE40279_average_beta.txt", header = TRUE, row.names = 1)
betas_full <- as.matrix(beta_raw)
betas_required <- betas_full[rownames(betas_full) %in% unlist(mPACE_Models$gold_standard_probes), , drop=FALSE]
pace <- PACEProjector(betas_required)

write.table(pace$DunedinPACE, file = "pace_original_dunedin.csv", col.names = FALSE, sep=";")