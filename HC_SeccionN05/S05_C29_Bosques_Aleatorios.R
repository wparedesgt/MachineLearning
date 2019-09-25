#S05_C29_Bosques_Aleatorios
#Bosques Aleatorios


library(dslabs)
library(tidyverse)
library(caret)
library(rpart)
library(randomForest)


#Los bosques aleatorios son un enfoque muy popular que aborda las deficiencias de los árboles de decisión utilizando una idea inteligente.

#El objetivo es mejorar el rendimiento de la predicción y reducir la inestabilidad promediando múltiples árboles de decisión, un bosque de árboles construido con aleatoriedad.

#Tiene dos características que ayudan a lograr esto.

#La primera característica se denomina agregación bootstrap o embolsado.

#El esquema general para el embolsado es el siguiente.

#Primero, construimos muchos árboles de decisión, T1 a TB, usando el conjunto de entrenamiento.

#Más tarde explicamos cómo estamos seguros de que son diferentes.

#Segundo, para cada observación j en el conjunto de prueba, formamos una predicción y hat j usando el árbol Tj.

#Ahora, para obtener una predicción final, combinamos las predicciones para cada árbol de dos maneras diferentes, una para resultados continuos y otra para resultados categóricos.

#Para resultados continuos, simplemente tomamos el promedio de los y hat j's.

#Para datos categóricos, predecimos y con un voto mayoritario.

#La clase que aparece más en todos los árboles es la que predecimos.

#Bien, ahora, pero ¿cómo obtenemos muchos árboles de decisión de un solo conjunto de entrenamiento?

#Para esto, usamos el bootstrap.

#Entonces, para crear, digamos, árboles de arranque B, hacemos lo siguiente.

#Para crear el árbol Tj a partir de un conjunto de entrenamiento de tamaño N, creamos un conjunto de entrenamiento de arranque mediante el muestreo de N observaciones de este conjunto de entrenamiento con reemplazo.

#Ahora construimos un árbol de decisión para cada uno de estos conjuntos de entrenamiento de arranque.

#Y luego aplicamos el algoritmo que acabamos de describir para obtener una predicción final.

#Aquí está el código para aplicar un bosque aleatorio a los datos de las encuestas de 2008.

#Es bastante simple.

#Lo hacemos así.

fit <- randomForest(margin ~ . , data = polls_2008)


#Podemos ver que el algoritmo mejora a medida que agregamos más árboles.

#Si traza el objeto que sale de esta función de esta manera, obtenemos un diagrama del error frente al número de árboles que se han creado.

plot(fit)

#En este caso, vemos que cuando llegamos a unos 200 árboles, el algoritmo no está cambiando mucho.


#Pero tenga en cuenta que para problemas más complejos requerirá más árboles para que el algoritmo converja.

#Aquí está el resultado final para los datos de las encuestas de 2008.

polls_2008 %>%
  mutate(y_hat = predict(fit, newdata = polls_2008)) %>% 
  ggplot() +
  geom_point(aes(day, margin)) +
  geom_line(aes(day, y_hat), col="red")


#Tenga en cuenta que el resultado final es algo suave.

#No es una función escalonada como los árboles individuales.

#El promedio es lo que permite estimaciones que no son funciones escalonadas.

#Para ver esto, hemos generado una animación para ayudar a ilustrar el procedimiento.

#En la figura animada, ves cada uno de los 50 árboles, B es igual a 1 hasta 50.

#Cada uno es una muestra de bootstrap que aparece en orden.

#Para cada una de las muestras de bootstrap, vemos el árbol que se ajusta a esa muestra de bootstrap.

#Y luego, en azul, vemos el resultado de embolsar los árboles hasta ese punto.

#Para que pueda ver la línea azul cambiando con el tiempo.

#Ahora veamos otro ejemplo.

#Ajustemos un bosque aleatorio a nuestro ejemplo de dos o siete dígitos.

#El código se vería así.

train_rf <- randomForest(y ~ ., data = mnist_27$train)

confusionMatrix(predict(train_rf, mnist_27$test), 
                mnist_27$test$y)$overall["Accuracy"]


#Y así es como se ven las probabilidades condicionales.

#Tenga en cuenta que ahora tenemos mucha más flexibilidad que un solo árbol.

#Este bosque aleatorio particular es un poco demasiado ondulado.

#Queremos algo más suave.

#Sin embargo, tenga en cuenta que no hemos optimizado los parámetros de ninguna manera.

#Así que usemos el paquete caret para hacer esto.

#Podemos hacerlo usando este código.

train_rf_2 <- train(y ~ .,
                    method = "Rborist",
                    tuneGrid = data.frame(predFixed = 2, minNode = c(3, 50)),
                    data = mnist_27$train)



#Aquí vamos a usar un algoritmo de bosque aleatorio diferente, Rborist, que es un poco más rápido.

#Y aquí está el resultado final. También vemos que nuestra precisión ha mejorado mucho.

confusionMatrix(predict(train_rf_2, mnist_27$test), mnist_27$test$y)$overall["Accuracy"]

#Por lo tanto, podemos controlar la suavidad de la estimación aleatoria del bosque de varias maneras.

#Una es limitar el tamaño de cada nodo.

#Podemos requerir que el número de puntos por nodo sea mayor.

#Una segunda característica del bosque aleatorio que aún no hemos descrito es que podemos usar una selección aleatoria de características para las divisiones.

#Específicamente, al construir cada árbol en cada partición recursiva, solo consideramos un subconjunto de predictores seleccionados al azar para verificar la mejor división.

#Y cada árbol tiene una selección aleatoria diferente de características.

#Esto reduce la correlación entre los árboles en los bosques, lo que a su vez mejora la precisión de la predicción.

#El argumento para este parámetro de ajuste en la función de bosque aleatorio es mtry.

#Pero cada implementación de bosque aleatorio tiene un nombre diferente.

#Puede mirar el archivo de ayuda para averiguar cuál.

#Una desventaja del bosque aleatorio es que perdemos la interpretabilidad.

#Estamos promediando cientos o miles de árboles.

#Sin embargo, hay una medida llamada importancia variable que nos ayuda a interpretar los resultados.

#La importancia variable básicamente nos dice cuánto influye cada predictor en las predicciones finales.

#Veremos un ejemplo más tarde.