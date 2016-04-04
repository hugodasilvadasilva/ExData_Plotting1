library(dplyr)

# Read dataset (download, unzip and load)
zip.file.name = "powerconsumption.zip"
txt.file.name = "household_power_consumption.txt"
url.file = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#Check if the file hasn't already been downloaded
if(!file.exists(zip.file.name)){
    
    # If it doesn't, download and unpack the file
    download.file(url = url.file, destfile = zip.file.name, method = "curl")
    unzip(zip.file.name)
}
df <- read.table(txt.file.name, header = TRUE, sep = ";", stringsAsFactors = FALSE)

### Starting the cleanning data ###

# Select only those columns that matter to plot2
powerconsumption <- df %>% select(Date, Time, Global_active_power)

# Converting the date and time columns into date and time format
powerconsumption$Datetime <- strptime(
    paste(powerconsumption$Date, powerconsumption$Time, sep = " "), 
    format = "%d/%m/%Y %H:%M:%S")

#Convert the Date column into date
powerconsumption$Date <- as.Date(
    as.character(powerconsumption$Date), 
    format = "%d/%m/%Y")

# Subset only those where Date is between 01/02/2007 and 02/02/2007
powerconsumption <- subset(
    powerconsumption, 
    powerconsumption$Date >= as.Date("2007-02-01", format = "%Y-%m-%d") & 
        powerconsumption$Date <= as.Date("2007-02-02", format = "%Y-%m-%d")
)

# Converts the measure columns into numeric type
powerconsumption$Global_active_power <- as.numeric(powerconsumption$Global_active_power)

# Creates the plot file into Working space
png(filename = "plot2.png", width = 480, height = 480)
plot(
    x = powerconsumption$Datetime, 
    y = powerconsumption$Global_active_power, 
    type = "lines", 
    ylab = "Global Active Power (kilowatts)", 
    xlab = "")
dev.off()