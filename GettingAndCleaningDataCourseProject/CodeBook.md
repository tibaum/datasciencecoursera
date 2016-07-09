# Code Book

## Raw Data

The raw data is obtained from the following source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The accompanying website is: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

The unzipped archive results in a folder `UCI HAR Dataset`. The following files from this folder are used in this project:
* train/y_train.txt
* train/subject_train.txt
* train/X_train.txt
* test/y_test.txt
* test/subject_test.txt
* test/X_test.txt
* features.txt
* activity_labels.txt

A description of the raw data and licence information are provided in the files `README.txt` and `features_info.txt` which are also contained in the folder `UCI HAR Dataset`.

## Transformations

The R-script `run_analysis.R` initially downloads the zip-archive mentioned above, unpacks the files and loads them into R. Then the script processes the raw data in the following way:

1. Creates one data set out of the training and test sets.
    * Combines the data from the files `y_train.txt`, `subject_train.txt` and `X_train.txt` into one set of training data that containes the information about which participant produced which data through which activity.
    * In the same way it combines the data from the files `y_test.txt`, `subject_test.txt` and `X_test.txt` into one set of test data.
    * It binds the observations of the training and the test data together into one data set.
2. Using the information from the file `features.txt` the script extracts the measurements on the mean and standard deviation for each measurement.
3. By now the data set containes only the IDs of the activities. Using the information from the file `activity_labels.txt` these IDs are mapped to their descriptive names, e.g. _1_ maps to _walking_.
4. Labels the columns with a description of what measurement the values belong. This is done by taking the information from the file `features.txt` again and processing the names a bit further (removing minus signs, making them more descriptive, e.g. writing _StandardDeviation_ instead of _std_, and so on).
5. Calculates for each activity and each subject the average per measurement.

Finally, the script saves the summarised data to a csv-file called `tidy_data.csv`.






