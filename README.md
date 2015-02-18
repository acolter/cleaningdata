# Cleaning Data ReadMe.md
This is the course project for Coursera's Getting and Cleaning Data course

## Overview

This repo contains several files: 
* UCI HAR Dataset is the directory of the raw data pulled from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones# 
* run_analysis.R is the script that produced the tidy data set
* CodeBook.md describes the variables, values, and units in the tidy data set.
* tidy.txt file is the tidy subset of the UCI HAR data. Its dimensions are 11,880 rows by 4 columns. It adheres to the following tidy data principles:

	* Each variable in one column.
	* Each observation in a different row.
	* One table for each observational unit.

## Raw Data

tidy.txt includes the combined test and training data sets from the following files:

* UCI HAR Dataset/test/subject_test.txt
* UCI HAR Dataset/test/X_test.txt
* UCI HAR Dataset/test/y_test.txt
* UCI HAR Dataset/train/subject_train.txt
* UCI HAR Dataset/train/X_train.txt
* UCI HAR Dataset/train/y_train.txt
* UCI HAR Dataset/features.txt
* UCI HAR Dataset/activity_labels.txt

## Script

run_analysis.R takes the raw data from the Human Activity Recognition Using Smartphones Dataset (UCI HAR), imports it into R, and transforms it into a tidy data subset.

The script performs the following operations:

1. Merges the training and the test sets to create one data set.
	* Creates ids for the subject, labels, and set files in both test and train directories. 
	* Merges the test.subject, test.labels, and test.set on the test_id column to create a single merge.test data frame. 
	* Merges the train.subject, train.labels, and train.set on the train_id column to create a single merge.train data frame.
	* Binds the train and test data frames.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
	* Greps column names with "mean()", "meanFreq()" "std()".
	* Selects columns with "mean()" and "std()" but remove columns with "meanFreq().
3. Uses descriptive activity names to name the activities in the data set.
	* Uses the list function to map the numeric activity values to descriptive names like "sitting" and "standing."
4. Appropriately labels the data set with descriptive variable names.
	* Uses sub and gsub to do a find and replace on the column names. The resulting descriptive names are included in CodeBook.md.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	* Uses gather to convert each feature to a measure variable and value.
	* Uses mutate and group_by to create a single value for each subject-activity-measure.
	* Uses summarize to calculate the mean of each value.
	* Arranges the tidy data set by subject.

