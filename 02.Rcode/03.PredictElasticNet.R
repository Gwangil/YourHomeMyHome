### 데이터 : '실거래가 수집 데이터 정리.R'의 X_all 또는 전체 데이터를 불러와서 시작.
#install.packages("data.table")
#install.packages('stringr')
library(data.table)
library(stringr)

X_all <- fread("E:/00.니집내집/90.데이터수집/01.실거래가/all.csv")						# 실거래가 정리 코드를 이용해서 all.csv를 만든것을 불러옴
colnames(X_all) <- c("si","gu","dong","bungi","bungi_main","bungi_sub","complex",
				"area","yearMonth","day","price","floor","constructed","roadName")	# column명을 영문으로 변환...R에서 한글은 인코딩이....ㅜㅜ
X_all$yearMonth <- as.Date(paste0(X_all$yearMonth,01),"%Y%m%d")						# yyyymm으로 받은 데이터에 임의로 01(dd)을 붙여 Date타입으로 변환
X_all$si <- as.factor(X_all$si)											# chr(character)형식을 factor로 변환 : 추후 모델적합시 속도향상(음.. 문자열이랑 요인(factor)랑 R에서 취급하는게 조금 다름...)
X_all$gu <- as.factor(X_all$gu)											# 문자열은 하나하나가 다 다른 개별 값이지만
X_all$dong <- as.factor(X_all$dong)											# factor는 해당 값의 목록(levels)이 있고, 해당 값은 그 목록의 몇 번째 값을 가져온건지 알 수 있음 levels(factorTypeData), as.numeric(factorTypeData)식으로
X_all$bungi <- as.factor(X_all$bungi)
X_all$bungi_main <- as.factor(X_all$bungi_main)
X_all$bungi_sub <- as.factor(X_all$bungi_sub)
X_all$complex <- as.factor(X_all$complex)
X_all$day <- as.factor(str_sub(X_all$day,1,-3))
X_all$roadName <- as.factor(X_all$roadName)

X_all[which.min(X_all$price),]											# which.min은 최소값의 index를 찾아줌
X_prac <- X_all[-which.min(X_all$price),]										# X.prac에 price의 최소값이 있는 index를 제외하고 할당 -- 나중에 평균값으로 지도에 뿌리는데, 이상치가 평균에 영향을줌
str(X_prac)

### 시장금리 데이터
rate <- fread("E:/00.니집내집/90.데이터수집/02.수정 및 csv/4.1.2 시장금리(월_분기_년).csv")
colnames(rate) <- c("yearMonth","cd91","bond5","bond10")
rate$yearMonth <- as.Date(paste0(rate$yearMonth,01),"%Y%m%d")
str(rate)
x <- merge(X_prac,rate,by="yearMonth")										# X_prac와 rate를 yearMonth 기준으로 merge

### 학교 수 데이터(고등학교만 사용)
highSchool <- fread("E:/00.니집내집/90.데이터수집/02.수정 및 csv/2017년_학교+학교수.csv")[,c(2,6)]	# 학교수 csv 데이터에서 2열(구), 6열(고등학교)만 저장시킴
colnames(highSchool) <- c("gu", "highSchool")
x <- merge(x,highSchool,by = "gu")

### 미분양주택 데이터
unsold <- fread("E:/00.니집내집/90.데이터수집/02.수정 및 csv/미분양주택현황.csv")
colnames(unsold) <- c("year","month","unsold")
unsold$unsold <- as.numeric(gsub(",","",unsold$unsold))							# 미분양건수 데이터가 천단위구분(,)가 포함되어 chr 타입으로 불러온걸, 천단위 구분자를 빼고 numeric 타입으로 변환
unsold$yearMonth <- seq(as.Date("20120101","%Y%m%d"),as.Date("20161201","%Y%m%d"),by="month")	# 연월이 따로 되어있는걸 합쳐는 것 대신 새로 20120101 부터 20161201 까지 월간격으로 생성
x <- merge(x, unsold[,c(3,4)],by="yearMonth")									# 미분양건수와 새로만든 연월 컬럼만 골라서 병합

########################## Model Fitting ###########################
#install.pacakges('dplyr')
#install.pacakges('glmnet')												# Elastic Net(LASSO & RIDGE Regression) 하기 위한 패키지
#install.pacakges('glmnetUtils')											# glmnet 패키지를 조금 개선, formula형식 지원 : 반응변수~설명변수, cross validation 함수 제공
#install.pacakges('caret')												# 여러가지 모델링 함수 와 시뮬레이션 환경을 설정, 수행할 수 있음
library(dplyr)
library(glmnet)
library(glmnetUtils)

