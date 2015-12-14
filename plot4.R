# expl-data-analisys course project #2
# Plot 4

library(data.table)
library(dplyr)
library(lubridate)
library(ggplot2)

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
#yrs <- unique(NEI$year)

#grep("[Cc]ombustion", SCC$SCC.Level.Four, value = FALSE)
#coal_combustion <- SCC %>% filter(grepl("[Cc]ombustion", SCC.Level.Four)) %>% filter(grepl("[Cc]oal", SCC.Level.Four))
x <- SCC %>% filter(grepl("[Cc]ombustion", Short.Name)) %>% filter(grepl("[Cc]oal", Short.Name))
coal_combustion <- NEI %>% filter(SCC %in% x$SCC)
yrs <- unique(coal_combustion$year)
y <- c()
for(i in yrs){
        x <- filter(coal_combustion, coal_combustion$year == i)
        y <- c(y, sum(x$Emissions)) 
} 
total_coal_emissions <- as.data.frame(cbind(Years = yrs, Total_Coal_Emissions = y))
# Open the plot device
png(filename = "./ExData_Plotting2/plot4.png", width = 480, height = 480)
qplot(Years, Total_Coal_Emissions, data = total_coal_emissions, geom = c("point","line"))
dev.off()

