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

# plot 1
png("plot1.png", width=480, height=480)
hist(data$Global_active_power, main = "Global Active Power", 
     col = "red", xlab = "Global Active Power (kilowatts)")
dev.off()