#install.packages('data.table')
#install.packages('dplyr')
#install.packages("XML")
#install.packages("stringr")
#install.packages("ggplot2")
#install.packages("leaflet")
#install.packages("jsonlite")
#install.packages('RCurl')
#install.packages('purrr')
#install.packages('viridis')
#install.packages('DT')
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
X_all <- fread("E:/00.니집내집/90.데이터수집/01.실거래가/all.csv")
X_all <- X_all[-which.min(X_all$거래금액),]
X.prac <- data.table(cbind(X_all$거래금액,X_all$건축년도,substr(X_all$계약년월,1,4),X_all$도로명,X_all$동,X_all$단지명,substr(X_all$계약년월,5,6),X_all$계약일,X_all$전용면적,X_all$번지))
X.prac$V1 <- as.numeric(X.prac$V1)
str(X.prac)

######

X.prac_map <- X.prac %>% filter(V3 >= 2016) %>% group_by(V5) %>% summarise(n = n(), mean = round(mean(V1), 0))
X.prac_map <- as.data.table(X.prac_map)

###################################

X.prac_map[grep("기장읍",X.prac_map$V5),]$V5 <- 
	str_sub(X.prac_map[grep("기장읍",X.prac_map$V5),]$V5,4)
X.prac_map <- as.data.table(X.prac_map)

url <- "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&language=ko&address="

for(i in 1:nrow(X.prac_map)){
    
    post <- paste0("부산광역시", X.prac_map[i, ]$V5)
    post <- iconv(post, from = "cp949", to = "UTF-8") # win version

    if ( is.na(post) ) {
        post <- paste0("부산광역시", X.prac_map[i, ]$V5)
        post <- URLencode(post)
    }

    geocode_url = paste(url, post,sep="")

    url_query <- getURL(geocode_url)
    
    url_json <- fromJSON(paste0(url_query, collapse = ""))
    
    x_point <- url_json$results$geometry$location[2]
    y_point <- url_json$results$geometry$location[1]
    
    X.prac_map[i, x_ := x_point]
    X.prac_map[i, y_ := y_point]
    X.prac_map[i, n_ := i]
  
}


#########################################

DT::datatable(X.prac_map)

#######################################

X.prac_map_purr <- X.prac_map %>% 
	mutate(level = cut(mean, c(0, 50000, 100000), labels = c("~ 5억", "5억 ~ 10억")))


X.prac_map_purr_split <- split(X.prac_map_purr, X.prac_map_purr$level)

pusan_leaf <- leaflet(width = "100%") %>% addTiles()

pusan_leaf_ <- names(X.prac_map_purr_split) %>%
    walk( function(df) {
        pusan_leaf <<- pusan_leaf %>%
            addMarkers(data = X.prac_map_purr_split[[df]],
                       lng = ~x_, lat = ~y_,
                       popup = ~as.character(V5),
                       label = ~as.character(mean),
                       labelOptions = labelOptions(noHide = T, textsize = "15px", direction  =  'auto'),
                       group  =  df,
                       clusterOptions  =  markerClusterOptions(removeOutsideVisibleBounds  =  F))
        })
    

pusan_leaf <- pusan_leaf %>%
  addLayersControl(
    overlayGroups = names(X.prac_map_purr_split),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% addMiniMap(toggleDisplay = TRUE) %>%
	addProviderTiles(providers$OpenStreetMap)

pusan_leaf

library(htmlwidgets)
saveWidget(pusan_leaf, file="pusan2016.html")

