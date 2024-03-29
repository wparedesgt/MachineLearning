#Ejercicio_N02_S03

#Regresion Logistica

library(tidyverse)
library(dslabs)
library(caret)

#Definiendo el datasets

set.seed(2, sample.kind="Rounding") #if you are using R 3.6 or later
make_data <- function(n = 1000, p = 0.5, 
                      mu_0 = 0, mu_1 = 2, 
                      sigma_0 = 1,  sigma_1 = 1){
  
  y <- rbinom(n, 1, p)
  f_0 <- rnorm(n, mu_0, sigma_0)
  f_1 <- rnorm(n, mu_1, sigma_1)
  x <- ifelse(y == 1, f_1, f_0)
  
  test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)
  
  list(train = data.frame(x = x, y = as.factor(y)) %>% slice(-test_index),
       test = data.frame(x = x, y = as.factor(y)) %>% slice(test_index))
}
dat <- make_data()

class(dat)

#Tenga en cuenta que hemos definido una variable x que es predictiva de un resultado binario y:

dat$train %>% ggplot(aes(x, color = y)) + geom_density()


#Establezca la semilla en 1, luego use la función make_data definida anteriormente para generar 25 conjuntos de datos diferentes con mu_1 <- seq (0, 3, len = 25). 

#Realice una regresión logística en cada uno de los 25 conjuntos de datos diferentes (pronostique 1 si p> 0.5) y calcule la precisión (res en las figuras) vs mu_1 (delta en las figuras) ".

#¿Cuál es la trama correcta?

set.seed(1, sample.kind="Rounding")

delta <- seq(0, 3, len = 25)
res <- sapply(delta, function(d){
  dat <- make_data(mu_1 = d)
  fit_glm <- dat$train %>% glm(y ~ x, family = "binomial", data = .)
  y_hat_glm <- ifelse(predict(fit_glm, dat$test) > 0.5, 1, 0) %>% factor(levels = c(0, 1))
  mean(y_hat_glm == dat$test$y)
})

plot(delta, res)
