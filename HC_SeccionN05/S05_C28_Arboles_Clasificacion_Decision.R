#S05_C28_Arboles_Clasificacion_Decision
#Arboles de Clasificación y Decision

library(dslabs)
library(tidyverse)
library(rvest)
library(caret)


#Cuando el resultado es categórico, nos referimos a estos métodos como árboles de clasificación o árboles de decisión.

#Usamos los mismos principios de partición, que usamos para el caso continuo, pero con algunas pequeñas diferencias para tener en cuenta el hecho de que ahora estamos trabajando con datos categóricos.

#La primera diferencia es que en lugar de tomar el promedio al final de cada nodo, ahora en las particiones, predecimos con la clase que tiene el voto mayoritario en cada nodo.

#Entonces, la clase que aparece más en un nodo, eso será lo que predecimos.

#La segunda diferencia es que ya no podemos usar la suma residual de cuadrados para decidir sobre la partición porque los resultados son categóricos.

#Bueno, podríamos usar un enfoque ingenuo, por ejemplo, buscando cuatro particiones que minimicen el error de entrenamiento.

#Los enfoques de mejor rendimiento utilizan métricas más sofisticadas.

#Dos de los más populares son el índice de Gini y la entropía.

#Definamos esos dos conceptos.

#Si definimos p hat m, k como una proporción de observaciones en la partición m que son de clase k, entonces el índice de Gini se define de la siguiente manera.

#\text{Gini}(j) = \sum_{k=1}^K\hat{p}_{j,k}(1 - \hat{p}_{j,k})

#Y la entropía se define de la siguiente manera.

#\text{entropy}(j) = - \sum_{k=1}^K\hat{p}_{j,k}log(\hat{p}_{j,k}), \text{with } 0 \times \log(0) \text{defined as } 0

#Ambas métricas buscan dividir las observaciones en subconjuntos que tienen la misma clase.

#Quieren lo que se llama pureza.

#Tenga en cuenta que de una partición, llamémosla m, solo tiene una clase, digamos que es la primera, entonces p hat de 1 para esa partición es igual a 1, mientras que todas las otras p hat son iguales a 0.

#Cuando esto sucede, tanto el índice de Gini como la entropía son 0, el valor más pequeño.

#Así que veamos un ejemplo.

#Veamos cómo funcionan los árboles de clasificación en los 2 o 7 de los ejemplos que hemos examinado en videos anteriores.

#Este es el código que escribiríamos para encajar en un árbol.

library(rpart)

data("mnist_27")

train_rpart <- train(y ~ .,
                     method = "rpart",
                     tuneGrid = data.frame(cp = seq(0.0, 0.1, len = 25)),
                     data = mnist_27$train)
plot(train_rpart)


#Luego observamos la función de parámetro de precisión versus complejidad, y podemos elegir el mejor parámetro de complejidad de este gráfico.

#Y ahora usamos ese árbol y vemos qué tan bien lo hacemos.

#Vemos que logramos una precisión de 0.82.

#Podemos usar este código.

confusionMatrix(predict(train_rpart, mnist_27$test), 
                mnist_27$test$y)$overall["Accuracy"]

#Tenga en cuenta que esto es mejor que la regresión logística, pero no tan bueno como los métodos del núcleo.

#Si trazamos la estimación de la probabilidad condicional obtenida con este árbol, nos muestra las limitaciones de los árboles de clasificación.

#Tenga en cuenta que con los árboles de decisión, el límite no se puede suavizar.

#A pesar de estas limitaciones, los árboles de clasificación tienen ciertas ventajas que los hacen muy útiles.

#Primero, son altamente interoperables, incluso más que los modelos de regresión lineal o los modelos de regresión logística.

#También son fáciles de visualizar si son lo suficientemente pequeños.

#Finalmente, a veces modelan los procesos de decisión humana.

#Por otro lado, el enfoque codicioso a través de particiones recursivas es un poco más difícil de entrenar que, por ejemplo, la regresión lineal o los vecinos más cercanos.

#Además, puede que no sea el mejor método ya que no es muy flexible y en realidad es bastante susceptible a los cambios en los datos de entrenamiento.

#Los bosques aleatorios, explicados en el siguiente video, mejoran varias de estas deficiencias.