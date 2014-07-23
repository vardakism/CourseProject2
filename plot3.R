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

# Question 3
# Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) variable, which of these four sources have 
# seen decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

## Subset for the Baltimore County
b.NEI<-NEI[NEI$ffips=="24510",]

## Summarize the total emissions per year and per type using the sum()
Temi<-ddply(b.NEI, .(year,type), summarise, totalPM=sum(Emissions))

## Plot with ggplot but adgust the margins. Use the facet.grid to create different
## panels
png("plot3.png", height=480, width=780)
ggplot(Temi,aes(y=totalPM,x=factor(year)))+
        geom_bar(stat="identity")+
        facet_grid(.~type)+
        xlab("years")+ylab(expression('Total PM'[2.5]*' Emissions'))+
        ggtitle(expression('Total PM'[2.5]*'Baltimore Emissions at available years for 4 different source types '))

dev.off()
