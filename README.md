# Lesson 3 Course Project

The R code first loads the features & activity labels as a reference tables
The loads the training data sets for subject, activity and X-train
The data sets were then given meaningful column/variable names. Variable names for X_train were taken from feature_labels

The code then checks to see if all three data sets match on row dimension, and if so, proceeds to a row id to all three, and uses that to merge. This is done rather than a raw cbind in the event of accidental sorting.
The training dats sets are then merged.

The exact same steps are repeated for test data sets except that row ids are to begin from the end of the training data sets

After that the row_di column is renamed so that two datasets now have the same name & they are merged using rbind.

Feature labels contain "mean90" and "std90" are pulled out using grep. These are then used to subset the main data set.

