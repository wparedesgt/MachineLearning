#Ejercicio_No1_S06_Conjuntos

#Para estos ejercicios, crearemos varios modelos de aprendizaje automático para el conjunto de datos mnist_27 y luego crearemos un conjunto. Cada uno de los ejercicios en esta verificación de comprensión se basa en el último.

#Use el conjunto de entrenamiento para construir un modelo con varios de los modelos disponibles en el paquete de caret. Probaremos 10 de los modelos de aprendizaje automático más comunes en este ejercicio:


models <- c("glm", "lda", "naive_bayes", "svmLinear", "knn", "gamLoess", "multinom", "qda", "rf", "adaboost")


#Aplique todos estos modelos usando train con todos los parámetros predeterminados. Es posible que deba instalar algunos paquetes. Tenga en cuenta que probablemente recibirá algunas advertencias. Además, probablemente tomará un tiempo entrenar a todos los modelos: ¡tenga paciencia!
 
 
#Ejecute el siguiente código para entrenar los distintos modelos:

library(caret)
library(dslabs)
library(tidyverse)


set.seed(1) 
data("mnist_27")

fits <- lapply(models, function(model){ 
  print(model)
  train(y ~ ., method = model, data = mnist_27$train)
}) 

names(fits) <- models


#Ahora que tiene todos los modelos entrenados en una lista, use sapply o map para crear una matriz de predicciones para el conjunto de pruebas. 

#Debería terminar con una matriz con filas de longitud (mnist_27$test$y) y columnas de longitud (models).

pred <- sapply(fits, function(object)
  predict(object, newdata = mnist_27$test))

dim(pred)

#¿Cuáles son las dimensiones de la matriz de predicciones?


#Numero de filas?


#Q3
#Ahora calcule la precisión para cada modelo en el conjunto de prueba.

acc <- colMeans(pred == mnist_27$test$y)

acc

mean(acc)


#Q4

#Luego, construya una predicción de conjunto por mayoría de votos y calcule la precisión del conjunto.

#¿Cuál es la precisión del conjunto?

votes <- rowMeans(pred == "7")
y_hat <- ifelse(votes > 0.5, "7", "2")

mean(y_hat == mnist_27$test$y)



#En Q3, calculamos la precisión de cada método en el conjunto de prueba y notamos que las precisiones individuales variaban.

#¿Cuántos de los métodos individuales funcionan mejor que el conjunto?


ind <- acc > mean(y_hat == mnist_27$test$y)
sum(ind)
models[ind]



#Es tentador eliminar los métodos que no funcionan bien y volver a hacer el conjunto.

#El problema con este enfoque es que estamos utilizando los datos de prueba para tomar una decisión. Sin embargo, podríamos usar las estimaciones mínimas de precisión obtenidas de la validación cruzada con los datos de entrenamiento para cada modelo. Obtenga estas estimaciones y guárdelas en un objeto. Informe la media de estas estimaciones de precisión del conjunto de entrenamiento.

#¿Cuál es la media de estas estimaciones de precisión del conjunto de entrenamiento?


acc_hat <- sapply(fits, function(fit) min(fit$results$Accuracy))
mean(acc_hat)



#Ahora solo consideremos los métodos con una precisión estimada mayor o igual a 0.8 al construir el conjunto.

#¿Cuál es la precisión del conjunto ahora?

ind <- acc_hat >= 0.8
votes <- rowMeans(pred[,ind] == "7")
y_hat <- ifelse(votes>=0.5, 7, 2)
mean(y_hat == mnist_27$test$y)



#Reduccion de Dimensiones

#Exploraremos los datos tissue_gene_expression y se graficarán.

data("tissue_gene_expression")
dim(tissue_gene_expression$x)

table(tissue_gene_expression$y)

pc <- prcomp(tissue_gene_expression$x)
data.frame(pc_1 = pc$x[,1], pc_2 = pc$x[,2], 
           tissue = tissue_gene_expression$y) %>%
  ggplot(aes(pc_1, pc_2, color = tissue)) +
  geom_point()


#Q2

#Los predictores para cada observación se miden utilizando el mismo dispositivo y procedimiento experimental. Esto introduce sesgos que pueden afectar a todos los predictores de una observación. Para cada observación, calcule el promedio en todos los predictores, y luego grafique esto contra la primera PC con el color que representa el tejido. Informar la correlación.

#¿Cuál es la correlación?


avgs <- rowMeans(tissue_gene_expression$x)

data.frame(pc_1 = pc$x[,1], avg = avgs, 
           tissue = tissue_gene_expression$y) %>%
  ggplot(aes(avgs, pc_1, color = tissue)) +
  geom_point()
cor(avgs, pc$x[,1])



#Vemos una asociación con la primera PC y los promedios de observación. Vuelva a hacer la PCA pero solo después de quitar el centro. Parte del código se proporciona para usted.


x <- with(tissue_gene_expression, sweep(x, 1, rowMeans(x))) 

pc <- prcomp(x)

data.frame(pc_1 = pc$x[,1], pc_2 = pc$x[,2], 
           tissue = tissue_gene_expression$y) %>%
  ggplot(aes(pc_1, pc_2, color = tissue)) +
  geom_point()



#Para las primeras 10 PC, haga un diagrama de caja que muestre los valores para cada tejido.

#Para la séptima PC, ¿qué dos tejidos tienen la mayor diferencia mediana?

for(i in 1:10){
  boxplot(pc$x[,i] ~ tissue_gene_expression$y, main = paste("PC", i))
}



#Trace el porcentaje de varianza explicado por el número de PC. Sugerencia: use la función de summary.

#¿Cuántas PC se requieren para alcanzar una variación porcentual acumulada explicada mayor que 50%?

plot(summary(pc)$importance[3,])
