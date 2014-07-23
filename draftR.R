temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp)
NEI <- readRDS(unzip(temp, "summarySCC_PM25.rds"))
SCC <- readRDS(unzip(temp, "Source_Classification_Code.rds"))
unlink(temp)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(plyr)
library(ggplot2)
# Question 1
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission
# from all sources for each of the years 1999, 2002, 2005, and 2008.

# a way
total.emissions <- aggregate(Emissions ~ year, NEI, sum)

#my way
library(plyr)
Temi<-ddply(NEI, .(year), summarise, totalPM=sum(Emissions))

png("plot1.png")
barplot(Temi$totalPM,names.arg = Temi$year,
     xlab="years", 
     ylab=expression('Total PM'[2.5]*' Emissions'),
     main=expression('Total PM'[2.5]*' Emissions at available years'))
dev.off()

# Temi$Nobs<-table(NEI$year)
# Temi$se<-Temi$sdPM/sqrt(Temi$Nobs)
# plot(Temi$avPM~Temi$year,,pch=16,xlab="years", 
#      ylab=expression('Total PM'[2.5]*' Emissions'),
#      main=expression('Total PM'[2.5]*' Emissions at available years'))
# arrows(Temi$year,(Temi$avPM-Temi$se),Temi$year,(Temi$avPM+Temi$se),
#        code=3,length=0.2,angle=90,col='red')

# Question 2
# Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips == "24510") 
# from 1999 to 2008? Use the base plotting system 
# to make a plot answering this question.

NEI$ffips<-as.factor(NEI$fips)
Temi<-ddply(NEI, .(year,ffips), summarise, totalPM=sum(Emissions))
B.Temi<-Temi[Temi$ffips=="24510",]

png("plot2.png")
barplot(B.Temi$totalPM,names.arg = B.Temi$year,
        xlab="years", 
        ylab=expression('Total PM'[2.5]*' Emissions'),
        main=expression('Total PM'[2.5]*' Emissions at available years for Baltimore'))
dev.off()

# Question 3
# Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) variable, which of these four sources have 
# seen decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? 
# Use the ggplot2 plotting system to make a plot answer this question.
b.NEI<-NEI[NEI$ffips=="24510",]
Temi<-ddply(b.NEI, .(year,type), summarise, totalPM=sum(Emissions))
library(ggplot2)
png("plot3.png", height=480, width=780)
ggplot(Temi,aes(y=totalPM,x=factor(year)))+geom_bar(stat="identity")+facet_grid(.~type)+
        xlab("years")+ylab(expression('Total PM'[2.5]*' Emissions'))+
        ggtitle(expression('Total PM'[2.5]*'Baltimore Emissions at available years for 4 different source types '))

dev.off()

# Question 4
# Across the United States, how have emissions from coal combustion-related sources
# changed from 1999-2008?

Coal_comb<- grepl("Comb.*Coal", SCC$EI.Sector)
CoalSCC<-SCC[Coal_comb,]
CoalNEI<-NEI[(NEI$SCC %in% CoalSCC$SCC),]
Temi<-ddply(CoalNEI, .(year), summarise, 
            totalPM=sum(Emissions))
png("plot4.png",height=480, width=680)
ggplot(Temi,aes(y=totalPM,x=factor(year)))+geom_bar(stat="identity")+
        xlab("years")+ylab(expression('Total PM'[2.5]*' Emissions'))+
        ggtitle(expression('Total PM'[2.5]*'U.S. Emissions at available years for Coal Combustion Sources '))
dev.off()

# Question 5
# How have emissions from motor vehicle sources changed from 1999-2008 
# in Baltimore City?

# Subset for Baltimore and type ON-ROAD that contains the motor vehicles emissions
bor.NEI<-NEI[NEI$ffips=="24510" & NEI$type=="ON-ROAD",]

Temi<-ddply(bor.NEI, .(year), summarise, 
            totalPM=sum(Emissions))

png("plot5.png",height=480, width=680)
ggplot(Temi,aes(y=totalPM,x=factor(year)))+geom_bar(stat="identity")+
        xlab("years")+ylab(expression('Total PM'[2.5]*' Emissions'))+
        ggtitle(expression('Total PM'[2.5]*'Baltimore Emissions at available years from Motor Vehicles '))
dev.off()

# Question 6
# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

orNEI<-NEI[NEI$type=="ON-ROAD",]
Temi<-ddply(orNEI, .(year,ffips), summarise, 
            totalPM=sum(Emissions))

# Scale the emissions for the two states so that they are comparable
TemiB_LA<-subset(Temi,Temi$ffips=="24510"|Temi$ffips=="06037")
# Create a factor for illustration purposes
TemiB_LA$County<-factor(TemiB_LA$ffips,levels=c("24510","06037"),
                       labels=c("Baltimore","Los Angeles"))
# Plot. Here please note the scales="free" part of the facet function. This will
# create different scales for the two facets so the results are comparable. 
png("plot6.png",height=480, width=680)
ggplot(TemiB_LA,aes(y=totalPM,x=factor(year)))+
        geom_bar(stat="identity",width=0.5)+facet_wrap(~County,scales="free")+
        xlab("years")+
        ylab(expression('Total PM'[2.5]*' Emissions'))+
        ggtitle(expression('Total PM'[2.5]*'Baltimore & LA Emissions at available years for 4 different source types '))
dev.off()
# feature_scale <- function(x) {(x-min(x)) / (max(x)-min(x))}
# TemiB_LAs<-ddply(TemiB_LA, .(ffips), summarise, 
#                  stotalPM=feature_scale(totalPM))
# TemiB_LA$EmiSc<-TemiB_LAs$stotalPM

