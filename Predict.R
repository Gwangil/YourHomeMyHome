library(data.table)
library(dplyr)
library(stringr)
library(glmnet); library(caret)
library(glmnetUtils)
#########	Data	########

X_all <- fread("E:/00.니집내집/90.데이터수집/01.실거래가/all.csv")
X_all$계약년월 <- as.Date(paste0(X_all$계약년월,01),"%Y%m%d")
colnames(X_all)[8] <- "전용면적"; colnames(X_all)[11] <- "거래금액"
str(X_all)

X_all[order(X_all$거래금액)[1:10],]
X_all[order(X_all$거래금액,decreasing = T)[1:10],]

#X_all[which.min(X_all$거래금액),]
X_trim <- X_all[-which.min(X_all$거래금액),]

x <- X_trim[,c(2,3,8,9,10,11,12,13)]
y <- as.matrix(X_trim[,11])
str(x)
str(y)

boxplot(scale(log(y)),horizontal=T)
hist(scale(log(y)),prob=T,ylim=c(0,0.5))
lines(density(scale(log(y))))
dn <- dnorm(seq(-3,3,length=1000))
lines(seq(-3,3,length=1000),dn,col=2)

#X_dong <- X_all %>% group_by(동) %>% summarise(거래금액 = mean(거래금액))

rate <- fread("E:/00.니집내집/90.데이터수집/02.수정 및 csv/4.1.2 시장금리(월_분기_년).csv")
colnames(rate)[1] <- "계약년월"
rate$계약년월 <- as.Date(paste0(rate$계약년월,01),"%Y%m%d")
str(rate)

x <- merge(x,rate,by="계약년월")
colnames(x) <- c("date","gu","dong","area","day","price","floor","constructed","cd91","bond5","bond10")

highSchool <- fread("E:/00.니집내집/90.데이터수집/02.수정 및 csv/2017년_학교+학교수.csv")[,c(2,6)]
x <- merge(x,highSchool,by.x = "gu", by.y = "군구")
colnames(x)[12] <- "highSchool"
unique(x$day)
x$day <- str_sub(x$day,1,-3)

unsold <- fread("E:/00.니집내집/90.데이터수집/02.수정 및 csv/미분양주택현황.csv")
unsold$미분양주택 <- as.numeric(gsub(",","",unsold$미분양주택))
unsold$date <- unique(x$date)
colnames(unsold)[3] <- "unsold"
x <- merge(x, unsold[,c(3,4)],by.x="date",by.y="date")


#########	Regression	#############

set.seed(01094844224)
gr <- sample(rep(seq(10),length=length(y)))

result <- matrix(NA,10,2)

for ( i in 1:10) {
	x.te <- subset(x,gr==i); x.tr <- subset(x,gr!=i)
	y.te <- subset(y,gr==i); y.tr <- subset(y,gr!=i)

	model <- lm(y.tr~., data=x.tr)
	#summary(model)
	
	pred <- predict(model,x.te)
	result[i,1] <- sqrt(mean((y.te-pred)^2))
	result[i,2] <- exp(y.te[which.max(y.te-pred)])-exp(pred[which.max(y.te-pred)])

}
apply(result,2,mean)
mean(result[,2])

###############################

model_ela <- cva.glmnet(log(거래금액)~., data=x)
str(model_ela)
summary(model_ela)
plot(model_ela)
model_ela$alpha
model_ela$modlist[[5]]
plot(model_ela$modlist[[5]])
plot(model_ela$modlist[[5]]$glmnet.fit)

#################
###https://quantmacro.wordpress.com/2016/04/26/fitting-elastic-net-model-in-r/

lambda.grid <- 10^seq(2,-2,length=100)
alpha.grid <- seq(0,1,length=11)

trnCtrl <- trainControl(
  method = "repeatedCV",
  number = 10,
  repeats = 5
)

srchGrd <- expand.grid(.alpha = alpha.grid, .lambda = lambda.grid)

###date,gu,dong,area,day,floor,constructed,cd91,bond5,bond5,highScool

set.seed(01094844224)
model_train <- train(log(price)~., data=x,
                     method = "glmnet",
                     tuneGrid = srchGrd,
                     trControl = trnCtrl,
                     standardize = TRUE, maxit = 1000000
                     )

win.graph();plot(model_train)
savePlot("E:/00.니집내집/02.R코드/workspace/gdadfccbbh.png",type="png")

#attributes(model_train)
model_train$bestTune
model.glmnet <- model_train$finalModel

coef_gdadfccbbh <- coef(model.glmnet, s=model_train$bestTune$lambda)
coef_gdadfccbbh


####date,gu,dong,area,floor,constructed,bond10,highSchool
x_use <- subset(x, select = c(price,date,gu,dong,area,floor,constructed,bond10,highSchool))

