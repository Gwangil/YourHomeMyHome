#install.packages('data.table')
#install.packages('dplyr')
#install.packages("XML")								# XML 다루는 패키지
#install.packages("stringr")
#install.packages("ggplot2")								# 그림 그리는 패키지
#install.packages("leaflet")								# 지도관련 패키지
#install.packages("jsonlite")								# json 관련 패키지
#install.packages('RCurl')								# url 관련 패키지
#install.packages('purrr')								# 뭐였더라.... 구글....
#install.packages('viridis')								# 뭐였더라.... 구글....
#install.packages('DT')									# 표 만들기 하는 테이블(html)
library(data.table)
library(dplyr)
library(stringr)
library(ggplot2)
library(leaflet)
library(jsonlite)
library(RCurl)
library(XML)
library(purrr)
library(viridis)
library(DT)
######
X_all <- fread("E:/00.니집내집/90.데이터수집/01.실거래가/all.csv")						# 실거래가 정리 코드를 이용해서 all.csv를 만든것을 불러옴
colnames(X_all) <- c("si","gu","dong","bungi","bungi_main","bungi_sub","complex",
				"area","yearMonth","day","price","floor","constructed","roadName")	# column명을 영문으로 변환...R에서 한글은 인코딩이....ㅜㅜ
X_all$yearMonth <- as.Date(paste0(X_all$yearMonth,01),"%Y%m%d")						# yyyymm으로 받은 데이터에 임의로 01(dd)을 붙여 Date타입으로 변환
X_all$si <- as.factor(X_all$si)											# chr(character)형식을 factor로 변환 : 추후 모델적합시 속도향상(음.. 문자열이랑 요인(factor)랑 R에서 취급하는게 조금 다름...)
X_all$gu <- as.factor(X_all$gu)											# 문자열은 하나하나가 다 다른 개별 값이지만
X_all$dong <- as.factor(X_all$dong)											# factor는 해당 값의 목록(levels)이 있고, 해당 값은 그 목록의 몇 번째 값을 가져온건지 알 수 있음 as.numeric(factorTypeData)식으로
X_all$bungi <- as.factor(X_all$bungi)
X_all$bungi_main <- as.factor(X_all$bungi_main)
X_all$bungi_sub <- as.factor(X_all$bungi_sub)
X_all$complex <- as.factor(X_all$complex)
X_all$day <- as.factor(str_sub(X_all$day,1,-3))
X_all$roadName <- as.factor(X_all$roadName)

X.prac <- X_all[-which.min(X_all$price),]										# which.min은 최소값의 index를 찾아줌, X.prac에 price의 최소값이 있는 index를 제외하고 할당 -- 나중에 평균값으로 지도에 뿌리는데, 이상치가 평균에 영향을줌
str(X.prac)

######
																# '%>%'는 dplyr패키지에서 지원하는 chain 방식을 사용하기위한 기호 -- 연산속도 향상, 코드 줄어듦
X.prac_map <- X.prac %>% filter(substr(X.prac$yearMonth,1,4) >= 2016) %>%				# X.prac 에서(%>%) yearMonth(계약년월)의 1~4번째자리:yyyy가 2016 이상인 것을 필터링 %>%
			 group_by(dong) %>% summarise(n = n(), mean = round(mean(price), 0)) %>%	# 필터링한 데이터를 동별로 그룹핑 하고 %>% 그룹별 요약(summarise)함, 갯수와 평균값 계산 %>%
			 as.data.table()											# 처리한 데이터를 data.table 타입으로 변환하여 X.prac_map에 저장
											
###################################

url <- "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&language=ko&address="	# google api로 위경도 받아올거임.

