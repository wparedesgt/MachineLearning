#Ejercicio_N06_S06_Cancer_Seno


#El conjunto de datos brca contiene información sobre muestras de biopsias para el diagnóstico de cáncer de seno para tumores que se determinaron que eran benignos (no cancerosos) y malignos (cancerosos). El objeto brca es una lista que consta de:
  
#brca$y: un vector de clasificaciones de muestra ("B" = benigno o "M" = maligno)

#brca$x: una matriz de características numéricas que describen las propiedades de la forma y el tamaño de los núcleos celulares extraídos de las imágenes del microscopio de biopsia

#Para estos ejercicios, cargue los datos configurando sus opciones y cargando las bibliotecas y los datos como se muestra en el código aquí:

options(digits = 3)
library(tidyverse)
library(matrixStats)
library(caret)
library(dslabs)
library(ggrepel)
data("brca")


#IMPORTANTE: Algunos de estos ejercicios usan conjuntos de datos dslabs que se agregaron en una actualización de julio de 2019. Asegúrese de que su paquete esté actualizado con el comando update.packages ("dslabs"). También puede actualizar todos los paquetes en su sistema ejecutando update.packages () sin argumentos, y debería considerar hacerlo rutinariamente.

#Cuantas Muestras hay en el dataset

length(brca$y)
dim(brca$x)[1]

#Cuantos predictores hay en la matriz

colnames(brca$x)
dim(brca$x)[2]

#Que proporcion de muestras son malignas

table(brca$y)
mean(brca$y == "M")

#0.372

#Que columna tiene el promedio mas alto
summary(brca$x)
colnames(brca$x)

max(brca$x[,24])

which.max(colMeans(brca$x))

#Que columna posee la desviacion standar mas baja

NoSeq <- seq(1:30)

head(brca$x)

sd(brca$x[,1])
median(brca$x[,1])
mean(brca$x[,1])
max(brca$x[,1])
sd(brca$x[,1])
summary(brca$x)

CalculaSD <- function(x) {
  desviacionSD <- sd(brca$x[,x])
  desviacionSD
}


sd(brca$x[,30])


sd_mas_baja <- sapply(NoSeq, CalculaSD) %>% table()

which.min(colSds(brca$x)) #Respuesta
x[is.na(x)] <- 0




#Pregunta 2: escalar la matriz

#Use sweep dos veces para escalar cada columna: reste la media de l a columna, luego divida por la desviación estándar de la columna.

#x <- sweep(brca$x,2,colMeans(brca$x), FUN="-")

x_scaled <- sweep(brca$x,2,colMeans(brca$x))
x_scaled <- sweep(x_scaled,2,colSds(brca$x), FUN="/")

sd(x_scaled[,1])
median(x_scaled[,1])

#Después de escalar, ¿cuál es la desviación estándar de la primera columna?

#1

#Después de escalar, ¿cuál es el promedio de la primera columna?

#-0.215


#Pregunta 3: Distancia

#Calcule la distancia entre todas las muestras usando la matriz escalada.



d <- dist(x_scaled)


d[2:357]




#¿Cuál es la distancia promedio entre la primera muestra, que es benigna, y otras muestras benignas?

head(d)

mean(d[1:356]); 
mean(d[357:569])

d_samples <- dist(x_scaled)
dist_BtoB <- as.matrix(d_samples)[1, brca$y == "B"]
mean(dist_BtoB[2:length(dist_BtoB)])


#¿Cuál es la distancia promedio entre la primera muestra y las muestras malignas?

dist_BtoM <- as.matrix(d_samples)[1, brca$y == "M"]
mean(dist_BtoM)


#Pregunta 4: Mapa de calor de características

#Haga un mapa de calor de la relación entre las características usando la matriz escalada.

#¿Cuál de estos mapas de calor es correcto?


#heatmap(x, labRow = NA, labCol = NA)

d_features <- dist(t(x_scaled))

heatmap(as.matrix(d_features), labRow = NA, labCol = NA)



#Pregunta 5: agrupamiento jerárquico

#Realice la agrupación jerárquica en las 30 características. Cortar el árbol en 5 grupos.

#Todas menos una de las opciones de respuesta están en el mismo grupo.

#¿Cuál está en un grupo diferente?


h <- hclust(d_features)

plot(h, cex = 0.65)

groups <- cutree(h, k = 5)

split(names(groups), groups)


#Proyecto de cáncer de mama, parte 2

#Pregunta 6: PCA: proporción de varianza

#Realice un análisis de componentes principales de la matriz escalada.

#¿Qué proporción de varianza se explica por el primer componente principal?

