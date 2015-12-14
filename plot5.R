# expl-data-analisys course project #2
# Plot 5

library(dplyr)
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

# Including Highway and off-highway
#grep("[Hh]ighway", SCC$Short.Name, value = TRUE)
# Gather and filter out only motor vehicle sources for baltimore
x <- SCC %>% filter(grepl("[Hh]ighway", Short.Name))
vehicle_emissions_baltimore <- NEI %>% filter(SCC %in% x$SCC) %>% filter(fips == "24510")
yrs <- unique(vehicle_emissions_baltimore$year)
y <- c()
for(i in yrs){
        x <- filter(vehicle_emissions_baltimore, vehicle_emissions_baltimore$year == i)
        y <- c(y, sum(x$Emissions)) 
} 
# Total Vehicle Emissions Baltimore
tveb <- as.data.frame(cbind(Years = yrs, Total_Vehicle_Emissions_Baltimore = y))

# Open the plot device
png(filename = "./ExData_Plotting2/plot5.png", width = 480, height = 480)
qplot(Years, Total_Vehicle_Emissions_Baltimore, data = tveb, geom = c("point","line"))
dev.off()