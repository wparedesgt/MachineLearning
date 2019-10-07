#S06_C34_Ajustando_MNIST
#Ajustando los datos MNIST
#Cargar la info de Caso de Estudio MNIST y de preprocesamiento

options(digits = 3)

#En este video, vamos a implementar k vecinos más cercanos y bosque aleatorio en los datos MNIST.

#Sin embargo, antes de comenzar, necesitamos agregar nombres de columna a las matrices de entidades, ya que este es un requisito del paquete caret.

#Podemos hacer esto usando este código.

colnames(x) <- 1:ncol(mnist$train$images)
colnames(x_test) <- colnames(mnist$train$images)


#Vamos a agregar como nombre el número de la columna.

#OK, entonces comencemos con knn.

#El primer paso es optimizar la cantidad de vecinos.

#Ahora, tenga en cuenta que cuando ejecutamos el algoritmo, tendremos que calcular una distancia entre cada observación en el conjunto de prueba y cada observación en el conjunto de entrenamiento.

#Estos son muchos cálculos.

#Por lo tanto, utilizaremos la validación cruzada k-fold para mejorar la velocidad.

control <- trainControl(method = "cv", number = 10, p = .9)

train_knn <- train(x[,col_index], y,
                   method = "knn", 
                   tuneGrid = data.frame(k = c(1,3,5,7)),
                   trControl = control)

#Por lo tanto, podemos usar el paquete caret para optimizar nuestro algoritmo vecino k-más cercano.

#Esto encontrará el modelo que maximiza la precisión.

ggplot(train_knn, highlight = TRUE)

#Tenga en cuenta que ejecutar este código lleva bastante tiempo en una computadora portátil estándar.

#Podría tomar varios minutos.

#En general, es una buena idea probar un fragmento de código con un pequeño subconjunto de datos primero para tener una idea del tiempo, antes de comenzar a ejecutar el código que puede tardar horas en ejecutarse o incluso días.

#Por lo tanto, siempre realice verificaciones o haga cálculos a mano para asegurarse de que su código no tome demasiado tiempo.

#Desea saber tener una idea de cuánto tiempo llevará su código.

#Entonces, una cosa que puede hacer es probarlo en conjuntos de datos más pequeños.

#Aquí definimos n como el número de filas que vamos a usar y b, el número de pliegues de validación cruzada que vamos a usar.

n <- 1000
b <- 2
index <- sample(nrow(x), n)
control <- trainControl(method = "cv", number = b, p = .9)
train_knn <- train(x[index ,col_index], y[index],
                   method = "knn",
                   tuneGrid = data.frame(k = c(3,5,7)),
                   trControl = control)


#Entonces podemos comenzar a aumentar estos números lentamente para tener una idea de cuánto tiempo llevará el código final. 

#Ahora, una vez que hayamos terminado de optimizar nuestro algoritmo, podemos ajustar todo el conjunto de datos.

#Entonces codificaríamos así.

fit_knn <- knn3(x[ ,col_index], y,  k = 5)

#Vemos que nuestra precisión es casi 0.95.

y_hat_knn <- predict(fit_knn,
                     x_test[, col_index],
                     type="class")

cm <- confusionMatrix(y_hat_knn, factor(y_test))

cm$overall["Accuracy"]

#A partir de la salida de especificidad y sensibilidad proveniente de la función de matriz de confusión, vemos que los ochos son los más difíciles de detectar y el dígito predicho siete más comúnmente incorrecto.

cm$byClass[,1:2]

#Ahora, veamos si podemos hacerlo aún mejor con un bosque aleatorio.

#Con el bosque aleatorio, el tiempo de cálculo es un desafío aún mayor que con los vecinos más cercanos.

#Para cada bosque, necesitamos construir cientos de árboles.

#También tenemos varios parámetros que podemos ajustar.

#Aquí usamos la implementación de bosque aleatorio en el paquete Rborist, que es más rápido que el del paquete de bosque aleatorio.

#Tiene menos funciones, pero es más rápido.

#Debido a que con el bosque aleatorio, el ajuste es la parte más lenta del procedimiento en lugar de la predicción, como con knn, solo usaremos una validación cruzada de cinco veces.

#También reduciremos la cantidad de árboles que están en forma, ya que aún no estamos construyendo nuestro modelo final.

#Finalmente, tomaremos un subconjunto aleatorio de observaciones al construir cada árbol.

#Podemos cambiar este número con el argumento nSamp de la función Rborist.

#Así que aquí hay un código para optimizar un bosque aleatorio.



library(Rborist)

control <- trainControl(method="cv", number = 5, p = 0.8)

grid <- expand.grid(minNode = c(1) , predFixed = c(10, 15, 35))

train_rf <-  train(x[, col_index], 
                   y, 
                   method = "Rborist", 
                   nTree = 50,
                   trControl = control,
                   tuneGrid = grid,
                   nSamp = 5000)






#Tarda unos minutos en ejecutarse.

#Podemos ver los resultados finales usando ggplot.

ggplot(train_rf)

#Y podemos elegir los parámetros utilizando el mejor componente de ajuste del objeto de entrenamiento.

train_rf$bestTune

#Y ahora estamos listos para optimizar nuestro árbol final.

#Ahora vamos a establecer el número de árboles en un número mayor.

#Podemos escribir esta pieza de código.

fit_rf <- Rborist(x[, col_index], y,
                  nTree = 1000,
                  minNode = train_rf$bestTune$minNode,
                  predFixed = train_rf$bestTune$predFixed)

#Una vez que el código termina de ejecutarse, y tarda unos minutos, podemos ver, usando la función de matriz de confusión, que nuestra precisión está por encima de 0.95.

y_hat_rf <- factor(levels(y)[predict(fit_rf, x_test[ ,col_index])$yPred])
cm <- confusionMatrix(y_hat_rf, y_test)
cm$overall["Accuracy"]


#De hecho, hemos mejorado con respecto a los vecinos más cercanos.

#Ahora, veamos algunos ejemplos de la imagen original en el conjunto de prueba en nuestras llamadas.

#Puedes ver que al primero lo llamamos ocho.

#Son las ocho.

#El segundo también se llama un ocho.

#Parece un ocho.

#Y todos ellos parecen haber tomado la decisión correcta.

#No es sorprendente: tenemos una precisión superior a 0,95.

rafalib::mypar(3,4)
for(i in 1:12){
  image(matrix(x_test[i,], 28, 28)[, 28:1], 
        main = paste("Our prediction:", y_hat_rf[i]),
        xaxt="n", yaxt="n")
}

#Ahora, tenga en cuenta que hemos hecho un ajuste mínimo aquí.

#Y con algunos ajustes adicionales, examinando más parámetros, cultivando más árboles, podemos obtener una precisión aún mayor.