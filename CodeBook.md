Describe the variables, the data, and any transformations or work that you performed to clean up the data.

## Created "project" folder
if(!file.exists("project")) {
+ dir.create("project")
+ }

## Downloaded zip file into the project folder
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./project/smartphone.zip", method = "curl")

I unzipped the zip file and then read in all the files. 

##Description of files
There were two groups of files: a test set and a training set
test/y_test.txt contained 2947 obs of 1 variable. This was a list of numbers 1-6 corresponding to a six different types of activities
    ## figure out whether this needs to be a factor, string or integer
test.set <- read.table("test/X_test.txt")    ## 2947 obs of 561 variables
train.labels <- read.table("train/y_train.txt", colClasses="factor")  
    ## 7352 obs of 1 variable
train.set <- read.table("train/X_train.txt")     ## 7352 obs of 561 variables
train.subjects <- read.table("train/subject_train.txt", colClasses="factor")  ## 7352 obs of 1 var
test.subjects <- read.table("test/subject_test.txt", colClasses="factor")     ## 2947 obs of 1 var
features <- read.table("features.txt")  ## 561 obs of 2 variables
activity.labels <- read.table("activity_labels.txt")  ## 6 obs of 2 variables