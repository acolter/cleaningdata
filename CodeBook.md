# Code Book
This code book describes the variables, the data, and any transformations or work performed to clean up the data.
The file tidy.txt is a tidy version of the data set provided in the Human Activity Recognition Using Smartphones Data Set available from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
It combines the training and test data sets and includes only the mean and standard deviation measurements taken. The final size of the tidy data set is 11,880 rows and 4 columns.

## Variables
The tidy data set contains four variables: 
* **subject** Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
* **activity** The six activities performed by the test subjects. There are six options: walking, walkingupstairs, walkingdownstairs, laying, sitting, standing. 
* **measurement** The 66 measurements taken of the subjects performing the activities. There are 66 options: fbodyaccjerkmeanx, fbodyaccjerkmeany, fbodyaccjerkmeanz, etc.
* **value** The average of each measurement for each subject performing each activity.

## Data
The files in the original data set included the following: 
  * features.txt -- A list of all 561 measurements.
  * activity_labels.txt -- Links the class labels (1-6) with their activity name (WALKING, SITTING, etc.)
  * test/subject_test.txt -- Each row identifies the subject (2, 4, 9, 10, 12, 13, 18, 20, 24) who performed the activity for each window sample.
  * test/y_test.txt -- The 2,947 class labels for the Test data set.
  * test/X_test.txt -- The 2,947 measurement values for the Test data set.
  * train/subject_train.txt -- Each row identifies the subject (1, 11, 14:17, 19, 21:23, 25, 26)
[13] "27" "28" "29" "3"  "30" "5"  "6"  "7"  "8") who performed the activity for each window sample.   
  * train/y_train.txt -- The 7,352 class labels for the Train data set.
  * train/X_train.txt -- The 7,352 measurement values for the Train data set.

The original data set listed 561 different time and frequency domain variables, each normalized and bounded within [-1, 1]. The tidy data set included a subset of 66 measurements showing the mean and standard deviation of the following: 

* tBodyAcc for the X, Y, and Z axis
* tGravityAcc for the X, Y, and Z axis
* tBodyAccJerk for the X, Y, and Z axis
* tBodyGyro for the X, Y, and Z axis
* tBodyGyroJerk for the X, Y, and Z axis
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc for the X, Y, and Z axis
* fBodyAccJerk for the X, Y, and Z axis
* fBodyGyro for the X, Y, and Z axis
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

## Worked performed to clean the data
Installed the dplyr and tidyr packages. 

Downloaded file using download.file(method, "curl")

Unzipped the zip file from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

Read in all files from the data set using read.table. The subject_test.txt, y_test.txt, subject_train.txt and y_train.txt files were read in using colClasses="factor"

Created column names for all data sets. The 561 values from features.txt was used to name the test.set and train.set data sets (X_test.txt and X_train.txt) The column for the test.labels and train.labels data sets (y_test and y_train) was named "activity". The column for the test.subject and train subject data sets (subject_test.txt and subject_train.txt) was named "subject". 

Created an id for the train data sets (1:7352) and another id for the test data set (7353:10299) to allow them to be stitched together using cbind (to attach the ids), then merge (to merge the three elements of the data set into one), then bind_rows (to merge the test and train sets in to one massive data set). 

Extracted only the measurements for labeled "mean()" and "std()". Did not extract measurements for "meanFreq()".

Named the activities in the data set using list(walking="1", walkingupstairs="2", walkingdownstairs="3", sitting="4", standing="5", laying="6").

Removed all the "-" and "()" out of the column names.

Converted all feature columns to values in a measurement column using gather(). Did this to, frankly, make it easier to calculate the average of the measurements. This makes the tidy data set long instead of wide (which is allowed according to the project assignment. 

Mashed the subject, activity and measurement column together to make it possible to calculate the average of the measurement value. Used mutate(), group_by(), summarize(), and separate(). 

Changed the subject variable class to numeric to and arranged the tidy data set by subject. 

Used write.table(tidy, file="tidy.txt", row.names=FALSE) to create the tidy data set file. 
