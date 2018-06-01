setwd("D:/NNtest")
dataDir <- "realestate"
dataList <- list.files(dataDir)

library(data.table)
library(dplyr)
library(stringr)
### https://keras.rstudio.com/index.html
# devtools::install_github("rstudio/keras")
# library(keras)
# install_keras()
library(keras)

rescale <- function(x, newMin=0, newMax=1) {(x - min(x)) / (max(x)-min(x)) * (newMax - newMin) + newMin}
#########################################################################################

X_all <- fread(paste(dataDir,"all.csv",sep="/"))
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

X_all[which.min(X_all$price),]
X_prac <- X_all[-which.min(X_all$price),]
str(X_prac)

### 시장금리 데이터
rate <- fread(paste(dataDir, "4.1.2 시장금리(월_분기_년).csv",sep="/"))
colnames(rate) <- c("yearMonth","cd91","bond5","bond10")
rate$yearMonth <- as.Date(paste0(rate$yearMonth,01),"%Y%m%d")
str(rate)
x <- merge(X_prac,rate,by="yearMonth")

### 학교 수 데이터(고등학교만 사용)
highSchool <- fread(paste(dataDir,"2017년_학교+학교수.csv",sep="/"))[,c(2,6)]
colnames(highSchool) <- c("gu", "highSchool")
x <- merge(x,highSchool,by = "gu")
x$gu <- as.factor(x$gu)

### 미분양주택 데이터
unsold <- fread(paste(dataDir,"미분양주택현황.csv",sep="/"))
colnames(unsold) <- c("year","month","unsold")
unsold$unsold <- as.numeric(gsub(",","",unsold$unsold))
unsold$yearMonth <- seq(as.Date("20120101","%Y%m%d"),as.Date("20161201","%Y%m%d"),by="month")
x <- merge(x, unsold[,c(3,4)],by="yearMonth")

#########################################################################################
x_sub <- select(x, yearMonth, gu, dong, area, price, floor, constructed, bond10, highSchool, unsold)
x_dummy <- model.matrix(price ~ ., data = x_sub)
str(x_dummy)
idx <- sample(1:244799, 244799*0.1)
x_dummy_scale <- rescale(x_dummy)
price_scale <- rescale(x_sub$price)
max_price <- max(x_sub$price)
min_price <- min(x_sub$price)

inputs <- layer_input(shape = c(141), name = "Input_Layer")
outputs <- inputs %>% 
    layer_dropout(rate = 0.3, name = "Input_to_Hidden_Dropout") %>% 
    layer_dense(units = 50,
                kernel_initializer = "glorot_uniform",  # Xavier initializer
                name = "Fully-connected_1") %>% 
    layer_batch_normalization(name = "Batch_Normalization_1") %>% 
    layer_activation(activation = "tanh", name = "Tanh_Activattion_1") %>% 
    layer_dropout(rate = 0.3, name = "Hidden_to_Hidden_Dropout") %>% 
    layer_dense(units = 15, name = "Fully-connected_2") %>% 
    layer_batch_normalization(name = "Batch_Normalization_2") %>% 
    layer_activation(activation = "tanh", name = "Tanh_Activation_2") %>% 
    layer_dense(units = 1, activation = "linear", name = "Linear_Output_Layer")
model <- keras_model(inputs, outputs)
summary(model)    

loss_mean_elastic_error <- function(y_true, y_pred) {
    lambda <- 0.5
    res <- k_mean(lambda * (y_true - y_pred) ^ 2 + (1 - lambda) * k_abs(y_true - y_pred))
    return(res)
}

model %>% compile(
    optimizer = optimizer_adam(lr = 0.0001),
    loss = loss_mean_elastic_error,
    metrics = c("mean_elastic_error" = loss_mean_elastic_error)
    )

history <- model %>% fit(
    x = x_dummy_scale[-idx, ],
    y = price_scale[-idx],
    batch_size = 128,
    epochs = 100,
    validation_split = 0.2
)

win.graph(); plot(history)
get_weights(model)

model %>% evaluate(x_dummy_scale[idx, ], price_scale[idx])

model %>% predict(x_dummy_scale[idx, ]) %>% rescale(newMin = min_price, newMax = max_price) -> pred_return
test_y_return <- rescale(price_scale[idx], min_price, max_price)

win.graph()
plot(test_y_return, pred_return, type = "p")
abline(1, 1, col = "red")
