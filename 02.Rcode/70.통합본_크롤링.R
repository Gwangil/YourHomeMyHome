library(rvest)
library(stringr)
library(KoNLP)
library(RColorBrewer)
library(wordcloud)
library(plyr)
library(extrafont)
useSejongDic()
setwd("F:/r_temp")
getNextMax <- function(htxt) {
  pagehref <- htxt %>% html_nodes ('.paging a') %>% html_attrs
  
  url00 <- paste0("http://news.naver.com/main/list.nhn", pagehref[[length(pagehref)]][1])
  htxt <- read_html(url00)
  maxpage <- htxt %>% html_nodes ('.paging a') %>% html_text
  return(list(maxpage,htxt))
}

getMaxPage <- function(url, code) {
  htxt <- read_html(url)
  maxpage <- htxt %>% html_nodes ('.paging a') %>% html_text
  
  
  while(sum(str_detect(maxpage, "다음")) != 0) {
    maxpage <- getNextMax(htxt)[[1]]
    htxt <- getNextMax(htxt)[[2]]
  }
  
  maxpage <- gsub("이전", "0", maxpage)
  maxpage <- max(as.numeric(maxpage))
  
  return(maxpage)
}

url1 <- paste(url_base, code, sep ='', "&page=")
url_base <- 'http://news.naver.com/main/list.nhn?sid2=260&sid1=101&mid=shm&mode=LS2D&date='
all.reviews <- c()

for(code in 20170825:20170825) {
  url1 <- paste(url_base, code, sep ='', "&page=")
  maxpage <- getMaxPage(url1,code)
  
  for(page in 1:maxpage) {
    url2 <- paste(url1, page, sep = '')
    htxt2 <- read_html(url2)
    comments <- htxt2 %>% html_nodes ('.list_body') %>% html_nodes('a')
    reviews <- html_text(comments)
    reviews <- str_trim(reviews)
    all.reviews <- c(all.reviews, reviews)
    all.reviews <- unique(all.reviews)
  } 
  write(all.reviews, paste("", code, sep='', "naver.txt"))
  print(paste("", code, sep='', "naver.txt"))
  txt1 <- readLines(paste("", code, sep='', "naver.txt"))
  all.reviews <- NULL
}

getNextMax_nate <- function(htxt) {
  pagehref <- htxt %>% html_nodes ('.paging a') %>% html_attrs
  
  url00 <- paste0("http://news.nate.com", pagehref[[length(pagehref)]][1])
  htxt <- read_html(url00)
  maxpage <- htxt %>% html_nodes ('.paging a') %>% html_text
  return(list(maxpage,htxt))
}

getMaxPage_nate <- function(url, code) {
  htxt <- read_html(url)
  maxpage <- htxt %>% html_nodes ('.paging a') %>% html_text
  
  
  while(sum(!str_detect(maxpage, " ")) == 10) {
    maxpage <- getNextMax_nate(htxt)[[1]]
    htxt <- getNextMax_nate(htxt)[[2]]
    
  }
  
  maxpage <- max(maxpage)
  return(maxpage)
}

url1 <- paste(url_base, code, sep ='', "&page=")
url_base <- 'http://news.nate.com/subsection?cate=eco03&mid=n0303&type=c&date='
all.reviews <- c()

for(code in 20170825:20170825) {
  url1 <- paste(url_base, code, sep ='', "&page=")
  maxpage <- getMaxPage_nate(url1,code)
  
  for(page in 1:maxpage) {
    url2 <- paste(url1, page, sep = '')
    htxt2 <- read_html(url2)
    comments <- htxt2 %>% html_nodes ('.postSubjectContent') %>% html_nodes('a')
    reviews <- html_text(comments)
    reviews <- str_trim(reviews)
    all.reviews <- c(all.reviews, reviews)
    all.reviews <- unique(all.reviews)
  } 
  write(all.reviews, paste("", code, sep='', "nate.txt"))
  print(paste("", code, sep='', "nate.txt"))
  txt2 <- readLines(paste("", code, sep='', "nate.txt"))
  all.reviews <- NULL
}

url_base <- 'http://realestate.daum.net/news/region/busan?&page='

for(page in 1:50) {
  url <- paste(url_base, page, sep ='')
  htxt <- read_html(url)
  comments <- htxt %>% html_nodes ('.list_partnews') %>% html_nodes('a')
  reviews <- html_text(comments)
  reviews <- str_trim(reviews)
  all.reviews <- c(all.reviews, reviews)
  all.reviews <- unique(all.reviews)
}
write(all.reviews, "daum_news.txt")
print("daum_news.txt")
txt3 <- readLines("daum_news.txt")





