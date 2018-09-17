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


