# get data
x_train <- read.table("C:/Users/Desktop/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/Desktop/UCI HAR Dataset/train/Y_train.txt")
x_test <- read.table("C:/Users/Desktop/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/Desktop/UCI HAR Dataset/test/Y_test.txt")
sub_train <- read.table("C:/Users/Desktop/UCI HAR Dataset/train/subject_train.txt")
sub_test <- read.table("C:/Users/Desktop/UCI HAR Dataset/test/subject_test.txt")
activity_labels <- read.table("C:/Users/Desktop/UCI HAR Dataset/activity_labels.txt")
features <- read.table("C:/Users/Desktop/UCI HAR Dataset/features.txt")
# merge data

data<-rbind(cbind(cbind(x_train,y_train),sub_train),cbind(cbind(x_test,y_test),sub_test))
features<-rbind(rbind(features,c(562,"Id_Activity")),c(563,"Subject"))[,2]
head(data)

# give names for each column
colnames(data)<-features
colnames(data)[562]<-"Subject"
colnames(data)[563]<-"ActivityId"
colnames(activity_labels)[1]<-"ActivityId"

# leave data with column names containing "mean","std"
data_mean_std <- sensor_data[,grepl("mean|std|ActivityId|Subject", names(data))]
# adding activity names matched with ActivityID
data_mean_std_activity_added<-join(data_mean_std,activity_labels,by="ActivityId", match = "first")
colnames(data_mean_std_activity_added)[82]<-"Activity_name"

#rename culumns
names(data_mean_std_activity_added) <- gsub('Acc',"Acceleration_signal",names(data_mean_std_activity_added))
names(data_mean_std_activity_added) <- gsub('Gyro',"Angular_velocity",names(data_mean_std_activity_added))
names(data_mean_std_activity_added) <- gsub('Mag',"Magnitude",names(data_mean_std_activity_added))
names(data_mean_std_activity_added) <- gsub('^f',"Frequency_domain_",names(data_mean_std_activity_added))
names(data_mean_std_activity_added) <- gsub('^t',"Time_domain_",names(data_mean_std_activity_added))

# independent dataset with mean values
data_mean_std_activity_added_averages = ddply(data_mean_std_activity_added, c("Subject","Activity_name"), numcolwise(mean))
write.table(data_mean_std_activity_added_averages,"C:/Users/Desktop/data_mean_std_activity_added_averages.txt",row.name=FALSE)