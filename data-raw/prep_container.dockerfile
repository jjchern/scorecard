FROM rocker/r-ver:3.4.1
LABEL maintainer="jjchern"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
 && apt-get install -y git-core \
	libcurl4-openssl-dev \
	libssl-dev \
	libxml2-dev \
	make \
	pandoc \
	pandoc-citeproc \
	zlib1g-dev
RUN ["install2.r", "-r 'https://cloud.r-project.org'", "devtools", "labelled", "readxl", "glue", "stringr", "bindrcpp", "rex", "rlang", "dplyr", "purrr", "tidyr", "tibble", "ggplot2", "tidyverse", "remotes", "reshape2", "haven", "lattice", "colorspace", "foreign", "withr", "lambda.r", "modelr", "bindr", "plyr", "futile.logger", "munsell", "gtable", "cellranger", "psych", "memoise", "knitr", "forcats", "curl", "highr", "broom", "Rcpp", "scales", "jsonlite", "mnormt", "rjson", "hms", "digest", "stringi", "magrittr", "lazyeval", "futile.options", "pkgconfig", "xml2", "lubridate", "assertthat", "httr", "rstudioapi", "R6", "nlme", "git2r"]
RUN ["installGithub.r", "tidyverse/readr@3ea8199", "hadley/rvest@9a51a5d"]
WORKDIR /payload/
CMD ["R"]
