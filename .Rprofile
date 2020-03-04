local({
  r <- getOption("repos")
  # pre-build binaries for linux, frozen to 2020-02-27
  r["RSPM_BIN"] <- "https://demo.rstudiopm.com/all/__linux__/bionic/2759"
  # fallback, same snapshot but only source
  r["RSPM_SOURCE"] <- "https://demo.rstudiopm.com/all/2759"
  r["MRAN"] <- "https://cran.microsoft.com/snapshot/2020-02-27/"
  options(repos = r)
})
