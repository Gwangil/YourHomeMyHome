library(data.table)														# data.frame 타입 + 좀더 발전된 data.table타입을 사용하고 편리한 함수를 제공해주는 패키지(fread함수 포함 : fast read)
library(dplyr)															# 데이터 핸들링을 편하게 해주는 패키지
library(stringr)															# 문자열 처리를 하기위한 패키지

path_year <- 12:16
path0 <- "E:/00.니집내집/90.데이터수집/01.실거래가/"										# \인식 안되므로 / 로 바꿔줌
X_tot <- list()															# list타입의 빈껍데기 생성 
for ( j in 1:length(path_year) ) {
  path <- paste0(path0,path_year[j],"년","/")										# path_year의 j번째 숫자와 "년", "/"를 path0에 붙여줌 -- R은 index가 1부터 시작(0아님), paste는 문자열 붙여주는 함수, paste0는 공백없이 결합[= paste("A","B",sep="")]
  temp <- list.files(path=path, pattern="*.csv")									# list.files함수를 이용해서 path 경로에있는 pattern에 맞는 파일명을 불러옴
  temp <- paste0(path,temp)													# path에 저장된 경로와 파일명을 결합
  
  X<-list()																# list타입의 빈껍데기 생성
  for (i in 1:length(temp)) {
    temp2 = fread(temp[i], header = TRUE)											# fread함수로 temp에 있는 경로&파일명 읽기
    X <- rbind(X,temp2,fill=TRUE)												# rbind로 행방향으로 연결(fill 옵션은 column의 수가 다르면 NA로 채워줌)
  }
  
  sector <- do.call(rbind, strsplit(X$시군구," "))									# strsplit으로 " "을기준으로 split하면 list타입의 output나오는 것을 rbind를 적용해서 합쳐줌
  sector[,4] <- gsub("부산광역시","",sector[,4])										# 4번째 열에 기장군은 '~리'가 들어가지만 나머지는 '부산광역시'가 채워지므로 '부산광역시'를 지움
  sector_fin <- cbind(sector[,1:2],paste0(sector[,3],sector[,4]))							# 시,구,동 3열짜리로 일치시키기 위해 3,4열 붙이는 연산을하고 1,2열과 열결합
  colnames(sector_fin) <- c("시","구","동")											# column이름 설정
  X <- cbind(sector_fin,X[,-1])												# 새롭게 만들어진 시,구,동 3열짜리 데이터와 앞서 만든 X데이터에서 1열(시군구)를 제외하고 결합
  
  X$계약년월 <- as.factor(X$계약년월)												# 숫자형태(int) yyyymm를 문자열(factor) 변환
  X[,11] <- as.numeric(sapply(X[,11],function(x) gsub(",","",x)))							# 천단위 구분표시(,) 때문에 문자열로 인식돼서 ,를 빼고 숫자형으로 변환 -- sapply는 데이터의 각 요소마다 함수 적용, 여기서는 사용자함수사용
  X$동[grep("가$",X$동)] <- str_sub(X$동[grep("가$",X$동)],1,-3)							# grep으로 '동'에서 "가"로 끝나는 글자(정규표현식, ex 보수동1가)가 있는 index를 찾고 '?가'를 제거하기위해 1번째글자부터 끝에서 3번째 글자(-3)까지만 가져옴
  
  X_tot[[j]]<-X															# X_tot의 1번째 list로 X를 할당
}																	# 12년~16년까지 반복
str(X_tot)																# X_tot의 구조를 보면 1번째 list에 12년 ~ 5번째 리스트에 16년 저장됨

X_all <- rbind(X_tot[[1]],X_tot[[2]],X_tot[[3]],X_tot[[4]],X_tot[[5]])						# list타입의 데이터를 rbind로 하나의 data.frame으로 만들어줌
str(X_all)																# 총 244800 x 14 데이터

write.csv(X_tot[[1]],"C:/Users/Gwangil/Desktop/니집내집/데이터수집/실거래가/2012.csv",row.names=F)		# csv파일로 export, row.names=F는 행이름 빼고 생성
write.csv(X_tot[[2]],"C:/Users/Gwangil/Desktop/니집내집/데이터수집/실거래가/2013.csv",row.names=F)
write.csv(X_tot[[3]],"C:/Users/Gwangil/Desktop/니집내집/데이터수집/실거래가/2014.csv",row.names=F)
write.csv(X_tot[[4]],"C:/Users/Gwangil/Desktop/니집내집/데이터수집/실거래가/2015.csv",row.names=F)
write.csv(X_tot[[5]],"C:/Users/Gwangil/Desktop/니집내집/데이터수집/실거래가/2016.csv",row.names=F)
write.csv(X_all,"C:/Users/Gwangil/Desktop/니집내집/데이터수집/실거래가/all.csv",row.names=F)

write.table(unique(X_all$구),"E:/니집내집/구동목록/01.구목록.txt",quote = F,row.names=F,col.names=F)	# 구 목록 생성, unique함수는 중복된것을 생략하고 데이터 출력
write.table(unique(X_all$동),"E:/니집내집/구동목록/02.동목록.txt",quote = F,row.names=F,col.names=F)	# 동 목록 생성
gudong <- aggregate(동 ~ 구,X_all,unique)											# aggregate는 ~(formual)를 이용하여 데이터에 함수 적용 -- '동 ~ 구' : '동'에 함수를 적용하는데 '구'별로 나눠서 적용
for ( i in 1:16) {
	filename <- paste0("E:/니집내집/구동목록/",gudong$구[i],"동목록.txt")						# 16개 구별로 동목록 생성
	write.table(gudong$동[i],filename,quote = F,row.names=F,col.names=F)
}
