#Ejercicio_N01_S03

library(tidyverse)
library(rvest)
library(caret)


#Cree un conjunto de datos con el siguiente código:

set.seed(1, sample.kind="Rounding") 
n <- 100
Sigma <- 9*matrix(c(1.0, 0.5, 0.5, 1.0), 2, 2)
dat <- MASS::mvrnorm(n = 100, c(69, 69), Sigma) %>%
  data.frame() %>% setNames(c("x", "y"))


#Construiremos 100 modelos lineales utilizando los datos anteriores y calcularemos la media y la desviación estándar de los modelos combinados. Primero, configure la semilla en 1 nuevamente (asegúrese de usar sample.kind = "Rounding" si su R es la versión 3.6 o posterior). Luego, dentro de un ciclo replicado.

#(1) particione el conjunto de datos en conjuntos de prueba y entrenamiento de igual tamaño usando dat$y para generar sus índices, 

#(2) entrene un modelo lineal que predice "y" desde "x", 

#(3) genere predicciones en la prueba establecer "y" 

#(4) calcular el RMSE de ese modelo. Luego, informe la media y la desviación estándar (DE) de los RMSE de los 100 modelos.

#Informe todas las respuestas a 3 dígitos significativos.

#1

test_index <- createDataPartition(dat$y, times = 1, p = 0.5, list = FALSE) #SI

train_set <- dat %>% slice(-test_index) #SI
test_set <- dat %>% slice(test_index) #SI

m <- mean(train_set$y)
# squared loss
mean((m - test_set$y)^2)

s <- sd(train_set$y)
#Perdida al cuadrado
sd((s - test_set$y))


#2

fit <- lm(y ~ x, data = train_set) #SI
fit$coefficients

#3

y_hat <- fit$coefficients[1]  + fit$coefficients[2] * test_set$x

y_hat <- predict(fit, test_set) #SI



#4

#Agregando la replica con replicate()

set.seed(1)
rmse <- replicate(100, {
  test_index <- createDataPartition(dat$y, times = 1, p = 0.5, list = FALSE)
  train_set <- dat %>% slice(-test_index)
  test_set <- dat %>% slice(test_index)
  fit <- lm(y ~ x, data = train_set)
  y_hat <- predict(fit, test_set)
  sqrt(mean((y_hat-test_set$y)^2))
})


mean(rmse)
sd(rmse)


#Ejercicio No.02

#Ahora repetiremos el ejercicio anterior pero utilizando conjuntos de datos más grandes. Escriba una función que tome un tamaño n, luego 

#(1) construya un conjunto de datos usando el código provisto en Q1 pero con n observaciones en lugar de 100 y sin set.seed (1), 

#(2) ejecuta el ciclo de réplica al que escribió responda Q1, que construye 100 modelos lineales y devuelve un vector de RMSE, y 

#(3) calcula la media y la desviación estándar. Establezca la semilla en 1 y luego use sapply o map para aplicar esta función a n <- c (100, 500, 1000, 5000, 10000).

#Sugerencia: solo necesita establecer la semilla una vez antes de ejecutar su función; no establezca una semilla dentro de su función. También asegúrese de usar sapply o map, ya que obtendrá diferentes respuestas ejecutando las simulaciones individualmente debido a la configuración de la semilla.

set.seed(1)
n <- c(100, 500, 1000, 5000, 10000)
res <- sapply(n, function(n){
  Sigma <- 9*matrix(c(1.0, 0.5, 0.5, 1.0), 2, 2)
  dat <- MASS::mvrnorm(n, c(69, 69), Sigma) %>%
    data.frame() %>% setNames(c("x", "y"))
  rmse <- replicate(100, {
    test_index <- createDataPartition(dat$y, times = 1, p = 0.5, list = FALSE)
    train_set <- dat %>% slice(-test_index)
    test_set <- dat %>% slice(test_index)
    fit <- lm(y ~ x, data = train_set)
    y_hat <- predict(fit, newdata = test_set)
    sqrt(mean((y_hat-test_set$y)^2))
  })
  c(avg = mean(rmse), sd = sd(rmse))
})

