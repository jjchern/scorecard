
library(tidyverse)
library(devtools)
library(stringr)
library(readxl)
library(labelled)
library(containerit)

# Save the codebook and cohort_map files ----------------------------------
# Include data from the most recent update (September 28th, 2017)

url = "https://collegescorecard.ed.gov/assets/CollegeScorecardDataDictionary.xlsx"
fil = "data-raw/CollegeScorecardDataDictionary_092017.xlsx"
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

# Prepare variable label and value labels ---------------------------------

codebook %>%
  select(var_name, var_label) %>%
  distinct(var_name, .keep_all = TRUE) %>%
  deframe() %>%
  as.list() -> var_label_lst
var_label_lst

codebook %>%
  select(var_name, val_label, value) %>%
  filter(!is.na(value)) %>%
  group_by(var_name) %>%
  nest() %>%
  mutate(data = map(data, deframe)) %>%
  deframe() -> val_label_lst
val_label_lst

use_data(var_label_lst, val_label_lst, overwrite = TRUE, internal = TRUE)

# Download the raw data ---------------------------------------------------
# Include data from the most recent update (September 28th, 2017)

url = "https://ed-public-download.app.cloud.gov/downloads/CollegeScorecard_Raw_Data.zip"
zip = "data-raw/CollegeScorecard_Raw_Data_092017.zip"
if (!file.exists(zip)) download.file(url, zip)

# List files in the zip file ----------------------------------------------

unzip(zip, list = TRUE)

# Name    Length                Date
# 1                         CollegeScorecard_Raw_Data/         0 2017-10-02 14:55:00
# 2  CollegeScorecard_Raw_Data/Crosswalks_20170806.zip  40757406 2017-09-05 11:32:00
# 3     CollegeScorecard_Raw_Data/MERGED1996_97_PP.csv  56322100 2017-09-30 09:44:00
# 4     CollegeScorecard_Raw_Data/MERGED1997_98_PP.csv  59834161 2017-09-30 09:44:00
# 5     CollegeScorecard_Raw_Data/MERGED1998_99_PP.csv  70813341 2017-09-30 09:45:00
# 6     CollegeScorecard_Raw_Data/MERGED1999_00_PP.csv  85101637 2017-09-30 09:45:00
# 7     CollegeScorecard_Raw_Data/MERGED2000_01_PP.csv  97737425 2017-09-30 09:46:00
# 8     CollegeScorecard_Raw_Data/MERGED2001_02_PP.csv 100518881 2017-09-30 09:46:00
# 9     CollegeScorecard_Raw_Data/MERGED2002_03_PP.csv 111745844 2017-09-30 09:47:00
# 10    CollegeScorecard_Raw_Data/MERGED2003_04_PP.csv 113713786 2017-09-30 09:48:00
# 11    CollegeScorecard_Raw_Data/MERGED2004_05_PP.csv 126436249 2017-09-30 09:48:00
# 12    CollegeScorecard_Raw_Data/MERGED2005_06_PP.csv 130602598 2017-09-30 09:49:00
# 13    CollegeScorecard_Raw_Data/MERGED2006_07_PP.csv 129281225 2017-09-30 09:50:00
# 14    CollegeScorecard_Raw_Data/MERGED2007_08_PP.csv 131979415 2017-09-30 09:50:00
# 15    CollegeScorecard_Raw_Data/MERGED2008_09_PP.csv 131845770 2017-09-30 09:51:00
# 16    CollegeScorecard_Raw_Data/MERGED2009_10_PP.csv 137341725 2017-09-30 09:52:00
# 17    CollegeScorecard_Raw_Data/MERGED2010_11_PP.csv 140178337 2017-09-30 09:52:00
# 18    CollegeScorecard_Raw_Data/MERGED2011_12_PP.csv 146759159 2017-09-30 09:53:00
# 19    CollegeScorecard_Raw_Data/MERGED2012_13_PP.csv 148646097 2017-09-30 09:54:00
# 20    CollegeScorecard_Raw_Data/MERGED2013_14_PP.csv 149314595 2017-09-30 09:55:00
# 21    CollegeScorecard_Raw_Data/MERGED2014_15_PP.csv 145894837 2017-09-30 09:55:00
# 22    CollegeScorecard_Raw_Data/MERGED2015_16_PP.csv  70217503 2017-09-30 09:39:00

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

## Merged file years
csv_lst %>%
  str_extract("([0-9]{1,4}_[0-9]{1,2})") %>%
  str_replace("_", "-") -> mf_year
mf_year

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

# Delete the raw zip file -------------------------------------------------
# unlink(zip)

# Container it ------------------------------------------------------------

container = dockerfile(from = sessionInfo(),
                       maintainer = "jjchern",
                       r_version = "3.4.2")
write(container, "data-raw/prep_container.dockerfile")
