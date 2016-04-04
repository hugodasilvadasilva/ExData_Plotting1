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
# Select only those columns that matter to plot3
powerconsumption <- df %>% select(Date, Time, Sub_metering_1, Sub_metering_2, Sub_metering_3)

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

# Converts the measures columns into numbers
powerconsumption$Sub_metering_1 <- as.numeric(powerconsumption$Sub_metering_1)
powerconsumption$Sub_metering_2 <- as.numeric(powerconsumption$Sub_metering_2)
powerconsumption$Sub_metering_3 <- as.numeric(powerconsumption$Sub_metering_3)

# Create the plot3
png(filename = "plot3.png", width = 480, height = 480)
plot(
    x = powerconsumption$Datetime, 
    y = powerconsumption$Sub_metering_1, 
    col = "black", 
    type = "lines", 
    xlab = "", 
    ylab = "Energy sub metering")
points(
    x = powerconsumption$Datetime, 
    y = powerconsumption$Sub_metering_2, 
    col = "red",
    type = "lines")
points(
    x = powerconsumption$Datetime, 
    y = powerconsumption$Sub_metering_3, 
    col = "blue",
    type = "lines")
legend("topright",
    col=c("black","red", "blue"),
    legend =c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
    lty = c(1,1,1),
    cex = 0.5
    )
dev.off()
