### ������ : '�ǰŷ��� ���� ������ ����.R'�� X_all �Ǵ� ��ü �����͸� �ҷ��ͼ� ����.
#install.packages("data.table")
#install.packages('stringr')
library(data.table)
library(stringr)

X_all <- fread("E:/00.��������/90.�����ͼ���/01.�ǰŷ���/all.csv")						# �ǰŷ��� ���� �ڵ带 �̿��ؼ� all.csv�� ������� �ҷ���
colnames(X_all) <- c("si","gu","dong","bungi","bungi_main","bungi_sub","complex",
				"area","yearMonth","day","price","floor","constructed","roadName")	# column���� �������� ��ȯ...R���� �ѱ��� ���ڵ���....�̤�
X_all$yearMonth <- as.Date(paste0(X_all$yearMonth,01),"%Y%m%d")						# yyyymm���� ���� �����Ϳ� ���Ƿ� 01(dd)�� �ٿ� DateŸ������ ��ȯ
X_all$si <- as.factor(X_all$si)											# chr(character)������ factor�� ��ȯ : ���� �����ս� �ӵ����(��.. ���ڿ��̶� ����(factor)�� R���� ����ϴ°� ���� �ٸ�...)
X_all$gu <- as.factor(X_all$gu)											# ���ڿ��� �ϳ��ϳ��� �� �ٸ� ���� ��������
X_all$dong <- as.factor(X_all$dong)											# factor�� �ش� ���� ���(levels)�� �ְ�, �ش� ���� �� ����� �� ��° ���� �����°��� �� �� ���� levels(factorTypeData), as.numeric(factorTypeData)������
X_all$bungi <- as.factor(X_all$bungi)
X_all$bungi_main <- as.factor(X_all$bungi_main)
X_all$bungi_sub <- as.factor(X_all$bungi_sub)
X_all$complex <- as.factor(X_all$complex)
X_all$day <- as.factor(str_sub(X_all$day,1,-3))
X_all$roadName <- as.factor(X_all$roadName)

X_all[which.min(X_all$price),]											# which.min�� �ּҰ��� index�� ã����
X_prac <- X_all[-which.min(X_all$price),]										# X.prac�� price�� �ּҰ��� �ִ� index�� �����ϰ� �Ҵ� -- ���߿� ��հ����� ������ �Ѹ��µ�, �̻�ġ�� ��տ� ��������
str(X_prac)

### ����ݸ� ������
rate <- fread("E:/00.��������/90.�����ͼ���/02.���� �� csv/4.1.2 ����ݸ�(��_�б�_��).csv")
colnames(rate) <- c("yearMonth","cd91","bond5","bond10")
rate$yearMonth <- as.Date(paste0(rate$yearMonth,01),"%Y%m%d")
str(rate)
x <- merge(X_prac,rate,by="yearMonth")										# X_prac�� rate�� yearMonth �������� merge

### �б� �� ������(�����б��� ���)
highSchool <- fread("E:/00.��������/90.�����ͼ���/02.���� �� csv/2017��_�б�+�б���.csv")[,c(2,6)]	# �б��� csv �����Ϳ��� 2��(��), 6��(�����б�)�� �����Ŵ
colnames(highSchool) <- c("gu", "highSchool")
x <- merge(x,highSchool,by = "gu")

### �̺о����� ������
unsold <- fread("E:/00.��������/90.�����ͼ���/02.���� �� csv/�̺о�������Ȳ.csv")
colnames(unsold) <- c("year","month","unsold")
unsold$unsold <- as.numeric(gsub(",","",unsold$unsold))							# �̺о�Ǽ� �����Ͱ� õ��������(,)�� ���ԵǾ� chr Ÿ������ �ҷ��°�, õ���� �����ڸ� ���� numeric Ÿ������ ��ȯ
unsold$yearMonth <- seq(as.Date("20120101","%Y%m%d"),as.Date("20161201","%Y%m%d"),by="month")	# ������ ���� �Ǿ��ִ°� ���Ĵ� �� ��� ���� 20120101 ���� 20161201 ���� ���������� ����
x <- merge(x, unsold[,c(3,4)],by="yearMonth")									# �̺о�Ǽ��� ���θ��� ���� �÷��� ��� ����

########################## Model Fitting ###########################
#install.pacakges('dplyr')
#install.pacakges('glmnet')												# Elastic Net(LASSO & RIDGE Regression) �ϱ� ���� ��Ű��
#install.pacakges('glmnetUtils')											# glmnet ��Ű���� ���� ����, formula���� ���� : ��������~��������, cross validation �Լ� ����
#install.pacakges('caret')												# �������� �𵨸� �Լ� �� �ùķ��̼� ȯ���� ����, ������ �� ����
library(dplyr)
library(glmnet)
library(glmnetUtils)

