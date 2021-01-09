library(rvest)
library(stringr)

busqueda<-"aspiradora"

url<-paste("https://listado.mercadolibre.com.ec/", busqueda, "#D[A:",busqueda,"]",sep = "")
selector_precio<-"#root-app > div > div > section > ol > li > div > div > a > div > div.ui-search-item__group.ui-search-item__group--price > div > div > span.price-tag.ui-search-price__part > span.price-tag-fraction"
selector_moneda<-"#root-app > div > div > section > ol > li > div > div > a > div > div.ui-search-item__group.ui-search-item__group--price > div > div > span.price-tag.ui-search-price__part > span.price-tag-symbol"
selector_descripcion<-"#root-app > div > div > section > ol > li > div > div > a > div > div.ui-search-item__group.ui-search-item__group--title > h2"
selector_tabla<-"#root-app > div > div > section > ol > li > div > div > a"
  
pag_web<-read_html(url)
nodo_precio <- pag_web %>% html_nodes(selector_precio) %>% html_text()
nodo_moneda <- pag_web %>% html_nodes(selector_moneda) %>% html_text()
nodo_descripcion <- pag_web %>% html_nodes(selector_descripcion) %>% html_text()
nodo_link <- pag_web %>% html_nodes(selector_tabla) %>% html_attr("href")

busquedaDF<- data.frame(Moneda = nodo_moneda, 
                        Precio=nodo_precio, 
                        Descripcion=nodo_descripcion, 
                        Link=nodo_link, stringsAsFactors = F)

