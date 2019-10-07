#S06_C35_Importancia_Variable
#Importancia Variable
#Cargar la info de Caso de Estudio MNIST y de preprocesamiento 


#Anteriormente describimos que una de las limitaciones del bosque aleatorio es que no son muy interpretables.

#Sin embargo, el concepto de importancia variable ayuda un poco a este respecto.

#Desafortunadamente, la implementación actual del paquete Rborist aún no admite cálculos de importancia variable.

#Entonces, para demostrar al concepto la importancia variable, vamos a utilizar la función de bosque aleatorio en el paquete de bosque aleatorio.

#Además, no vamos a filtrar ninguna columna de la matriz de características.

#Vamos a usarlos todos.

#Entonces el código se verá así.

library(randomForest)

x <- mnist$train$images[index,]
y <- factor(mnist$train$labels[index])

rf <- randomForest(x,y, ntree = 50)

#Una vez que ejecutamos esto, podemos calcular la importancia de cada característica usando la función importante.

#Entonces escribiríamos algo como esto.

imp <- importance(rf)

imp

#Si observa la importancia, inmediatamente vemos que las primeras características tienen cero importancia.

#Nunca se usan en el algoritmo de predicción.

#Esto tiene sentido porque estas son las características en los bordes, las características que no tienen escritura, ni píxeles oscuros en ellas.

#En este ejemplo en particular, tiene sentido explorar la importancia de esta característica usando una imagen.

#Haremos una imagen donde cada característica se traza en la ubicación de la imagen de donde vino.

#Entonces podemos usar este código.

image(matrix(imp, 28,28))

#Y vemos dónde están las características importantes.

#Tiene mucho sentido.

#Están en el medio, donde está la escritura.

#Y puedes ver los diferentes números allí: seis, ocho, siete.

#Estas son las características que distinguen un dígito de otro.

#Una parte importante de la ciencia de datos es visualizar resultados para discernir por qué estamos fallando.

#Cómo hacemos esto depende de la aplicación.

#Para los ejemplos con los dígitos, encontraremos dígitos para los que estábamos bastante seguros de una llamada, pero era incorrecta.

#Podemos comparar lo que obtuvimos con vecinos k-más cercanos a lo que obtuvimos con bosque aleatorio.

#Entonces podemos escribir código como este y luego hacer imágenes de los casos en los que cometimos un error.

p_max <- predict(fit_knn, x_test[,col_index])
p_max <- apply(p_max, 1, max)

ind <- which(y_hat_knn != y_test)
ind <- ind[order(p_max[ind], decreasing = TRUE)]


#Aquí están.

rafalib::mypar(3,4)

for(i in ind[1:12]){
  image(matrix(x_test[i,], 28, 28)[, 28:1],
        main = paste0("Pr(",y_hat_knn[i],")=",round(p_max[i], 2),
                      " but is a ",y_test[i]),
        xaxt="n", yaxt="n")
}


#El primero se llamó cero.

#En realidad es un dos.

#Puedes ver por qué.

#El segundo se llamaba cuatro, pero es un seis.

#Ese definitivamente ves por qué cometimos un error, etc.

#Pero al mirar estas imágenes, puede obtener ideas sobre cómo podría mejorar su algoritmo.

#Podemos hacer lo mismo para el bosque aleatorio.

p_max <- predict(fit_rf, x_test[,col_index])$census  
p_max <- p_max / rowSums(p_max)
p_max <- apply(p_max, 1, max)

ind  <- which(y_hat_rf != y_test)
ind <- ind[order(p_max[ind], decreasing = TRUE)]

rafalib::mypar(3,4)

for(i in ind[1:12]){
  image(matrix(x_test[i,], 28, 28)[, 28:1], 
        main = paste0("Pr(",y_hat_rf[i],")=",round(p_max[i], 2),
                      " but is a ",y_test[i]),
        xaxt="n", yaxt="n")
}

#Estos son los 12 casos principales en los que estábamos muy seguros de que era un dígito, cuando en realidad era otro.