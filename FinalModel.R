library(data.table)
library(dplyr)
library(stringr)
library(glmnet); library(caret)
library(glmnetUtils)
#########	Data	########
###
X_all <- fread("E:/00.니집내집/90.데이터수집/01.실거래가/all.csv")
colnames(X_all) <- c("si","gu","dong","bungi","bungi_main","bungi_sub","complex",
				"area","yearMonth","day","price","floor","constructed","roadName")
X_all$yearMonth <- as.Date(paste0(X_all$yearMonth,01),"%Y%m%d")
X_all$si <- as.factor(X_all$si)
X_all$gu <- as.factor(X_all$gu)
X_all$dong <- as.factor(X_all$dong)
X_all$bungi <- as.factor(X_all$bungi)
X_all$bungi_main <- as.factor(X_all$bungi_main)
X_all$bungi_sub <- as.factor(X_all$bungi_sub)
X_all$complex <- as.factor(X_all$complex)
X_all$day <- as.factor(str_sub(X_all$day,1,-3))
X_all$roadName <- as.factor(X_all$roadName)
X_all[order(X_all$price)[1:10],]
X_all[order(X_all$price,decreasing = T)[1:10],]

X_all[which.min(X_all$price),]
X_trim <- X_all[-which.min(X_all$price),]

###
y <- as.matrix(X_trim[,11]);	str(y)
par(mfrow=c(2,1))
boxplot(y,horizontal=T,ylab="origin")
boxplot(log(y),horizontal=T,ylab="transform")
hist(scale(y),prob=T,ylim=c(0,0.5))
lines(density(scale(y)))
lines(seq(-3,3,length=1000),dnorm(seq(-3,3,length=1000)),col=2)
hist(scale(log(y)),prob=T,ylim=c(0,0.5))
lines(density(scale(log(y))))
lines(seq(-3,3,length=1000),dnorm(seq(-3,3,length=1000)),col=2)

###
rate <- fread("E:/00.니집내집/90.데이터수집/02.수정 및 csv/4.1.2 시장금리(월_분기_년).csv")
colnames(rate) <- c("yearMonth","cd91","bond5","bond10")
rate$yearMonth<- as.Date(paste0(rate$yearMonth,01),"%Y%m%d")
x <- merge(X_trim,rate,by="yearMonth")

highSchool <- fread("E:/00.니집내집/90.데이터수집/02.수정 및 csv/2017년_학교+학교수.csv")[,c(2,6)]
colnames(highSchool) <- c("gu", "highSchool")
x <- merge(x,highSchool,by = "gu"); x$gu <- as.factor(x$gu)

unsold <- fread("E:/00.니집내집/90.데이터수집/02.수정 및 csv/미분양주택현황.csv")
colnames(unsold)[3] <- "unsold"
unsold$unsold<- as.numeric(gsub(",","",unsold$unsold))
unsold$yearMonth<- unique(x$yearMonth)
x <- merge(x, unsold[,c(3,4)],by="yearMonth")


########Elastic Net (Advanced Regression)#########
###https://quantmacro.wordpress.com/2016/04/26/fitting-elastic-net-model-in-r/

lambda.grid <- 10^seq(2,-2,length=100)
alpha.grid <- seq(0,1,length=11)

trnCtrl <- trainControl(
  method = "repeatedCV",
  number = 10,
  repeats = 5
)

srchGrd <- expand.grid(.alpha = alpha.grid, .lambda = lambda.grid)

x_use <- subset(x, select = c(price,yearMonth,gu,dong,area,floor,constructed,bond10,highSchool))

set.seed(01094844224)
model_train <- train(log(price)~., data=x_use,
                     method = "glmnet",
                     tuneGrid = srchGrd,
                     trControl = trnCtrl,
                     standardize = TRUE, maxit = 1000000
)

win.graph();plot(model_train)
savePlot("E:/00.니집내집/02.R코드/workspace/final.png",type="png")

Result_final
bestTune_final  <- model_train$result<- model_train$bestTune
model.glmnet_final <- model_train$finalModel

coef_final <- coef(model.glmnet_final, s=model_train$bestTune$lambda)
coef_final

x_use2 <- model.matrix(~.-price,x_use)
pred <- predict(model.glmnet_final,x_use2[,-1], s=model_train$bestTune$lambda)


totalAndPredict <- cbind(price=x$price,round(exp(pred)),subset(x,select=-price))
colnames(totalAndPredict)[2] <- "predictedPrice"

selectGu <- "금정구"
selectDong <- "장전동"
toDT <- totalAndPredict %>% filter(gu==selectGu,dong==selectDong) %>%
	 select(gu,dong,price,predictedPrice,yearMonth,complex,area,floor,constructed) %>% arrange(desc(yearMonth))
DT_gudong <- DT::datatable(toDT,colnames=c("구","동","실거래가","예측가격","거래년월","단지명","면적","층","건축년도"),
                          extensions =c( 'Buttons'),width="100%",height="100%",
                          options = list(dom = 'Bfrtip',
                                         buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                         pageLength = 5, autoWidth = TRUE
                          )
)
DT::saveWidget(DT_gudong, 'jangjeon.html')


# #############################prediction test #####################
# 
# 
# x.test <- data.frame(date=as.Date("2017-08-01"),gu="기장군",dong="기장읍내리",area=88,floor=8,constructed=2013,bond10=3.04,highSchool=6)
# 
# pred <- predict(finalModel,x.test)
# pred2 <- (-2.453615e+01) +  (1.053526e-04)*as.numeric(as.Date("2017-08-01"))+
# 	(-9.707774e-02) +    1.480988e-01 + (1.102082e-02) * 88 + (9.011435e-03)*8 +
# 	(1.590970e-02)*2013 + ( -3.411286e-02)*3.04 + ( 2.768265e-03)*6
# pred3 <- predict(model.glmnet_final,x.test,s=model_train$bestTune$lambda)
# 
# exp(pred)
# exp(pred2)

