#plot5.R

#setup
library(dplyr)
library(tidyr)
library(ggplot2)

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

#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

SCC_vehicle <- filter(SCC, grepl('Vehicle', SCC.Level.Two, ignore.case=TRUE))

NEI_vehicle <- NEI %>%
  filter(SCC %in% SCC_vehicle$SCC & fips=='24510') %>%
  group_by(year) %>%
  summarise(sum(Emissions))
names(NEI_vehicle) <- c('year','Emissions')


#set graphics device
par(mfrow=c(1,1))
png(file="plot5.png")

#Build Plot 4
plot <- with(NEI_vehicle,qplot(year,Emissions))
plot + geom_line()

#Shut down graphics device
dev.off()