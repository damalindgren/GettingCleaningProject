run_analysis <- function()
{
    library("data.table")
    
    #get the column headers from feature
    features <- read.table("UCI HAR Dataset//features.txt", header=FALSE)
    
    #read the test data. 
   
    x_test <- read.table("UCI HAR Dataset//test//X_test.txt", header=FALSE)
    
    y_test <- read.table("UCI HAR Dataset//test/y_test.txt", header=FALSE)
    
    y_subject_test <- read.table("UCI HAR Dataset//test/subject_test.txt")
    
    #merge together the test tables
    test_table <- cbind( x_test, y_subject_test, y_test)
    
    #read the train data

    x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)
    
    y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE)
    
    y_subject_train <- read.table("UCI HAR Dataset//train/subject_train.txt", header=FALSE)
    
    #merge the train tables
    
    train_table <- cbind(x_train, y_subject_train, y_train )
                           
   
    # merge the test and train tables
    table <- rbind(test_table, train_table)
    names(table) <- c(as.vector(features[,2]), "SubjectID", "ActivityID")
  
    #add the activity labels
    activity_table <- read.table(file="UCI HAR Dataset//activity_labels.txt", header=FALSE)
    
    names(activity_table) <- c("ActivityID", "ActivityLabel")
  
    table <- suppressWarnings(merge(table, activity_table))
    
    ##finding what coulumns to keep
    
    #renaming meanFreq() to mFreq()
    names(table) <- gsub("meanFreq()", "mFreq()", names(table))
    
    meangrep <- c(grep("mean()|std()", names(table)),563,564)
    
    table <- table[,meangrep]
     
   
    
    
    #melting the table
    tableMelt <- melt(table, id=c(67,68))

    
    #casting a table 
    
   activityData <- dcast(tableMelt, ActivityLabel + SubjectID ~ variable, mean)
   
    
}