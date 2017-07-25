library(readr)

## Download the data file

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile = "household_power_consumption.zip")

## Read in the data from where it was downloaded; make sure to indicate that "?" is the NA value
hpc <- read_delim("household_power_consumption.zip",";", escape_double = FALSE, 
                  na = "?", trim_ws = TRUE)

## Reformat the Date variable, and limit the data set to the appropriate dates (Feb 1st and 2nd, 2007)
hpc$Date <- as.Date(hpc$Date, "%d/%m/%Y")
hpc <- hpc[hpc$Date == "2007-02-01" | hpc$Date == "2007-02-02",]

## Reformat the time variable (must prepend the date for strptime to work)
hpc$when <- paste(hpc$Date, hpc$Time)
hpc$when <- strptime(hpc$when, "%Y-%m-%d %H:%M:%S")

## Open the png graphics device, using the parameters given in the assignment
png(filename = "plot4.png",
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white", res = NA, family = "", restoreConsole = TRUE,
    type = c("windows", "cairo", "cairo-png"))

## Plot the histogram to the graphics device. 

par(mfrow = c(2, 2), mar = c(4, 4, 2, 1))
## Top left graph
with(hpc, plot(when, Global_active_power, type = "l",
       xlab = "", ylab = "Global Active Power", main = ""))

## Top right graph
with(hpc, plot(when, Voltage, type = "l",
               xlab = "datetime", ylab = "Voltage", main = ""))

## Bottom left graph
with(hpc, plot(when, Sub_metering_1, type = "o", cex = 0, xlab = "", ylab = "Energy sub metering", main = ""))
        lines(hpc$when, hpc$Sub_metering_2, type = "o", col = "red", cex = 0)
        lines(hpc$when, hpc$Sub_metering_3, type = "o", col = "blue", cex = 0)

## Add the legend        
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty=1, cex=1, bty= "n")

## Bottom right graph
with(hpc, plot(when, Global_reactive_power, type = "l",
               xlab = "datetime", ylab = "Global_reactive_power", main = ""))


## Turn OFF the graphics device, so the plot will be written to the specified file
dev.off()