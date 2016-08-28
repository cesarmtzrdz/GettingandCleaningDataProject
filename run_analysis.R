#First we will download the .zip and place it into your working directory

workDir <- getwd()
fullfileName <- paste(workDir,"/dataset.zip",sep="")
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = fullfileName)

#unzip
unzip(zipfile = fullfileName ,overwrite = TRUE)

#delete zipfile
if (file.exists(fullfileName)) file.remove(fullfileName)

#after reviewing the folders and files, it is clear that we will need to setup first the column names for the files:
features <- read.table ( "UCI HAR Dataset/features.txt" , col.names = c ( "Id", "Description"), stringsAsFactors=FALSE )

#set the activity labels too:
activities <- read.table ( "UCI HAR Dataset/activity_labels.txt" , col.names = c ( "Id", "Description"), stringsAsFactors=FALSE )

#At this point we have the column names for our files. THe files are in two folders: Train and Test. THey both have
#the same structure, so we will import them into tables:

#test files
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test.x <- read.table("UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("UCI HAR Dataset/test/y_test.txt")

#train files
train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
train.x <- read.table("UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("UCI HAR Dataset/train/y_train.txt")

#replace in Y files the ID activity with the Full description:
test.y[,1] <- activities$Description[match(test.y[,1],activities$Id)]
train.y[,1] <- activities$Description[match(train.y[,1],activities$Id)]

#now add files as columns:
test <- cbind (test.subject,test.x,test.y)
train <- cbind (train.subject, train.x, train.y)

#add the column names to the files, 
filescolnames <- c("Subject",features[,2],"Activity")
colnames(test) <- filescolnames
colnames(train) <- filescolnames

#now merge train an data and do some cleanup of variables
data <- rbind (train, test)
rm(test,train,train.subject,train.x,train.y,test.subject,test.x,test.y)


#now, we only will care for the columns that contains std() and mean(), so we know which columns are looking into the names(data):
stdmeancols <- grep("-(mean|std)\\(\\)", names(data))

#get only those columns from data, with also Subject(first pos(1)) and Activity(last position):
#Extracts only the measurements on the mean and standard deviation for each measurement
subdata <- data[,c(1,stdmeancols,length(names(data)))]


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
#http://seananderson.ca/2013/10/19/reshape.html 
library(reshape2)

subdatamelted <- melt(subdata, id = c("Subject", "Activity"))
subdatamean <- dcast(subdatamelted, Subject + Activity ~ variable, mean)

write.table(subdatamean, "hopefully_tidy.txt", row.names = FALSE, quote = FALSE)

