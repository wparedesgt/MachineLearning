#Ejercicio_N04_S04
#Bootstrap

#La función createResample se puede usar para crear muestras de bootstrap. Por ejemplo, podemos crear 10 muestras de arranque para el conjunto de datos mnist_27 de esta manera.

library(dslabs)
library(tidyverse)
library(caret)


set.seed(1995, sample.kind = "Rounding")

indexes <- createResample(mnist_27$train$y,10)

head(indexes)

sum(indexes[[1]] == 3)
sum(indexes[[1]] == 4)
sum(indexes[[1]] == 7)

#Vemos que algunos números aparecen más de una vez y otros no aparecen ninguna vez. Esto tiene que ser así para que cada conjunto de datos sea independiente. Repita el ejercicio para todos los índices muestreados.

#¿Cuál es el número total de veces que aparece 3 en todos los índices muestreados?

x <- sapply(indexes, function(ind){
  sum(ind == 3)
})
sum(x)

#Genere un conjunto de datos aleatorio con el siguiente código:

y <- rnorm(100, 0, 1)

#Estime el 75º cuantil, que sabemos que es qnorm (0,75), con el cuantil de muestra: cuantil (y, 0,75).

#Establezca la semilla en 1 y realice una simulación de Monte Carlo con 10,000 repeticiones, generando el conjunto de datos aleatorios y estimando el 75º cuantil cada vez. ¿Cuál es el valor esperado y el error estándar del 75º cuantil?

quantile(y <- rnorm(100, 0, 1), 0.75)

set.seed(1)

B <- 10^4

M <- replicate(B, {
  X1 <- quantile(y <- rnorm(100, 0, 1), 0.75)
  median(X1)
})
median(M)
sd(M)

#En la práctica, no podemos ejecutar una simulación de Monte Carlo. Usa la muestra:

set.seed(1)
y <- rnorm(100, 0, 1)

#Establezca la semilla en 1 nuevamente después de generar y y use 10 muestras de arranque para estimar el valor esperado y el error estándar del 75º cuantil.

set.seed(1)
indexes <- createResample(y, 10)
q_75_star <- sapply(indexes, function(ind){
  y_star <- y[ind]
  quantile(y_star, 0.75)
})
mean(q_75_star)
sd(q_75_star)

#Repita el ejercicio de Q4 pero con 10,000 muestras de bootstrap en lugar de 10. Establezca la semilla en 1.


set.seed(1)
indexes <- createResample(y, 10^4)
q_75_star <- sapply(indexes, function(ind){
  y_star <- y[ind]
  quantile(y_star, 0.75)
})
mean(q_75_star)
sd(q_75_star)
