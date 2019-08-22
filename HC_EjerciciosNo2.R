#HC Ejercicio No.2 ML Comprensión

#Practicaremos la construcción de un algoritmo de aprendizaje automático utilizando un nuevo conjunto de datos, iris, que proporciona múltiples predictores para que podamos usar para entrenar. Para comenzar, eliminaremos las especies de setosa y nos enfocaremos en las especies de iris versicolor y virginica usando el siguiente código:

library(tidyverse)
library(caret)
data(iris)
iris <- iris[-which(iris$Species=='setosa'),]
y <- iris$Species

names(iris)


#Las siguientes preguntas involucran el trabajo con este conjunto de datos.

#Pregunta No. 1

#Primero, creamos una división uniforme de los datos y probemos particiones usando createDataPartition. El código con una línea que falta se da a continuación:

set.seed(2)


test <- iris[test_index,]
train <- iris[-test_index,]

#Cree el test_index

test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)

# linea de codigo
test <- iris[test_index,]
train <- iris[-test_index,]


#Pregunta No. 2


#A continuación, descubriremos la característica singular en el conjunto de datos que produce la mayor precisión general. Puede usar el código de la introducción y de Q1 para comenzar su análisis.

#Usando solo el conjunto de datos de entrenamiento del iris, para cada función, realice una búsqueda simple para encontrar el corte que produzca la mayor precisión. Utilice la función de seq() en el rango de cada función por intervalos de 0.1 para esta búsqueda

#¿Qué característica produce la mayor precisión?

foo <- function(x){
  rangedValues <- seq(range(x)[1],range(x)[2],by=0.1)
  sapply(rangedValues,function(i){
    y_hat <- ifelse(x>i,'virginica','versicolor')
    mean(y_hat==train$Species)
  })
}

predictions <- apply(train[,-5],2,foo)
sapply(predictions,max)	

#Pregunta No. 3

#Utilizando el valor de corte inteligente (smart cutoff) calculado en los datos de entrenamiento de Q2, ¿cuál es la precisión general en los datos de prueba?

y_hat <- sample(c('virginica', 'versicolor'), 
                length(test), replace = TRUE) %>%
  factor(levels(test$Species))




#La precisión general se define simplemente como la proporción general que se predice correctamente sin smart cutoff.


mean(y_hat == test$Species)


iris %>% group_by(Species) %>%
  summarize(mean(Petal.Length), sd(Petal.Length))


cutoff <- seq(4.6, 5.3, 0.5)

accuracy <- map_dbl(cutoff, function(x) {
  y_hat <- ifelse(train$Petal.Length > x, 'virginica', 'versicolor') %>% 
    factor(levels = levels(test$Species))
  mean(y_hat == train$Species)
} )

max(accuracy) #Respuesta Correcta

best_cutoff <- cutoff[which.max(accuracy)]

best_cutoff


y_hat <- ifelse(train$Petal.Length > best_cutoff, 'virginica', 'versicolor') %>% factor(levels(train$Species))

#Respuesta Correcta

mean(y_hat == train$Species)



#Pregunta No. 4
Q4

#Tenga en cuenta que tuvimos una precisión general superior al 96% en los datos de entrenamiento, pero la precisión general fue menor en los datos de prueba. Esto puede suceder a menudo si sobreentrenamos. De hecho, podría darse el caso de que una sola característica no sea la mejor opción. Por ejemplo, una combinación de características podría ser óptima. El uso de una sola función y la optimización del corte como lo hicimos con nuestros datos de capacitación puede llevar a un sobreajuste.

#Dado que conocemos los datos de prueba, podemos tratarlos como si hiciéramos nuestros datos de entrenamiento para ver si la misma característica con un límite diferente optimizará nuestras predicciones.

#¿Qué característica optimiza mejor nuestra precisión general?


#respuesta

#train$Petal.Width


#Pregunta No. 5

#Ahora realizaremos un análisis exploratorio de los datos.

plot(iris,pch=21,bg=iris$Species)

#Tenga en cuenta que Petal.Length y Petal.Width en combinación podrían dar potencialmente más información que cualquiera de las dos características por sí solas.


#Optimice los puntos de corte para Petal.Length y Petal.Width por separado en el conjunto de datos de entranamiento (train) mediante el uso de la función seq() con incrementos de 0.1. Luego, informe la precisión general cuando se aplique al conjunto de datos 'test' creando una regla que predice virginica si Petal.Length es mayor que el corte de longitud O Petal.Width es mayor que el corte de ancho, y versicolor de lo contrario.


#Optimizar en Train probar en test con funcion seq().

petalLengthRange <- seq(range(train$Petal.Length)[1],range(train$Petal.Length)[2],by=0.1)

petalWidthRange <- seq(range(train$Petal.Width)[1],range(train$Petal.Width)[2],by=0.1)

length_predictions <- sapply(petalLengthRange,function(i){
  y_hat <- ifelse(train$Petal.Length>i,'virginica','versicolor')
  mean(y_hat==train$Species)
})

length_cutoff <- petalLengthRange[which.max(length_predictions)] # 4.7

width_predictions <- sapply(petalWidthRange,function(i){
  y_hat <- ifelse(train$Petal.Width>i,'virginica','versicolor')
  mean(y_hat==train$Species)
})

width_cutoff <- petalWidthRange[which.max(width_predictions)] # 1.5

y_hat <- ifelse(test$Petal.Length>length_cutoff | test$Petal.Width>width_cutoff,'virginica','versicolor')

mean(y_hat==test$Species)

