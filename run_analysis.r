#reading data sets
test_data <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
train_data <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
features <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
act_labels <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
#merging test data sets and train data sets
test <- cbind(cbind(test_subject, test_labels), test_data)
train <- cbind(cbind(train_subject, train_labels), train_data)
overall_data <- rbind(test,train)
#turning the name of varibles into descriptive ones
colnames(overall_data)<- c("subject", "activity_label", as.vector(features[,2]))
#extracting only the measurements on the mean and standard deviation for each measurement
subset_mean_std <- overall_data[, c(1,2,grep("mean()|std()", names(overall_data)))]
#using descriptive activity names to name the activities in the data set
subset_mean_std[,2] <- as.factor(subset_mean_std[,2])
subset_mean_std[,1] <- as.factor(subset_mean_std[,1])
for (i in 1:6){
  levels(subset_mean_std$activity_label)[i] <- as.character(act_labels[i,2])
}
#creating a new tidy data set
ns <- length(levels(subset_mean_std$subject))
nact <- length(levels(subset_mean_std$activity_label))
tidy_data <-matrix(nrow = ns*nact, ncol =ncol(subset_mean_std) )
for (i in 1:ns){
  for (j in 1:nact){
    tidy_data[(i-1)*nact+j,1] <- levels(subset_mean_std$subject)[i]
    tidy_data[(i-1)*nact+j,2] <- levels(subset_mean_std$activity_label)[j]
    for (k in 3:ncol(subset_mean_std)){
      tidy_data[(i-1)*nact+j, k] <- mean(subset_mean_std[subset_mean_std$subject %in% levels(subset_mean_std$subject)[i] & subset_mean_std$activity_label %in% levels(subset_mean_std$activity_label)[j],k])
    }
  }
}
tidy_data <-as.data.frame(tidy_data)
colnames(tidy_data) <- names(subset_mean_std)
#wrting the data set into a txt file
write.table(tidy_data, file = "Assignment_tidy_data_set.txt", row.names = F)