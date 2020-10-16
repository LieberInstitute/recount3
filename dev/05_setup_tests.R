## Setup test files

library("recount3")

## Create test dir
test_dir <- here::here("inst", "test_files")
dir.create(test_dir, showWarnings = FALSE)
bfc_test <- recount3_cache(test_dir)

create_rse_manual(project = "DRP002835", annotation = "ercc", bfc = bfc_test)
create_rse_manual(project = "DRP002835", annotation = "ercc", type = "exon", bfc = bfc_test)