### Elastic Net ����
# ������ ���߼���ȸ�͸������� �������� ��ȭ�� ���� ���������� ����� �����ؼ� �߿亯�� ���� ����, �־��� �����Ϳ� ������(overfitting)�ϴ°��� ����
# LASSO, RIDGE�� ����Ͽ� �پ��� ������� ���������� ������, ������ ������ �����ϴ� hyper parameter : lambda
# ������ ���� ������ ���Ǵ� ���������� ���� �پ��� ����� 0���� ������� : ������ ū ������ ����
# ���� alpha * LASSO�� (1-alpha) * RIDGE ������� ���� ���� Elastic Net
# ���߼���ȸ�͸������� alpah, lambda �ּ� 2���� hyper parameter �߰�

### Cross Validation
# 10-fold��� �ϸ� �����͸� 10���� �׷����� ������
# ���� 1�׷��� test Set, 

###glmnet�Լ� �⺻ ����
# glmnet(x, y, alpha, lambda, family, ...)
# -- x : ��������, y : ��������, alpha�� LASSO, RIDGE ��������(1=LASSO(�⺻��), 0=RIDGE)
# -- lambda�� �־��� alpha���� lambda�� ��� ��������, ����θ� �Լ��� ������ ���� ����
# -- family�� ������ ������ : "gaussian", ������ : "binomail", �̿��� �������� ����
# glmnetUtils�� ����ϸ� y~x, data=X ���� formula ���� ��밡��


### Using 'glmnetUtils' Package
model_ela <- cva.glmnet(log(price)~., data=									# cva.glmnet���� alpha���� �ٲ㰡�� 10-fold(�⺻��) cross validation �ǽ�
		subset(x,select=-c(si,bungi,bungi_main,bungi_sub,complex,day,roadName,cd91,bond5)))	# ��, ����, ������ �� ������ �����ϰ� ���� : �ǹ̰� ���ų�, �Ǵܻ��� ������ ����

summary(model_ela)													# alpha 11����, �̿� ���� �𵨸���Ʈ 11���� ���� ���� Ȯ��
str(model_ela)														# cva.glmnet�� ����� ���� ���� Ȯ�ΰ��� : $, [[ ]] ���� ������� ã�� ���� ����

plot(model_ela)														# lambda�� ��ȭ�� ���� mse���� ��ȭ �ö�, alpha�� �������� ����, �Ķ������� ������ alpha�� 0�� �����
model_ela$alpha														# �����տ� ���� alpha�� ���
model_ela$modlist[[5]]													# model_ela�� 11�� modlist���� 5��° ����Ʈ�� �������� : alpha�� 5��° ���� ����� ��
																# -- modlist ���� : glmnet�Լ��� ����� ����
																# -- $lambda : �־��� alpha�Ͽ��� �� ���ս� lambda�� ��ȭ��Ű�� ������ lambda����
																# -- $cvm, cvsd, cvup, cvlo : �� ���� 10-fold cross validation �ϸ� ���� mse�� ���, ǥ������, ���+ǥ������, ���-ǥ������ : lambda�� �� ��ŭ ���
																# -- $nzero : �� �𵨿��� ����� ���� 0�� �ƴ� ������ ����� ��Ÿ��
																# -- $glmnet.fit : �� lambda������ 0�� �ƴ� ����� ��(Df), ��������(%Dev)�� ���
																# -- $lambda.min : mse�� ����� �ּ� �϶� lambda ��
																# -- $lambda.1se : mse�� �ּ� �϶����� ǥ�������� 1�� ��ŭ ������� �� lambda��, mse������ ���� �� �����ϰ� = �������� lambda�� ���ϰ�, 0���� �������� ������ �ø�
plot(model_ela$modlist[[5]])												# 5��° alpha�϶� ���� mse�� ��ȭ�ϴ� �ö�
																# -- �������� �ּ��϶� mse�� ���Ʒ��� ���� ���� cvup, cvlo�̴�. ������ ���ڴ� ����� 0�� �ƴ� ������ ��, ������ ���� lambda.min, lambda.1se
plot(model_ela$modlist[[5]]$glmnet.fit)										# 5��° alpha���� �� ����� �پ�� ���� ������
																# -- L1 Norm�� �������� ���������� ���ϰ� ��, ������ ���ڰ� ������ ��

### Using 'caret' Package
### Ref) https://quantmacro.wordpress.com/2016/04/26/fitting-elastic-net-model-in-r/
library(caret)

lambda.grid <- 10^seq(2,-2,length=100)										# lambda�� ���� 0.01���� 100���� 100�� ����
alpha.grid <- seq(0,1,length=11)											# alpha���� 0���� 1���� 0.1 �������� ����

