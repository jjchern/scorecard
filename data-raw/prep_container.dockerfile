FROM rocker/r-ver:3.4.2
LABEL maintainer="jjchern"
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
 && apt-get install -y git-core \
	libxml2-dev \
	make \
	NULL
RUN ["install2.r", "-r 'https://cloud.r-project.org'", "bindrcpp", "labelled", "readxl", "stringr", "dplyr", "purrr", "tidyr", "tibble", "tidyverse", "devtools", "hrbrthemes", "reshape2", "haven", "lattice", "colorspace", "yaml", "rlang", "foreign", "glue", "hunspell", "lambda.r", "modelr", "bindr", "plyr", "futile.logger", "munsell", "gtable", "cellranger", "psych", "memoise", "labeling", "forcats", "extrafont", "Rttf2pt1", "broom", "Rcpp", "jsonlite", "mnormt", "hms", "digest", "stringi", "magrittr", "lazyeval", "futile.options", "extrafontdb", "pkgconfig", "xml2", "lubridate", "assertthat", "httr", "R6", "nlme", "remotes"]
RUN ["installGithub.r", "tidyverse/readr@3ea8199", "hadley/ggplot2@9979112", "tidyverse/tidyselect@30a60b5", "jimhester/withr@8ba5e46", "hadley/rvest@9a51a5d", "hadley/scales@d767915", "slowkow/ggrepel@007318f"]
WORKDIR /payload/
CMD ["R"]
