
library(tidyverse)
library(devtools)
library(stringr)
library(readxl)
library(labelled)
library(containerit)

# Save the codebook and cohort_map files ----------------------------------
# Include data from the most recent update (December 12, 2019)

url = "https://collegescorecard.ed.gov/assets/CollegeScorecardDataDictionary.xlsx"
fil = "data-raw/CollegeScorecardDataDictionary_122019.xlsx"
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
  fill(var_name, var_label, source, dev_friendly_name, api_data_type) %>%
  print() -> codebook

readxl::read_excel(fil, sheet = 5) %>%
  rename_all(tolower) %>%
  rename(var_name = `variable name`) %>%
  mutate(var_name = tolower(var_name)) %>%
  gather(datafile, note, -var_name) %>%
  print() -> cohort_map

use_data(codebook, cohort_map, overwrite = TRUE)

# Prepare variable label and value labels ---------------------------------

codebook %>%
  select(var_name, var_label) %>%
  distinct(var_name, .keep_all = TRUE) %>%
  deframe() %>%
  as.list() %>%
  print() -> var_label_lst

codebook %>%
  select(var_name, val_label, value) %>%
  filter(!is.na(value)) %>%
  group_by(var_name) %>%
  nest() %>%
  mutate(data = map(data, deframe)) %>%
  deframe() %>%
  print() -> val_label_lst

use_data(var_label_lst, val_label_lst, overwrite = TRUE, internal = TRUE)

# Download the raw data ---------------------------------------------------
# Include data from the most recent update (December 12, 2019)

url = "https://ed-public-download.app.cloud.gov/downloads/CollegeScorecard_Raw_Data.zip"
zip = "data-raw/CollegeScorecard_Raw_Data_122019.zip"
if (!file.exists(zip)) download.file(url, zip)

# List files in the zip file ----------------------------------------------

unzip(zip, list = TRUE) %>%
  as_tibble() %>%
  arrange(Name) %>%
  print(n = 28)

# # A tibble: 28 x 3
#   Name                                                           Length Date
#   <chr>                                                           <dbl> <dttm>
# 1 CollegeScorecard_Raw_Data/                                          0 2019-12-03 16:12:00
# 2 CollegeScorecard_Raw_Data/.DS_Store                              6148 2019-11-18 21:06:00
# 3 CollegeScorecard_Raw_Data/Crosswalks.zip                     35375490 2019-05-06 07:06:00
# 4 CollegeScorecard_Raw_Data/data.yaml                            486192 2019-10-13 13:13:00
# 5 CollegeScorecard_Raw_Data/FieldOfStudyData1415_1516_PP.csv   43757585 2019-11-15 15:14:00
# 6 CollegeScorecard_Raw_Data/FieldOfStudyData1516_1617_PP.csv   51099892 2019-11-15 15:14:00
# 7 CollegeScorecard_Raw_Data/MERGED1996_97_PP.csv               63348240 2019-10-10 09:18:00
# 8 CollegeScorecard_Raw_Data/MERGED1997_98_PP.csv               66766520 2019-10-10 09:19:00
# 9 CollegeScorecard_Raw_Data/MERGED1998_99_PP.csv               77519889 2019-10-10 09:19:00
# 10 CollegeScorecard_Raw_Data/MERGED1999_00_PP.csv              91808656 2019-10-10 09:20:00
# 11 CollegeScorecard_Raw_Data/MERGED2000_01_PP.csv             104425976 2019-10-10 09:21:00
# 12 CollegeScorecard_Raw_Data/MERGED2001_02_PP.csv             107365717 2019-10-10 09:21:00
# 13 CollegeScorecard_Raw_Data/MERGED2002_03_PP.csv             118529545 2019-10-10 09:22:00
# 14 CollegeScorecard_Raw_Data/MERGED2003_04_PP.csv             120662741 2019-10-10 09:23:00
# 15 CollegeScorecard_Raw_Data/MERGED2004_05_PP.csv             133477657 2019-10-10 09:24:00
# 16 CollegeScorecard_Raw_Data/MERGED2005_06_PP.csv             137842770 2019-10-10 09:24:00
# 17 CollegeScorecard_Raw_Data/MERGED2006_07_PP.csv             136534126 2019-10-10 09:25:00
# 18 CollegeScorecard_Raw_Data/MERGED2007_08_PP.csv             139346257 2019-10-10 09:26:00
# 19 CollegeScorecard_Raw_Data/MERGED2008_09_PP.csv             139318440 2019-10-10 09:27:00
# 20 CollegeScorecard_Raw_Data/MERGED2009_10_PP.csv             145004052 2019-10-10 09:28:00
# 21 CollegeScorecard_Raw_Data/MERGED2010_11_PP.csv             148149393 2019-10-10 09:28:00
# 22 CollegeScorecard_Raw_Data/MERGED2011_12_PP.csv             155062442 2019-10-10 09:29:00
# 23 CollegeScorecard_Raw_Data/MERGED2012_13_PP.csv             157050875 2019-10-10 09:30:00
# 24 CollegeScorecard_Raw_Data/MERGED2013_14_PP.csv             157811300 2019-10-10 09:31:00
# 25 CollegeScorecard_Raw_Data/MERGED2014_15_PP.csv             156335981 2019-10-10 09:32:00
# 26 CollegeScorecard_Raw_Data/MERGED2015_16_PP.csv             152061339 2019-10-10 09:33:00
# 27 CollegeScorecard_Raw_Data/MERGED2016_17_PP.csv             153213137 2019-09-18 18:56:00
# 28 CollegeScorecard_Raw_Data/MERGED2017_18_PP.csv              68092022 2019-12-02 06:59:00

# Save main datasets -------------------------------------------------------

## List of csv files
unzip(zip, list = TRUE) %>%
  as_tibble() %>%
  arrange(Name) %>%
  filter(grepl("MERGED", Name)) %>%
  pull(Name) %>%
  print() -> csv_lst

## Dataset names
csv_lst %>%
  str_extract("([0-9]{1,4}_[0-9]{1,2})") %>%
  paste0("mf", .) %>%
  print() -> data_names

## Merged file years
csv_lst %>%
  str_extract("([0-9]{1,4}_[0-9]{1,2})") %>%
  str_replace("_", "-") %>%
  print() -> mf_year

## Load csv files, assign var labels, val labels, and dataset names
csv_lst %>%
  map(~unz(zip, .)) %>%
  map(~read_csv(., guess_max = 10000, na = c("", "NA", "NULL"))) %>%
  map(~rename_all(., tolower)) %>%
  ### Add mf_year as the first column
  map2(.y = mf_year, ~mutate(., mf_year = .y)) %>%
  map(~select(., mf_year, everything())) %>%
  ### Identifiers should always be string
  map(~mutate_at(., c("unitid", "opeid", "opeid6"), as.character)) %>%
  ### Variables that has value labels should be numeric
  map(~mutate_at(., names(val_label_lst), as.numeric)) %>%
  map(~`var_label<-`(., var_label_lst)) %>%
  map(~`val_labels<-`(., val_label_lst)) %>%
  ### Drop columns that all values are NA
  map(~discard(., ~all(is.na(.x)))) %>%
  ### Assign dataset names
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
use_data(mf2015_16, overwrite = TRUE)
use_data(mf2016_17, overwrite = TRUE)
use_data(mf2017_18, overwrite = TRUE)

# Delete the raw zip file -------------------------------------------------
# unlink(zip)

# Container it ------------------------------------------------------------

container = dockerfile(from = sessionInfo(),
                       maintainer = "jjchern",
                       r_version = "3.4.2")
write(container, "data-raw/prep_container.dockerfile")
