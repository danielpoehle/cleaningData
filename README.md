cleaningData
============
==================================================================
Average Smartphone Sensor Data for Different Activities
Version 1.0
==================================================================
Original Data:
=============
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================
Citation:
========
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and 
Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones 
using a Multiclass Hardware-Friendly Support Vector Machine. 
International Workshop of Ambient Assisted Living (IWAAL 2012). 
Vitoria-Gasteiz, Spain. Dec 2012
==================================================================
Description of the Original Dataset:
===================================
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually.  

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 
==================================================================
Description of the provided Dataset:
===================================
This dataset contains the mean and standard deviation of the original sensor data. For each subject, activity and sensor data the average of all collected sensor data is given. See the Codebook for more details.
==================================================================
Notes: 
=====
- All features are normalized and bounded within [-1,1].
==================================================================
Explanation of the provided Script run_analysis.R:
=================================================
Line 1:4
========
setting the working directory and importing the necessary libraries

Line 6:13
=========
The file names are stored to variables for the import oft the data set

Line 15:27
==========
Import of the data train set into a data frame
first column are the subjects named 1...30
second column are the activities named 1...6
the sensor data with total 561 variables are stored in column 3:563 
to import the sensor data, the loop goes column by column and cuts a string of length 15
out of each line at the right position for each column
example: the first column in the sensor-data goes from position 2...16, 
the second column goes from position 18...32 etc.
so for column i from 1:561 this means: cut from position 2+(i-1)*16 to position 16*i

Line 29:41
==========
The same is done for the test data set

Line 43:50
==========
To merge training and test data set, the column names have to fit together
column 1 gets name "Subject"
column 2 gets name "Activity"
column 3:563 get the names of the features of the sensor data

Line 52
=======
Training and test data set are merged to the complete data set

Line 54:60
==========
Only sensor data with mean or standard deviation shall be used
so the column names are filtered by key words "mean" and "std"
then the filtered data set with relevant columns is created

Line 62:67
==========
To give descriptive activity names, the given activity-labels are imported 
and will be used as factor levels for the second column "Activity" 

Line 69
=======
To have a look at the tidy dataset with relevant columns 


Line 71:80
==========
The second independent data set is created with every combination of
subject, activity and sensor variable. The value for the sensor variable shall
be the average of all values of the filtered tidy data set.
the for loop calculates the mean for each variable and every combinantion 
of subject and activity using tapply.
The resulting data-set is not tidy because the variable activity is not in a
single column but in 6 different columns

Line 82:87
==========
To tidy the data set, the activity-columns are melted to one single column 
called "Activity" and the values are transformed to factors

Line 89
=======
To have a look at the tidy dataset with average values


Line 91
=======
The tidy dataset with average values is written to a text file

==================================================================
