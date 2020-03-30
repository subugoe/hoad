local({
  # this keeps whatever is already listed in repos, in case any are set
  r <- getOption("repos")
  # these are set by cross-platform checks
  r["RSPM"] <- Sys.getenv("RSPM")
  r["CRAN"] <- Sys.getenv("CRAN")
  # pre-build binaries for linux, frozen to 2020-03-23
  r["RSPM_BIN"] <- "https://demo.rstudiopm.com/all/__linux__/bionic/3055"
  # fallback, same snapshot but only source
  r["RSPM_SOURCE"] <- "https://demo.rstudiopm.com/all/3055"
  r["MRAN"] <- "https://cran.microsoft.com/snapshot/2020-03-23/"
  options(repos = r)
})
