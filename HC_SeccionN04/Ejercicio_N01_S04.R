#Ejercicio_N01_S04

#Cargue el siguiente dataset
library(tidyverse)
library(dslabs)
data("tissue_gene_expression")

#El dataset incluye ina matriz x:

dim(tissue_gene_expression$x)

#Esta matriz tiene los niveles de expresión génica de 500 genes de 189 muestras biológicas que representan siete tejidos diferentes. El tipo de tejido se almacena en "y".

table(tissue_gene_expression$y)

#¿Cuál de las siguientes líneas de código calcula la distancia euclidiana entre cada observación y la almacena en el objeto d?

d <- dist(tissue_gene_expression$x)


#Compare las distancias entre las observaciones 1 y 2 (ambas cerebelo), las observaciones 39 y 40 (ambas del colon) y las observaciones 73 y 74 (ambas endometriales).

#En cuanto a la distancia, ¿las muestras de tejidos del mismo tipo están más cerca una de la otra?

ind <- c(1, 2, 39, 40, 73, 74)
as.matrix(d)[ind,ind]

#Haz un diagrama de todas las distancias usando la función de imagen para ver si el patrón que observaste en Q2 es general.

#¿Qué código haría correctamente la grafica deseada?

image(as.matrix(d))

