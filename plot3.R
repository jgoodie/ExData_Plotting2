# expl-data-analisys course project #2
# Plot 3

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

# Do we have all the years or just a subset?
# looks like we only have 1999, 2002, 2005, and 2008. Ooops the assignment actually says this.
yrs <- unique(NEI$year)
baltimore <- filter(NEI, fips == "24510") %>%
        group_by(type)

# Poking at the data some more
# onroad <- filter(baltimore, type == "ON-ROAD")
# nonroad <- filter(baltimore, type == "NON-ROAD")
# nonpoint <- filter(baltimore, type == "NONPOINT")
# point <- filter(baltimore, type == "POINT")
#
# Note to self: Seriously look into Dimension Reduction on this one. 
#

# Open the plot device
png(filename = "./ExData_Plotting2/plot3.png", width = 800, height = 600)
# This method is not that great. It's hard to tell (even with the lm smoother) where the decreases were.
# qplot(year, Emissions, data = baltimore, color = type, facets = . ~ type, geom = c("point","smooth"), method = "lm")
g <- ggplot(baltimore, aes(year, Emissions))
# g + geom_point(aes(color = type)) + geom_smooth(method = "lm") + facet_grid(. ~ type) + ylim(0,400) # or less
# Better as it doesn't cut out the outliers. It only zooms in or out.
g + geom_point(aes(color = type)) + geom_smooth(method = "lm") + facet_grid(. ~ type) + coord_cartesian(ylim = c(0,75))
dev.off()
