# expl-data-analisys course project #2
# Plot 1

library(data.table)
library(dplyr)
library(lubridate)
library(lattice)
if(!file.exists("ExData_Plotting2")){
        dir.create("ExData_Plotting2")
}
#Zipped data URL
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# Check for existence of zipped data file if doesn't exist download and extract the data to the ExData_Plotting2 folder.
if(!file.exists("./ExData_Plotting2/NEI_data.zip")){
        download.file(fileURL, destfile = "./ExData_Plotting2/NEI_data.zip")
        unzip("./ExData_Plotting2/NEI_data.zip", exdir = "./ExData_Plotting2")
        list.files("./ExData_Plotting2")
        dataDownloaded <- date()
        dataDownloaded
}

# Read the data
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./ExData_Plotting2/summarySCC_PM25.rds")
SCC <- readRDS("./ExData_Plotting2/Source_Classification_Code.rds")
# Do we have all the years or just a subset?
# looks like we only have 1999, 2002, 2005, and 2008. Ooops the assignment actually says this.
yrs <- unique(NEI$year)
y <- c()
for(i in yrs){
        x <- filter(NEI, NEI$year == i)
        y <- c(y, sum(x$Emissions)) 
} 
total_emissions <- as.data.frame(cbind(Years = yrs, Total_Emissions = y))
# Open the plot device
png(filename = "./ExData_Plotting2/plot1.png", width = 480, height = 480)
# I like the line graph better
#plot(total_emissions$Total_Emissions ~ total_emissions$Years, type="h", lwd=100, lend="square", col="green")
plot(total_emissions$Total_Emissions ~ total_emissions$Years, type="l", ylab = "Total Emissions (tons)", 
     xlab="Year", main = "Total Emissions (PM2.5)")
# Close the device and write the file.
dev.off()