set.seed(01094844224)
model_train <- train(log(price)~., data=x_use,
                     method = "glmnet",
                     tuneGrid = srchGrd,
                     trControl = trnCtrl,
                     standardize = TRUE, maxit = 1000000
)

win.graph();plot(model_train)
# savePlot("E:/00.니집내집/02.R코드/workspace/dgdafcbh.png",type="png")

model_train$bestTune
model.glmnet <- model_train$finalModel

coef_dgdafcbh <- coef(model.glmnet, s=model_train$bestTune$lambda)
coef_dgdafcbh

####date,gu,dong,area,floor,constructed,bond10,highSchool,unsold
x_use <- subset(x, select = c(price,date,gu,dong,area,floor,constructed,bond10,highSchool,unsold))

set.seed(01094844224)
model_train <- train(log(price)~., data=x_use,
                     method = "glmnet",
                     tuneGrid = srchGrd,
                     trControl = trnCtrl,
                     standardize = TRUE, maxit = 1000000
)

win.graph();plot(model_train)
# savePlot("E:/00.니집내집/02.R코드/workspace/dgdafcbhu.png",type="png")

model_train$result
model_train$bestTune
model.glmnet <- model_train$finalModel

coef_dgdafcbhu <- coef(model.glmnet, s=model_train$bestTune$lambda)
coef_dgdafcbhu


#####no standardized

x_use <- subset(x, select = c(price,date,gu,dong,area,floor,constructed,bond10,highSchool,unsold))

set.seed(01094844224)
model_train <- train(log(price)~., data=x_use,
                     method = "glmnet",
                     tuneGrid = srchGrd,
                     trControl = trnCtrl,
                     standardize = FALSE, maxit = 1000000
)

win.graph();plot(model_train)
# savePlot("E:/00.니집내집/02.R코드/workspace/dgdafcbhu_nostandard.png",type="png")

model_train$result
model_train$bestTune
model.glmnet <- model_train$finalModel

coef_dgdafcbhu_nostandard <- coef(model.glmnet, s=model_train$bestTune$lambda)
coef_dgdafcbhu_nostandard

#####no standardized & numeric partial scale

x_use <- subset(x, select = c(price,date,gu,dong,area,floor,constructed,bond10,highSchool,unsold))
x_use <- cbind(x_use[,1:4],scale(x_use[,5:10]))

set.seed(01094844224)
model_train <- train(log(price)~., data=x_use,
                     method = "glmnet",
                     tuneGrid = srchGrd,
                     trControl = trnCtrl,
                     standardize = FALSE, maxit = 1000000
)

win.graph();plot(model_train)
# savePlot("E:/00.니집내집/02.R코드/workspace/dgdafcbhu_nostandard_partscale.png",type="png")

model_train$result
model_train$bestTune
model.glmnet <- model_train$finalModel

coef_dgdafcbhu_nostandard_partscale <- coef(model.glmnet, s=model_train$bestTune$lambda)
coef_dgdafcbhu_nostandard_partscale

#################all variables & TRUE

set.seed(01094844224)
model_train <- train(log(price)~., data=x,
                     method = "glmnet",
                     tuneGrid = srchGrd,
                     trControl = trnCtrl,
                     standardize = TRUE, maxit = 1000000
)

win.graph();plot(model_train)
savePlot("E:/00.니집내집/02.R코드/workspace/allTrue.png",type="png")

Result_allTrue <- model_train$result
bestTune_allTrue <- model_train$bestTune
model.glmnet_allTrue <- model_train$finalModel

coef_allTrue <- coef(model.glmnet_allTrue, s=bestTune_allTrue$lambda)
coef_allTrue

#################all variables & FALSE

set.seed(01094844224)
model_train <- train(log(price)~., data=x,
                     method = "glmnet",
                     tuneGrid = srchGrd,
                     trControl = trnCtrl,
                     standardize = FALSE, maxit = 1000000
)

win.graph();plot(model_train)
savePlot("E:/00.니집내집/02.R코드/workspace/allFalse.png",type="png")

Result_allFalse <- model_train$result
bestTune_allFalse <- model_train$bestTune
model.glmnet_allFalse <- model_train$finalModel

coef_allFalse <- coef(model.glmnet_allFalse, s=bestTune_allFalse$lambda)
coef_allFalse


####final use
x_use <- subset(x, select = c(price,date,gu,dong,area,floor,constructed,bond10,highSchool))

set.seed(01094844224)
model_train <- train(log(price)~., data=x_use,
                     method = "glmnet",
                     tuneGrid = srchGrd,
                     trControl = trnCtrl,
                     standardize = TRUE, maxit = 1000000
)

win.graph();plot(model_train)
savePlot("E:/00.니집내집/02.R코드/workspace/final.png",type="png")

Result_final <- model_train$result
bestTune_final <- model_train$bestTune
model.glmnet_final <- model_train$finalModel

coef_final <- coef(model.glmnet_final, s=model_train$bestTune$lambda)
coef_final

