# set working directory
setwd("D:/Users/DanielPoehle/Documents/RFiles/Cours/project")
library(stringr)
library(reshape2)

# Set the fileNames to load the data sets afterwards
fileXTrain <- "./UCI HAR Dataset/train/X_train.txt"
fileYTrain <- "./UCI HAR Dataset/train/y_train.txt"
fileSubjectTrain <- "./UCI HAR Dataset/train/subject_train.txt"

fileXTest <- "./UCI HAR Dataset/test/X_test.txt"
fileYTest <- "./UCI HAR Dataset/test/y_test.txt"
fileSubjectTest <- "./UCI HAR Dataset/test/subject_test.txt"

##### 1. Load Train-Data ###########################

# first column: subject 1...30
dataTrainClean <- read.csv(fileSubjectTrain, stringsAsFactors = FALSE, header = FALSE)
# second column: activity 1...6
dataTrainClean <- cbind(dataTrainClean, read.csv(fileYTrain, stringsAsFactors = FALSE, header = FALSE))

# third until 563 th column: data from sensors
dataXTrain <- readLines(fileXTrain)
# first column in sensor-data goes from character 2...16, second col goes from 18...32 etc. last col goes from character 8962...8976
for(i in 1:561){
  dataTrainClean <- cbind(dataTrainClean, as.numeric(str_sub(dataXTrain, 2+(i-1)*16,16*i)))
}

##### 2. Load Test-Data ###########################

# first column: subject 1...30
dataTestClean <- read.csv(fileSubjectTest, stringsAsFactors = FALSE, header = FALSE)
# second column: activity 1...6
dataTestClean <- cbind(dataTestClean, read.csv(fileYTest, stringsAsFactors = FALSE, header = FALSE))

# third until 563 th column: data from sensors
dataXTest <- readLines(fileXTest)
# first column in sensor-data goes from character 2...16, second col goes from 18...32 etc. last col goes from character 8962...8976
for(i in 1:561){
  dataTestClean <- cbind(dataTestClean, as.numeric(str_sub(dataXTest, 2+(i-1)*16,16*i)))
}

##### 3. Merge Train and Test-Data ###########################

fileNameFeatures <- "./UCI HAR Dataset/features.txt"
features <- read.csv(fileNameFeatures, stringsAsFactors = FALSE, header = FALSE, sep = "\n")
names(dataTrainClean)[1:2] <- c("Subject", "Activity")
names(dataTestClean)[1:2] <- c("Subject", "Activity")
names(dataTrainClean)[3:563] <- features[,1]
names(dataTestClean)[3:563] <- features[,1]

dataCompleteClean <- rbind(dataTrainClean, dataTestClean)

##### 4. Get relevant columns with mean() and std() ###########################

colWithMean <- grep("mean()", features[,1])
colWithStd <- grep("std()", features[,1])
relevantColumns <- sort(c(colWithMean,colWithStd))+2 #Add 2 because of first and second column subject and activity

dataRelevantClean <- dataCompleteClean[,c(1,2,relevantColumns)]

##### 5. Set factors for Activities ###########################

fileNameActivities <- "./UCI HAR Dataset/activity_labels.txt"
activities <- read.csv(fileNameActivities, stringsAsFactors = FALSE, header = FALSE, sep = "\n")
dataRelevantClean$Activity <- as.factor(dataRelevantClean$Activity)
levels(dataRelevantClean$Activity) <- activities[,1]

View(dataRelevantClean)

##### 6. Get average data for each combination of subject and activity ###########################

averageData <- data.frame(Subject = integer(0), WALKING = numeric(0), WALKING_UPSTAIRS = numeric(0), WALKING_DOWNSTAIRS = numeric(0), SITTING = numeric(0), STANDING = numeric(0), LAYING = numeric(0), Variable = character(0))

for(i in 3:81){
  tempDf <- data.frame(tapply(dataRelevantClean[,i], dataRelevantClean[,1:2], mean))
  tempDf <- cbind(Subject = row.names(tempDf), tempDf)
  tempDf <- cbind(tempDf, Variable = rep(names(dataRelevantClean)[i], length(unique(dataRelevantClean[,1]))))
  averageData <- rbind(averageData, tempDf)
}

##### 7. Tidy dataset: columns for activities melted to the column "Activity" ###########################

averageData <- melt(averageData, id = c("Subject", "Variable"), measure.vars = c("X1.WALKING", "X2.WALKING_UPSTAIRS", "X3.WALKING_DOWNSTAIRS", "X4.SITTING", "X5.STANDING", "X6.LAYING"))
names(averageData)[2:4] <- c("Sensor_Variable", "Activity", "Average_Value") 
averageData$Activity <- as.factor(averageData$Activity)
levels(averageData$Activity) <- activities[,1]

View(averageData)

write.table(averageData, file = "averageDataSet.txt", row.names = FALSE)
