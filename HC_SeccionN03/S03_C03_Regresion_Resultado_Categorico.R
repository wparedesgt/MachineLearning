#S03_C03_Regresión_para_un_resultado_categórico
#Regresion para un resultado categorico

library(tidyverse)
library(caret)
library(dslabs)
#Continuemos con la regresión.

#El enfoque de regresión también se puede aplicar a datos categóricos.

#Para ilustrar esto, lo aplicaremos a nuestro ejemplo anterior de predicción de sexo, masculino o femenino, usando alturas.

data("heights")

y <- heights$height
set.seed(2, sample.kind = "Rounding")

test_index <- createDataPartition(y, times = 1, p= 0.5, list = FALSE)
train_set <- heights %>% slice(-test_index)
test_set <- heights %>% slice(test_index)

#Si definimos el resultado "Y" como 1 para las mujeres o 0 para los hombres y "X" como la altura, en este caso, estamos interesados en la probabilidad condicional de ser mujer dada la altura.

#Y = 1 para Mujeres
#Y = 0 para Hombres
#X para Altura

#Pr(Y = 1|X = x)

#Como ejemplo, proporcionemos una predicción para un estudiante que mide 66 pulgadas de alto.

#¿Cuál es la condición de ser mujer si tienes 66 pulgadas de alto?

#En nuestro conjunto de datos, podemos estimar esto redondeando a la pulgada más cercana y calcular el promedio de estos valores.


#Puede hacerlo usando este código, y encuentra que la probabilidad condicional es del 24%.

train_set %>% 
  filter(round(height) == 66) %>% 
  summarise(mean(sex == "Female"))


#Veamos cómo se ve para varios valores de X.

#Repetiremos el mismo ejercicio pero durante 60 pulgadas, 61 pulgadas, etc.

#Tenga en cuenta que estamos eliminando valores X para los que tenemos muy pocos puntos de datos.

#Y si hacemos esto, obtenemos los siguientes resultados.

heights %>% 
  mutate(x = round(height)) %>%
  group_by(x) %>%
  filter(n() >= 10) %>%
  summarize(prop = mean(sex == "Female")) %>%
  ggplot(aes(x, prop)) +
  geom_point()

#Dado que los resultados de este gráfico parecen ser lineales, y es el único enfoque que conocemos actualmente, intentaremos la regresión.

#Suponemos que la probabilidad condicional de que Y sea igual a 1 dado X es una intersección de línea más la pendiente por la altura.

#Si convertimos los factores a 0s y 1s, podemos estimar beta 0 y beta 1 con mínimos cuadrados utilizando este fragmento de código.

lm_fit <- mutate(train_set, y = as.numeric(sex == "Female")) %>% lm(y ~ height, data = .)

#Una vez que tenemos las estimaciones, podemos obtener una predicción real.

#Nuestra estimación de la probabilidad condicional será beta 0 hat más beta 1 hat multiplicada por x.

#Para formar una predicción, definimos una regla de decisión.

#Predecimos mujeres si la probabilidad condicional es mayor al 50%.

#Ahora podemos usar la función de matriz de confusión para ver cómo lo hicimos.

p_hat <- predict(lm_fit, test_set)
y_hat <- ifelse(p_hat > 0.5, "Female", "Male") %>% factor()

confusionMatrix(y_hat, test_set$sex)$overall["Accuracy"]

#Vemos que tenemos una precisión del 78.5%.