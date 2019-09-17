#S04_C18_Overtraining_Oversmoothing
#Sobreentrenamiento y exceso de suavizado


library(tidyverse)
library(dslabs)
library(caret)
library(purrr)

knn_fit <- knn3(y ~ .,data = mnist_27$train, k = 5)



#Ahora para ver por qué mejoramos la regresión logística en este caso de que solo tenemos dos predictores, podemos hacer algunas visualizaciones.

#Aquí está la verdadera probabilidad condicional a la izquierda.

#Y a la derecha, puede ver la estimación que obtuvimos con knn con cinco vecinos.

#Entonces ves que la estimación tiene la esencia de la forma de la probabilidad condicional verdadera.

#Por lo tanto, hacemos mejor que la regresión logística.

#Sin embargo, probablemente podamos hacerlo mejor.

#Porque si nos fijamos bien, esta estimación, vemos algunas islas de azul en las áreas rojas.

#Intuitivamente, esto no tiene mucho sentido.

#¿Por qué están solos así?
  
#Esto se debe a lo que llamamos sobreentrenamiento.

#Para comprender qué es el sobreentrenamiento, tenga en cuenta que tenemos una mayor precisión cuando predecimos en un conjunto de entrenamiento que comparamos en un conjunto de prueba.

#Podemos hacerlo usando este código.

y_hat_knn <- predict(knn_fit, mnist_27$train, type = "class")
confusionMatrix(data = y_hat_knn, reference = mnist_27$train$y)$overall["Accuracy"]

y_hat_knn <- predict(knn_fit, mnist_27$test, type = "class")
confusionMatrix(data = y_hat_knn, reference = mnist_27$test$y)$overall["Accuracy"]


#Puede ver que la precisión calculada en el lado del entrenamiento es bastante mayor.

#Es 0.882 en comparación con lo que obtenemos en el conjunto de prueba, que es solo .815.

#Esto es porque sobreentrenamos.

#El sobreentrenamiento es peor cuando establecemos k igual a 1.

#k= 1

#Con k igual a 1, la estimación para cada punto en el conjunto de entrenamiento se obtiene con solo la y correspondiente a ese punto porque usted es su vecino más cercano.

#Entonces, en este caso, obtenemos una precisión prácticamente perfecta en el conjunto de entrenamiento porque cada punto se usa para predecirse a sí mismo.

#La precisión perfecta ocurrirá cuando tengamos predictores únicos, que casi tenemos aquí.

#fit knn with k=1

knn_fit_1 <- knn3(y ~ ., data = mnist_27$train, k = 1)
y_hat_knn_1 <- predict(knn_fit_1, mnist_27$train, type = "class")
confusionMatrix(data=y_hat_knn_1, reference=mnist_27$train$y)$overall[["Accuracy"]]


#Entonces puede ver que cuando usamos k es igual a 1, nuestra precisión en un conjunto de entrenamiento es 0.995, cinco precisión casi perfecta.

#Sin embargo, cuando verificamos el conjunto de pruebas, la precisión es realmente peor que con la regresión logística.

#Solo llega a 0.735.

#Podemos ver eso usando este código.

y_hat_knn_1 <- predict(knn_fit_1, mnist_27$test, type = "class")
confusionMatrix(data=y_hat_knn_1, reference=mnist_27$test$y)$overall[["Accuracy"]]


#Para ver el ajuste excesivo en una figura, podemos trazar los datos y luego usar contornos para mostrar qué divide a los dos de los sietes.

#Y esto es lo que obtienes cuando usas k es igual a 1.

#Observe todas las pequeñas islas que en el conjunto de entrenamiento se ajustan perfectamente a los datos.

#Tendrás este pequeño punto rojo solo, y se formará una pequeña isla a su alrededor para que obtengas la predicción perfecta.

#Pero una vez que miras el conjunto de prueba, ese punto se ha ido.

#Ya no hay rojo allí.

#Ahora hay quizás un azul, y te equivocas.

#La probabilidad condicional estimada siguió los datos de entrenamiento demasiado de cerca.

#Aunque no es tan malo, vemos que este sobreentrenamiento con k es igual a 5, o el valor predeterminado. Entonces deberíamos considerar una k más grande.

#Probemos un ejemplo.

