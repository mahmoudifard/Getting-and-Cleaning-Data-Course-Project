##Getting and Cleaning Data Course Project
##Seyed Mahmoudifard
##Instructions for project

##The purpose of this project is to demonstrate your ability to collect, work with, 
##and clean a data set. The goal is to prepare tidy data that can be used for later
##analysis. You will be graded by your peers on a series of yes/no questions related
##to the project. You will be required to submit: 

##  1- a tidy data set as described below
##  2- a link to a Github repository with your script for performing the analysis
##  3- a code book that describes the variables, the data, and any transformations
##     or work that you performed to clean up the data called CodeBook.md. You should
##     also include a README.md in the repo with your scripts. This repo explains how
##     all of the scripts work and how they are connected.


##One of the most exciting areas in all of data science right now is wearable
##computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop
##the most advanced algorithms to attract new users. The data linked to from the
##course website represent data collected from the accelerometers from the Samsung
##Galaxy S smartphone. 

##Here are the data for the project: 
  
##https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##You should create one R script called run_analysis.R that does the following.
  
##  1- Merges the training and the test sets to create one data set.  
##  2- Extracts only the measurements on the mean and standard deviation for each measurement.  
##  3- Uses descriptive activity names to name the activities in the data set  
##  4- Appropriately labels the data set with descriptive variable names.  
##  5- From the data set in step 4, creates a second, independent tidy data set
##     with the average of each variable for each activity and each subject.  

##setting the working directory


setwd("C://Users//Ehsan//Desktop//R training//Data cleaning")


##Downloading the Data and put it in the Data folder

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/
            getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

##Unziping the file and put them in a folder named UCI HAR Dataset

unzip(zipfile="./data/Dataset.zip",exdir="./data")
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)

##The files that will be used to load data are listed as follows:  
  
##test/subject_test.txt
##test/X_test.txt
##test/y_test.txt
##train/subject_train.txt
##train/X_train.txt
##train/y_train.txt


##ReadING data from the mentioned files

##Values of Varible Activity consist of data from "Y_train.txt" and "Y_test.txt"
##values of Varible Subject consist of data from "subject_train.txt" and subject_test.txt"
##Values of Varibles Features consist of data from "X_train.txt" and "X_test.txt"
##Names of Varibles Features come from "features.txt"
##levels of Varible Activity come from "activity_labels.txt"

##So we will use Activity, Subject and Features as part of descriptive variable
##names for data in data frame.

##Reading the Activity files  

dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

##Reading the Subject files  

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

##Reading Fearures files

dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)


##Merges the training and the test sets to create one data set  
##1.Concatenate the data tables by rows  



dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

##2.set names to variables

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2


##3.Merge columns to get the data frame Data for all data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

##Extracts only the measurements on the mean and standard deviation for each measurement  
##Subset Name of Features by measurements on the mean and standard deviation
##i.e taken Names of Features with "mean()" or "std()"  

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

##Subset the data frame Data by seleted names of Features

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)



##Uses descriptive activity names to name the activities in the data set  
##1.Read descriptive activity names from "activity_labels.txt"

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

##Appropriately labels the data set with descriptive variable names  

##In the former part, variables activity and subject and names of the activities 
##have been labelled using descriptive names.In this part, Names of Feteatures will
##labelled using descriptive variable names.

##prefix t is replaced by time
##Acc is replaced by Accelerometer
##Gyro is replaced by Gyroscope
##prefix f is replaced by frequency
##Mag is replaced by Magnitude
##BodyBody is replaced by Body

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#Creating a second,independent tidy data set and ouput it

##In this part,a second, independent tidy data set will be created with the average
##OF each variable for each activity and each subject based on the data set in step 4.

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

##Prouducing Codebook  
library(knitr)
knit2html("data cleaning project.Rmd")

