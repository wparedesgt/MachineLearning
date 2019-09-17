#S04_C17_Knn

library(tidyverse)
library(dslabs)
library(caret)

#En esta parte, aprenderemos nuestro primer algoritmo de aprendizaje automático, el algoritmo k-vecinos más cercanos o (k-nearest neighbors).

#Para demostrarlo, vamos a utilizar los datos de dígitos con dos predictores que creamos en una clase anterior.

#Los vecinos K más cercanos están relacionados con el suavizado.

#Para ver esto, pensaremos en el condicional probablemente, el probable de ser un siete, y es igual a 1, dados los dos predictores.

#p(x1,x2) = Pr(Y=1|X1=x1,X2=x2)

#Esto se debe a que los ceros y los que observamos son ruidosos porque algunas de las regiones de probabilidad condicional no están cerca de cero o uno, lo que significa que a veces puede ir en cualquier dirección.

#Entonces tenemos que estimar la probabilidad condicional.

#Cómo hacemos esto?
  
#Vamos a intentar alisar.

#Los vecinos más cercanos a K son similares al suavizado de bin.

#Pero es más fácil adaptarse a múltiples dimensiones.

#Primero definimos la distancia entre observaciones en función de las características.

#Básicamente, para cualquier punto para el que desee estimar la probabilidad condicional, observamos los puntos k más cercanos y luego tomamos un promedio de estos puntos.

#Nos referimos al conjunto de puntos utilizados para calcular el promedio como vecindario.

#Debido a la conexión que describimos anteriormente entre las expectativas condicionales y las probabilidades condicionales, esto nos da la probabilidad condicional estimada, al igual que bin smoothers nos dio una tendencia estimada.

#P^(X1,X2)


#Podemos controlar la flexibilidad de nuestra estimación a través de k.

#Las K más grandes dan como resultado estimaciones más pequeñas, mientras que las K más pequeñas dan como resultado estimaciones más flexibles y más onduladas.

#Así que implementemos k-nearest neighbors.

#Vamos a compararlo con la regresión logística, que será el estándar que debemos superar.

#Podemos escribir este código para calcular las predicciones de glm.

fit_glm <- glm(y~x_1+x_2, data=mnist_27$train, family="binomial")

p_hat_logistic <- predict(fit_glm, mnist_27$test)

y_hat_logistic <- factor(ifelse(p_hat_logistic > 0.5, 7, 2))

confusionMatrix(data = y_hat_logistic, reference = mnist_27$test$y)$overall[1]


#Y tenga en cuenta que tenemos una precisión de 0,76.

#Ahora comparemos esto con knn.

#Utilizaremos la función knn3() que viene con el paquete caret.

#Si miramos el archivo de ayuda de este paquete, vemos que podemos llamarlo de dos maneras.

#En el primero, especificamos una fórmula y un dataframe.

#El dataframe contiene todos los datos que se utilizarán.

#La fórmula tiene la forma de resultado tilde predictor 1 más predictor 1 más predictor 3 y así sucesivamente.

#outcome ~ predictor_1 + predictor_2 + predictor_3
``
#Entonces, en este m donde solo tenemos dos predictores, escribiríamos "y"  esos son los resultados: tilde x1 más x2.

#y~ x_1+x_2

#Pero si vamos a usar todos los predictores, podemos usar un atajo, y es el punto.

#Teclearíamos y tilde dot.

#y ~ .

#Y eso dice usar todos los predictores.

#Entonces, la llamada a knn3 se ve simplemente así.

knn_fit <- knn3(y ~ ., data = mnist_27$train)

head(mnist_27)


#La segunda forma de llamar a esta función es que el primer argumentSobreentrenamiento y exceso de suavizadoSobreentrenamiento y exceso de suavizadoSobreentrenamiento y exceso de suavizadoSobreentrenamiento y exceso de suavizadoo son los predictores matriciales y el segundo, un vector de resultados.

#Entonces el código se vería así en su lugar.

#Definiríamos nuestra matriz con los predictores.

x <- as.matrix(mnist_27$train[,2:3])

#Luego, cuando definiríamos un vector con los resultados.

y <- mnist_27$train$y

#Y luego lo llamaríamos simplemente así.

knn_fit <- knn3(x,y)

#La razón por la que tenemos dos formas de hacerlo es porque la fórmula es una forma más rápida y sencilla de escribirla cuando tenemos prisa.

#Pero una vez que nos enfrentamos a grandes conjuntos de datos, querremos usar el enfoque matricial, el segundo enfoque.

#Muy bien, ahora, para esta función, también necesitamos elegir un parámetro, el número de vecinos a incluir.

#Comencemos con el valor predeterminado, que es k igual a 5.

#k = 5

#Podemos escribirlo explícitamente así.

knn_fit <- knn3(y ~ .,data = mnist_27$train, k = 5)


#Debido a que este conjunto de datos es equilibrado, hay muchos dos, ya que hay siete y nos preocupamos tanto por la sensibilidad como por la especificidad, ambos errores son igualmente malos, usaremos la precisión para cuantificar el rendimiento.

#La función de predicción para esta función knn produce una probabilidad para cada clase, o podría producir el resultado que maximiza la probabilidad, el resultado con la probabilidad más alta.Sobreentrenamiento y exceso de suavizadoSobreentrenamiento y exceso de suavizado

#Así que vamos a utilizar el código de predicción, el objeto ajustado, los nuevos datos para los que estamos prediciendo.

#Ese es el conjunto de datos de prueba.

#Y luego vamos a escribir, escriba igual a clase.

#Esto nos dará los resultados reales que se predicen.

y_hat_knn <- predict(knn_fit, mnist_27$test, type = "class")

#Entonces, una vez que tengamos esto, podemos calcular nuestra precisión utilizando la fórmula de matriz de confusión como esta.

confusionMatrix(data = y_hat_knn, reference = mnist_27$test$y)$overall["Accuracy"]

#Y vemos que ya tenemos una mejora sobre la regresión logística.

#Nuestra precisión es 0.815.