library(data.table)
library(dplyr)
library(stringr)

path_year <- 12:16
path0 <- "E:/00.니집내집/90.데이터수집/01.실거래가/"   # \인식 안되므로 / 로 바꿔줌
X_tot <- list()
for ( j in 1:length(path_year) ) {
	path <- paste0(path0,path_year[j],"년","/")
	temp <- list.files(path=path, pattern="*.csv")
	temp <- paste0(path,temp)
	
	X<-list()
	for (i in 1:length(temp)) {
		temp2 = fread(temp[i], header = TRUE)
		X <- rbind(X,temp2,fill=TRUE)
	}

	sector <- do.call(rbind, strsplit(X$시군구," "))
	sector[,4] <- gsub("부산광역시","",sector[,4])
	sector_fin <- cbind(sector[,1:2],paste0(sector[,3],sector[,4]))
	colnames(sector_fin) <- c("시","구","동")
	X <- cbind(sector_fin,X[,-1])

	X$계약년월 <- as.factor(X$계약년월)
	X[,11] <- as.numeric(sapply(X[,11],function(x) gsub(",","",x)))
	# X$동[grep("가$",X$동)] <- str_sub(X$동[grep("가$",X$동)],1,str_locate(X$동[grep("가$",X$동)],"가")[,2]-2)
	X$동[grep("가$",X$동)] <- str_sub(X$동[grep("가$",X$동)],1,-3)
	
	X_tot[[j]]<-X
}
str(X_tot)

X_all <- rbind(X_tot[[1]],X_tot[[2]],X_tot[[3]],X_tot[[4]],X_tot[[5]])
str(X_all)

#write.csv(X_tot[[1]],"C:/Users/Gwangil/Desktop/니집내집/데이터수집/실거래가/2012.csv",row.names=F)
#write.csv(X_tot[[2]],"C:/Users/Gwangil/Desktop/니집내집/데이터수집/실거래가/2013.csv",row.names=F)
#write.csv(X_tot[[3]],"C:/Users/Gwangil/Desktop/니집내집/데이터수집/실거래가/2014.csv",row.names=F)
#write.csv(X_tot[[4]],"C:/Users/Gwangil/Desktop/니집내집/데이터수집/실거래가/2015.csv",row.names=F)
#write.csv(X_tot[[5]],"C:/Users/Gwangil/Desktop/니집내집/데이터수집/실거래가/2016.csv",row.names=F)
#write.csv(X_all,"C:/Users/Gwangil/Desktop/니집내집/데이터수집/실거래가/all.csv",row.names=F)

#write.table(unique(X_all$구),"E:/니집내집/구동목록/01.구목록.txt",quote = F,row.names=F,col.names=F)
#write.table(unique(X_all$동),"E:/니집내집/구동목록/02.동목록.txt",quote = F,row.names=F,col.names=F)
#gudong <- aggregate(동 ~ 구,X_all,unique)
#for ( i in 1:16) {
#	filename <- paste0("E:/니집내집/구동목록/",gudong$구[i],"동목록.txt")
#	write.table(gudong$동[i],filename,quote = F,row.names=F,col.names=F)
#}



##########dplyr#####################
filter(hflights_df, Month == 1 | Month == 2)
arrange(hflights_df, ArrDelay, Month, Year)
arrange(hflights_df, desc(Month))
select(hflights_df, Year, Month, DayOfWeek)
mutate(hflights_df, gain = ArrDelay - DepDelay, gain_per_hour = gain/(AirTime/60))

planes <- group_by(hflights_df, TailNum)
delay <- summarise(planes, count = n(), dist = mean(Distance, na.rm = TRUE), 
     delay = mean(ArrDelay, na.rm = TRUE))
delay <- filter(delay, count > 20, dist < 2000)
library(ggplot2)
ggplot(delay, aes(dist, delay)) + geom_point(aes(size = count), alpha = 1/2) + 
    geom_smooth() + scale_size_area()

hflights_df %.% group_by(Year, Month, DayofMonth) %.% summarise(arr = mean(ArrDelay, 
     na.rm = TRUE), dep = mean(DepDelay, na.rm = TRUE)) %.% filter(arr > 30 | 
     dep > 30)