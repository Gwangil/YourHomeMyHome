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

x <- X_prac[,c(2,3,8,9,10,12,13)];	str(x)									# 전체에서 '구, 동, 면적, 거래년월, 거래일, 층, 건축년도'의 column만 x에 할당
y <- as.matrix(X_prac[,11]);	str(y)										# y에 price 열 할당

par(mfrow=c(2,1))														# par : 그래프 그리는 창 설정할때 쓰는 함수 여러가지 옵션있음 // mfrow : 한 그래프 창을 어떻게 분할할지, 여기선 2행 1열짜리로 분할(위아래로 하나씩 순차적으로 그려짐)
boxplot(y,horizontal=T,ylab="origin")										# 가격의 분포가 어떤지 확인하기 위해 상자그림을 그림 // horizontal 옵션으로 상자그림을 가로로 눕히고, ylab으로 이름 달기
boxplot(log(y),horizontal=T,ylab="transform")									# 비교를 위해 가격의 값을 log변환하여 그림그림 : 원 데이터는 왼쪽으로 데이터가 치우치지만 로그변환 한 데이터는 가운데로 조정됨
hist(scale(y),prob=T,ylim=c(0,0.5))											# 마찬가지로 분포를 확인하기 위해 히스토그램 그림, prob 옵션은 T하면 밀도, F하면 빈도수로 그려줌 // scale은 변수를 표준화하는 함수
lines(density(scale(y)))												# 활성화 되어있는 plot창에 lines함수로 선을 그려줌, density함수로 데이터의 분포를 그려줌
lines(seq(-3,3,length=1000),dnorm(seq(-3,3,length=1000)),col=2)						# 정규분포와 비교하기위해 dnorm 함수로 정규분포의 pdf값을 얻어서 정규분포곡선을 그려넣음, seq함수는 수열생성 여기선 -3부터 3까지 균등간격으로 1000개 추출
hist(scale(log(y)),prob=T,ylim=c(0,0.5))										# 로그변환 한 데이터로 똑같이 그려줌
lines(density(scale(log(y))))
lines(seq(-3,3,length=1000),dnorm(seq(-3,3,length=1000)),col=2)
y <- log(y)															# 원래의 데이터보다 로그변환을 한 데이터가 정규분포와 더 가까워지므로 로그변환값을 사용해서 예측실시
																# 회귀분석 할때 정규분포를 따른다는 가정이 필요하므로 데이터를 정규분포와 비슷하게 변환시켜주는 방법이 좋은 경우가 많음
																# 변환데이터로 예측 후 예측값을 다시 역변환 해서 해석하는것 필요, 만약 데이터가 오른쪽으로 치우치면 n제곱변환 가능

set.seed(01094844224)													# 랜덤넘버 시드설정
gr <- sample(rep(seq(10),length=length(y)))									# 1~10을 y의 수만큼 반복생성후, sample을 통해 무작위로 뿌린 것을 해당 관측치가 속한 그룹으로 하기위함

result <- matrix(NA,10,2)												# NA로 이루어진 10x2행렬 생성 : 결과값 저장하기위함, 10개의 그룹만큼 반복, 각 2개 결과값

for ( i in 1:10) {													# 10-folds Cross Validation을 하기위해 1~10그룹만큼 for문 반복
	x.te <- subset(x,gr==i); x.tr <- subset(x,gr!=i)							# subset함수로 데이터를 떼어냄, i번째 그룹을 test Set, 나머지를 training Set
	y.te <- subset(y,gr==i); y.tr <- subset(y,gr!=i)

	model <- lm(y.tr~., data=x.tr)										# lm함수로 다중선형회귀모형 적합, '반응변수~설명변수1+설명변수2+...' 처럼 formula형식으로 모형설정, 설명변수에 .를 쓰면 모든 설명변수 다 사용
	#summary(model)													# summary(모형) 하면 모형에대한 전반적인 정보 확인가능
	
	pred <- predict(model,x.te)											# predict(모형, 데이터)함수로 적합된 모형에 test Set을 대입하여 예측값 계산
	result[i,1] <- sqrt(mean((y.te-pred)^2))									# RMSE 계산 : 모형의 성능평가 방법 중 하나, 오차가 얼마나 나는지
	result[i,2] <- exp(y.te[which.max(y.te-pred)])-exp(pred[which.max(y.te-pred)])		# exp함수로 로그변환했떤 역변환, 예측오차가 가장 큰 지점의 실제 가격과 예측가격의 차이를 구한 것
}

apply(result,2,mean)													# apply(데이터,방향,적용함수)로 result행렬의 column 평균 구함, 두번째 인수에 1은 행방향, 2는 열방향
mean(result[,2])														# 각각의 반복에서 가장크게 실제가격과 예측가격의 차이가 난것들의 평균