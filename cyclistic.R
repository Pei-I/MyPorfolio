### Cyclistic_Exercise_Full_Year_Analysis ###

# This analysis is for case study 1 from the Google Data Analytics Certificate 
# It’s originally based on the case study "'Sophisticated, Clear, and Polished’:
# Divvy and Data Visualization" written by Kevin Hartman 
# (found here: https://artscience.blog/home/divvy-dataviz-case-study). 
# We will be using the Divvy dataset for the case study. 
# The purpose of this script is to consolidate downloaded Divvy data into a 
# single dataframe and then conduct simple analysis to help answer the key question:
# “In what ways do members and casual riders use Divvy bikes differently?”


# environment setting
library(tidyverse)
library(lubridate)
library(sqldf)

#=====================
# STEP 1: COLLECT DATA
#=====================

#2020
apr_2020<-read.csv("C:/Users/Administrator/Documents/Case Study Cyclistic/data/2020/202004-divvy-tripdata.csv")
may_2020<-read.csv("C:/Users/Administrator/Documents/Case Study Cyclistic/data/2020/202005-divvy-tripdata.csv")
jun_2020<-read.csv("C:/Users/Administrator/Documents/Case Study Cyclistic/data/2020/202006-divvy-tripdata.csv")
jul_2020<-read.csv("C:/Users/Administrator/Documents/Case Study Cyclistic/data/2020/202007-divvy-tripdata.csv")
aug_2020<-read.csv("C:/Users/Administrator/Documents/Case Study Cyclistic/data/2020/202008-divvy-tripdata.csv")
sep_2020<-read.csv("C:/Users/Administrator/Documents/Case Study Cyclistic/data/2020/202009-divvy-tripdata.csv")
oct_2020<-read.csv("C:/Users/Administrator/Documents/Case Study Cyclistic/data/2020/202010-divvy-tripdata.csv")
nov_2020<-read.csv("C:/Users/Administrator/Documents/Case Study Cyclistic/data/2020/202011-divvy-tripdata.csv")
dec_2020<-read.csv("C:/Users/Administrator/Documents/Case Study Cyclistic/data/2020/202012-divvy-tripdata.csv")

q2_2020<-sqldf('SELECT * FROM apr_2020 UNION ALL SELECT * FROM may_2020 UNION ALL SELECT * FROM jun_2020')
q3_2020<-sqldf('SELECT * FROM jul_2020 UNION ALL SELECT * FROM aug_2020 UNION ALL SELECT * FROM sep_2020')
q4_2020<-sqldf('SELECT * FROM oct_2020 UNION ALL SELECT * FROM nov_2020 UNION ALL SELECT * FROM dec_2020')

#2021
jan_2021<-read.csv("C:/Users/Administrator/Documents/Case Study Cyclistic/data/2021/202101-divvy-tripdata.csv")
feb_2021<-read.csv("C:/Users/Administrator/Documents/Case Study Cyclistic/data/2021/202102-divvy-tripdata.csv")
mar_2021<-read.csv("C:/Users/Administrator/Documents/Case Study Cyclistic/data/2021/202103-divvy-tripdata.csv")
q1_2021<-sqldf('SELECT * FROM jan_2021 UNION ALL SELECT * FROM feb_2021 UNION ALL SELECT * FROM mar_2021')

#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================


# Compare column names each of the files
colnames(q2_2020)
colnames(q3_2020)
colnames(q4_2020)
colnames(q1_2021)

# Inspect the dataframes and look for inconguencies
str(q2_2020)
str(q3_2020)
str(q4_2020)
str(q1_2021)

# Convert start_station_id and end_station_id to character so that they can stack correctly
q2_2020<-mutate(q2_2020, start_station_id = as.character(start_station_id),
                end_station_id = as.character(end_station_id))
q3_2020<-mutate(q3_2020, start_station_id = as.character(start_station_id),
                end_station_id = as.character(end_station_id))
q4_2020<-mutate(q4_2020, start_station_id = as.character(start_station_id),
                end_station_id = as.character(end_station_id))


# Stack individual quarter's data frames into one big data frame
all_trips <- bind_rows(q2_2020, q3_2020, q4_2020, q1_2021)

# Convert started_at and ended_at to datetime
all_trips<-mutate(all_trips, started_at = as_datetime(started_at),
                  ended_at = as_datetime(ended_at))

# Remove the columns I don't need
all_trips <- all_trips %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng))

#======================================================
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================

# Inspect the new table that has been created
colnames(all_trips)  #List of column names
nrow(all_trips)  #How many rows are in data frame?
dim(all_trips)  #Dimensions of the data frame?
head(all_trips)  #See the first 6 rows of data frame.  Also tail(qs_raw)
str(all_trips)  #See list of columns and data types (numeric, character, etc)
summary(all_trips)  #Statistical summary of data. Mainly for numerics

