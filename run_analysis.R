library(plyr)
library(dplyr)
library(memisc)
##Load the X axis labels
x_labels= read.table("UCI HAR Dataset/features.txt")

##Load the subject data
sub_train = read.table("UCI HAR Dataset/train/subject_train.txt")
sub_test = read.table("UCI HAR Dataset/test/subject_test.txt")
ac_labels = read.table("UCI HAR Dataset/activity_labels.txt")

##Load the X axis data
x_train = read.table("UCI HAR Dataset/train/X_train.txt")
x_test = read.table("UCI HAR Dataset//test/X_test.txt")

##Load the Y axis data
y_train = read.table("UCI HAR Dataset/train/y_train.txt")
y_test = read.table("UCI HAR Dataset//test/y_test.txt")

##give clear column and row names. Point 3
colnames(sub_train) = "activity"
colnames(sub_test) = "activity"
colnames(y_test) = "subject"
colnames(y_train) = "subject"
colnames(x_train) = x_labels$V2
row.names(x_train) = paste( "train", row.names(x_train), sep="")
colnames(x_test) = x_labels$V2
row.names(x_test) = paste( "test", row.names(x_test), sep="")

##merge the test and training sets (point 1)
merged_test <- cbind(sub_test, y_test, x_test)
merged_train <- cbind(sub_train, y_train, x_train)
merged_set <- rbind(merged_test, merged_train)

##Make Activity human readable
merged_set$activity <- ac_labels$V2[merged_set$activity]
##clear memory
rm(x_test, x_train, sub_train, sub_test, y_train, y_test)


##select only the mean and standard deviation columns. Excludes the meanFreq() variables: (point 2). point 3 above
activity.mean.stddev = subset(observation = names(merged_set),merged_set, select = grep("activity|subject|(mean\\(\\)$)|(std\\(\\)$)", names(merged_set)))
##clean the variable names, part 4
names(activity.mean.stddev) = gsub("\\(", "", names(activity.mean.stddev))
names(activity.mean.stddev) = gsub("\\)", "", names(activity.mean.stddev))
names(activity.mean.stddev) = gsub("-", ".", names(activity.mean.stddev))
names(activity.mean.stddev) = tolower(names(activity.mean.stddev))


##group by subject and activity and summarize, for the final step:
activity.mean.summary = activity.mean.stddev %>% group_by(subject, activity) %>%
  summarize_each(funs(mean))

#outputting codebooks
Write(codebook(activity.mean.stddev), file="activity-mean-stddev-cdbk.txt")
Write(codebook(activity.mean.summary), file="activity-mean-summary-cdbk.txt")

#outputting the two tables
write.table(activity.mean.stddev, row.name = FALSE, file="activity-mean-stddev.txt")
write.table(activity.mean.summary, row.name = FALSE, file="activity-mean-summary.txt")


