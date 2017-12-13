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

X.prac <- X_all[-which.min(X_all$price),]
str(X.prac)

######

X.prac_map <- X.prac %>% filter(substr(X.prac$yearMonth,1,4) >= 2016) %>%
			 group_by(dong) %>% summarise(n = n(), mean = round(mean(price), 0)) %>%
			 as.data.table()

###################################

# X.prac_map[grep("기장읍",X.prac_map$dong),]$dong <-
# 	str_sub(X.prac_map[grep("기장읍",X.prac_map$dong),]$dong,4)
# X.prac_map <- as.data.table(X.prac_map)

url <- "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&language=ko&address="

for(i in 1:nrow(X.prac_map)){
    
    post <- paste0("부산광역시", X.prac_map[i, ]$dong)
    post <- iconv(post, from = "cp949", to = "UTF-8") # win version

    if ( is.na(post) ) {
        post <- paste0("부산광역시", X.prac_map[i, ]$V5)
        post <- URLencode(post)
    }

    geocode_url = paste(url, post,sep="")

    url_query <- getURL(geocode_url)
    
    url_json <- fromJSON(paste0(url_query, collapse = ""))
    
    x_point <- url_json$results$geometry$location$lng
    y_point <- url_json$results$geometry$location$lat
    
    X.prac_map[i, x_ := x_point]
    X.prac_map[i, y_ := y_point]
    X.prac_map[i, n_ := i]
  
}

#######################################

X.prac_map_purr <- X.prac_map %>% 
	mutate(level = cut(mean, c(seq(0,50000,10000),10e+10),
			 labels = c("~ 1억", "1억 ~ 2억", "2억 ~ 3억", "3억 ~ 4억", "4억 ~ 5억","5억 ~ ")))

X.prac_map_purr$label <- 
	sapply(X.prac_map_purr$mean, function(x) {
		djr <- str_sub(round(x,-3),end=-5)
		cjsaks <- str_sub(round(x,-3),-4,-4)

		if ( djr != "" && cjsaks != "0" ) {
			paste0(djr,"억",cjsaks,"천만" )
		} else if(djr != "" & cjsaks == "0" ) {
			paste0(djr,"억")
		} else paste0(cjsaks,"천만" )
		}
	)


X.prac_map_purr_split <- split(X.prac_map_purr, X.prac_map_purr$level)


pusan_leaf <- leaflet(width = "100%") %>% addTiles()

pusan_leaf_ <- names(X.prac_map_purr_split) %>%
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
    

pusan_leaf <- pusan_leaf %>%
  addLayersControl(
    overlayGroups = names(X.prac_map_purr_split),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% addMiniMap(toggleDisplay = TRUE) %>%
	addProviderTiles(providers$OpenStreetMap)

pusan_leaf

library(htmlwidgets)
saveWidget(pusan_leaf, file="pusan2016.html")

