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

#Creando un test con los datos obtenidos dividiendolos para luego comparar la prediccion de Machine Learning 
#con la realidad de los datos


#Entrenamiento

wbcd_train <- wbcd_n[1:469, ]


#Test

wbcd_test <- wbcd_n[470:569, ]


#Excluyendo la variable diagnosis

wbcd_train_labels <- wbcd[1:469, 1]

wbcd_test_labels <- wbcd[470:569, 1]

library(class)




#Prueba de K-NN

wbcd_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k= 3)

wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test,
                      cl = wbcd_train_labels, k = 21)

library(gmodels)

#Después de cargar el paquete con el comando library (gmodels), podemos cree una tabulación cruzada que indique el 
#acuerdo entre los dos vectores.
#Especificar prop.chisq = FALSE eliminará el chi-cuadrado innecesario en los valores de la salida:

CrossTable(x = wbcd_test_labels, y = wbcd_test_pred,
           prop.chisq=FALSE)

#Para estandarizar un vector, podemos usar la función de scale() incorporada de la R, que, 
#por defecto, vuelve a escalar los valores utilizando la estandarización z-score. La función scale()
#ofrece el beneficio adicional de que se puede aplicar directamente a un marco de datos, por lo que podemos
#evitar el uso de la función lapply () Para crear una versión estandarizada de puntaje z
#Los datos wbcd, podemos usar el siguiente comando:

wbcd_z <- as.data.frame(scale(wbcd[-1]))


#Escalando todas las caracteristicas

summary(wbcd_z$area_mean)

#Dividiendo los datos

wbcd_train <- wbcd_z[1:469, ]
wbcd_test <- wbcd_z[470:569, ]
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]

#Creando una preddiccion K-NN

wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test,
                      cl = wbcd_train_labels, k = 21)

#Cruzando las tablas


CrossTable(x = wbcd_test_labels, y = wbcd_test_pred,
           prop.chisq = FALSE)

