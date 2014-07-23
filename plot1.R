# The overall goal of this assignment is to explore the National Emissions Inventory
# database and see what it say about fine particulate matter pollution in 
# the United States over the 10-year period 1999-2008. You may use any R package 
# you want to support your analysis.

## 1. Unzip the file from: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
##  to your local working directory
## 2. Load the data
## 3. This first line will likely take a few seconds. Be patient!

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Load the required packages
library(plyr)
library(ggplot2)

# Question 1
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission
# from all sources for each of the years 1999, 2002, 2005, and 2008.

## Summarize the total emissions per year using the sum()
Temi<-ddply(NEI, .(year), summarise, totalPM=sum(Emissions))

png("plot1.png")
barplot(Temi$totalPM,names.arg = Temi$year,
        xlab="years", 
        ylab=expression('Total PM'[2.5]*' Emissions'),
        main=expression('Total PM'[2.5]*' Emissions at available years'))
dev.off()