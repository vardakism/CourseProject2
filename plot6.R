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


# Question 6
# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

## Subset the NEI dataset for ON-Road type, which contains the motor vehicle emissions
orNEI<-NEI[NEI$type=="ON-ROAD",]
Temi<-ddply(orNEI, .(year,ffips), summarise, 
            totalPM=sum(Emissions))

## Subset for these two counties
TemiB_LA<-subset(Temi,Temi$ffips=="24510"|Temi$ffips=="06037")

## Create a factor for illustration purposes
TemiB_LA$County<-factor(TemiB_LA$ffips,levels=c("24510","06037"),
                        labels=c("Baltimore","Los Angeles"))

## Plotwith ggplot but adgust the margins. 
## Here please note the scales="free" part of the facet function. This will
## create different scales for the two facets so the results are comparable. 

png("plot6.png",height=480, width=680)
ggplot(TemiB_LA,aes(y=totalPM,x=factor(year)))+
        geom_bar(stat="identity",width=0.5)+facet_wrap(~County,scales="free")+
        xlab("years")+
        ylab(expression('Total PM'[2.5]*' Emissions'))+
        ggtitle(expression('Total PM'[2.5]*'Baltimore & LA Emissions at available years for 4 different source types '))
dev.off()