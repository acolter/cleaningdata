run_analysis <- function() {
  
  # Install dplyr and tidyr
  library(dplyr)
  library(tidyr)
  
  # Read in all files from the dataset
  features <- read.table("UCI HAR Dataset/features.txt")  
  activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")  
  test.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt", colClasses="factor") #int?    
  test.labels <- read.table("UCI HAR Dataset/test/y_test.txt", colClasses="factor") 
  test.set <- read.table("UCI HAR Dataset/test/X_test.txt")    
  train.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt", colClasses="factor") #int? 
  train.labels <- read.table("UCI HAR Dataset/train/y_train.txt", colClasses="factor")  
  train.set <- read.table("UCI HAR Dataset/train/X_train.txt")     
  
  ## Create column names for all datasets
  feature.labels <- features[[2]]
  names(test.set) <- feature.labels 
  names(train.set) <- feature.labels
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
  #testlist <- list(test.subjects, test.labels, test.set) #uses plyr
  #testdf <- join_all(testlist) #uses plyr
  merge.1 <- merge(test.subjects, test.labels, by = "test_id", all=TRUE)
  merge.test <- merge(merge.1, test.set, by = "test_id", all=TRUE)
  colnames(merge.test)[1] <- "id"
  #merge.test.df <- tbl_df(merge.test)
  
  merge.2 <- merge(train.subjects, train.labels, by = "train_id", all=TRUE)
  merge.train <- merge(merge.2, train.set, by = "train_id", all=TRUE)
  colnames(merge.train)[1] <- "id"
  #merge.train.df <- tbl_df(merge.train)
  
  merge.all <- bind_rows(merge.train, merge.test) 
  # threw unequal factor levels warning, coerced "subject" to character
  
  ## Extract only measurements for mean and standard deviation
  mean.cols <- grep("mean()", colnames(merge.all))
  meanFreq.cols <- grep("meanFreq()", colnames(merge.all))
  std.cols <- grep("std()", colnames(merge.all))
  mean.std.cols <- sort(c(mean.cols, std.cols))
  #col.names <- merge.all[, mean.std.cols]
  df <- select(merge.all, id:activity, mean.std.cols, -meanFreq.cols)
  
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
  names(df) <- sub("[(]", "", names(df)) #would "\\(" also work? 
  names(df) <- sub(")", "", names(df))
  names(df) <- tolower(names(df))
  
  ## Need to make subject an integer, not a character
  df$subject <- as.numeric(df$subject)
  
  ## Order df by subject, then activity
  df <- arrange(df, subject, activity)
    
  ## Create a second, independent tidy data set with the average 
  ## of each variable for each activity and each subject
  ## Converts all feature columns to values in a measure column
  tidydf <- gather(df, measure, value, -(id:activity))
  
  ##Look up summarize_each and aggregate
  ## Add subact to group subject and activity into a single value
  tidydf.mutate <- mutate(tidydf, SAM=paste(subject, activity, measure))
  by_SAM <- group_by(tidydf.mutate, SAM)
  tidydf.summarize <- summarize(by_SAM, mean(value))
  tidy <- tidydf.summarize %>% 
    separate(col=SAM, into=c("subject", "activity", "measure")) 
  names(tidy)[4] <- "average"
  tidy$subject <- as.numeric(tidy$subject) 
  tidy <- arrange(tidy, subject)
 
  write.table(tidy, file="tidy.txt", row.names=FALSE)
  
  #tidydf <- gather(df, measure, value, -(id:activity))
  #by_measure <- tidydf %>% 
    #group_by(measure) %>%
    #summarise_each(funs(mean))
  
  # Vector of values in measure column  
  #measure_vec <- unique(tidydf$measure)
  #dfMelt <- melt(tidydf, id=c("id", "subjects", "activity"), measure.vars = "measure")
#

}