pca <- prcomp(x_scaled)

summary(pca) #respuesta 0.443 en PC1

#¿Cuántos componentes principales se requieren para explicar al menos el 90% de la varianza?


#How many principal components are required to explain at least 90% of the variance?

summary(pca) #l primer vaor de Cumulative Proportion excede el 0.9 en el PC7



#Q7


#Trace los dos primeros componentes principales con un color que represente el tipo de tumor (benigno / maligno).

#¿Cual de los siguientes es verdadero?


pca$x[,1:2]

pcs <- data.frame(pca$x[,1:2], Tipo = brca$y)

pcs %>% ggplot(aes(PC1, PC2, color = Tipo)) +
  geom_point()
 

#Q8 PCA PC Boxplot

#Hacer un boxplot de los primeros 10 PCs  agrupados por tipo de tumor.

data.frame(type = brca$y, pca$x[,1:10]) %>%
  gather(key = "PC", value = "value", -type) %>%
  ggplot(aes(PC, value, fill = type)) +
  geom_boxplot()

#Cancer de Seno Parte 3

#Establezca la semilla en 1, luego cree una partición de datos que divida brca$y y la versión escalada de la matriz brca$x en un conjunto de prueba del 20% y un 80% de entrenamiento utilizando el siguiente código:


set.seed(1, sample.kind = "Rounding")    # if using R 3.6 or later
test_index <- createDataPartition(brca$y, times = 1, p = 0.2, list = FALSE)
test_x <- x_scaled[test_index,]
test_y <- brca$y[test_index]
train_x <- x_scaled[-test_index,]
train_y <- brca$y[-test_index]



#Question 9: Training and test sets

#Check that the training and test sets have similar proportions of benign and malignant tumors.

#What proportion of the training set is benign?

table(train_y)
mean(train_y == "B")

#What proportion of the test set is benign?

table(test_y)
mean(test_y == "B")

#Question 10a: K-means Clustering

#The predict_kmeans function defined here takes two arguments - a matrix of observations x and a k-means object k - and assigns each row of x to a cluster from k.

#La función predic_kmeans definida aquí toma dos argumentos: una matriz de observaciones "x" y un objeto k-means, y asigna cada fila de x a un cluster desde k.

predict_kmeans <- function(x, k) {
  centers <- k$centers    # ex,tract cluster centers
  # calculate distance to cluster centers
  distances <- sapply(1:nrow(x), function(i){
    apply(centers, 1, function(y) dist(rbind(x[i,], y)))
  })
  max.col(-t(distances))  # select cluster with min distance to center
}

#Establezca la semilla en 3. Realice la agrupación k-means en el conjunto de entrenamiento con 2 centros y asigne la salida a k. Luego use la función predic_kmeans para hacer predicciones en el conjunto de prueba.

#¿Cuál es la precisión general?

set.seed(3)

k <- kmeans(train_x, centers = 2)

p_hat <- predict_kmeans(test_x, k)

y_hat <- ifelse(p_hat == 1, "B", "M") %>% factor()

confusionMatrix(y_hat, test_y)$overall["Accuracy"]


#Pregunta 10b: K-means Clustering

#Que proporcion de tumores benignos fue correctamente identificacdo.

sensitivity(factor(y_hat), test_y, positive = "B")


#Que proporcion de tumores malignos fue correctamente identificacdo.

sensitivity(factor(y_hat), test_y, positive = "M")



#Pregunta 11: modelo de regresión logística

#Ajuste un modelo de regresión logística en el conjunto de entrenamiento utilizando todos los predictores.

#Ignorar las advertencias sobre el algoritmo no convergente. Haga redicciones en el conjunto de prueba.

#¿Cuál es la precisión del modelo de regresión logística en el conjunto de prueba?

train_set <- tibble(y = train_y, x = train_x)
test_set <- tibble(y = test_y, x = test_x)

train_lm <- train(train_x, train_y, method = "glm")
y_hat_lm <- predict(train_lm, test_x, type = "raw")
confusionMatrix(y_hat_lm, test_set$y)$overall["Accuracy"]



#Pregunta 12: modelos LDA y QDA

#Entrene un modelo LDA y un modelo QDA en el conjunto de entrenamiento. Haga predicciones sobre el conjunto de prueba usando cada modelo.



#¿Cuál es la precisión del modelo LDA en el conjunto de prueba?

train_lda <- train(train_x, train_y, method = "lda")  
y_hat_lda <- predict(train_lda, test_x)
confusionMatrix(y_hat_lda, test_set$y)$overall["Accuracy"]

#¿Cuál es la precisión del modelo QDA en el conjunto de prueba?

