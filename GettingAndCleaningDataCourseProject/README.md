# Coursera Course Getting And Cleaning Data: Course Project

## Overview

This is my project work for the [Getting And Cleaning Data Course On Coursera](https://www.coursera.org/learn/data-cleaning). The objective of this project is to run an analysis on the _Human Activity Recognition Using Smartphones Dataset_ which contains measurements on activities such as sitting, walking or walking upstairs.

The repository contains the file `run_analysis.R` which downloads the raw data, runs an analysis and produces a summary of the data. The file `tidy_data.txt` contains the result of the analysis and is also contained in the repository. A detailed description of the transformation of the raw data and the resulting variables can be found in the file `CodeBook.md`.

## Reproducing the analysis

To reproduce the analysis copy the script `run_analysis.R` into your working directory. At the R-Prompt type:

```R
source("run_analysis.R")
```

The script will then download the raw data to your working directory and unpack the zip-archive. Then the script runs an analysis on the raw data producing summarised data by calculating average values of the measurements (see code book for details). The summary is written to a file called `tidy_data.txt` in your working directory. You can load the generated file into R using the following command:

```R
summary <- read.table("tidy_data.txt", header = TRUE)
```

The script has dependencies on the packages `lubridate`, `dplyr`, `tidyr` and `magrittr`. If they are not already installed, you need to install them prior to running the script. This can be done with the `install.packages("packagename")`-command.
