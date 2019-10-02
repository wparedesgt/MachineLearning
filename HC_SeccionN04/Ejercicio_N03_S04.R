#Ejercicio_N03_S04

#Genere un conjunto de predictores y resultados aleatorios usando el siguiente código:
library(dslabs)
library(tidyverse)
library(caret)
library(purrr)

set.seed(1996) 
n <- 1000
p <- 10000
x <- matrix(rnorm(n*p), n, p)
colnames(x) <- paste("x", 1:ncol(x), sep = "_")
y <- rbinom(n, 1, 0.5) %>% factor()

x_subset <- x[ ,sample(p, 100)]


#Debido a que "x" y "y" son completamente independientes, no debería poder predecir y usando x con una precisión mayor que 0.5. Confirme esto ejecutando la validación cruzada utilizando regresión logística para ajustar el modelo. Debido a que tenemos tantos predictores, seleccionamos una muestra aleatoria x_subset. Use el subconjunto cuando entrene al modelo.

#¿Qué código realiza correctamente esta validación cruzada?

fit <- train(x_subset, y, method = "glm")
fit$results

#Ahora, en lugar de utilizar una selección aleatoria de predictores, vamos a buscar aquellos que sean más predictivos del resultado. Podemos hacer esto comparando los valores para el grupo y = 1 con los del grupo y = 0, para cada predictor, usando una prueba t. Puede realizar este paso así:

#install.packages("BiocManager")
#BiocManager::install("genefilter")
library(genefilter)
tt <- colttests(x, y)


#¿Cuál de las siguientes líneas de código crea correctamente un vector de los valores p llamados pvals?

names(tt)

pvals <- tt$p.value


#Cree un índice ind con los números de columna de los predictores que estaban "estadísticamente significativos" asociados con y. Utilice un valor de corte p de 0.01 para definir "estadísticamente significativo".

#¿Cuántos predictores sobreviven a este corte?


ind <- which(pvals <= 0.01)
length(ind)

#Ahora vuelva a ejecutar la validación cruzada después de redefinir x_subset para que sea el subconjunto de x definido por las columnas que muestran una asociación "estadísticamente significativa" con y.

#¿Cuál es la precisión ahora?

x_subset <- x[ ,sample(ind, 100)]

fit <- train(x_subset, y, method = "glm")
fit$results

#Vuelva a ejecutar la validación cruzada nuevamente, pero esta vez usando kNN. Pruebe la siguiente cuadrícula k = seq (101, 301, 25) de parámetros de ajuste. Haz un diagrama de las precisiones resultantes.

#¿Qué código es correcto?

fit <- train(x_subset, y, method = "knn", tuneGrid = data.frame(k = seq(101, 301, 25)))
ggplot(fit)


#En los ejercicios anteriores, vemos que a pesar del hecho de que x e y son completamente independientes, pudimos predecir y con una precisión superior al 70%. Debemos estar haciendo algo mal entonces.

#Respuesta:

#Utilizamos todo el conjunto de datos para seleccionar las columnas utilizadas en el modelo. correcto

#Explicación

#Como utilizamos todo el conjunto de datos para seleccionar las columnas en el modelo, la precisión es demasiado alta. El paso de selección debe incluirse como parte del algoritmo de validación cruzada, y luego la validación cruzada se realiza después del paso de selección de columna.

#Como ejercicio de seguimiento, intente rehacer la validación cruzada, esta vez incluyendo el paso de selección en el algoritmo de validación cruzada. La precisión ahora debería estar cerca del 50%.


#Use la función de entrenamiento con kNN para seleccionar la mejor k para predecir el tejido a partir de la expresión génica en el conjunto de datos tissue_gene_expression de dslabs. Pruebe k = seq (1,7,2) para ajustar los parámetros. Para esta pregunta, no divida los datos en conjuntos de prueba y entrenamiento (comprenda que esto puede conducir a un sobreajuste, pero ignórelo por ahora).

#¿Qué valor de k da como resultado la mayor precisión?

data("tissue_gene_expression")

y <- tissue_gene_expression$y
x <- tissue_gene_expression$x

#fit <- knn3(x,y, k = seq(1,7,2))

sapply(seq(1,7,2), function(k){
  fit <- knn3(x, y, k = k)
  y_hat <- predict(fit, newdata = data.frame(x=x),
                   type = "class")
  mean(y_hat == y)
})

