FROM rocker/r-ver:3.4.0
LABEL maintainer="jjchern"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
 && apt-get install -y git-core \
	libxml2-dev \
	make
RUN ["install2.r", "-r 'https://cloud.r-project.org'", "labelled", "readxl", "stringr", "bindrcpp", "dplyr", "purrr", "tidyr", "tibble", "ggplot2", "tidyverse", "devtools", "remotes", "reshape2", "haven", "lattice", "colorspace", "rlang", "foreign", "glue", "withr", "modelr", "lambda.r", "bindr", "plyr", "munsell", "gtable", "cellranger", "futile.logger", "psych", "memoise", "forcats", "highlight", "broom", "Rcpp", "scales", "jsonlite", "mnormt", "rjson", "hms", "digest", "stringi", "magrittr", "lazyeval", "futile.options", "pkgconfig", "xml2", "lubridate", "rstudioapi", "assertthat", "httr", "R6", "nlme"]
RUN ["installGithub.r", "tidyverse/readr@3ea8199", "hadley/rvest@9a51a5d"]
WORKDIR /payload/
CMD ["R"]
