
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
#> # A tibble: 7,703 x 1,744
#>    mf_year unitid    opeid opeid6                              instnm
#>      <chr>  <dbl>    <chr>  <chr>                               <chr>
#>  1 2014-15 100654 00100200 001002            Alabama A & M University
#>  2 2014-15 100663 00105200 001052 University of Alabama at Birmingham
#>  3 2014-15 100690 02503400 025034                  Amridge University
#>  4 2014-15 100706 00105500 001055 University of Alabama in Huntsville
#>  5 2014-15 100724 00100500 001005            Alabama State University
#>  6 2014-15 100751 00105100 001051           The University of Alabama
#>  7 2014-15 100760 00100700 001007   Central Alabama Community College
#>  8 2014-15 100812 00100800 001008             Athens State University
#>  9 2014-15 100830 00831000 008310     Auburn University at Montgomery
#> 10 2014-15 100858 00100900 001009                   Auburn University
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

Exploring codebook and plot in-state tuition with a joyplot
-----------------------------------------------------------

``` r
vars = c("mf_year", "iclevel", "control", "tuitionfee_in")

scorecard::codebook %>% 
  select(var_name, var_label, value, val_label) %>% 
  filter(var_name %in% vars) %>% 
  knitr::kable()
```

| var\_name      | var\_label                |  value| val\_label         |
|:---------------|:--------------------------|------:|:-------------------|
| control        | Control of institution    |      1| Public             |
| control        | Control of institution    |      2| Private nonprofit  |
| control        | Control of institution    |      3| Private for-profit |
| tuitionfee\_in | In-state tuition and fees |     NA| NA                 |
| iclevel        | Level of institution      |      1| 4-year             |
| iclevel        | Level of institution      |      2| 2-year             |
| iclevel        | Level of institution      |      3| Less-than-2-year   |

``` r

dplyr_seq = . %>% 
  select(one_of(vars)) %>%
  haven::as_factor() %>% 
  filter(iclevel %in% c("4-year", "2-year")) %>% 
  mutate(year = mf_year %>% parse_number() %>% as.factor()) %>% 
  group_by(iclevel, control) %>% 
  mutate_at(c("tuitionfee_in"),
            ~statar::winsorise(., probs = c(0.02, 0.98), verbose = FALSE)) %>% 
  ungroup()

## Test the functional sequence
scorecard::mf2014_15 %>% dplyr_seq()
#> # A tibble: 5,530 x 5
#>    mf_year iclevel           control tuitionfee_in   year
#>      <chr>  <fctr>            <fctr>         <dbl> <fctr>
#>  1 2014-15  4-year            Public          9096   2014
#>  2 2014-15  4-year            Public          7510   2014
#>  3 2014-15  4-year Private nonprofit          6900   2014
#>  4 2014-15  4-year            Public          9158   2014
#>  5 2014-15  4-year            Public          8720   2014
#>  6 2014-15  4-year            Public          9826   2014
#>  7 2014-15  2-year            Public          3491   2014
#>  8 2014-15  4-year            Public            NA   2014
#>  9 2014-15  4-year            Public          9080   2014
#> 10 2014-15  4-year            Public         10200   2014
#> # ... with 5,520 more rows

bind_rows(
  scorecard::mf2014_15 %>% dplyr_seq(),
  scorecard::mf2013_14 %>% dplyr_seq(),
  scorecard::mf2012_13 %>% dplyr_seq(),
  scorecard::mf2011_12 %>% dplyr_seq(),
  scorecard::mf2010_11 %>% dplyr_seq(),
  scorecard::mf2009_10 %>% dplyr_seq(),
  scorecard::mf2008_09 %>% dplyr_seq(),
  scorecard::mf2007_08 %>% dplyr_seq(),
  scorecard::mf2006_07 %>% dplyr_seq(),
  scorecard::mf2005_06 %>% dplyr_seq(),
  scorecard::mf2004_05 %>% dplyr_seq(),
  scorecard::mf2003_04 %>% dplyr_seq(),
  scorecard::mf2002_03 %>% dplyr_seq(),
  scorecard::mf2001_02 %>% dplyr_seq(),
  scorecard::mf2000_01 %>% dplyr_seq()
) -> df

df %>% 
  ggplot(aes(x = tuitionfee_in, y = year, fill = iclevel)) +
  ggjoy::geom_joy(scale = 2, alpha = .8, colour = "white") +
  ggjoy::theme_joy() +
  facet_grid(iclevel~control, scales = "free") +
  labs(x = NULL, y = NULL,
       title = "In-State Tuition and Fees, 2000-2014") +
  scale_x_continuous(labels = scales::dollar) +
  scale_y_discrete(breaks = seq(2014, 2000, -3), 
                   expand = c(0.01, 0)) +
  theme(axis.text = element_text(size = 8),
        legend.position = "none")
```

