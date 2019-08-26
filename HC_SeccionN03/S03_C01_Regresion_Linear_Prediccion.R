#S03_C01_Regresion_Linear_Prediccion
#Regresión Linear Para Predicción

#La regresión lineal puede considerarse un algoritmo de aprendizaje automático.

#Como verá, es demasiado rígido para ser útil en general, pero para algunos desafíos funciona bastante bien.

#También sirve como un enfoque de referencia.

#Si no puede vencerlo con un enfoque más complejo, probablemente quiera apegarse a la regresión lineal.

#Para establecer rápidamente la conexión entre la regresión y el aprendizaje automático, reformularemos el estudio de Galten con alturas como resultado continuo.

#Vamos a cargarlo usando este código.

library(tidyverse)
library(dslabs)
library(HistData)
library(caret)

set.seed(1983)

galton_heights <- GaltonFamilies %>%
  filter(childNum == 1 & gender == "male") %>%
  select(father, childHeight) %>%
  rename(son = childHeight)


str(galton_heights)
class(galton_heights)
summary(galton_heights)

#Suponga que tiene la tarea de construir un algoritmo de aprendizaje automático que prediga la altura "Y" del hijo usando la altura "X" del padre.

#Comencemos generando algunas pruebas y conjuntos de entrenamiento usando este código.

y <- galton_heights$son

test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)

train_set <- galton_heights %>% slice(-test_index)
test_set <- galton_heights %>% slice(test_index)


#En este caso, si ignoramos la altura del padre y adivinamos la altura del hijo, adivinaríamos la altura promedio de su hijo.

#Entonces, nuestra predicción sería el promedio, que podemos obtener de esta manera.

avg <- mean(train_set$son)

avg

#La pérdida al cuadrado R es de aproximadamente 6.60, que puede ver escribiendo este código.

mean((avg - test_set$son)^2)

#¿Ahora podemos hacerlo mejor?
  
#En el curso de regresión, aprendimos que si un par "X Y" sigue una distribución normal bivariada, como lo hacen las alturas del hijo y del padre, la expectativa condicional que es lo que queremos estimar en el aprendizaje automático es equivalente a la línea de regresión.

#f(x) = E(Y|X = x) = Bo + B1x


#También introdujimos los mínimos cuadrados como método para estimar la pendiente y la intersección.

#Podemos escribir este código para obtener rápidamente ese modelo ajustado.

fit <- lm(son ~ father, data = train_set)

fit$coefficients

#Esto nos da una estimación de la expectativa condicional, que es una fórmula simple.

#Son 38, más 0.47x.

#f^(x) = 38 + 0.47x


#Podemos ver que esto de hecho proporciona una mejora sobre nuestro enfoque de adivinanzas que nos dio una pérdida de 6.6.

#Ahora tenemos una pérdida de 4.78, un poco más baja.

y_hat <- fit$coefficients[1] + fit$coefficients[2] * test_set$father

mean((y_hat - test_set$son)^2)
