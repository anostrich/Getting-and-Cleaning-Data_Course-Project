# Getting-and-Cleaning-Data_Course-Project
This repository is for the course project of getting and cleaning data course on coursera.And this "README.md" file is goint to explain how my r script(run_analysis) can create the requried tidy data set and write it into a txt file.

# Reading data sets
* I use the read.table function to read the data sets.
```
test_data <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
train_data <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
features <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
act_labels <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
```

# Merging test data sets and train data sets
* I use the cbind and rbind function to merge the test data sets and train data sets.
* Firstly, I merge the subject and activity labels data sets of test, and than merge the created data sets with the main data set of test.
* Secondly, I follow the same process as test data set to create train data set.
* Finally, I merge the test data set and train data set by rbind function.
```
test <- cbind(cbind(test_subject, test_labels), test_data)
train <- cbind(cbind(train_subject, train_labels), train_data)
overall_data <- rbind(test,train)
```
#Turning the name of varibles into descriptive ones
* Firstly I extracts the desciptive variables' names form the features names.
* Secondly, I use the colnames funtion change the names of varibles.
```
colnames(overall_data)<- c("subject", "activity_label", as.vector(features[,2]))
```

#Extracting only the measurements on the mean and standard deviation for each measurement
* I use grep function to extract the column names of the required measurements, ,extract them from the overall data set.
```
subset_mean_std <- overall_data[, c(1,2,grep("mean()|std()", names(overall_data)))]
```

#Using descriptive activity names to name the activities in the data set
* Firstly, I convert the subject and activity labels varibles into factor.
* Secondly, I use the levels function to change the numeric levels of activity labels into descriptive ones.
```
subset_mean_std[,2] <- as.factor(subset_mean_std[,2])
subset_mean_std[,1] <- as.factor(subset_mean_std[,1])
for (i in 1:6){
  levels(subset_mean_std$activity_label)[i] <- as.character(act_labels[i,2])
}
```
#Creating a new tidy data set
* Firstly, I use the lenght function to calculate the number of subject and activity labels. Then I know how much rows the  new tidy data should have.
* Secondly, I create the an empty matirx as the new tidy data set.
* Thirdly, I use for loop to give the value of each element of the matrix.
   1. Give the values of the subject colummn.
   2. Give the values of the activity labels column.
   3. Give the valuse of each row, except the elements of subject and activity label
* Finaly, I turn the matrix into data fame, and name the varibles.
```
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
```
#Wrting the data set into a txt file
* I use the write.table function write the tidy data set into a text file.
```
write.table(tidy_data, file = "Assignment_tidy_data_set.txt", row.names = F)
```