res


#Pregunta No3

#¿Qué le sucede al RMSE cuando el tamaño del conjunto de datos aumenta?

#En promedio, el RMSE no cambia mucho a medida que n aumenta, pero la variabilidad del RMSE disminuye. 


#Pregunta No. 4

#Ahora repita el ejercicio de Q1, esta vez haciendo que la correlación entre "x" y "y" sea más grande, como en el siguiente código:

set.seed(1)
n <- 100
Sigma <- 9*matrix(c(1.0, 0.95, 0.95, 1.0), 2, 2)
dat <- MASS::mvrnorm(n = 100, c(69, 69), Sigma) %>%
  data.frame() %>% setNames(c("x", "y"))



set.seed(1)
rmse <- replicate(100, {
  test_index <- createDataPartition(dat$y, times = 1, p = 0.5, list = FALSE)
  train_set <- dat %>% slice(-test_index)
  test_set <- dat %>% slice(test_index)
  fit <- lm(y ~ x, data = train_set)
  y_hat <- predict(fit, test_set)
  sqrt(mean((y_hat-test_set$y)^2))
})


mean(rmse)
sd(rmse)
  

#Ejercicio No. 5

#¿Cuál de las siguientes explica mejor por qué el RMSE en la pregunta 4 es mucho más bajo que el RMSE en la pregunta 1?

#Cuando aumentamos la correlación entre x e y, x tiene más poder predictivo y, por lo tanto, proporciona una mejor estimación de y

#Ejercicio No. 6

#Crear el siguiente data set usando este codigo:


set.seed(1)
Sigma <- matrix(c(1.0, 0.75, 0.75, 0.75, 1.0, 0.25, 0.75, 0.25, 1.0), 3, 3)
dat <- MASS::mvrnorm(n = 100, c(0, 0, 0), Sigma) %>%
  data.frame() %>% setNames(c("y", "x_1", "x_2"))


#Tenga en cuenta que y está correlacionado con x_1 y x_2, pero los dos predictores son independientes entre sí, como se ve por cor (dat).

cor(dat)

#Establezca la semilla en 1, luego use el paquete caret para dividir en un conjunto de prueba y entrenamiento del mismo tamaño. Compare el RMSE cuando use solo x_1, solo x_2 y ambos x_1 y x_2. Entrena un modelo lineal para cada uno.


set.seed(1)

rmse <- replicate(100, {
  test_index <- createDataPartition(dat$y, times = 1, p = 0.5, list = FALSE)
  train_set <- dat %>% slice(-test_index)
  test_set <- dat %>% slice(test_index)
  fit <- lm(y ~ (x_1+x_2), data = train_set)
  y_hat <- predict(fit, test_set)
  sqrt(mean((y_hat-test_set$y)^2))
})



mean(rmse)
sd(rmse)


#¿Cuál de los tres modelos funciona mejor (tiene el RMSE más bajo)?


#Ejercicio No. 07

#Informe el RMSE más bajo de los tres modelos probados en Q6.

#0.307

#Ejercicio No. 08

#Repita el ejercicio de Q6 pero ahora cree un ejemplo en el que x_1 y x_2 estén altamente correlacionadas.


set.seed(1)
Sigma <- matrix(c(1.0, 0.75, 0.75, 0.75, 1.0, 0.95, 0.75, 0.95, 1.0), 3, 3)
dat <- MASS::mvrnorm(n = 100, c(0, 0, 0), Sigma) %>%
  data.frame() %>% setNames(c("y", "x_1", "x_2"))



set.seed(1)

rmse <- replicate(100, {
  test_index <- createDataPartition(dat$y, times = 1, p = 0.5, list = FALSE)
  train_set <- dat %>% slice(-test_index)
  test_set <- dat %>% slice(test_index)
  fit <- lm(y ~ (x_1 + x_2), data = train_set)
  y_hat <- predict(fit, test_set)
  sqrt(mean((y_hat-test_set$y)^2))
})



mean(rmse)
sd(rmse)


