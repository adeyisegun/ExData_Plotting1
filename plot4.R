library(data.table)
# url containing the data to read from
path = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# create a temp folder to load data 
from_dir <- tempfile()
t_dir <- tempfile()
download.file(path, t_dir, mode = "wb")

#unzip data into temp folder
unzip(t_dir, exdir = from_dir)

# get the first row of the data
dat <- fread(file = paste0(from_dir,"/household_power_consumption.txt"), nrows = 1)

# to calculate number of rows to skip when reading data
a <- strptime(paste(dat[,1], dat[,2]), "%d/%m/%Y %H:%M:%S")
b <- strptime("01/02/07 00:00:00", "%d/%m/%y %H:%M:%S")
skip = as.integer(difftime(b, a, units = "min")) + 1

# to calculate number of rows to read
c <- strptime("01/02/07 00:00:00", "%d/%m/%y %H:%M:%S")
d <- strptime("03/02/07 00:00:00", "%d/%m/%y %H:%M:%S")
nrows = as.integer(difftime(d, c, units = "min"))

# read household_power_consumption data
data <- fread(file = paste0(from_dir,"/household_power_consumption.txt"), skip = skip, nrows = nrows)

#check if skip & nrows was calculated correctly
e <- strptime(paste(data[1,1],data[1,2]), "%d/%m/%Y %H:%M:%S")
if(!identical(b,e) == TRUE) {stop("check the first row")}

# Rename column of data
colnames(data) <- c("Date","Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

# add a column to contain date&time
library(dplyr)
data <- mutate(data, date_time = as.POSIXct(paste(data$Date, data$Time), format="%d/%m/%Y %H:%M:%S"))

#where to save your png file to
# check the same folder you loaded the r script from
setwd(dirname(rstudioapi::getSourceEditorContext()$path))



# plot 4
png("plot4.png", width=480, height=480)
par(mfrow = c(2, 2), mar = c(4, 5, 1, 1), oma = c(2, 0, 0, 0))

# plot 4a
plot(data$date_time, data$Global_active_power, type = "l", 
     ylab = "Global Active Power", xlab = "")
# plot 4b
plot(data$date_time, data$Voltage, type = "l", ylab = "Voltage", xlab = "datetime")
# plot 4c
plot(data$date_time, data$Sub_metering_1, type = "l",
     ylab = "Energy sub metering", xlab = "")
points(data$date_time, data$Sub_metering_2, type = "l", col = "red")
points(data$date_time, data$Sub_metering_3, type = "l", col = "blue")
legend("topright", col = c("black","red","blue"), pch = "__", 
       legend =  names(data[, c(7,8,9)]), bty="n")
# plot 4d
plot(data$date_time, data$Global_reactive_power, type = "l", ylab = names(data[, 4]), xlab = "datetime")
dev.off()