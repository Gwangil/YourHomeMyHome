txt <- readLines("total.txt")

data <- sapply(txt, extractNoun, USE.NAMES = F)
data <- unlist(data)
data <- Filter(function(x){nchar(x)>=2}, data)

data = gsub('[[:punct:]]', '', data)
data = gsub('[[:cntrl:]]', '', data)
data = gsub("[A-Za-z]","", data)
data = gsub('\\d+', '', data)
data = gsub('부산', '', data)
data = gsub('서울', '', data)
data = gsub('부동', '부동산', data)
data = gsub('부동산산', '부동산', data)
data = gsub('부동산', '', data)
write(unlist(data),"total_ex.txt")
rev <- read.table("total_ex.txt")
wordcount <- table(rev)
wordcount <- head(sort(wordcount, decreasing = T), 50)
write.csv(wordcount,"total_word.csv")
palete <- brewer.pal(6,"RdYlGn")
win.graph()
loadfonts(device ="win")
windowsFonts(headline=windowsFont("HY헤드라인M"))

wordcloud(names(wordcount), freq=wordcount, scale = c(5,1), rot.per = 0.1,  min.freq=1, max.words=Inf, random.order=F, color= T, colors=palete, family="headline")
savePlot(paste("", code, sep='', "wordcloud.png"), type="png")
legend(0.3, 1, "부동산", cex=0.8, fill=NA, border=NA, bg="white", text.col="blue", text.font=2, box.col="blue")

library(mongolite)
con <- mongolite::mongo(collection= "test_data",
                       db = "test",
                       url = "mongodb://localhost",
                       verbose = TRUE,
                       options = ssl_options())

df <- utils::read.csv("./2012.csv")
con$insert(df)
df1 <- con$find(query = '{"동":{"$gt":3000}}')