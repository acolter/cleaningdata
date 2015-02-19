run_analysis <- function() {
  
  # Install dplyr and tidyr
  library(dplyr)
  library(tidyr)
  
  # Read in all files from the dataset
  features <- read.table("UCI HAR Dataset/features.txt")  
  activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")  
  test.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt") 
  test.labels <- read.table("UCI HAR Dataset/test/y_test.txt", colClasses="factor") 
  test.set <- read.table("UCI HAR Dataset/test/X_test.txt")    
  train.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")  
  train.labels <- read.table("UCI HAR Dataset/train/y_train.txt", colClasses="factor")  
  train.set <- read.table("UCI HAR Dataset/train/X_train.txt")     
  
  ## Create column names for all datasets
  names(test.set) <- features[[2]] 
  names(train.set) <- features[[2]]
  names(test.labels) <- "activity"
  names(train.labels) <- "activity"
  names(test.subjects) <- "subject"
  names(train.subjects) <- "subject"
  
  ## Create IDs for all datasets
  train_id <- seq(1,7352)
  train.subjects <- cbind(train_id, train.subjects)
  train.labels <- cbind(train_id, train.labels)
  train.set <- cbind(train_id, train.set)
  
  test_id <- seq(7353,10299)
  test.subjects <- cbind(test_id, test.subjects)
  test.labels <- cbind(test_id, test.labels)
  test.set <- cbind(test_id, test.set)
  
  ## Merge the test dataset
  merge.1 <- merge(test.subjects, test.labels, by = "test_id", all=TRUE)
  merge.test <- merge(merge.1, test.set, by = "test_id", all=TRUE)
  colnames(merge.test)[1] <- "id"
  rm(merge.1)
  
  merge.2 <- merge(train.subjects, train.labels, by = "train_id", all=TRUE)
  merge.train <- merge(merge.2, train.set, by = "train_id", all=TRUE)
  colnames(merge.train)[1] <- "id"
  rm(merge.2)
  
  merge.all <- bind_rows(merge.train, merge.test) 
  
  ## Extract only measurements for mean and standard deviation
  meanstd.cols <- grep("mean()|std()", colnames(merge.all))
  meanFreq.cols <- grep("meanFreq()", colnames(merge.all))
  df <- select(merge.all, id:activity, meanstd.cols, -meanFreq.cols)
  
  ## Order df by subject, then activity
  df <- arrange(df, subject, activity)
  
  ## Use descriptive activity names to name the activities in the data set
  levels(df$activity) <- list(walking="1", 
                              walkingupstairs="2", 
                              walkingdownstairs="3", 
                              sitting="4", 
                              standing="5", 
                              laying="6")
  
  ## Appropriately label the data set with descriptive variable names
  ## Remove all "-" and "()" in the column names
  names(df) <- gsub("-", "", names(df))
  names(df) <- sub("\\()", "", names(df)) 
  names(df) <- tolower(names(df))  
    
  ## Create a second, independent tidy data set with the average of each variable for each activity and each subject
  ## Converts all feature columns to values in a measurement column
  tidydf <- gather(df, measurement, value, -(id:activity))
  
  ## Mash subject, activity, and measurement into a single value, then calculate the mean of each value
  tidy <- tidydf %>%
    mutate(SAM=paste(subject, activity, measurement)) %>%
    group_by(SAM) %>%
    summarize(mean(value)) %>%
    separate(col=SAM, into=c("subject", "activity", "measurement"))
  
  ## Change mean(value) column name to average
  names(tidy)[4] <- "average"
   
  write.table(tidy, file="tidy.txt", row.names=FALSE)
  
}