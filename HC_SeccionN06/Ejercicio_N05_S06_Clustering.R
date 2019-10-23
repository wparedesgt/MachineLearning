#Ejercicio_N05_S06_Clustering

library(tidyverse)
library(dslabs)
library(caret)

data("tissue_gene_expression")

#Q1

#Cargue tissue_gene_expression. Remueva la fila de premedio y calcule la distancia entre cada observacion. Almacene el resultado en un objeto llamado d.

d <- dist(tissue_gene_expression$x - rowMeans(tissue_gene_expression$x))

head(d)


#Q2

#Haga un diagrama de agrupamiento jerárquico y agregue los tipos de tejido como etiquetas.

#Observarás múltiples ramas.

#¿Qué tipo de tejido está en la rama más a la izquierda?

h1 <- hclust(d)

plot(h1, cex = 0.65)


#Q3

#Ejecute una agrupación k-means en los datos con K = 7. Haga una tabla que compare los grupos identificados con los tipos de tejido reales. Ejecute el algoritmo varias veces para ver cómo cambia la respuesta.

#¿Qué observas para la agrupación del tejido hepático?

cl <- kmeans(tissue_gene_expression$x, centers = 7)

table(cl$cluster, tissue_gene_expression$y)


#Q4

#Seleccione los 50 genes más variables. Asegúrese de que las observaciones aparezcan en las columnas, que el predictor esté centrado, y agregue una barra de color para mostrar los diferentes tipos de tejidos. Sugerencia: use el argumento ColSideColors para asignar colores. Además, use col = RColorBrewer :: brewer.pal (11, "RdBu") para un mejor uso de los colores.


library(RColorBrewer)
sds <- matrixStats::colSds(tissue_gene_expression$x)
ind <- order(sds, decreasing = TRUE)[1:50]
colors <- brewer.pal(7, "Dark2")[as.numeric(tissue_gene_expression$y)]


heatmap(t(tissue_gene_expression$x[,ind]), col = brewer.pal(11, "RdBu"), scale = "row", ColSideColors = colors)

#heatmap(t(tissue_gene_expression$x[,ind]), col = brewer.pal(11, "RdBu"), scale = "row", ColSideColors = rev(colors))

#heatmap(t(tissue_gene_expression$x[,ind]), col = brewer.pal(11, "RdBu"), scale = "row", ColSideColors = sample(colors))

#heatmap(t(tissue_gene_expression$x[,ind]), col = brewer.pal(11, "RdBu"), scale = "row", ColSideColors = sample(colors))

