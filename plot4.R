#plot4.R

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

#Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

SCC_Coal <- filter(SCC, grepl('Coal', Short.Name,ignore.case=TRUE) & grepl('Comb', Short.Name,ignore.case=TRUE))

NEI_Coal <- NEI %>%
  filter(SCC %in% SCC_Coal$SCC) %>%
  group_by(year) %>%
  summarise(sum(Emissions))
names(NEI_Coal) <- c('year','Emissions')


#set graphics device
par(mfrow=c(1,1))
png(file="plot4.png")

#Build Plot 4
plot <- with(NEI_Coal,qplot(year,Emissions))
plot + geom_line()

#Shut down graphics device
dev.off()