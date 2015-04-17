#plot3.R

#Setup
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

#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008?

NEI_Baltimore_Type <- NEI %>%
  filter(fips==24510) %>%
  group_by(year,type) %>%
  summarise(sum(Emissions))
names(NEI_Baltimore_Type) <- c('year','type','Emissions')

#set graphics device
par(mfrow=c(1,1))
png(file="plot3.png")

#Build Plot 3
plot <- with(NEI_Baltimore_Type,qplot(year,Emissions, color=type))
plot + geom_line()

#Shut down graphics device
dev.off()