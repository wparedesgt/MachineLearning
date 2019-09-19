#S04_C25_Mas_3_clases
#Caso de Estudio mas de 3 clases

library(tidyverse)
library(dslabs)
library(caret)


#En este tema, daremos un ejemplo un poco más complejo, uno con tres clases en lugar de dos.

#Primero creamos un conjunto de datos similar a los dos o siete conjuntos de datos.

#Excepto que ahora tenemos uno, dos y sietes.

#Podemos generar ese conjunto de datos utilizando este código bastante complejo.

if(!exists("mnist"))mnist <- read_mnist()

set.seed(3456)

index_127 <- sample(which(mnist$train$labels %in% c(1,2,7)), 2000)

y <- mnist$train$labels[index_127] 
x <- mnist$train$images[index_127,]

index_train <- createDataPartition(y, p=0.8, list = FALSE)

# get the quadrants
# temporary object to help figure out the quadrants
row_column <- expand.grid(row=1:28, col=1:28)
upper_left_ind <- which(row_column$col <= 14 & row_column$row <= 14)
lower_right_ind <- which(row_column$col > 14 & row_column$row > 14)

# binarize the values. Above 200 is ink, below is no ink
x <- x > 200 

# cbind proportion of pixels in upper right quadrant and proportion of pixels in lower right quadrant
x <- cbind(rowSums(x[ ,upper_left_ind])/rowSums(x),
           rowSums(x[ ,lower_right_ind])/rowSums(x)) 





#Una vez que hayamos terminado, obtenemos un conjunto de entrenamiento y un conjunto de prueba.


train_set <- data.frame(y = factor(y[index_train]),
                        x_1 = x[index_train,1],
                        x_2 = x[index_train,2])

test_set <- data.frame(y = factor(y[-index_train]),
                       x_1 = x[-index_train,1],
                       x_2 = x[-index_train,2])

#Aquí mostramos los datos para el conjunto de entrenamiento.

train_set %>%  ggplot(aes(x_1, x_2, color=y)) + geom_point()

#Puede ver los predictores x1 y x2.

#Y luego, en color, le mostramos las diferentes etiquetas, las diferentes categorías.

#Los unos están en rojo, los verdes son los dos, y los puntos azules son los sietes.

#Como ejemplo, ajustaremos un modelo qda.

#Usaremos el paquete caret.

#Entonces, todo lo que hacemos es escribir este fragmento de código.

train_qda <- train(y ~ ., 
                   method = "qda", 
                   data = train_set)

#Entonces, ¿cómo difieren las cosas ahora?
  
#Primero tenga en cuenta que estimamos tres probabilidades condicionales, aunque todas tienen que sumar 1.

#Entonces, si escribe predecir con probabilidad de tipo, ahora obtiene una matriz con tres columnas, una probabilidad para las unidades, una probabilidad para los dos, una probabilidad para los sietes.

predict(train_qda, test_set, type = "prob") %>% head()


#Predecimos el que tiene la mayor probabilidad.

#Entonces, para la primera observación de la primera linea, predeciríamos un dos.

#Y ahora nuestros predictores son una de tres clases.

#Si usamos la función de predicción, con la configuración predeterminada de solo darle el resultado, obtenemos los dos, los unos y siete.

predict(train_qda, test_set)


#La matriz de confusión es una tabla de tres por tres ahora porque podemos cometer dos tipos de errores con los unos, dos tipos de errores con los dos y dos tipos de errores con los sietes.

#puedes verlo aqui.

confusionMatrix(predict(train_qda, test_set), test_set$y)

#La precisión todavía está en un número porque básicamente calcula la frecuencia con la que hacemos la predicción correcta.

#Tenga en cuenta que para la sensibilidad y la especificidad, tenemos un par de valores para cada clase.

#Esto se debe a que para definir estos términos, necesitamos un resultado binario.

#Por lo tanto, tenemos tres columnas, una para cada clase como positiva y las otras dos como negativas.

#Finalmente, podemos visualizar qué partes de las regiones se llaman unidades, dos y siete simplemente en una grafica con la probabilidad condicional estimada.

#Veamos cómo se ve para lda.

#Podemos entrenar al modelo así.

train_lda <- train(y ~ . , 
                   method = "lda", 
                   data = train_set)

confusionMatrix(predict(train_lda, test_set), test_set$y)$overal["Accuracy"]


#La precisión es mucho peor, y se debe a que nuestras regiones límite tienen tres líneas.

#Esto es algo que podemos mostrar matemáticamente.

#Los resultados para knn son en realidad mucho mejores.

train_knn <- train(y ~ . , 
                   method = "knn", 
                   tuneGrid = data.frame(k = seq(15, 51, 2)), 
                   data = train_set)

confusionMatrix(predict(train_knn, test_set), test_set$y)$overall["Accuracy"]


#Mira qué tan alta es la precisión.

#Y también podemos ver que la probabilidad condicional estimada es mucho más flexible, como podemos ver en este gráfico.

#Tenga en cuenta que la razón por la que qda y, en particular, lda no funcionan bien se debe a la falta de ajuste.

#Podemos ver eso trazando los datos y notando que al menos los definitivamente no son bivariados normalmente distribuidos.

train_set %>% mutate(y = factor(y)) %>% ggplot(aes(x_1, x_2, fill = y, color=y)) + geom_point(show.legend = FALSE) + stat_ellipse(type="norm")

#En resumen, generar modelos puede ser muy poderoso, pero solo cuando podemos aproximar con éxito la distribución conjunta de la condición del predictor en cada clase.

