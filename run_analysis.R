

##############################################################



## Import data
xr = read.table("X_train.txt",sep="")
xt = read.table("X_test.txt",sep="")
yr = read.table("y_train.txt",sep="")
yt = read.table("y_test.txt",sep="")
sr = read.table("subject_train.txt",sep="")
st = read.table("subject_test.txt",sep="")

## merges the training and the test sets to create one data set: dataALL
data <- rbind(xr, xt)
subject <- rbind(sr, st)
activity <- rbind(yr, yt)
dataALL <- cbind(data,subject,activity)

## Extract names for variables and activity labels
features=read.table("features.txt",sep="")
featuresname <- as.character(features$V2)
actlabel=read.table("activity_labels.txt",sep="")
actlabelname <- as.character(actlabel$V2)

## extract the measurements on the mean and standard diviation using features names: "mean", "std"
vnames <- c(featuresname, "Subject", "Activity")
names(dataALL)[1:563]<- vnames
colNames <- (vnames[(grepl("mean",vnames) | grepl("std",vnames) | grepl("Subject",vnames) | grepl("Activity",vnames)) == TRUE])
exdata <- dataALL[,colNames]

## name data set with Activity names
for (n in 1:6){
  exdata$Activity[exdata$Activity == n] <- actlabelname[n]
}

## step5: group data set by activity and subject and calculate the average of each of the variables
newdata <- aggregate(exdata[,1] ~ Subject + Activity, exdata, mean)
for (i in 2:79){
  d <- aggregate(exdata[,i] ~ Subject + Activity, exdata, mean) 
  newdata[,i+2] <- d[,3]
}

## rename column and save as text file
newcolName <- c("Subject", "Activity",colNames[1:79])
names(newdata)[1:81]<- newcolName
tidydataset <- newdata
write.table(tidydataset, "tidydataset.txt", sep=" ", row.names=FALSE)