![](README-files/unnamed-chunk-3-1.png)

Compare in-state and out-of-state tuition and fees
--------------------------------------------------

``` r
vars = c("mf_year", "iclevel", "control", "tuitionfee_in", "tuitionfee_out")

dplyr_seq = . %>% 
  select(one_of(vars)) %>%
  haven::as_factor() %>% 
  filter(iclevel %in% c("4-year", "2-year")) %>% 
  filter(control == "Public") %>% 
  mutate(type = paste(control, iclevel)) %>% 
  mutate(year = mf_year %>% parse_number() %>% as.factor()) %>% 
  group_by(type) %>% 
  mutate_at(c("tuitionfee_in", "tuitionfee_out"),
            ~statar::winsorise(., probs = c(0.02, 0.98), verbose = FALSE)) %>% 
  ungroup() %>% 
  gather(in_or_out, tuitionfee, tuitionfee_in:tuitionfee_out) %>% 
  mutate(in_or_out = if_else(in_or_out == "tuitionfee_in",
                              "In-state tuition and fees",
                              "Out-of-state tuition and fees"))

## Test the functional sequence
scorecard::mf2014_15 %>% dplyr_seq()
#> # A tibble: 3,600 x 7
#>    mf_year iclevel control          type   year                 in_or_out
#>      <chr>  <fctr>  <fctr>         <chr> <fctr>                     <chr>
#>  1 2014-15  4-year  Public Public 4-year   2014 In-state tuition and fees
#>  2 2014-15  4-year  Public Public 4-year   2014 In-state tuition and fees
#>  3 2014-15  4-year  Public Public 4-year   2014 In-state tuition and fees
#>  4 2014-15  4-year  Public Public 4-year   2014 In-state tuition and fees
#>  5 2014-15  4-year  Public Public 4-year   2014 In-state tuition and fees
#>  6 2014-15  2-year  Public Public 2-year   2014 In-state tuition and fees
#>  7 2014-15  4-year  Public Public 4-year   2014 In-state tuition and fees
#>  8 2014-15  4-year  Public Public 4-year   2014 In-state tuition and fees
#>  9 2014-15  4-year  Public Public 4-year   2014 In-state tuition and fees
#> 10 2014-15  2-year  Public Public 2-year   2014 In-state tuition and fees
#> # ... with 3,590 more rows, and 1 more variables: tuitionfee <dbl>

bind_rows(
  scorecard::mf2014_15 %>% dplyr_seq(),
  scorecard::mf2013_14 %>% dplyr_seq(),
  scorecard::mf2012_13 %>% dplyr_seq(),
  scorecard::mf2011_12 %>% dplyr_seq(),
  scorecard::mf2010_11 %>% dplyr_seq(),
  scorecard::mf2009_10 %>% dplyr_seq(),
  scorecard::mf2008_09 %>% dplyr_seq(),
  scorecard::mf2007_08 %>% dplyr_seq(),
  scorecard::mf2006_07 %>% dplyr_seq(),
  scorecard::mf2005_06 %>% dplyr_seq(),
  scorecard::mf2004_05 %>% dplyr_seq(),
  scorecard::mf2003_04 %>% dplyr_seq(),
  scorecard::mf2002_03 %>% dplyr_seq(),
  scorecard::mf2001_02 %>% dplyr_seq(),
  scorecard::mf2000_01 %>% dplyr_seq()
) -> df

df %>% 
  ggplot(aes(x = tuitionfee, y = year, fill = in_or_out)) +
  ggjoy::geom_joy(scale = 2, alpha = .8, colour = "white") +
  ggjoy::theme_joy() +
  facet_wrap(~type, scales = "free") +
  labs(x = NULL, y = NULL,
       title = "In-State Vs. Out-of-State Tuition and Fees for Public Colleges",
       caption = "Source: College Scorecard, 2000-2014") +
  scale_x_continuous(labels = scales::dollar) +
  scale_y_discrete(breaks = seq(2014, 2000, -3), 
                   expand = c(0.01, 0)) +
  theme(axis.text = element_text(size = 9),
        legend.position = "top",
        legend.title = element_blank(),
        legend.justification = "center")
```

![](README-files/unnamed-chunk-4-1.png)
