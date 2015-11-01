# Load libraries ----------------------------------------------------------

rm(list = ls())
library(readr)
library(dplyr)
library(devtools)

# Download the raw data ---------------------------------------------------

download.file("https://s3.amazonaws.com/ed-college-choice-public/CollegeScorecard_Raw_Data.zip",
              "data-raw/raw.zip")

# Save the datasets -------------------------------------------------------

merged1996 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED1996_PP.csv"))
use_data(merged1996)

merged1997 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED1997_PP.csv"))
use_data(merged1997)

merged1998 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED1998_PP.csv"))
use_data(merged1998)

merged1999 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED1999_PP.csv"))
use_data(merged1999)

merged2000 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2000_PP.csv"))
use_data(merged2000)

merged2001 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2001_PP.csv"))
use_data(merged2001)

merged2002 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2002_PP.csv"))
use_data(merged2002)

merged2003 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2003_PP.csv"))
use_data(merged2003)

merged2004 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2004_PP.csv"))
use_data(merged2004)

merged2005 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2005_PP.csv"))
use_data(merged2005)

merged2006 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2006_PP.csv"))
use_data(merged2006)

merged2007 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2007_PP.csv"))
use_data(merged2007)

merged2008 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2008_PP.csv"))
use_data(merged2008)

merged2009 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2009_PP.csv"))
use_data(merged2009)

merged2010 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2010_PP.csv"))
use_data(merged2010)

merged2011 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2011_PP.csv"))
use_data(merged2011)

merged2012 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2012_PP.csv"))
use_data(merged2012)

merged2013 = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/MERGED2013_PP.csv"))
use_data(merged2013)

codebook = read_csv(unz("data-raw/raw.zip", filename = "CollegeScorecard_Raw_Data/CollegeScorecardDataDictionary-09-12-2015.csv"))
use_data(codebook)

# Delete the raw zip file -------------------------------------------------

# unlink("data-raw/raw.zip")

