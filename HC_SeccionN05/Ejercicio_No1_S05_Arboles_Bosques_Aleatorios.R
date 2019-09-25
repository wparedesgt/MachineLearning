#Ejercicio_No1_S05

library(dslabs)
library(tidyverse)
library(randomForest)
library(caret)
library(rpart)


#Q1

#Cree un conjunto de datos simple donde el resultado crezca 0.75 unidades en promedio por cada aumento en un predictor, utilizando este código:


n <- 1000
sigma <- 0.25
set.seed(1) 
x <- rnorm(n, 0, 1)
y <- 0.75 * x + rnorm(n, 0, sigma)
dat <- data.frame(x = x, y = y)

dim(dat)
str(dat)
class(dat)

#¿Qué código usa correctamente rpart para ajustar un árbol de regresión y guarda el resultado para que encaje?

fit <- rpart(y ~ ., data = dat)


#Q2

#¿Cuál de los siguientes graficos tiene la misma forma de árbol obtenida en Q1?
  
plot(fit)


#Q3

#A continuación se muestra la mayor parte del código para hacer un diagrama de dispersión de "y" versus "x" junto con los valores predichos basados en el ajuste.


dat %>% 
  mutate(y_hat = predict(fit)) %>% 
  ggplot() +
  geom_point(aes(x, y)) + 
  geom_step(aes(x, y_hat), col=2)
  #BLANK

#¿Qué línea de código se debe usar para reemplazar #BLANK en el código anterior?

#Q4

#Ahora ejecute Random Forests en lugar de un árbol de regresión usando randomForest del paquete __randomForest__, y rehaga el diagrama de dispersión con la línea de predicción. Parte del código se proporciona a continuación.



dat %>% 
mutate(y_hat = predict(fit)) %>% 
ggplot() +
geom_point(aes(x, y)) +
geom_step(aes(x, y_hat), col = 2)
  
  
fit <- randomForest(y ~ x, data = dat)
  
#Q5

#Use la función de plot() para ver si el bosque aleatorio de Q4 ha convergido o si necesitamos más árboles.
  
# ¿Cuál de estos gráficos se produce al trazar el bosque aleatorio?
  
plot(fit)


#Q6

#Parece que los valores predeterminados para el Bosque aleatorio dan como resultado una estimación que es demasiado flexible (poco uniforme). Vuelva a ejecutar el Bosque aleatorio, pero esta vez con un tamaño de nodo de 50 y un máximo de 25 nodos. Rehacer la grafica.

#Parte del código se proporciona a continuación.

fit <- randomForest(y ~ x, data = dat, nodesize = 50, maxnodes = 25)

dat %>% 
mutate(y_hat = predict(fit)) %>% 
ggplot() +
geom_point(aes(x, y)) +
geom_step(aes(x, y_hat), col = 2)
