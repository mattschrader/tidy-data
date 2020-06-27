# Step 1: merge the data set into one data set
x_merged <- rbind(x_test, x_train)
y_merged <- rbind(y_test, y_train)
subject_merged <- rbind(subject_test, subject_train)
data_set <- cbind(subject_merged, y_merged, x_merged)

# Step 2: extract the mean and standard deviation from each measurement
mean_std_data <- data_set %>% select(subject, code, contains("mean"), contains("std"))

# Step 3: name the activities in the data set with the descriptive activity names
mean_std_data$code <- activities[mean_std_data$code, 2]

# Step 4: appropriately labels the data set with descriptive variable names
data_cols <- colnames(mean_std_data)
data_cols <- gsub("^f", "frequencyDomain", data_cols)
data_cols <- gsub("^t", "timeDomain", data_cols)
data_cols <- gsub("Acc", "Accelerometer", data_cols)
data_cols <- gsub("Gyro", "Gyroscope", data_cols)
data_cols <- gsub("Mag", "Magnitude", data_cols)
data_cols <- gsub("Freq", "Frequency", data_cols)
data_cols <- gsub("mean", "Mean", data_cols)
data_cols <- gsub("std", "StandardDeviation", data_cols)
data_cols <- gsub("BodyBody", "Body", data_cols)
colnames(mean_std_data) <- data_cols
names(mean_std_data)[2] = "activity"

# Step 5: create a second, independent tidy data set with the average of each variable for each activity and each subject
clean_data <- mean_std_data %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(clean_data, "clean_data.txt", row.name=FALSE)
