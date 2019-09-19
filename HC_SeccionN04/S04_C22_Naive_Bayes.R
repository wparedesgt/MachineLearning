#S04_C22_Naive_Bayes
#Naive Bayes

library(dslabs)
library(tidyverse)
library(caret)
library(purrr)
library(gridExtra)


#Regla Bayes

#p(x) = Pr(Y = 1|X = x) = \frac{f_{X|Y=1}(X)Pr(Y = 1)}{f_{X|Y=0}(X)Pr(Y = 0) + f_{X|Y=1}(X)Pr(Y = 1)}

#Comencemos con un ejemplo muy simple y poco interesante, pero ilustrativo.

#Predecir sexo a partir del ejemplo de altura.

#Podemos obtener los datos y generar entrenamiento y pruebas con este código.

data("heights")
y<- heights$height

set.seed(2)

test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)

train_set <- heights %>% slice(-test_index)
test_set <- heights %>% slice(test_index)


#En este ejemplo, el ingenuo enfoque de Bayes es particularmente apropiado.

#Porque sabemos que la distribución normal es una muy buena aproximación de las distribuciones condicionales de altura dado el sexo para ambas clases, mujeres y hombres.

#Esto implica que podemos aproximar las distribuciones condicionales simplemente estimando promedios y desviaciones estándar de los datos con este simple código, como este.

params <- train_set %>% 
  group_by(sex) %>% 
  summarize(avg = mean(height), sd = sd(height))

params


#La prevalencia, que denotaremos con pi, que es igual a la probabilidad de y es igual a 1, puede estimarse a partir de los datos de esta manera.

#Pi = Pr(Y=1)

pi <- train_set %>% 
  summarize(pi = mean(sex == "Female")) %>%
  .$pi

pi

#Básicamente calculamos la proporción de mujeres.

#Ahora podemos usar nuestras estimaciones de desviaciones promedio y estándar para obtener la regla real.

#Obtenemos las distribuciones condicionales, f0 y f1, y luego usamos el teorema de Bayes para calcular la estimación ingenua de Bayes de la probabilidad condicional.

x <- test_set$height

f0 <- dnorm(x, params$avg[2], params$sd[2])
f1 <- dnorm(x, params$avg[1], params$sd[1])

p_hat_bayes <- f1*pi / (f1*pi + f0*(1-pi))

#Esta estimación de la probabilidad condicional se parece mucho a una estimación de regresión logística, como podemos ver en este gráfico.


#De hecho, podemos mostrar matemáticamente que el enfoque ingenuo de Bayes es similar al enfoque de regresión logística en este caso particular.

#Pero no vamos a mostrar esa derivación aquí.