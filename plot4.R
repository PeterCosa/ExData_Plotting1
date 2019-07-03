library(dplyr)
library(lubridate)
library(sqldf)
###Setup output device to png file
png("plot4.png", width = 480, height = 480)

### Read in data to data.table
powerdata <- read.table("household_power_consumption.txt", header = TRUE,sep=";"
                        , stringsAsFactors = FALSE)
power_tbl <- tbl_df(powerdata)

#### Filter out the dates that are not required
epc <- filter(power_tbl, Date == "2/2/2007" | Date == "1/2/2007")

#### Create the date/time column by creating a new column joining date time
epc <- mutate(epc, DateTime = paste(Date, Time, sep = " "))

#### Format the date/time variable
epc$DateTime <- strptime(epc$DateTime, "%d/%m/%Y %H:%M:%S")

### Make all other columns numeric 
epc[, 3:9] <- lapply(epc[, 3:9], as.numeric)

##exclude the first two columns from the data set and put the date filed at the start
epc_data <- epc[ , c(10, 3:9)]

### Tidy column names 
epc_data <- rename(epc_data, Kitchen = Sub_metering_1, 
                   Laundry_room = Sub_metering_2, Heater_AC = Sub_metering_3)

par(mfrow = c(2,2))
plot(epc_data$DateTime, epc_data$Global_active_power, type = "l", ylab = "Global Active Power", xlab = "")

plot(epc_data$DateTime, epc_data$Voltage, type = "l", ylab = "Voltage", xlab = "datetime")

plot(epc_data$DateTime, epc_data$Kitchen, type = "l", ylab = "Energy sub metering", xlab = "")
points(epc_data$DateTime, epc_data$Laundry_room, type = "l", col = "red")
points(epc_data$DateTime, epc_data$Heater_AC, type = "l", col = "blue")
legend("topright", lty = c(1,1,1), lwd = c(2,2,2), col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n", cex = 0.75)

plot(epc_data$DateTime, epc_data$Global_reactive_power,
     type = "l", ylab = "Global reactive power", xlab = "datetime")


dev.off()
