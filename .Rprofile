if (file.exists("~/.Rprofile") && interactive()) {
  source("~/.Rprofile") # always still source user .Rprofile
}

is_linux <- function() {
  R.version$platform == "x86_64-pc-linux-gnu" &&
    R.version$arch == "x86_64" &&
    R.version$os == "linux-gnu"
}

set_rspm <- function(snapshot = "latest") {
  if (is_linux()) {
    user_agent <- paste(
      getRversion(),
      R.version$platform,
      R.version$arch,
      R.version$os
    )
    # Set the default HTTP user agent
    options(
      HTTPUserAgent = sprintf(
        "R/%s R (%s)", getRversion(),
        user_agent
      ),
      download.file.extra = sprintf(
        "--header \"User-Agent: R (%s)\"",
        user_agent
      ),
      repos = paste0(
        "https://packagemanager.rstudio.com/all/__linux__/bionic/",
        snapshot
      )
    )
  } else {
    options(
      repos = paste0(
        "https://packagemanager.rstudio.com/all/",
        snapshot
      )
    )
  }
}
# snapshot number freezes the package versions
set_rspm(snapshot = 279)

message("Loaded project .Rprofile...")
