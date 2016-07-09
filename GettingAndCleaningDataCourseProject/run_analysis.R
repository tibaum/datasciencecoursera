library(lubridate)
library(dplyr)
library(tidyr)
library(magrittr)


# ========== Getting the data ==========
if (!dir.exists("UCI HAR Dataset")) {
    data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(data_url, destfile = "uci_har_dataset.zip", method = "curl")
    date_downloaded <- now()
    unzip("uci_har_dataset.zip", exdir = getwd())
}


#  ========== Loading the data ==========
options(stringsAsFactors = FALSE)

data_dir <- "UCI HAR Dataset"

training_labels <- read.table(file.path(data_dir, "train", "y_train.txt"))[[1]]
training_subject <- read.table(file.path(data_dir, "train", "subject_train.txt"))[[1]]
training_set <- read.table(file.path(data_dir, "train", "X_train.txt"))

test_labels <- read.table(file.path(data_dir, "test", "y_test.txt"))[[1]]
test_subject <- read.table(file.path(data_dir, "test", "subject_test.txt"))[[1]]
test_set <- read.table(file.path(data_dir, "test", "X_test.txt"))

features <- read.table(file.path(data_dir, "features.txt"))[[2]]
activity_labels <- read.table(file.path(data_dir, "activity_labels.txt"), col.names = c("id", "activity"))



#  ========== Step 1: Merging the training and the test sets  ==========
training_data <- training_set %>% mutate("activity_label" = training_labels, "subject" = training_subject)
test_data <- test_set %>% mutate("activity_label" = test_labels, "subject" = test_subject)
merged_data <- bind_rows(training_data, test_data)



#  ========== Step 2: Extracting the measurements on the mean and standard deviation  ==========
mean_and_std_cols <- grep("-(mean|std)\\(\\)", features)
merged_data <- merged_data %>% select(mean_and_std_cols, activity_label:subject)



#  ========== Step 3: Using descriptive activity names ==========
activity_labels$activity <- activity_labels$activity %>% tolower %>% gsub("_", "", .)
merged_data <- left_join(merged_data, activity_labels, by = c("activity_label" = "id"))
names(merged_data)[ncol(merged_data)] <- "activity"
merged_data <- merged_data %>% select(-activity_label)



#  ========== Step 4: Labeling the data set with descriptive variable names ==========
var_names <- features[mean_and_std_cols]
# make names more readable,
# but produce CamelCaseNames to avoid white space, dots and underlines in variable names
var_names %<>% gsub("\\(\\)", "", .)
var_names %<>% gsub("^t", "time", .)
var_names %<>% gsub("^f", "frequency", .)
var_names %<>% gsub("-mean", "Mean", .)
var_names %<>% gsub("-std", "StandardDeviation", .)
var_names %<>% gsub("-X", "X", .)
var_names %<>% gsub("-Y", "Y", .)
var_names %<>% gsub("-Z", "Z", .)
var_names %<>% gsub("Acc", "Acceleration", .)
var_names %<>% gsub("Gyro", "Gyroscope", .)
var_names %<>% gsub("Mag", "Magnitude", .)
columns_to_name <- 1:length(var_names)
names(merged_data)[columns_to_name] <- var_names



#  ========== Step 5: Tidying the data set with the average of each variable for each activity and each subject ==========
tidy_data <- merged_data %>%
    gather(measurement, value, -activity, -subject) %>%
    group_by(activity, subject, measurement) %>%
    summarise(average = mean(value)) %>%
    arrange(activity, subject, measurement)

write.table(tidy_data, file = file.path(getwd(), "tidy_data.txt"), row.names = FALSE)
