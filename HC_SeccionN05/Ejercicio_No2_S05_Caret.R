#Ejercicio_No2_S05_Caret

#Estos ejercicios lo llevan a través de un análisis utilizando el conjunto de datos de tissue_gene_expression.

library(dslabs)
library(tidyverse)
library(rpart)
library(caret)
library(purrr)
library(randomForest)

data("tissue_gene_expression")


names(tissue_gene_expression)

table(tissue_gene_expression$y)


#Q1

#Use la función rpart para ajustar un árbol de clasificación al conjunto de datos tejido_gene_expresión. Use la función de train para estimar la precisión. Pruebe los valores de cp de seq (0, 0.1, 0.01). Realice una grafica de las precisiones para informar los resultados del mejor modelo. Establecer la semilla a 1991.

set.seed(1991)


fit_rpart <- with(tissue_gene_expression, 
            train(x,y, method = "rpart", 
                  tuneGrid = data.frame(cp = seq(0,0.01,0.01))))

ggplot(fit_rpart, highlight = TRUE)


#Q2

#Tenga en cuenta que solo hay 6 placentas en el conjunto de datos. Por defecto, rpart requiere 20 observaciones antes de dividir un nodo. Eso significa que es difícil tener un nodo en el que las placentas sean la mayoría. Vuelva a ejecutar el análisis que hizo en el ejercicio en Q1, pero esta vez, permita que rpart divida cualquier nodo utilizando el argumento control = rpart.control (minsplit = 0).

#Mire nuevamente la matriz de confusión para determinar si la precisión aumenta. Nuevamente, establezca la semilla en 1991.

#¿Cuál es la precisión ahora?



set.seed(1991)

y <- tissue_gene_expression$y
x <- tissue_gene_expression$x

fit_rpart <- with(tissue_gene_expression, 
            train(x,y, method = "rpart", 
                  tuneGrid = data.frame(cp = seq(0,0.01,0.01)), 
                  control = rpart.control(minsplit = 0)))



ggplot(fit_rpart, highlight = TRUE)
confusionMatrix(fit_rpart)


#Trace el árbol del modelo que mejor se ajuste al análisis que ejecutó en Q1.

#¿Qué gen está en la primera división?

plot(fit_rpart$finalModel)
text(fit_rpart$finalModel)

#Q4

#Podemos ver que con solo siete genes, podemos predecir el tipo de tejido. Ahora veamos si podemos predecir el tipo de tejido con incluso menos genes utilizando un bosque aleatorio. 

#Usa la función de train() y el método rf para entrenar un bosque aleatorio. 

#Pruebe valores de mtry que van desde seq (50, 200, 25) (también puede explorar otros valores por su cuenta). 

#¿Qué valor mtry maximiza la precisión? Para permitir que los pequeños nodos crezcan como lo hicimos con los árboles de clasificación, use el siguiente argumento: nodeize = 1.

#Nota: este ejercicio tardará un tiempo en ejecutarse. Si primero desea probar su código, intente usar valores más pequeños con ntree. Establezca la semilla a 1991 nuevamente.

#¿Qué valor de mtry maximiza la precisión?

set.seed(1991)

fit <- with(tissue_gene_expression, 
            train(x, y, method = "rf", 
                  tuneGrid = data.frame(mtry = seq(50,200,25)), 
                  nodesize = 1))


ggplot(fit, highlight = TRUE)

#Q5

#Use la funcion varImp on la salida de train y guardela en un objeto llamado imp.


imp <- varImp(fit)

names(imp)

head(imp)




#Q6

#El modelo rpart que ejecutamos anteriormente produjo un árbol que usó solo siete predictores. Extraer los nombres de los predictores no es sencillo, pero se puede hacer. Si el resultado de la llamada al entrenamiento fue fit_rpart, podemos extraer los nombres de esta manera:

tree_terms <- as.character(unique(fit_rpart$finalModel$frame$var[!(fit_rpart$finalModel$frame$var == "<leaf>")]))
tree_terms

#Calcule la importancia variable en la llamada del Bosque aleatorio para estos siete predictores y examine dónde se clasifican.

imp$importance["CFHR4",]

tibble(term = rownames(imp$importance), 
           importance = imp$importance$Overall) %>%
  mutate(rank = rank(-importance)) %>% arrange(desc(importance)) %>%
  filter(term %in% tree_terms)

