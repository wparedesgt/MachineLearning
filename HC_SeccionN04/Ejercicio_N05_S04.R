#Ejercicio_N05_S04

#En los siguientes ejercicios, vamos a aplicar LDA y QDA al conjunto de datos tissue_gene_expression. Comenzaremos con ejemplos simples basados en este conjunto de datos y luego desarrollaremos un ejemplo realista.

#Q1

#Cree un conjunto de datos de muestras de cerebelo e hipocampo, dos partes del cerebro y una matriz de predicción con 10 columnas seleccionadas al azar utilizando el siguiente código:

library(tidyverse)
library(dslabs)
library(caret)

data("tissue_gene_expression")

set.seed(1993)

ind <- which(tissue_gene_expression$y %in% c("cerebellum", "hippocampus"))

y <- droplevels(tissue_gene_expression$y[ind])

x <- tissue_gene_expression$x[ind, ]

x <- x[, sample(ncol(x), 10)]


#Use la función de entrenamiento "train()" para estimar la precisión de LDA. Para esta pregunta, use todo el conjunto de datos tissue_gene_expression dataset: no lo divida en conjuntos de entrenamiento y prueba (comprenda que esto puede conducir a un sobreajuste).

train_lda <- train(x,y, 
                   method = "lda", 
                   data = tissue_gene_expression)


train_lda$results["Accuracy"]

#Q2

#En este caso, LDA se ajusta a dos distribuciones normales de 10 dimensiones. Mire el modelo ajustado mirando el componente finalModel del resultado del entrenamiento.

#Observe que hay un componente llamado "means" que incluye los medios estimados de ambas distribuciones. 

#Trace los vectores medios uno contra el otro y determine qué predictores (genes) parecen estar impulsando el algoritmo.

#¿Qué DOS genes parecen estar manejando el algoritmo?

train_lda$finalModel$means


t(train_lda$finalModel$means) %>% data.frame() %>%
  mutate(predictor_name = rownames(.)) %>%
  ggplot(aes(cerebellum, hippocampus, label = predictor_name)) +
  geom_point() +
  geom_text() +
  geom_abline()


#Q3

#Repita el ejercicio en Q1 con QDA.

#Cree un conjunto de datos de muestras de cerebelo e hipocampo, dos partes del cerebro y una matriz de predicción con 10 columnas seleccionadas al azar utilizando el siguiente código:

library(tidyverse)
library(dslabs)      
library(caret)

data("tissue_gene_expression")

set.seed(1993)

ind <- which(tissue_gene_expression$y %in% c("cerebellum", "hippocampus"))

y <- droplevels(tissue_gene_expression$y[ind])

x <- tissue_gene_expression$x[ind, ]
x <- x[, sample(ncol(x), 10)]

#Use la función de entrenamiento "train()" para estimar la precisión de QDA. Para esta pregunta, use todo el conjunto de datos tissue_gene_expression: no lo divida en conjuntos de entrenamiento y prueba (comprenda que esto puede conducir a un sobreajuste).

#¿Cuál es la precisión?


fit_qda <- train(x,y, 
                   method = "qda", 
                   data = tissue_gene_expression)


fit_qda$results["Accuracy"]


#Q4

#¿Qué DOS genes manejan el algoritmo cuando se usa QDA en lugar de LDA?

fit_qda$finalModel$means



t(fit_qda$finalModel$means) %>% data.frame() %>%
  mutate(predictor_name = rownames(.)) %>%
  ggplot(aes(cerebellum, hippocampus, label = predictor_name)) +
  geom_point() +
  geom_text() +
  geom_abline()


#Q5

#Una cosa que vimos en las gráficas anteriores es que los valores de los predictores se correlacionan en ambos grupos: algunos predictores son bajos en ambos grupos y otros altos en ambos grupos. El valor medio de cada predictor encontrado en colMeans (x) no es informativo ni útil para la predicción y, a menudo, para fines de interpretación, es útil centrar o escalar cada columna. Esto se puede lograr con el argumento preProcess en train. Vuelva a ejecutar LDA con preProcess = "center".

#Tenga en cuenta que la precisión no cambia, pero ahora es más fácil identificar los predictores que difieren más entre los grupos que en función de la gráfica realizada en Q2.

#¿Qué DOS genes manejan el algoritmo después de realizar el escalado?

fit_lda <- train(x,y, method = "lda", preProcess = "center")

fit_lda$results["Accuracy"]

fit_lda$finalModel$means


t(fit_lda$finalModel$means) %>% data.frame() %>%
  mutate(predictor_name = rownames(.)) %>%
  ggplot(aes(predictor_name, hippocampus)) +
  geom_point() +
  coord_flip()


#Puedes ver que son diferentes genes los que impulsan el algoritmo ahora. Esto se debe a que el predictor significa cambio.

#En los ejercicios anteriores vimos que los enfoques LDA y QDA funcionaban bien. 

#Para una mayor exploración de los datos, puede trazar los valores predictores para los dos genes con las mayores diferencias entre los dos grupos en un diagrama de dispersión para ver cómo parecen seguir una distribución bivariada como se supone por los enfoques LDA y QDA, coloreando el puntos por el resultado, utilizando el siguiente código:

d <- apply(fit_lda$finalModel$means, 2, diff)
ind <- order(abs(d), decreasing = TRUE)[1:2]
plot(x[, ind], col = y)


#Q6

#Ahora vamos a aumentar ligeramente la complejidad del desafío. Repita el análisis LDA de Q5 pero utilizando todos los tipos de tejidos. Use el siguiente código para crear su conjunto de datos:

library(tidyverse)
library(dslabs)      
library(caret)
data("tissue_gene_expression")

set.seed(1993) #set.seed(1993, sample.kind="Rounding") if using R 3.6 or later
y <- tissue_gene_expression$y
x <- tissue_gene_expression$x
x <- x[, sample(ncol(x), 10)]



fit_lda <- train(x,y, method = "lda", preProcess = "center")

fit_lda$results["Accuracy"]
