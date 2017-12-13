library(data.table)
library(stringr)
X_all <- fread("E:/00.니집내집/90.데이터수집/01.실거래가/all.csv")
X_all$계약년월 <- as.Date(paste0(X_all$계약년월,01),"%Y%m%d")
colnames(X_all)[8] <- "전용면적"; colnames(X_all)[11] <- "거래금액"

X_trim <- X_all[-which.min(X_all$거래금액),]

x <- X_trim[,c(2,3,8,9,10,11,12,13)]

rate <- fread("E:/00.니집내집/90.데이터수집/02.수정 및 csv/4.1.2 시장금리(월_분기_년).csv")
colnames(rate)[1] <- "계약년월"
rate$계약년월 <- as.Date(paste0(rate$계약년월,01),"%Y%m%d")
x <- merge(x,rate,by="계약년월")
colnames(x) <- c("date","gu","dong","area","day","price","floor","constructed","cd91","bond5","bond10")

highSchool <- fread("E:/00.니집내집/90.데이터수집/02.수정 및 csv/2017년_학교+학교수.csv")[,c(2,6)]
x <- merge(x,highSchool,by.x = "gu", by.y = "군구")
colnames(x)[12] <- "highSchool"

x$day <- str_sub(x$day,1,-3)

unsold <- fread("E:/00.니집내집/90.데이터수집/02.수정 및 csv/미분양주택현황.csv")
unsold$미분양주택 <- as.numeric(gsub(",","",unsold$미분양주택))
unsold$date <- unique(x$date)
colnames(unsold)[3] <- "unsold"
x <- merge(x, unsold[,c(3,4)],by.x="date",by.y="date")

x_use <- subset(x, select = c(price,date,gu,dong,area,floor,constructed,bond10,highSchool,unsold))


#####
library(glmnetUtils)
model_using <- glmnet(log(price)~.,data=x_use,alpha=0.1,lambda=0.01)
summary(model_using)
model_using$beta


pred <- predict(model_using,x_use)

price_pred <- exp(pred)
#matplot(cbind(x_use$price,price_pred))
#x_pred <- cbind(price_predict = price_pred[,1],x_use)