for(i in 1:nrow(X.prac_map)){
    
    post <- paste0("부산광역시", X.prac_map[i, ]$dong)								# 부산광역시??동
    post <- iconv(post, from = "cp949", to = "UTF-8") # win version					# R 기본 character set이 cp949...

    if ( is.na(post) ) {												# 상황에따라 iconv함수 결과가 NA가 나올때가 있어서 이럴때는
        post <- paste0("부산광역시", X.prac_map[i, ]$V5)							# 그런데 어떤건 iconv에서 NA가 나고 어떤건 URLencode에서 NA가 뜰수도 있음..우선 지금 사용하는 데이터는 둘중 한번은 제대로됨
        post <- URLencode(post)											# URLencode로 encoding변환..
    }

    geocode_url = paste(url, post,sep="")										# api url에 우리가 찾고싶은 곳 연결

    url_query <- getURL(geocode_url)										# url결과를 json으로 받아오옴
    
    url_json <- fromJSON(paste0(url_query, collapse = ""))							# json형태를 읽어들임
    
    x_point <- url_json$results$geometry$location$lng								# 경도
    y_point <- url_json$results$geometry$location$lat								# 위도
    
    X.prac_map[i, x_ := x_point]											# 위경도 저장, 아마 :=는 값을 특정컬럼에 넣을때 쓰는것으로 추정됨...
    X.prac_map[i, y_ := y_point]
    X.prac_map[i, n_ := i]
  
}

#######################################

X.prac_map_purr <- X.prac_map %>% 											# X.prac_map_purr 데이터를 만듦( X.prac_map을 이용하면서 %>% )
	mutate(level = cut(mean, c(seq(0,50000,10000),10e+10),						# mutate로 새 변수(level) 추가, cut으로 (0,1억,2억,...,5억,아주큰숫자) 자리에서
			 labels = c("~ 1억", "1억 ~ 2억", "2억 ~ 3억", "3억 ~ 4억", "4억 ~ 5억","5억 ~ ")))	# 끊어서 labels를 달아줌

X.prac_map_purr$label <- 												# label변수 만듦
	sapply(X.prac_map_purr$mean, function(x) {								# mean변수에 사용자지정함수 적용
		djr <- str_sub(round(x,-3),end=-5)									# djr(억) : 끝에서 5번째 자리까지가 억단위
		cjsaks <- str_sub(round(x,-3),-4,-4)								# cjsaks(천만) : 천만까지 반올림하면 끝에서 4번째 자리가 천만단위

		if ( djr != "" && cjsaks != "0" ) {									# 억단위 미만이거나, 천만단위가 0인 상황 구분하여
			paste0(djr,"억",cjsaks,"천만" )									# if, else를 사용해서 "억", "천만"형태로 만들어줌(가시성 높이기위함)
		} else if(djr != "" & cjsaks == "0" ) {
			paste0(djr,"억")
		} else paste0(cjsaks,"천만" )
		}
	)


X.prac_map_purr_split <- split(X.prac_map_purr, X.prac_map_purr$level)					# X.prac_map_purr을 level기준으로 split


pusan_leaf <- leaflet(width = "100%") %>% addTiles()								# leaflet 기본 전체 세계지도 생성

pusan_leaf_ <- names(X.prac_map_purr_split) %>%									# 세계지도에 마커, 값 뿌려주는 부분
    walk( function(df) {
        pusan_leaf <<- pusan_leaf %>%
            addMarkers(data = X.prac_map_purr_split[[df]],
                       lng = ~x_, lat = ~y_,
                       popup = ~as.character(dong),
                       label = ~as.character(label),
                       labelOptions = labelOptions(noHide = T, textsize = "15px", direction  =  'auto'),
                       group  =  df,
                       clusterOptions  =  markerClusterOptions(removeOutsideVisibleBounds  =  F))
        })
    

pusan_leaf <- pusan_leaf %>%												# 억단위 체크박스, 미니맵 추가
  addLayersControl(
    overlayGroups = names(X.prac_map_purr_split),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% addMiniMap(toggleDisplay = TRUE) %>%
	addProviderTiles(providers$OpenStreetMap)									# 배경지도(Tile)을 저장할때 묶어서 가기위해 사용

pusan_leaf

library(htmlwidgets)													# 만들어진 지도가 html형식, html형식 export
saveWidget(pusan_leaf, file="pusan2016.html")

