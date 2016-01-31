library(plyr)
library(memisc)
##Load the X axis labels
x_labels= read.table("UCI HAR Dataset/features.txt")

##Load the X axis data
x_train = read.table("UCI HAR Dataset/train/X_train.txt")
x_test = read.table("UCI HAR Dataset//test/X_test.txt")

##give clear column and row names. Point 3
colnames(x_train) = x_labels$V2
row.names(x_train) = paste( "train", row.names(x_train), sep="")
colnames(x_test) = x_labels$V2
row.names(x_test) = paste( "test", row.names(x_test), sep="")

##Load the Y axis data
y_train = read.table("UCI HAR Dataset/train/y_train.txt")
y_test = read.table("UCI HAR Dataset//test/y_test.txt")
##Load the subject data
sub_train = read.table("UCI HAR Dataset/train/subject_train.txt")
sub_test = read.table("UCI HAR Dataset/test/subject_test.txt")

##merge the test and training sets (point 1)
x_test$subject = sub_test[1,]
x_test$y = y_test[1,]
x_train$subject = sub_train[1,]
x_train$y = y_train[1,]
mergedset = rbind(x_train, x_test)

##clear memory
rm(x_test, x_train, sub_train, sub_test, y_train, y_test)


##select only the mean and standard deviation columns. Excludes the meanFreq() variables: (point 2). point 3 above
activity.mean.stddev = subset(observation = names(mergedset),mergedset, select = grep("(mean\\(\\)$)|(std\\(\\)$)", names(mergedset)))
##clean the variable names, part 4
names(activity.mean.stddev) = gsub("\\(", "", names(activity.mean.stddev))
names(activity.mean.stddev) = gsub("\\)", "", names(activity.mean.stddev))



##break the means and std into seperate sets
means = subset(activity.mean.stddev, select = grep("mean$",names(activity.mean.stddev)))
sds = subset(activity.mean.stddev, select = grep("std$",names(activity.mean.stddev)))
names(means)= sub("-mean", "", names(means))
names(sds)= sub("-std", "", names(sds))
## put the parts back together as averages. Part 5
meanaverage = sapply(means, function (x) mean(x))
stddeviationaverage = sapply(sds, function (x) mean(x))
activity.mean.summary = data.frame(activity=names(means), meanaverage, stddeviationaverage)
rm(means, mergedset, sds, x_labels)

#outputting codebooks
Write(codebook(activity.mean.stddev), file="activity-mean-stddev-cdbk.txt")
Write(codebook(activity.mean.summary), file="activity-mean-summary-cdbk.txt")

#outputting the two tables
write.table(activity.mean.stddev, row.name = FALSE, file="activity-mean-stddev.txt")
write.table(activity.mean.summary, row.name = FALSE, file="activity-mean-summary.txt")
print(activity.mean.summary)

