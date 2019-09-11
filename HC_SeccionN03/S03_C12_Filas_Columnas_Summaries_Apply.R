#S03_C12_Columnas_Filas_Summaries_Apply
#Resumenes de filas y columnas aplicadas

avgs <- apply(x, 1, mean)

sds <- apply(x, 2, sd)

#Así que ahora comencemos a atacar los desafíos que planteamos anteriormente.

#Para el primero relacionado con la oscuridad total de píxeles, queremos sumar los valores de cada fila y luego visualizar cómo estos valores varían según el dígito.

#La función rowSums toma una matriz como entrada y calcula los valores deseados.

#Toma la suma de cada fila.

#Entonces, este pequeño código simple lo hace muy rápidamente.

sums <- rowSums(x)


#También podemos calcular los promedios con la función rowMeans como esta.

avg <- rowMeans(x)

#Una vez que tengamos esto, simplemente podemos generar un diagrama de caja para ver cómo cambia la intensidad de píxel promedio de dígito a dígito.

#Aquí está.

data_frame(labels = as.factor(y), row_averages = avg) %>%
  qplot(labels, row_averages, data = ., geom = "boxplot")


#Desde esta gráfica, vemos que, como es lógico, los que usan menos tinta que otros dígitos.

#Tenga en cuenta que también podemos calcular las sumas y promedios de columna usando las funciones colSums y colMeans respectivamente.

#El paquete matrixStats agrega funciones que realizan operaciones en cada fila o columna de manera muy eficiente, incluidas las funciones rowSds y colSds.

#Tenga en cuenta que las funciones que acabamos de describir están realizando una operación similar a dos funciones que ya hemos aprendido, sapply() y map() por función.

#Aplican la misma función a una parte de nuestro objeto.

#En este caso, cada fila o cada columna.

#La función de aplicación le permite aplicar cualquier función, no solo suma o media, a una matriz.

#El primer argumento de la función de aplicación es la matriz.

La segunda es la dimensión a la que desea aplicar la función, una para filas, dos para columnas.

Y el tercer argumento es la función.

Entonces, por ejemplo, rowMeans se puede escribir así.

Pero tenga en cuenta que al igual que sapply y map, podemos realizar cualquier función.

Entonces, si quisiéramos la desviación estándar para cada columna, podríamos escribir esto.

Ahora, lo que paga con esta flexibilidad es que no son tan rápidas como las funciones dedicadas como rowMeans, colMeans, etc.