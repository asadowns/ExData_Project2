#plot2.R

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

#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?

NEI_Baltimore_Summarized <- NEI %>%
  filter(fips==24510) %>%
  group_by(year) %>%
  summarise(sum(Emissions))
names(NEI_Baltimore_Summarized) <- c('year','Emissions')

#set graphics device
par(mfrow=c(1,1))
png(file="plot2.png")

#Build Plot 1
with(NEI_Baltimore_Summarized,plot(year,Emissions, type='l'))

#Shut down graphics device
dev.off()