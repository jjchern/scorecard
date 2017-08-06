
library(tidyverse)
library(devtools)
library(stringr)
library(readxl)
library(labelled)
library(containerit)

# Save the codebook and cohort_map files ----------------------------------

url = "https://collegescorecard.ed.gov/assets/CollegeScorecardDataDictionary.xlsx"
fil = "data-raw/CollegeScorecardDataDictionary.xlsx"
if (!file.exists(fil)) download.file(url, fil)

read_excel(fil, sheet = 4) %>%
  rename_all(tolower) %>%
  rename(var_name = `variable name`,
         var_label = `name of data element`,
         dev_category = `dev-category`,
         val_label = label,
         dev_friendly_name = `developer-friendly name`,
         api_data_type = `api data type`) %>%
  select(var_name, var_label, dev_category,
         value, val_label, source, everything()) %>%
  mutate(var_name = tolower(var_name),
         var_label = gsub("[\r\n]", "", var_label)) %>%
  fill(var_name, var_label, source, dev_friendly_name, api_data_type) -> codebook
codebook

readxl::read_excel(fil, sheet = 5) %>%
  rename_all(tolower) %>%
  rename(var_name = `variable name`) %>%
  mutate(var_name = tolower(var_name)) %>%
  gather(datafile, note, -var_name) -> cohort_map
cohort_map

use_data(codebook, cohort_map, overwrite = TRUE)

# Prepare variable label --------------------------------------------------

codebook %>%
  select(var_name, var_label) %>%
  distinct(var_name, .keep_all = TRUE) %>%
  deframe() %>%
  as.list() -> var_label_lst
var_label_lst

# Prepare value labels ----------------------------------------------------

codebook %>%
  select(var_name, val_label, value) %>%
  filter(!is.na(value)) %>%
  group_by(var_name) %>%
  nest() %>%
  mutate(data = map(data, deframe)) %>%
  deframe() -> val_label_lst
val_label_lst

# Download the raw data ---------------------------------------------------

url = "https://ed-public-download.app.cloud.gov/downloads/CollegeScorecard_Raw_Data.zip"
zip = "data-raw/CollegeScorecard_Raw_Data.zip"
if (!file.exists(zip)) download.file(url, zip)

# List files in the zip file ----------------------------------------------

unzip(zip, list = TRUE)

# Name    Length                Date
# 1                         CollegeScorecard_Raw_Data/         0 2016-12-27 08:47:00
# 2  CollegeScorecard_Raw_Data/Crosswalks_20160908.zip  38045951 2016-09-08 21:42:00
# 3     CollegeScorecard_Raw_Data/MERGED1996_97_PP.csv  55220605 2016-12-15 12:57:00
# 4     CollegeScorecard_Raw_Data/MERGED1997_98_PP.csv  59053924 2016-12-15 12:58:00
# 5     CollegeScorecard_Raw_Data/MERGED1998_99_PP.csv  70229449 2016-12-15 12:58:00
# 6     CollegeScorecard_Raw_Data/MERGED1999_00_PP.csv  84703482 2016-12-15 12:59:00
# 7     CollegeScorecard_Raw_Data/MERGED2000_01_PP.csv  97532245 2016-12-15 13:00:00
# 8     CollegeScorecard_Raw_Data/MERGED2001_02_PP.csv 100337087 2016-12-15 13:00:00
# 9     CollegeScorecard_Raw_Data/MERGED2002_03_PP.csv 111782914 2016-12-15 13:01:00
# 10    CollegeScorecard_Raw_Data/MERGED2003_04_PP.csv 113813363 2016-12-15 13:02:00
# 11    CollegeScorecard_Raw_Data/MERGED2004_05_PP.csv 126760179 2016-12-15 13:02:00
# 12    CollegeScorecard_Raw_Data/MERGED2005_06_PP.csv 130989222 2016-12-15 13:03:00
# 13    CollegeScorecard_Raw_Data/MERGED2006_07_PP.csv 129601157 2016-12-15 13:04:00
# 14    CollegeScorecard_Raw_Data/MERGED2007_08_PP.csv 132381344 2016-12-15 13:05:00
# 15    CollegeScorecard_Raw_Data/MERGED2008_09_PP.csv 132326367 2016-12-15 13:05:00
# 16    CollegeScorecard_Raw_Data/MERGED2009_10_PP.csv 137860968 2016-12-15 13:06:00
# 17    CollegeScorecard_Raw_Data/MERGED2010_11_PP.csv 140820124 2016-12-15 13:07:00
# 18    CollegeScorecard_Raw_Data/MERGED2011_12_PP.csv 147544872 2016-12-15 13:08:00
# 19    CollegeScorecard_Raw_Data/MERGED2012_13_PP.csv 149502255 2016-12-15 13:09:00
# 20    CollegeScorecard_Raw_Data/MERGED2013_14_PP.csv 148301400 2016-12-15 13:10:00
# 21    CollegeScorecard_Raw_Data/MERGED2014_15_PP.csv  70331131 2016-12-15 12:51:00

# Save main datasets -------------------------------------------------------

## List of csv files
unzip(zip, list = TRUE) %>%
  slice(-(1:2)) %>%
  pull(Name) -> csv_lst
csv_lst

## Dataset names
csv_lst %>%
  str_extract("([0-9]{1,4}_[0-9]{1,2})") %>%
  paste0("mf", .) -> data_names
data_names

## Load csv files, assign var labels, val labels, and dataset names
csv_lst %>%
  map(~unz(zip, .)) %>%
  map(~read_csv(., guess_max = 10000, na = c("", "NA", "NULL"))) %>%
  map(~rename_all(., tolower)) %>%
  ### Variables that has value labels should be numeric
  map(~mutate_at(., names(val_label_lst), as.numeric)) %>%
  map(~`var_label<-`(., var_label_lst)) %>%
  map(~`val_labels<-`(., val_label_lst)) %>%
  map2(.y = data_names, ~assign(.y, .x, envir = .GlobalEnv))

use_data(mf1996_97, overwrite = TRUE)
use_data(mf1997_98, overwrite = TRUE)
use_data(mf1998_99, overwrite = TRUE)
use_data(mf1999_00, overwrite = TRUE)
use_data(mf2000_01, overwrite = TRUE)
use_data(mf2001_02, overwrite = TRUE)
use_data(mf2002_03, overwrite = TRUE)
use_data(mf2003_04, overwrite = TRUE)
use_data(mf2004_05, overwrite = TRUE)
use_data(mf2005_06, overwrite = TRUE)
use_data(mf2006_07, overwrite = TRUE)
use_data(mf2007_08, overwrite = TRUE)
use_data(mf2008_09, overwrite = TRUE)
use_data(mf2009_10, overwrite = TRUE)
use_data(mf2010_11, overwrite = TRUE)
use_data(mf2011_12, overwrite = TRUE)
use_data(mf2012_13, overwrite = TRUE)
use_data(mf2013_14, overwrite = TRUE)
use_data(mf2014_15, overwrite = TRUE)

# Delete the raw zip file -------------------------------------------------

unlink(zip)

# Containerit! ------------------------------------------------------------

container = dockerfile(from = sessionInfo())
write(container, "data-raw/prep_container.dockerfile")
