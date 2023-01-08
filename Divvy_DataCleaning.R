## 1. import raw data
rm(list=ls())
dv_all_raw <- read.csv("divvy_all_fixed.csv")
dv_distance <- read.csv("trip_distance (1).csv")
dv_station <- read_excel("station_table_final.xlsx")

## 2. duplicate data
dv_all <- dv_all_raw

## 3. remove N/A
dv_all <- na.omit(dv_all)

## 3. calculate trip duration
# change data type for started_at and ended_at
dv_all$started_at <- as.POSIXct(dv_all$started_at, format = "%Y-%m-%d %H:%M:%S")
dv_all_raw$ended_at <- as.POSIXct(dv_all_raw$ended_at, format = "%Y-%m-%d %H:%M:%S")
dv_all$trip_duration_min <- difftime(dv_all$ended_at, dv_all$started_at, units = 'mins')

## 4. add columns for additional info
#. YY/MM/DD 
dv_all$Year <- substr(dv_all$started_at, 1, 4)
dv_all$Month <- substr(dv_all$started_at, 6, 7)
dv_all$Date <- substr(dv_all$started_at, 9, 10)
dv_all$Year <- as.numeric(dv_all$Year)
dv_all$Month <- as.numeric(dv_all$Month)
dv_all$Date <- as.numeric(dv_all$Date)

# 5. location = (lat, long)
s1 <- paste(dv_all$start_lat, dv_all$start_lng, sep=",")
e1 <- paste(dv_all$end_lat, dv_all$end_lng, sep=",")
dv_all$Location_start <- paste0("(",s1,")")
dv_all$Location_end <- paste0("(",e1,")")

## 8.
dv_all2 <- merge(dv_all, dv_distance, by="X")
View(dv_all2)

write.csv(dv_all2,file="dv_all_fixed_4.csv")
write.csv(dv_all4,file="dv_all_fixed_5.csv")

# double check
dv_doublecheck <- read.csv("dv_all_fixed_4.csv")
str(dv_doublecheck)
