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

# Question 5
# How have emissions from motor vehicle sources changed from 1999-2008 
# in Baltimore City?

## Subset for Baltimore and type ON-ROAD that contains the motor vehicles emissions
bor.NEI<-NEI[NEI$ffips=="24510" & NEI$type=="ON-ROAD",]

## Summarize the total emissions per year using the sum()
Temi<-ddply(bor.NEI, .(year), summarise, 
            totalPM=sum(Emissions))

## Plot with ggplot but adgust the margins. 
png("plot5.png",height=480, width=680)
ggplot(Temi,aes(y=totalPM,x=factor(year)))+
        geom_bar(stat="identity")+
        xlab("years")+
        ylab(expression('Total PM'[2.5]*' Emissions'))+
        ggtitle(expression('Total PM'[2.5]*'Baltimore Emissions at available years from Motor Vehicles '))
dev.off()
