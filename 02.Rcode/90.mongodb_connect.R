library(mongolite)										#mongolite ���̺귯�� ȣ��
con <- mongolite::mongo(collection = "mean_pusan",					#mongolite�� mongo�Լ� ����ؼ� Ŀ�ؼ� ���� --> package::function
	db = "newDB",										#collection, db, url ����
	url = "mongodb://52.78.114.111",
	verbose=TRUE,										#verbose,options�� ��Ȯ�� �˰��ʹٸ� google����..
	options=ssl_options())
con$drop()												#drop�ϸ� �ش� �÷��� �����
con$insert(mean_pusan)										#mean_pusan�� ����Ǿ��ִ� �����͸� ���� �÷��ǿ� �Է�
con$find()												#�÷��� ��ȸ
													
													#rm(con)���� Ŀ�ؼ�����
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
													#insert()�ȿ��� ������ �ڵ鸵�۾��Ѱ�
