## Synopsis

This script produces a summarized dataset, by subject and by activity, of the average and standard deviation of the main measurements taken using an accelerometor on a Samsung S2.

Prerequisites:

plyr, dplyr and memisc libraries are required.

Data must be populated beforehand.
Dataset is located at:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Extract the Zip file to a sub-folder, \UCI HAR Dataset

Running the script:

Call source("run_analysis.R")

The unsummarized data extract will be output to activity-mean-stddev.txt
The summarized data extract will be output to activity-mean-summary.txt
