#Nearest Neighbors

#dist funcion

library(tidyverse)


wbcd <- read.csv("data/wisc_bc_data.csv", stringsAsFactors = FALSE)

#Eliminando el ID

wbcd$id <- NULL

#ver los diagnosticos

table(wbcd$diagnosis)

#agregando un factor y niveles

wbcd$diagnosis <- factor(wbcd$diagnosis, levels = c("B", "M"), 
                                                  labels = c("Benign", "Malignant"))

#Redondeando en porcentaje

round(prop.table(table(wbcd$diagnosis)) * 100, digits = 1)

#Sumatoria del dataframe

summary(wbcd[c("radius_mean", "area_mean", "smoothness_mean")])

#Transformando y normalizando datos numericos

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

#pruebas

normalize(c(1, 2, 3, 4, 5))
normalize(c(10, 20, 30, 40, 50))

library(purrr)


#Normalizando la columna

wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))


#Validando la informacion

summary(wbcd_n$area_mean)