### Elastic Net 개요
# 기존의 다중선형회귀모형에서 설명력의 변화에 관한 제약조건을 계수를 조정해서 중요변수 선택 가능, 주어진 데이터에 과적합(overfitting)하는것을 줄임
# LASSO, RIDGE를 비롯하여 다양한 방법으로 제약조건을 설정함, 제약의 정도를 설정하는 hyper parameter : lambda
# 제약이 강해 질수록 사용되는 설명변수의 수가 줄어들고 계수는 0으로 가까워짐 : 영향이 큰 변수가 생존
# 그중 alpha * LASSO와 (1-alpha) * RIDGE 방식으로 섞은 것이 Elastic Net
# 다중선형회귀모형에서 alpah, lambda 최소 2개의 hyper parameter 추가

### Cross Validation
# 10-fold라고 하면 데이터를 10개의 그룹으로 나누고
# 그중 1그룹을 test Set, 

###glmnet함수 기본 내용
# glmnet(x, y, alpha, lambda, family, ...)
# -- x : 설명변수, y : 반응변수, alpha는 LASSO, RIDGE 조합정도(1=LASSO(기본값), 0=RIDGE)
# -- lambda는 주어진 alpha에서 lambda를 어떻게 설정할지, 비워두면 함수가 적절히 람다 생성
# -- family는 간단히 연속형 : "gaussian", 범주형 : "binomail", 이외의 여러가지 있음
# glmnetUtils를 사용하면 y~x, data=X 식의 formula 형식 사용가능


### Using 'glmnetUtils' Package
model_ela <- cva.glmnet(log(price)~., data=									# cva.glmnet으로 alpha값도 바꿔가며 10-fold(기본값) cross validation 실시
		subset(x,select=-c(si,bungi,bungi_main,bungi_sub,complex,day,roadName,cd91,bond5)))	# 시, 번지, 단지명 등 변수는 제외하고 실행 : 의미가 없거나, 판단상의 이유로 제거

summary(model_ela)													# alpha 11종류, 이에 따른 모델리스트 11가지 등의 정보 확인
str(model_ela)														# cva.glmnet의 결과에 대한 구조 확인가능 : $, [[ ]] 같은 방법으로 찾아 들어갈수 있음

plot(model_ela)														# lambda의 변화에 따른 mse값의 변화 플랏, alpha는 선색으로 구분, 파란색으로 갈수록 alpha가 0에 가까움
model_ela$alpha														# 모델적합에 사용된 alpha값 출력
model_ela$modlist[[5]]													# model_ela의 11개 modlist에서 5번째 리스트를 가지고옴 : alpha의 5번째 값이 적용된 모델
																# -- modlist 내용 : glmnet함수의 결과와 유사
																# -- $lambda : 주어진 alpha하에서 모델 적합시 lambda를 변화시키며 적용한 lambda값들
																# -- $cvm, cvsd, cvup, cvlo : 각 모델을 10-fold cross validation 하며 계산된 mse의 평균, 표준편차, 평균+표준편차, 평균-표준편차 : lambda의 수 만큼 계산
																# -- $nzero : 각 모델에서 계수의 값이 0이 아닌 변수가 몇개인지 나타냄
																# -- $glmnet.fit : 각 lambda에서의 0이 아닌 계수의 수(Df), 설명정도(%Dev)를 출력
																# -- $lambda.min : mse의 평균이 최소 일때 lambda 값
																# -- $lambda.1se : mse가 최소 일때에서 표준편차의 1배 만큼 허용했을 때 lambda값, mse기준을 보다 덜 엄격하게 = 제약조건 lambda를 강하게, 0으로 떨어지는 변수를 늘림
plot(model_ela$modlist[[5]])												# 5번째 alpha일때 모델의 mse가 변화하는 플랏
																# -- 빨간점이 최소일때 mse고 위아래의 선이 각각 cvup, cvlo이다. 위쪽의 숫자는 계수가 0이 아닌 변수의 수, 점선은 각각 lambda.min, lambda.1se
plot(model_ela$modlist[[5]]$glmnet.fit)										# 5번째 alpha에서 각 계수가 줄어는 것을 보여줌
																# -- L1 Norm이 작을수록 제약조건을 강하게 줌, 위쪽의 숫자가 변수의 수

### Using 'caret' Package
### Ref) https://quantmacro.wordpress.com/2016/04/26/fitting-elastic-net-model-in-r/
library(caret)

lambda.grid <- 10^seq(2,-2,length=100)										# lambda의 값을 0.01부터 100까지 100개 추출
alpha.grid <- seq(0,1,length=11)											# alpha역시 0부터 1까지 0.1 간격으로 생성

