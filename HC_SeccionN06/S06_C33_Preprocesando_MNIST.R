#S06_C33_Preprocesando_MNIST
#Pre procesando los datos MNIST
#Cargar la info de Caso de Estudio MNIST

#En el aprendizaje automático, a menudo transformamos predictores antes de ejecutar el algoritmo de aprendizaje automático.

#Este es realmente un paso importante.

#También eliminamos predictores que claramente no son útiles, también un paso importante.

#Llamamos a todo esto preprocesamiento.

#Los ejemplos de preprocesamiento incluyen estandarizar los predictores, tomar la transformación logarítmica de algunos predictores u otra transformación, eliminar predictores que están altamente correlacionados con otros y eliminar predictores con muy pocos valores no únicos o variaciones cercanas a cero.

#Vamos a mostrar un ejemplo de uno de estos.

#El ejemplo que veremos se relaciona con la variabilidad de las características.

#Podemos ver que hay una gran cantidad de características con variabilidad cero, o casi cero.

#Podemos usar este código para calcular la desviación estándar de cada columna y luego trazarlas en un histograma.

library(matrixStats)
sds <- colSds(x)

qplot(sds, bins = 256, color = I("black"))


#Así es como se ve.

#Esto se espera, porque hay partes de la imagen que rara vez contienen escritura, muy pocos píxeles oscuros, por lo que hay muy poca variación.

#y casi todos los valores son 0.

#El paquete caret incluye una función que recomienda eliminar las funciones debido a una variación cercana a cero.

#Puedes ejecutarlo así.

library(caret)

nzv <- nearZeroVar(x)

#Podemos ver que las columnas que se eliminan son las amarillas en este gráfico simplemente haciendo una imagen de la matriz.

image(matrix(1:784 %in% nzv, 28, 28))

#Una vez que eliminamos estas columnas, terminamos manteniendo estas columnas.

col_index <- setdiff(1:ncol(x), nzv)
length(col_index)

#Ahora, estamos listos para adaptarnos a algunos modelos.


