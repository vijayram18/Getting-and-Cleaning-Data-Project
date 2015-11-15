# Get working directory string
library(data.table)
wdir <- getwd()

# Step 1: Load the reference tables: features & activity labels

activity_labels <- read.table("activity_labels.txt", quote="\"", comment.char="", stringsAsFactors=FALSE)
names(activity_labels) <- c("activity_cd", "activity")

feature_labels <- read.table("features.txt", quote="\"", comment.char="", stringsAsFactors=FALSE)
names(feature_labels) <- c("feature_cd", "feature")

# Step 2: Load training data sets: subject_train, X_train, y_train
subject_train <- read.table(paste(wdir, "/train/subject_train.txt", sep =""), quote="\"", comment.char="", stringsAsFactors=FALSE)
names(subject_train) <- "Subject_no"
X_train <- read.table(paste(wdir, "/train/X_train.txt", sep =""), quote="\"", comment.char="", stringsAsFactors=FALSE)
names(X_train) <- feature_labels$feature
y_train <- read.table(paste(wdir, "/train/y_train.txt", sep =""), quote="\"", comment.char="", stringsAsFactors=FALSE)
names(y_train) <- "activity_cd"

# Step 3: Assign a row_id in case of accidental sorting.

if (nrow(subject_train) == nrow(X_train) & nrow(X_train) == nrow(y_train)) { row_id <- 1:nrow(X_train) 
subject_train <- cbind(subject_train,row_id)
X_train <- cbind(X_train,row_id)
y_train <- cbind(y_train,row_id)
}

#Step 4: Merge the data sets
data_sx_train <- merge(subject_train, X_train, by = "row_id")
data_train <- merge(data_sx_train, y_train, by = "row_id")
data_train <- merge(data_train, activity_labels, by = "activity_cd")


# Step 5: Repeat Step 2 with test; Load test data sets: subject_test, X_test, y_test
subject_test <- read.table(paste(wdir, "/test/subject_test.txt", sep =""), quote="\"", comment.char="", stringsAsFactors=FALSE)
names(subject_test) <- "Subject_no"
X_test <- read.table(paste(wdir, "/test/X_test.txt", sep =""), quote="\"", comment.char="", stringsAsFactors=FALSE)
names(X_test) <- feature_labels$feature
y_test <- read.table(paste(wdir, "/test/y_test.txt", sep =""), quote="\"", comment.char="", stringsAsFactors=FALSE)
names(y_test) <- "activity_cd"

# Step 6: Repeat Step 3 with test; Assign a row_id in case of accidental sorting.
# Use row_id starting after the last rown from train

if (nrow(subject_test) == nrow(X_test) & nrow(X_test) == nrow(y_test)) { row_id2 <- (nrow(X_train) + 1): (nrow(X_train)+ nrow(X_test)) 
subject_test <- cbind(subject_test,row_id2)
X_test <- cbind(X_test,row_id2)
y_test <- cbind(y_test,row_id2)
}

# Step 7: Repeat Step 4 with test; Merge the data sets
data_sx_test <- merge(subject_test, X_test, by = "row_id2")
data_test <- merge(data_sx_test, y_test, by = "row_id2")
data_test <- merge(data_test, activity_labels, by = "activity_cd")


# Step 8: Combine train and test data set
setnames(data_test, "row_id2", "row_id")
data_combined <- rbind(data_train, data_test)

# Step 9: Subset the data
select_features_mean <- grep("mean()", feature_labels$feature, fixed = TRUE)
select_features_std <- grep("std()", feature_labels$feature, fixed = TRUE)
select_features <- feature_labels$feature[c(select_features_mean, select_features_std)]
data_msd <- data_combined[,c("row_id", "Subject_no", "activity_cd", "activity", select_features)]
data_aggr_msd <- with(data_msd,aggregate(data_msd, by = list(Subject_no, activity), mean))

# Clean up
drop <- names(data_aggr_msd) %in% c("Group.1", "activity", "row_id")
data_aggr_msd <- data_aggr_msd[!drop]
setnames(data_aggr_msd, "Group.2","activity")

#Export
write.table(data_aggr_msd, file = "Step5_tidy_data.txt", sep = ",")

# Remove everything
rm(list =ls())

