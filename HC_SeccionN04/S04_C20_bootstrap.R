#S04_C20_bootstrap
#Bootstrap

library(dslabs)
library(tidyverse)
library(caret)
library(purrr)
library(gridExtra)

#En está modulo describimos el bootstrap.

#Vamos a usar un ejemplo muy simple para hacerlo.

#Suponga que la distribución del ingreso de una población es la siguiente.

n <- 10^6
income <- 10^(rnorm(n, log10(45000), log10(3)))
qplot(log10(income), bins = 30, color = I("black"))

#La mediana de la población es, en este caso, de aproximadamente 45,000.

m <- median(income)
m

#Supongamos que no tenemos acceso a toda la población, pero queremos estimar la mediana, llamémosla M. Tomamos una muestra de 250 y estimamos la mediana de la población, M, con la muestra mediana grande M, como esta.

set.seed(1995, sample.kind = "Rounding")

N <- 250
X <- sample(income, N)
M<- median(X)
M

#Ahora, ¿podemos construir un intervalo de confianza?
  
#¿Cuál es la distribución de la mediana muestral?
  
#De una simulación de Monte Carlo, vemos que la distribución de la mediana de la muestra es aproximadamente normal con el siguiente valor esperado y los errores estándar.

B <- 10^4

M <- replicate(B, {
  X <- sample(income, N)
  median(X)
})


#puedes verlo aqui.

p1 <- qplot(M, bins = 30, color = I("black"))
p2 <- qplot(sample = scale(M)) + geom_abline()
grid.arrange(p1, p2, ncol = 2)

mean(M)
sd(M)

#El problema aquí es que, como hemos descrito antes, en la práctica, no tenemos acceso a la distribución.

#En el pasado, hemos usado el teorema del límite central, pero el teorema del límite central que estudiamos se aplica a los promedios y aquí estamos interesados en la mediana.

#El bootstrap nos permite aproximar una simulación de Monte Carlo sin acceso a toda la distribución.

#La idea general es relativamente simple.

#Actuamos como si la muestra fuera la población completa y la muestra con conjuntos de datos de reemplazo del mismo tamaño.

#Luego calculamos la estadística de resumen, en este caso, la mediana, en lo que se llama la muestra de bootstrap.
#Ahora podemos comprobar qué tan cerca está de la distribución real.

#Podemos ver que está relativamente cerca.

  
#Hay una teoría que nos dice que la distribución de la estadística obtenida con muestras de bootstrap se aproxima a la distribución de nuestra estadística real.

#Así es como construimos muestras de bootstrap en una distribución aproximada.

#Este simple código.

B <- 10^4
M_star <- replicate(B, {
  X_star <- sample(X, N, replace = TRUE)
  median(X_star)
})

#Ahora podemos comprobar qué tan cerca está de la distribución real.

tibble(monte_carlo = sort(M), bootstrap = sort(M_star)) %>%
  qplot(monte_carlo, bootstrap, data = .) + 
  geom_abline()


#Podemos ver que está relativamente cerca.

quantile(M, c(0.05, 0.95))
quantile(M_star, c(0.05, 0.95))

#Vemos que no es perfecto, pero proporciona una aproximación decente.

#En particular, observe las cantidades que necesitamos para formar un intervalo de confianza del 95%.

#Están bastante cerca.

#Esto es mucho mejor de lo que obtenemos si utilizamos sin pensar el teorema del límite central, que nos daría este intervalo de confianza, que es completamente incorrecto.

median(X) + 1.96 * sd(X) / sqrt(N) * c(-1, 1)


#Si sabemos que la distribución es normal, podemos usar un bootstrap para estimar la media, el error estándar, y luego formar un intervalo de confianza de esa manera.

mean(M) + 1.96 * sd(M) * c(-1,1)
mean(M_star) + 1.96 * sd(M_star) * c(-1, 1)

