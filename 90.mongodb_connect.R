library(mongolite)										#mongolite 라이브러리 호출
con <- mongolite::mongo(collection = "mean_pusan",					#mongolite의 mongo함수 사용해서 커넥션 만듦 --> package::function
	db = "newDB",										#collection, db, url 설정
	url = "mongodb://52.78.114.111",
	verbose=TRUE,										#verbose,options를 정확히 알고싶다면 google에게..
	options=ssl_options())
con$drop()												#drop하면 해당 컬렉션 비워줌
con$insert(mean_pusan)										#mean_pusan에 저장되어있는 데이터를 앞의 컬렉션에 입력
con$find()												#컬렉션 조회
													
													#rm(con)으로 커넥션해제
con <- mongolite::mongo(collection = "mean_gu",
	db = "newDB",
	url = "mongodb://52.78.114.111",
	verbose=TRUE,
	options=ssl_options())
con$drop()
con$insert(mean_gu)

con <- mongolite::mongo(collection = "mean_dong",
	db = "newDB",
	url = "mongodb://52.78.114.111",
	verbose=TRUE,
	options=ssl_options())
con$drop()
con$insert(mean_dong)

con <- mongolite::mongo(collection = "total",
                        db = "newDB",
                        url = "mongodb://52.78.114.111",
                        verbose=TRUE,
                        options=ssl_options())
con$insert(totalAndPredict)

con <- mongolite::mongo(collection = "transaction",
                        db = "newDB",
                        url = "mongodb://52.78.114.111",
                        verbose=TRUE,
                        options=ssl_options())
con$insert(totalAndPredict %>% filter(yearMonth >= "2016-01-01") %>% select(gu,dong,complex,area,floor,constructed,price,predictedPrice))
													#insert()안에서 데이터 핸들링작업한것

