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

# Question 4
# Across the United States, how have emissions from coal combustion-related sources
# changed from 1999-2008?

## Find all rhe SCC entries that contain in the EI.Sector the words Comb and Coal
## Then subset the NEI dataset for these entries using the SCC variable
Coal_comb<- grepl("Comb.*Coal", SCC$EI.Sector)
CoalSCC<-SCC[Coal_comb,]
CoalNEI<-NEI[(NEI$SCC %in% CoalSCC$SCC),]

## Summarize the total emissions per year  using the sum()
Temi<-ddply(CoalNEI, .(year), summarise, 
            totalPM=sum(Emissions))

## Plot with ggplot but adgust the margins. 
png("plot4.png",height=480, width=680)
ggplot(Temi,aes(y=totalPM,x=factor(year)))+
        geom_bar(stat="identity")+
        xlab("years")+
        ylab(expression('Total PM'[2.5]*' Emissions'))+
        ggtitle(expression('Total PM'[2.5]*'U.S. Emissions at available years for Coal Combustion Sources '))
dev.off()
