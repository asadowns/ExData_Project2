#plot1.R

#Setup
library(dplyr)
library(tidyr)

if (!file.exists('NEI_data.zip')) {
  download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip','NEI_data.zip', method='curl')
  downloadDate <- date()  
}

if (!file.exists('summarySCC_PM25.rds')) {
  unzip('NEI_data.zip')
}

if (!exists('NEI')) {
  NEI <- tbl_df(readRDS("summarySCC_PM25.rds"))
  SCC <- tbl_df(readRDS("Source_Classification_Code.rds"))
}

#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

NEI_Summarized <- NEI %>%
  group_by(year) %>%
  summarise(sum(Emissions))
  names(NEI_Summarized) <- c('year','Emissions')

#set graphics device
par(mfrow=c(1,1))
png(file="plot1.png")

#Build Plot 1
with(NEI_Summarized,plot(year,Emissions, type='l'))

#Shut down graphics device
dev.off()