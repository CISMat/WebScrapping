library(rvest)
library(stringr)

busqueda<-"aspiradora"
numero_paginas = 5

#####################################################
# Se inicia la busqueda en la pagina de mercado libre
#####################################################

url<-paste("https://listado.mercadolibre.com.ec/", busqueda, "#D[A:",busqueda,"]",sep = "")
selector_precio<-"#root-app > div > div > section > ol > li > div > div > a > div > div.ui-search-item__group.ui-search-item__group--price > div > div > span.price-tag.ui-search-price__part > span.price-tag-fraction"
selector_moneda<-"#root-app > div > div > section > ol > li > div > div > a > div > div.ui-search-item__group.ui-search-item__group--price > div > div > span.price-tag.ui-search-price__part > span.price-tag-symbol"
selector_descripcion<-"#root-app > div > div > section > ol > li > div > div > a > div > div.ui-search-item__group.ui-search-item__group--title > h2"
selector_general<-"#root-app > div > div > section > ol> li > div > div > a > div"
selector_tabla<-"#root-app > div > div > section > ol > li > div > div > a"

pag_web<-read_html(url)
nodo_precio <- pag_web %>% html_nodes(selector_precio) %>% html_text()
nodo_moneda <- pag_web %>% html_nodes(selector_moneda) %>% html_text()
nodo_descripcion <- pag_web %>% html_nodes(selector_descripcion) %>% html_text()
nodo_link <- pag_web %>% html_nodes(selector_tabla) %>% html_attr("href")
nodo_costo_envio<-ifelse(grepl("Envío gratis",pag_web %>% html_nodes(selector_general) %>% html_text())==T,"Envío gratis","")
nodo_usado<-ifelse(grepl("Usado",pag_web %>% html_nodes(selector_general) %>% html_text())==T,"Usado","Nuevo")

busquedaDF<- data.frame(Moneda = nodo_moneda, 
                        Precio = nodo_precio, 
                        Descripcion = nodo_descripcion, 
                        Envío = nodo_costo_envio,
                        Usado = nodo_usado,
                        Link = nodo_link,
                        stringsAsFactors = F)

##########################################################
# Continua la busqueda en las siguientes paginas de la url
##########################################################

for( i in 2:numero_paginas){
  selector<-paste("#root-app > div > div > section > div > ul > li:nth-child(",i,") > a",sep = "")
  new_url <- pag_web %>% html_nodes(selector) %>% html_attr("href")
  next_pag_web<-read_html(new_url)
  nodo_precio <- next_pag_web %>% html_nodes(selector_precio) %>% html_text()
  nodo_moneda <- next_pag_web %>% html_nodes(selector_moneda) %>% html_text()
  nodo_descripcion <- next_pag_web %>% html_nodes(selector_descripcion) %>% html_text()
  nodo_link <- next_pag_web %>% html_nodes(selector_tabla) %>% html_attr("href")
  nodo_costo_envio<-ifelse(grepl("Envío gratis",next_pag_web %>% html_nodes(selector_general) %>% html_text())==T,"Envío gratis","")
  nodo_usado<-ifelse(grepl("Usado",next_pag_web %>% html_nodes(selector_general) %>% html_text())==T,"Usado","Nuevo")
  DF<-data.frame(Moneda = nodo_moneda, 
                 Precio = nodo_precio, 
                 Descripcion = nodo_descripcion, 
                 Envío = nodo_costo_envio,
                 Usado = nodo_usado,
                 Link = nodo_link,
                 stringsAsFactors = F)
  busquedaDF<-rbind(busquedaDF,DF)
}

###################################################
# Busqueda información por cada artículo y vendedor
###################################################

#busquedaDF$Link[2]
#detalles <- as.character(c("Marca","Volumen","Potencia"))
#detalles_busqueda<-function(url){}