train_qda <- train(train_x, train_y, method = "qda")
y_hat_qda <- predict(train_qda, test_x)
confusionMatrix(y_hat_qda, test_set$y)$overall["Accuracy"]


#Pregunta 13: modelo de Loess

#Establezca la semilla en 5, luego ajuste un modelo de loess en el conjunto de entrenamiento con el paquete de caret. Deberá instalar el paquete gam si aún no lo ha hecho. Use default tuning grid. Esto puede tomar varios minutos; ignorar las advertencias. Generar predicciones en el conjunto de prueba.

set.seed(5)
library(gam)

#¿Cuál es la precisión del modelo loess en el conjunto de prueba?

train_loess <- train(train_x, train_y, method = "gamLoess")
y_hat_loess <- predict(train_loess, test_x)
confusionMatrix(y_hat_loess, test_set$y)$overall["Accuracy"]


#Proyecto de cáncer de mama, parte 4

#Pregunta 14: Modelo de vecinos K más cercanos

#Establezca la semilla en 7, luego entrene un modelo de vecinos k-más cercanos en el conjunto de entrenamiento usando el paquete caret. Pruebe valores impares de k de 3 a 21. Use el modelo final para generar predicciones en el conjunto de prueba.

set.seed(7)
k <- seq(3,21,2)

k

train_knn <- train(train_x, train_y, 
                   method = "knn", 
                   tuneGrid = data.frame(k = c(3,5,7,9,11,13,15,17,19,21))
                   )



#¿Cuál es el valor final de k utilizado en el modelo?

ggplot(train_knn, highlight = TRUE) 
train_knn$bestTune
  
#¿Cuál es la precisión del modelo kNN en el conjunto de prueba?

y_hat_knn <- predict(train_knn, test_x)

confusionMatrix(y_hat_knn, test_set$y)$overall["Accuracy"]


#Pregunta 15a: modelo de bosque aleatorio

#Establezca la semilla en 9, luego entrene un modelo de bosque aleatorio en el conjunto de entrenamiento usando el paquete de caret. Pruebe valores mtry de 3, 5, 7 y 9. Use el argumento importance=TRUE para que se pueda extraer la importancia de la característica. Generar predicciones en el conjunto de prueba.

library(randomForest)

set.seed(9)

grid <- data.frame(mtry = c(3,5,7,9))

train_rf <- train(train_x, train_y,  test_set$y,
                  method = "rf", 
                  tuneGrid = grid, 
                  importance = TRUE)

#¿Qué valor de mtry da la mayor precisión?

ggplot(train_rf, highlight = TRUE)
train_rf$bestTune  
  
#¿Cuál es la precisión del modelo de bosque aleatorio en el conjunto de prueba?

y_hat_rf <- predict(train_rf, test_x)
confusionMatrix(y_hat_rf, test_set$y)$overall["Accuracy"]


#¿Cuál es la variable más importante en el modelo forestal aleatorio?
models <- c("glm", "lda", "qda", "gamLoess", "knn", "rf")

fit_rf <- randomForest(train_x, train_y, 
                       minNode = train_rf$bestTune$mtry)

varImp(train_rf)

#Pregunta 15b: modelo forestal aleatorio

#Considere las 10 variables más importantes en el modelo de bosque aleatorio.

varImp(train_rf)

#¿Qué conjunto de características es más importante para determinar el tipo de tumor?

varImp(train_rf)

#Pregunta 16a: Crear un conjunto

#Cree un conjunto utilizando las predicciones de los 7 modelos creados en los ejercicios anteriores: k-means, regresión logística, LDA, QDA, loess, k vecinos más cercanos y bosque aleatorio. Use el conjunto para generar una predicción mayoritaria del tipo de tumor (si la mayoría de los modelos sugieren que el tumor es maligno, prediga maligno).

#¿Cuál es la precisión de la predicción de conjunto?

models <- c( "k_means","glm", "lda", "qda", "gamLoess", "knn", "rf")


fits <- c(y_hat, y_hat_lm, y_hat_lda, y_hat_qda, y_hat_loess, y_hat_knn, y_hat_rf )

table(fits)


class(fits)
str(fits)


fits1 <- createDataPartition(fits, times = 1, p = 0.1428, list = FALSE)


fits2 <- fits[fits1]

table(fits2)


y_hat_all_models <- ifelse(fits2 == 1, "B", "M") %>% factor()


confusionMatrix(y_hat_all_models, test_y)$overall["Accuracy"]

#fits <- lapply(models, function(model){ 
#  print(model)
#  train(train_x, train_y, method = model)
#}) 

#names(fits) <- models



