#Ejercicio_N04_S03

#¿Qué línea de código crea correctamente una matriz de 100 por 10 de números normales generados aleatoriamente y la asigna a x?

x <- matrix(rnorm(100*10), 100, 10)

x


#Escriba la línea de código que le daría la información especificada sobre la matriz x que generó en q1. No incluya espacios en su línea de código.

dim(x)
nrow(x)
ncol(x)

#¿Cuál de las siguientes líneas de código agregaría el escalar 1 a la fila 1, el escalar 2 a la fila 2, y así sucesivamente, para la matriz x?

x <- x + seq(nrow(x))

x <- sweep(x, 1, 1:nrow(x),"+")



#¿Cuál de las siguientes líneas de código agregaría el escalar 1 a la columna 1, el escalar 2 a la columna 2, y así sucesivamente, para la matriz x?

x <- sweep(x, 2, 1:ncol(x), FUN = "+") correcto


#¿Qué código calcula correctamente el promedio de cada fila de x?

rowMeans(x)


#¿Qué código calcula correctamente el promedio de cada columna de x?

colMeans(x)
  

#Para cada observación en los datos de entrenamiento mnist, calcule la proporción de píxeles que están en el área gris, definida como valores entre 50 y 205. (Para visualizar esto, puede hacer un diagrama de caja por clase de dígito).

#¿Qué proporción de los 60000 * 784 píxeles en los datos de entrenamiento mnist están en el área gris en general, definida como valores entre 50 y 205?


library(tidyverse)
library(dslabs)
if(!exists("mnist")) mnist <- read_mnist()

y <- rowMeans(mnist$train$images>50 & mnist$train$images<205)
qplot(as.factor(mnist$train$labels), y, geom = "boxplot")

mean(y)