trnCtrl <- trainControl(												# 시뮬레이션 training 설정
  method = "repeatedCV",												# repeated Cross Validation 방법
  number = 10,														# 10-folds Cross Validation 실시
  repeats = 5														# repeated CV에서 5번 반복 : n-folds CV을 5번 반복한 결과의 평균을 사용하는 방법, 즉 폴더수 * 반복수 만큼 모델을 적합하게 됨
)

srchGrd <- expand.grid(.alpha = alpha.grid, .lambda = lambda.grid)					# alpha와 lambda를 각각 매칭

set.seed(123456789)
x_use = subset(x,select=-c(si,bungi,bungi_main,bungi_sub,complex,day,roadName,cd91,bond5))	# 앞의 방법에서 사용한 데이터를 임의의 x_use에 할당

model_train <- train(log(price)~., data=x_use,									# train함수로 training시작 : log(price)를 반응변수, x_use데이터 사용 
                     method = "glmnet",										# glmnet의 방법을 사용, 도움말을 보면 다양한 모델함수 지원
                     tuneGrid = srchGrd,										# parameter들의 튜닝은 앞에서 alpha와 lambda를 grid매칭시킨 것을 사용
                     trControl = trnCtrl,										# 추가 설정은 앞에서 설정한것을 따름
                     standardize = TRUE, maxit = 1000000							# 데이터를 표준화 시키키고, 식이 수렴하지 않을 경우 최대반복수는 100만번 반복 후 근사값 사용
)

win.graph();plot(model_train)												# alpha(Mixing Percentage), lambda(Regularization Parameter)의 변화에 따른 모형의 RMSE값의 변화
# savePlot("저장경로/파일명.png",type="png")

#attributes(model_train)												# model_train에 포함되어있는 것들이 어떤 것이 있는지 출력
model_train$bestTune													# RMSE가 최소가 될때의 alpha, lambda를 구해줌
model.glmnet <- model_train$finalModel										# bestTune의 alpha,lambda가 적용된 glmnet모델이 finalModel에 들어 있어서 그것을 model.glmnet에 할당해줌

coef_gdadfccbbh <- coef(model.glmnet, s=model_train$bestTune$lambda)					# coef함수를 이용하여 모델object에 대한 coefficient를 구함, s옵션으로 lambda를 특정지음
coef_gdadfccbbh

###no standardized & numeric partial scale

x_use <- subset(x, select = c(price,date,gu,dong,area,floor,constructed,bond10,highSchool,unsold))
x_use <- cbind(x_use[,1:4],scale(x_use[,5:10]))									# 연속형설명변수들(5~10번째 column)만 scale로 표준화시킴; 반응변수,날짜,질적변수는 표준화 안됨.

set.seed(123456789)
model_train <- train(log(price)~., data=x_use,
                     method = "glmnet",
                     tuneGrid = srchGrd,
                     trControl = trnCtrl,
                     standardize = FALSE, maxit = 1000000							# 앞에선 standardize=TURE로인해 데이터타입을 가리지않고 표준화 했다면, 이번엔 표준화가 필요한 변수를 표준화해서 오기때문에 FALSE로 한다
)

win.graph();plot(model_train)
# savePlot("저장경로/파일명.png",type="png")

model_train$result													# alpha와 lambda에 따라 RMSE, sd(RMSE), R^2, sd(R^2) 구해줌, R^2(R squared)는 모델이 데이터를 얼마만큼 설명해주는지 나타냄
model_train$bestTune
model.glmnet <- model_train$finalModel

coef_dgdafcbhu_nostandard_partscale <- coef(model.glmnet, s=model_train$bestTune$lambda)
coef_dgdafcbhu_nostandard_partscale

###
# 이러한 방법으로 사용변수, 데이터의 크기, method, parameter 등을 바꿔가며 좋은 모델을 만들어가면 됩니다.
# 머신러닝 기법 중 하나라고 보면 됨.

model_using <- glmnet(log(price)~.,data=x_use,alpha=0.1,lambda=0.01)					# alpha와 lambda를 이렇게 특정지어서 glmnet으로 모델을 적합할 수 도 있음, 적당한 alpha, lambda는 꼭 bestTune에서 나오는게 아닐 수도 있음
summary(model_using)													# 모델결과 요약
model_using$beta														# 계수를 보여줌, 절편을 나타내는 계수는 $a0로 불러옴

pred <- predict(model_using,x_use)											# 우선 훈련자료를 어떻게 예측해내는지 예측 : predict(ModelObject,TestData)
																# predict함수대신 Data %*% Model$beta + Model$a0로 행렬계산해도 같음
price_pred <- exp(pred)													# 모델적합에서 반응변수를 log변환 해준것이기 때문에 원래 가격에 맞게 다시 지수변환
