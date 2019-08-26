#S03_C02_Funciones_Prediccion
#Funciones de Predicción

#Antes de continuar con los conceptos que conectan la regresión lineal con el aprendizaje automático, describamos la función predict().

#La función predict() es muy útil para aplicaciones de aprendizaje automático.

#Esta función toma un objeto ajustado de funciones como lm o glm y un marco de datos con los nuevos predictores para los que desea predecir y devuelve una predicción.

#Entonces, en nuestro ejemplo actual, en lugar de escribir la fórmula para la línea de regresión, podemos usar la función predict() de esta manera.

#Cargar Ejemplos anteriores

library(tidyverse)
library(dslabs)
library(HistData)
library(caret)


set.seed(1983)
galton_heights <- GaltonFamilies %>%
  filter(gender == "male") %>%
  group_by(family) %>%
  sample_n(1) %>%
  ungroup() %>%
  select(father, childHeight) %>%
  rename(son = childHeight)

y <- galton_heights$son
test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)
train_set <- galton_heights %>% slice(-test_index)
test_set <- galton_heights %>% slice(test_index)

m <- mean(train_set$son)
# squared loss
mean((m - test_set$son)^2)

# fit linear regression model
fit <- lm(son ~ father, data = train_set)
fit$coef
y_hat <- fit$coef[1] + fit$coef[2]*test_set$father
mean((y_hat - test_set$son)^2)


#Podemos ver que obtenemos el mismo resultado de la pérdida al computarlo tal como lo hicimos antes.

y_hat <- predict(fit, test_set)


#Y vemos que una vez más obtenemos 4.78.

mean((y_hat - test_set$son)^2)


#Es porque usar predic es equivalente a usar la línea de regresión.

#Tenga en cuenta que predecir no siempre devuelve objetos del mismo tipo.

#Para conocer los detalles, debe buscar en el archivo de ayuda el tipo de objeto ajustado que se está utilizando.

#Entonces, si usamos lm, podríamos obtener un tipo de objeto diferente que si usamos glm.

#Para conocer los detalles, puede consultar el archivo de ayuda para predict.lm y predict.glm.

?predict.lm
?predict.glm

#Habrá otros ejemplos como este, donde la función se llama, digamos, knn.

#Luego tenemos que mirar el archivo de ayuda para predict.knn.