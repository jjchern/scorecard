
<!-- README.md is generated from README.Rmd. Please edit that file -->
About `scorecard`
=================

The `scorecard` repo contains an R script (in the [`data-raw` folder](https://github.com/jjchern/scorecard/tree/master/data-raw)) that downloads and process raw data from the [College Scorecard](https://collegescorecard.ed.gov), 1996-2014. The datasets are stored in the [`data` folder](https://github.com/jjchern/scorecard/tree/master/data).

The data was last updated on January 13th, 2017 (as of August 5, 2017). See the [changelog](https://collegescorecard.ed.gov/data/changelog/) for more details.

Related R Package
=================

[Benjamin Skinner](https://github.com/btskinner) has created a wonderful R client [`rscorecard`](http://btskinner.me/rscorecard/) for the [College Scorecard GET API](https://collegescorecard.ed.gov/data/documentation/). If you're interested in getting some specific variables quickly, I suggest using the `rscorecard` package.

Installation
============

You can also download the datasets as an R package. The size of the `data` folder is 138.1 MB, so it might take a while to install and load into memory.

``` r
# install.packages("devtools")
devtools::install_github("jjchern/scorecard")

# To uninstall the package, use:
# remove.packages("scorecard")
```

Examples
========

Loading the merged file for school year 2014-15
-----------------------------------------------

``` r
library(tidyverse)
scorecard::mf2014_15
#> # A tibble: 7,703 x 1,743
#>    unitid    opeid opeid6                              instnm
#>     <dbl>    <chr>  <chr>                               <chr>
#>  1 100654 00100200 001002            Alabama A & M University
#>  2 100663 00105200 001052 University of Alabama at Birmingham
#>  3 100690 02503400 025034                  Amridge University
#>  4 100706 00105500 001055 University of Alabama in Huntsville
#>  5 100724 00100500 001005            Alabama State University
#>  6 100751 00105100 001051           The University of Alabama
#>  7 100760 00100700 001007   Central Alabama Community College
#>  8 100812 00100800 001008             Athens State University
#>  9 100830 00831000 008310     Auburn University at Montgomery
#> 10 100858 00100900 001009                   Auburn University
#> # ... with 7,693 more rows, and 1739 more variables: city <chr>,
#> #   stabbr <chr>, zip <chr>, accredagency <chr>, insturl <chr>,
#> #   npcurl <chr>, sch_deg <chr>, hcm2 <dbl>, main <dbl+lbl>,
#> #   numbranch <dbl>, preddeg <dbl+lbl>, highdeg <dbl+lbl>,
#> #   control <dbl+lbl>, st_fips <dbl+lbl>, region <dbl+lbl>,
#> #   locale <dbl+lbl>, locale2 <dbl+lbl>, latitude <dbl>, longitude <dbl>,
#> #   ccbasic <dbl+lbl>, ccugprof <dbl+lbl>, ccsizset <dbl+lbl>,
#> #   hbcu <dbl+lbl>, pbi <dbl+lbl>, annhi <dbl+lbl>, tribal <dbl+lbl>,
#> #   aanapii <dbl+lbl>, hsi <dbl+lbl>, nanti <dbl+lbl>, menonly <dbl+lbl>,
#> #   womenonly <dbl+lbl>, relaffil <dbl+lbl>, adm_rate <dbl>,
#> #   adm_rate_all <dbl>, satvr25 <dbl>, satvr75 <dbl>, satmt25 <dbl>,
#> #   satmt75 <dbl>, satwr25 <dbl>, satwr75 <dbl>, satvrmid <dbl>,
#> #   satmtmid <dbl>, satwrmid <dbl>, actcm25 <dbl>, actcm75 <dbl>,
#> #   acten25 <dbl>, acten75 <dbl>, actmt25 <dbl>, actmt75 <dbl>,
#> #   actwr25 <dbl>, actwr75 <dbl>, actcmmid <dbl>, actenmid <dbl>,
#> #   actmtmid <dbl>, actwrmid <dbl>, sat_avg <dbl>, sat_avg_all <dbl>,
#> #   pcip01 <dbl>, pcip03 <dbl>, pcip04 <dbl>, pcip05 <dbl>, pcip09 <dbl>,
#> #   pcip10 <dbl>, pcip11 <dbl>, pcip12 <dbl>, pcip13 <dbl>, pcip14 <dbl>,
#> #   pcip15 <dbl>, pcip16 <dbl>, pcip19 <dbl>, pcip22 <dbl>, pcip23 <dbl>,
#> #   pcip24 <dbl>, pcip25 <dbl>, pcip26 <dbl>, pcip27 <dbl>, pcip29 <dbl>,
#> #   pcip30 <dbl>, pcip31 <dbl>, pcip38 <dbl>, pcip39 <dbl>, pcip40 <dbl>,
#> #   pcip41 <dbl>, pcip42 <dbl>, pcip43 <dbl>, pcip44 <dbl>, pcip45 <dbl>,
#> #   pcip46 <dbl>, pcip47 <dbl>, pcip48 <dbl>, pcip49 <dbl>, pcip50 <dbl>,
#> #   pcip51 <dbl>, pcip52 <dbl>, pcip54 <dbl>, cip01cert1 <dbl+lbl>,
#> #   cip01cert2 <dbl+lbl>, cip01assoc <dbl+lbl>, cip01cert4 <dbl>,
#> #   cip01bachl <dbl>, ...
```
