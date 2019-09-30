#Presicion equilibrada y punctuacion F1

#Datos anteriores

library(tidyverse)
library(caret)
library(dslabs)
library(e1071)
data("heights")

y <- heights$sex
x <- heights$height

set.seed(2)
test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)

train_set <- heights[-test_index,]
test_set <- heights[test_index,]


y_hat <- sample(c("Male", "Female"),
                length(test_index), replace = TRUE) %>% 
  factor(levels(test_set$sex))

y_hat <- ifelse(x > 62, "Male", "Female") %>% 
  factor(levels = levels(test_set$sex))

cutoff <- seq(61,70)
accuracy <- map_dbl(cutoff, function(x) {
  y_hat <- ifelse(train_set$height > x, "Male", "Female") %>% 
    factor(levels = levels(test_set$sex))
  mean(y_hat == train_set$sex)
} )

best_cutoff <- cutoff[which.max(accuracy)]

best_cutoff

y_hat <- ifelse(test_set$height > best_cutoff, "Male", "Female") %>% 
  factor(levels = levels(test_set$sex)) 

y_hat <- factor(y_hat)

mean(y_hat == test_set$sex)


#Veamos otra métrica.

#Aunque en general recomendamos estudiar tanto la especificidad como la sensibilidad, a menudo es útil tener un resumen de un solo número, por ejemplo, para fines de optimización.

#Una métrica que se prefiere sobre la precisión general es el promedio de especificidad y sensibilidad, conocido como la precisión equilibrada.

#"Balance Accurancy"


#Debido a que la especificidad y la sensibilidad aumentan, es más apropiado calcular el promedio armónico de especificidad y sensibilidad de esta manera.


#F1 - SCORE

# 1 / 1/2(1/recall + 1 / precision)



#De hecho, la puntuación de F1, un resumen de un número ampliamente utilizado, es el promedio armónico de precisión y recuperación.

#Debido a que es fácil de escribir, a menudo se ve este promedio armónico escrito de esta manera.

# 2 precision * recall / precision + recall

#Todo bien.

#Vamos a discutir algunas otras consideraciones.

#Tenga en cuenta que, según el contexto, algunos tipos de errores son más costosos que otros.

#Por ejemplo, en el caso de la seguridad del avión, es mucho más importante maximizar la sensibilidad sobre la especificidad.

#No predecir que un avión funcionará mal antes de que se caiga es un error mucho más costoso que poner a tierra un avión cuando, de hecho, el avión está en perfectas condiciones.

#En un caso criminal de asesinato capital, lo contrario es cierto, ya que un falso positivo puede llevar a matar a una persona inocente.

#El puntaje de F1 se puede adoptar para sopesar la especificidad y la sensibilidad de manera diferente.

#Para hacer esto, definimos "beta" para representar cuánto más importante es la sensibilidad en comparación con la especificidad, y consideramos un promedio armónico ponderado utilizando esta fórmula.

# 1 / B2/1+B2 * 1/recall +  1/1+B2 * 1/presicion

#La función F_meas en el paquete caret calcula el resumen con beta por defecto a uno.

#Así que vamos a reconstruir nuestro algoritmo de predicción, pero esta vez maximizando la puntuación F en lugar de la precisión general.

#Podemos hacerlo simplemente editando el código y usando esto en su lugar.

cutoff <- seq(61,70)
F_1 <- map_dbl(cutoff, function(x) {
  y_hat <- ifelse(train_set$height > x, "Male", "Female") %>%
    factor(levels = levels(test_set$sex))
  F_meas(data = y_hat, reference = factor(train_set$sex))
})


#Como antes, podemos trazar la medida F1 contra los diferentes puntos de corte.

#Y vemos que se maximiza al 61% cuando usamos un corte de 66 pulgadas.
max(F_1)

best_cutoff <- cutoff[which.max(F_1)]
best_cutoff

#Un corte de 66 pulgadas tiene mucho más sentido que 64.

y_hat <- ifelse(test_set$height > best_cutoff, "Male", "Female") %>%
  factor(levels = levels(test_set$sex))

#Además, equilibra la especificidad y la sensibilidad de nuestra matriz de confusión como se ve aquí.

confusionMatrix(data = y_hat, reference = test_set$sex)

#Ahora vemos que lo hacemos mucho mejor que adivinar, y que tanto la sensibilidad como la especificidad son relativamente altas.

#Hemos construido nuestro primer algoritmo de aprendizaje automático.

#Toma la altura como un predictor, y predice a la mujer si tiene 66 pulgadas o menos.