#Probemos con un ejemplo mucho más amplio.

#Probemos 401.

#Podemos ajustar el modelo simplemente cambiando la k a 401 de esta manera.

#fit knn with k=401

knn_fit_401 <- knn3(y ~ ., data = mnist_27$train, k = 401)
y_hat_knn_401 <- predict(knn_fit_401, mnist_27$test, type = "class")
confusionMatrix(data=y_hat_knn_401, reference=mnist_27$test$y)$overall["Accuracy"]

#Vemos que la precisión en un conjunto de prueba es solo 0.79, no muy buena, una precisión similar a la regresión logística.

#De hecho, las estimaciones en realidad se parecen bastante.

#A la izquierda está la regresión logística.

#A la derecha hay k vecinos más cercanos con k igual a 401.

#El tamaño de k es tan grande que no permite suficiente flexibilidad.

#Casi estamos incluyendo la mitad de los datos para calcular cada uno de los estimados la probabilidad condicional.

#A esto lo llamamos exceso de suavidad.

#Entonces, ¿cómo elegimos k?
  
#Cinco parece ser demasiado pequeño.

#401 parece ser demasiado grande.

#Algo en el medio podría ser mejor.

#Entonces, lo que podemos hacer es repetir lo que acabamos de hacer para diferentes valores de k.

#Entonces podemos probar todos los números impares entre 3 y 251.

ks <- seq(3,251,2)

#Y haremos esto usando la función map_df() para repetir lo que acabamos de hacer para cada k.

#Para fines comparativos, calcularemos la precisión utilizando ambos conjuntos de entrenamiento que sean incorrectos.

#No deberíamos hacer eso, pero solo por comparación lo haremos y el conjunto de prueba, que es la forma correcta de hacerlo.

#El código se ve simplemente así.

accuracy <- map_df(ks, function(k){
  fit <- knn3(y ~ ., data = mnist_27$train, k = k)
  y_hat <- predict(fit, mnist_27$train, type = "class")
  cm_train <- confusionMatrix(data = y_hat, reference = mnist_27$train$y)
  train_error <- cm_train$overall["Accuracy"]
  y_hat <- predict(fit, mnist_27$test, type = "class")
  cm_test <- confusionMatrix(data = y_hat, reference = mnist_27$test$y)
  test_error <- cm_test$overall["Accuracy"]
  tibble(train = train_error, test = test_error)
})


#Una vez que ejecutamos ese código, ahora podemos trazar la precisión contra el valor de k, y eso se ve así.

ks[which.max(accuracy$test)]
max(accuracy$test)


#Primero, tenga en cuenta que la precisión frente a la gráfica k es bastante irregular.

#No esperamos esto porque los pequeños cambios en k no deberían afectar demasiado el rendimiento del algoritmo.

#La irregularidad se explica por el hecho de que la precisión se calcula en esta muestra y, por lo tanto, es una variable aleatoria.

#Esto demuestra por qué preferimos minimizar la pérdida de expectativas, en lugar de la pérdida que observamos con un conjunto de datos.

#Pronto aprenderemos una mejor manera de estimar esta pérdida esperada.

#Ahora, a pesar del ruido presente en la trama, todavía vemos un patrón general.

#Los valores bajos de k dan una precisión baja del conjunto de prueba pero una alta precisión del conjunto de entrenamiento, lo que es evidencia de sobreentrenamiento.

#Los valores grandes de k dan como resultado una baja precisión, lo que es evidencia de exceso de suavidad.

#El máximo se alcanza entre 25 y 41.

#Y la precisión máxima es 0.85, sustancialmente mayor que la regresión logística.

#De hecho, la estimación resultante con k es igual a 41 se parece bastante a la probabilidad condicional verdadera, como vemos en este gráfico.

#Ahora, ¿es una precisión de 0.85 lo que deberíamos esperar si aplicamos este algoritmo en el mundo real?
  
#La respuesta es en realidad no porque rompimos una regla de oro del aprendizaje automático.

#Seleccionamos la k usando el conjunto de prueba.

#Entonces, ¿cómo seleccionamos la k?
  
#En los siguientes videos, presentamos el importante concepto de validación cruzada, que proporciona una forma de estimar la pérdida esperada para un método dado usando solo el conjunto de entrenamiento.
