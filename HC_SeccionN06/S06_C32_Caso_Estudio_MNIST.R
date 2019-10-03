#S06_C32_Caso_Estudio_MNIST
#Caso de estudio MNIST


library(dslabs)
library(tidyverse)
library(rpart)
library(caret)
library(purrr)
library(randomForest)


#Hemos aprendido varios algoritmos de aprendizaje automático y hemos demostrado cómo usarlos con ejemplos ilustrativos.

#Pero ahora vamos a probarlos con un ejemplo real.

#Este es un conjunto de datos popular utilizado en competiciones de aprendizaje automático llamado dígitos MNIST.

#Podemos cargar los datos usando el siguiente paquete dslabs, como este.

mnist <- read_mnist()

#El conjunto de datos incluye dos componentes, un conjunto de entrenamiento y un conjunto de prueba.

#Puedes ver eso escribiendo esto.

names(mnist)

#Cada uno de estos componentes incluye una matriz con características en las columnas.

#Puede acceder a ellos usando un código como este.

dim(mnist$train$images)

#También incluye un vector con las clases como enteros.

#Puedes ver eso usando este código

class(mnist$train$labels)

table(mnist$train$labels)

#Como queremos que este ejemplo se ejecute en una computadora portátil pequeña y en menos de una hora, consideraremos un subconjunto del conjunto de datos.

#Tomaremos muestras de 10,000 filas aleatorias del conjunto de entrenamiento y 1,000 filas aleatorias del conjunto de prueba.

# sample 10k rows from training set, 1k rows from test set

set.seed(123)
index <- sample(nrow(mnist$train$images), 10000)
x <- mnist$train$images[index,]
y <- factor(mnist$train$labels[index])

index <- sample(nrow(mnist$test$images), 1000)
x_test <- mnist$test$images[index,]
y_test <- factor(mnist$test$labels[index])

