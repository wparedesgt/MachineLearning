#Ejercicio_N06_S06_Cancer_Seno


#El conjunto de datos brca contiene información sobre muestras de biopsias para el diagnóstico de cáncer de seno para tumores que se determinaron que eran benignos (no cancerosos) y malignos (cancerosos). El objeto brca es una lista que consta de:
  
#brca$y: un vector de clasificaciones de muestra ("B" = benigno o "M" = maligno)

#brca$x: una matriz de características numéricas que describen las propiedades de la forma y el tamaño de los núcleos celulares extraídos de las imágenes del microscopio de biopsia

#Para estos ejercicios, cargue los datos configurando sus opciones y cargando las bibliotecas y los datos como se muestra en el código aquí:

options(digits = 3)
library(tidyverse)
library(matrixStats)
library(caret)
library(dslabs)
data("brca")


#IMPORTANTE: Algunos de estos ejercicios usan conjuntos de datos dslabs que se agregaron en una actualización de julio de 2019. Asegúrese de que su paquete esté actualizado con el comando update.packages ("dslabs"). También puede actualizar todos los paquetes en su sistema ejecutando update.packages () sin argumentos, y debería considerar hacerlo rutinariamente.

#Cuantas Muestras hay en el dataset

length(brca$y)
dim(brca$x)[1]

#Cuantos predictores hay en la matriz

colnames(brca$x)
dim(brca$x)[2]

#Que proporcion de muestras son malignas

table(brca$y)
mean(brca$y == "M")

#0.372

#Que columna tiene el promedio mas alto
summary(brca$x)
colnames(brca$x)

max(brca$x[,24])

which.max(colMeans(brca$x))

#Que columna posee la desviacion standar mas baja

NoSeq <- seq(1:30)

head(brca$x)

sd(brca$x[,1])
median(brca$x[,1])
mean(brca$x[,1])
max(brca$x[,1])
sd(brca$x[,1])
summary(brca$x)

CalculaSD <- function(x) {
  desviacionSD <- sd(brca$x[,x])
  desviacionSD
}


sd(brca$x[,30])


sd_mas_baja <- sapply(NoSeq, CalculaSD) %>% table()

which.min(colSds(brca$x)) #Respuesta


#Pregunta 2: escalar la matriz

#Use sweep dos veces para escalar cada columna: reste la media de l a columna, luego divida por la desviación estándar de la columna.

x <- sweep(brca$x,2,colMeans(brca$x), FUN="-")

x <- sweep(x,2,colSds(brca$x), FUN="/")

sd(x[,1])
median(x[,1])

#Después de escalar, ¿cuál es la desviación estándar de la primera columna?

#1

#Después de escalar, ¿cuál es el promedio de la primera columna?

#-0.215


#Pregunta 3: Distancia

#Calcule la distancia entre todas las muestras usando la matriz escalada.

d <- dist(x)


d[2:357]




#¿Cuál es la distancia promedio entre la primera muestra, que es benigna, y otras muestras benignas?

head(d)

mean(d[1:356]); 
mean(d[357:569])

d_samples <- dist(x)
dist_BtoB <- as.matrix(d_samples)[1, brca$y == "B"]
mean(dist_BtoB[2:length(dist_BtoB)])


#¿Cuál es la distancia promedio entre la primera muestra y las muestras malignas?

dist_BtoM <- as.matrix(d_samples)[1, brca$y == "M"]
mean(dist_BtoM)


#Pregunta 4: Mapa de calor de características

#Haga un mapa de calor de la relación entre las características usando la matriz escalada.

#¿Cuál de estos mapas de calor es correcto?


#heatmap(x, labRow = NA, labCol = NA)

d_features <- dist(t(x))

heatmap(as.matrix(d_features), labRow = NA, labCol = NA)