trnCtrl <- trainControl(												# �ùķ��̼� training ����
  method = "repeatedCV",												# repeated Cross Validation ���
  number = 10,														# 10-folds Cross Validation �ǽ�
  repeats = 5														# repeated CV���� 5�� �ݺ� : n-folds CV�� 5�� �ݺ��� ����� ����� ����ϴ� ���, �� ������ * �ݺ��� ��ŭ ���� �����ϰ� ��
)

srchGrd <- expand.grid(.alpha = alpha.grid, .lambda = lambda.grid)					# alpha�� lambda�� ���� ��Ī

set.seed(01094844224)
x_use = subset(x,select=-c(si,bungi,bungi_main,bungi_sub,complex,day,roadName,cd91,bond5))	# ���� ������� ����� �����͸� ������ x_use�� �Ҵ�

model_train <- train(log(price)~., data=x_use,									# train�Լ��� training���� : log(price)�� ��������, x_use������ ��� 
                     method = "glmnet",										# glmnet�� ����� ���, ������ ���� �پ��� ���Լ� ����
                     tuneGrid = srchGrd,										# parameter���� Ʃ���� �տ��� alpha�� lambda�� grid��Ī��Ų ���� ���
                     trControl = trnCtrl,										# �߰� ������ �տ��� �����Ѱ��� ����
                     standardize = TRUE, maxit = 1000000							# �����͸� ǥ��ȭ ��ŰŰ��, ���� �������� ���� ��� �ִ�ݺ����� 100���� �ݺ� �� �ٻ簪 ���
)

win.graph();plot(model_train)												# alpha(Mixing Percentage), lambda(Regularization Parameter)�� ��ȭ�� ���� ������ RMSE���� ��ȭ
# savePlot("������/���ϸ�.png",type="png")

#attributes(model_train)												# model_train�� ���ԵǾ��ִ� �͵��� � ���� �ִ��� ���
model_train$bestTune													# RMSE�� �ּҰ� �ɶ��� alpha, lambda�� ������
model.glmnet <- model_train$finalModel										# bestTune�� alpha,lambda�� ����� glmnet���� finalModel�� ��� �־ �װ��� model.glmnet�� �Ҵ�����

coef_gdadfccbbh <- coef(model.glmnet, s=model_train$bestTune$lambda)					# coef�Լ��� �̿��Ͽ� ��object�� ���� coefficient�� ����, s�ɼ����� lambda�� Ư������
coef_gdadfccbbh

###no standardized & numeric partial scale

x_use <- subset(x, select = c(price,date,gu,dong,area,floor,constructed,bond10,highSchool,unsold))
x_use <- cbind(x_use[,1:4],scale(x_use[,5:10]))									# ����������������(5~10��° column)�� scale�� ǥ��ȭ��Ŵ; ��������,��¥,���������� ǥ��ȭ �ȵ�.

set.seed(01094844224)
model_train <- train(log(price)~., data=x_use,
                     method = "glmnet",
                     tuneGrid = srchGrd,
                     trControl = trnCtrl,
                     standardize = FALSE, maxit = 1000000							# �տ��� standardize=TURE������ ������Ÿ���� �������ʰ� ǥ��ȭ �ߴٸ�, �̹��� ǥ��ȭ�� �ʿ��� ������ ǥ��ȭ�ؼ� ���⶧���� FALSE�� �Ѵ�
)

win.graph();plot(model_train)
# savePlot("������/���ϸ�.png",type="png")

model_train$result													# alpha�� lambda�� ���� RMSE, sd(RMSE), R^2, sd(R^2) ������, R^2(R squared)�� ���� �����͸� �󸶸�ŭ �������ִ��� ��Ÿ��
model_train$bestTune
model.glmnet <- model_train$finalModel

coef_dgdafcbhu_nostandard_partscale <- coef(model.glmnet, s=model_train$bestTune$lambda)
coef_dgdafcbhu_nostandard_partscale

###
# �̷��� ������� ��뺯��, �������� ũ��, method, parameter ���� �ٲ㰡�� ���� ���� ������ �˴ϴ�.
# �ӽŷ��� ��� �� �ϳ���� ���� ��.

model_using <- glmnet(log(price)~.,data=x_use,alpha=0.1,lambda=0.01)					# alpha�� lambda�� �̷��� Ư����� glmnet���� ���� ������ �� �� ����, ������ alpha, lambda�� �� bestTune���� �����°� �ƴ� ���� ����
summary(model_using)													# �𵨰�� ���
model_using$beta														# ����� ������, ������ ��Ÿ���� ����� $a0�� �ҷ���

pred <- predict(model_using,x_use)											# �켱 �Ʒ��ڷḦ ��� �����س����� ���� : predict(ModelObject,TestData)
																# predict�Լ���� Data %*% Model$beta + Model$a0�� ��İ���ص� ����
price_pred <- exp(pred)													# �����տ��� ���������� log��ȯ ���ذ��̱� ������ ���� ���ݿ� �°� �ٽ� ������ȯ