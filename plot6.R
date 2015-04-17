#plot6.R

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

#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
#Which city has seen greater changes over time in motor vehicle emissions?

SCC_vehicle <- filter(SCC, grepl('Vehicle', SCC.Level.Two, ignore.case=TRUE))

NEI_vehicleCAMD <- NEI %>%
  filter(SCC %in% SCC_vehicle$SCC & (fips=='24510' | fips=='06037')) %>%
  group_by(year,fips) %>%
  summarise(sum(Emissions))
names(NEI_vehicleCAMD) <- c('year','fips','Emissions')


#set graphics device
par(mfrow=c(1,1))
png(file="plot6.png")

#Build Plot 6
plot <- with(NEI_vehicleCAMD,qplot(year,Emissions, color=fips))
plot + geom_line()

#Shut down graphics device
dev.off()