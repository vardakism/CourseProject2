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

# Question 2
# Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips == "24510") 
# from 1999 to 2008? Use the base plotting system 
# to make a plot answering this question.

## Summarize the total emissions per year and per County using the sum()
NEI$ffips<-as.factor(NEI$fips)
Temi<-ddply(NEI, .(year,ffips), summarise, totalPM=sum(Emissions))
## Subset for onlt Baltimore
B.Temi<-Temi[Temi$ffips=="24510",]

png("plot2.png")
barplot(B.Temi$totalPM,names.arg = B.Temi$year,
        xlab="years", 
        ylab=expression('Total PM'[2.5]*' Emissions'),
        main=expression('Total PM'[2.5]*' Emissions at available years for Baltimore'))
dev.off()