# There are a few problems need to be fixed:

# (1) The data can only be aggregated at the ride-level, which is too granular. 
#     We will want to add some additional columns of data -- such as day, month,
#     year -- that provide additional opportunities to aggregate the data.
# (2) Add a calculated field for length of ride > "ride_length".
# (3) There are some rides where tripduration shows up as negative, 
#     including several hundred rides where Divvy took bikes out of circulation
#     for Quality Control reasons. Delete these rides.

# Add columns that list the date, month, day, and year of each ride.
all_trips$date <- as.Date(all_trips$started_at) 
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

# Add a "ride_length" calculation to all_trips (in seconds)
# Syntax: difftime(ended time, started time)

all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)

# Convert "ride_length" from Factor to numeric so we can run calculations on the data
all_trips$ride_length <- as.numeric(all_trips$ride_length)
is.numeric(all_trips$ride_length)

# Remove "bad" data
# The dataframe includes a few hundred entries when bikes were taken out of 
# docks and checked for quality by Divvy or ride_length was negative
# Create a new version of the dataframe (v2) since data is being removed

# Drop rows which ride_length <0
summary(all_trips$ride_length)

sqldf('SELECT ride_length FROM all_trips WHERE ride_length <0')
all_trips_v2 <- all_trips[!(all_trips$start_station_name == "HQ QR" | all_trips$ride_length<0),]

# Drop rows which ride_length = 0

summary(all_trips_v2$ride_length)

all_trips_v2 %>% 
  select(start_station_id, end_station_id, ride_length) %>% 
  filter(ride_length==0)

all_trips_v3 <- subset(all_trips_v2, ride_length !=0)

#=====================================
# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================


# Descriptive analysis on ride_length (all figures in seconds)
summary(all_trips_v3$ride_length)

# See the most popular bike type
all_trips_v3 %>% 
  count(rideable_type) 

# Compare members and casual users
aggregate(all_trips_v3$ride_length ~ all_trips_v3$member_casual, FUN = mean)
aggregate(all_trips_v3$ride_length ~ all_trips_v3$member_casual, FUN = median)
aggregate(all_trips_v3$ride_length ~ all_trips_v3$member_casual, FUN = max)
aggregate(all_trips_v3$ride_length ~ all_trips_v3$member_casual, FUN = min)

# See the average ride time by each day for members vs casual users

aggregate(all_trips_v3$ride_length ~ all_trips_v3$member_casual + all_trips_v3$day_of_week, FUN = mean)

sqldf('SELECT day_of_week, AVG(ride_length), member_casual 
       FROM all_trips_v3  
       GROUP BY day_of_week, member_casual') #try sqldf package

# Notice that the days of the week are out of order. Let's fix that.
all_trips_v3$day_of_week <- ordered(all_trips_v3$day_of_week, 
                                    levels=c("星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"))


# Compare the number of rides by each day
count(all_trips_v3, day_of_week)

# Compare the number of rides by each day for members vs casual users

all_trips_v3 %>% 
  group_by(day_of_week) %>% 
  count(member_casual) 


sqldf('SELECT day_of_week, COUNT(*), member_casual 
       FROM all_trips_v3  
       GROUP BY day_of_week, member_casual') #try sqldf pkg

# Compare the number of rides for members vs casual users 
count(all_trips_v3, member_casual)

# analyze ridership data by type and weekday
all_trips_v3 %>% 
  mutate(weekday = wday(started_at, label = TRUE, locale = "English")) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, weekday)								# sorts

sqldf('SELECT day_of_week weekday, COUNT(*) number_of_rides, AVG(ride_length) average_duration, member_casual 
         FROM all_trips_v3  
        GROUP BY day_of_week, member_casual') #try sqldf pkg

# Assign a name for the analyzed data frame

V<-all_trips_v3 %>% 
  mutate(weekday = wday(started_at, label = TRUE, locale = "English")) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  

# Notice that the days of the week are out of order. Let's fix that.

V$weekday <- ordered(V$weekday, levels=c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))


# Visualize the number of rides by rider type
ggplot(data = V, mapping = aes(x = weekday, y = number_of_rides, fill = member_casual))+
  geom_col( position = "dodge")+
  labs(title = "Cyclistic BIKE-SHARE: Weekday VS. Number of Rides", 
       subtitle = "Comparison of Rider Type", 
       caption = "Data collected from https://divvy-tripdata.s3.amazonaws.com/index.html")


ggplot(data = V, mapping = aes(x = weekday, y = average_duration, fill = member_casual))+
  geom_col( position = "dodge")+
  labs(title = "Cyclistic BIKE-SHARE: Weekday VS. Avg Duration", 
       subtitle = "Comparison of Rider Type", 
       caption = "Data collected from https://divvy-tripdata.s3.amazonaws.com/index.html")


#=================================================
# STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
#=================================================

write.csv(V,'result.csv')






