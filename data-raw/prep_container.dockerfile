FROM rocker/r-ver:3.4.0
LABEL maintainer="jjchern"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
 && apt-get install -y git-core \
	libxml2-dev \
	make \
	pandoc \
	pandoc-citeproc
RUN ["install2.r", "-r 'https://cloud.r-project.org'", "bindrcpp", "labelled", "readxl", "stringr", "dplyr", "purrr", "tidyr", "tibble", "ggplot2", "tidyverse", "devtools", "remotes", "reshape2", "haven", "lattice", "colorspace", "htmltools", "rlang", "foreign", "glue", "withr", "lambda.r", "modelr", "bindr", "plyr", "munsell", "gtable", "cellranger", "futile.logger", "psych", "memoise", "evaluate", "knitr", "forcats", "broom", "Rcpp", "clipr", "scales", "backports", "jsonlite", "mnormt", "rjson", "hms", "digest", "stringi", "rprojroot", "magrittr", "lazyeval", "futile.options", "pkgconfig", "xml2", "datapasta", "lubridate", "rstudioapi", "assertthat", "rmarkdown", "httr", "R6", "nlme"]
RUN ["installGithub.r", "tidyverse/readr@3ea8199", "hadley/rvest@9a51a5d", "clauswilke/ggjoy@ccb1121"]
WORKDIR /payload/
CMD ["R"]
