FROM rocker/r-ver:3.4.0
LABEL maintainer="jjchern"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
 && apt-get install -y git-core \
	libxml2-dev \
	make \
	pandoc \
	pandoc-citeproc
RUN ["install2.r", "-r 'https://cloud.r-project.org'", "bindrcpp", "labelled", "readxl", "stringr", "dplyr", "purrr", "tidyr", "tibble", "ggplot2", "tidyverse", "devtools", "Rcpp", "futile.logger", "cellranger", "plyr", "bindr", "futile.options", "forcats", "digest", "lubridate", "jsonlite", "memoise", "nlme", "gtable", "lattice", "pkgconfig", "rlang", "psych", "haven", "xml2", "httr", "withr", "knitr", "hms", "glue", "R6", "foreign", "lambda.r", "modelr", "reshape2", "magrittr", "scales", "assertthat", "mnormt", "colorspace", "stringi", "lazyeval", "munsell", "broom", "remotes"]
RUN ["installGithub.r", "tidyverse/readr@3ea8199", "jjchern/scorecard@71c177a", "hadley/rvest@9a51a5d"]
WORKDIR /payload/
CMD ["R"]
