#Ejercicio_N02_S04

library(dslabs)
library(tidyverse)
library(caret)
library(purrr)

#Anteriormente, utilizamos la regresión logística para predecir el sexo en función de la altura. Ahora vamos a usar knn para hacer lo mismo. Establezca la semilla en 1, luego use el paquete caret para dividir los datos de "alturas" de dslabs en un conjunto de entrenamiento y prueba de igual tamaño. Use la función sapply para realizar knn con k valores de seq (1, 101, 3) y calcular las puntuaciones F_1.

data("heights")

y <- heights$height
set.seed(1, sample.kind = "Rounding")

test_index <- createDataPartition(y, times = 1, p= 0.5, list = FALSE)
train_set <- heights %>% slice(-test_index)
test_set <- heights %>% slice(test_index)

ks <- seq(1,101, 3)

F_1 <- sapply(ks, function(k){
  fit <- knn3(sex ~ height, data = train_set, k = k)
  y_hat <- predict(fit, test_set, type = "class") %>%
    factor(levels = levels(train_set$sex))
  F_meas(data = y_hat, reference = test_set$sex)
})

plot(ks, F_1)
max(F_1)
ks[which.max(F_1)]


#A continuación, utilizaremos el mismo ejemplo de expresión génica utilizado en la Comprobación de comprensión: ejercicios de distancia. Puedes cargarlo así:

data("tissue_gene_expression")

#Divida los datos en conjuntos de entrenamiento y prueba e informe la precisión que obtiene. Pruébelo para k = 1, 3, 5, 7, 9, 11. Establezca la semilla en 1 antes de dividir los datos.

dim(tissue_gene_expression$x)
table(tissue_gene_expression$y)

set.seed(1)

y <- tissue_gene_expression$y
x <- tissue_gene_expression$x

train_index <- createDataPartition(y, list = FALSE)

sapply(c(1,3,5,7,9, 11), function(k){
  fit <- knn3(x[train_index,], y[train_index], k = k)
  y_hat <- predict(fit, newdata = data.frame(x=x[-train_index,]),
                   type = "class")
  mean(y_hat == y[-train_index])
})


#Este es
set.seed(1)
library(caret)
y <- tissue_gene_expression$y
x <- tissue_gene_expression$x
test_index <- createDataPartition(y, list = FALSE)
sapply(seq(1, 11, 2), function(k){
  fit <- knn3(x[-test_index,], y[-test_index], k = k)
  y_hat <- predict(fit, newdata = data.frame(x=x[test_index,]),
                   type = "class")
  mean(y_hat == y[test_index])
})

