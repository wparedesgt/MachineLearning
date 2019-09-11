#S03_C13_Filtrando_Columnas_Basado_Resumen
#Filtrando columnas basadas en su resumen

#Ahora pasemos a nuestro segundo desafío.

#Estudiemos la variación de cada píxel y eliminemos las columnas asociadas con píxeles que no cambian mucho, por lo tanto, no informan la clasificación.

#Aunque es un enfoque simplista, cuantificaremos la variación de cada píxel con su desviación estándar en todas las entradas.

#Como cada columna representa un píxel, utilizamos la función colSds del paquete de estadísticas de matriz como este.

library(matrixStats)

sds <- colSds(x)


#Un vistazo rápido a la distribución de estos valores muestra que algunos píxeles tienen una variabilidad muy baja de entrada a entrada.


qplot(sds, bins = "30", color = I("black"))


#Esto tiene sentido, ya que no escribimos en algunas partes del cuadro.

#Aquí está la variación trazada por ubicación.

image(1:28, 1:28, matrix(sds, 28, 28)[, 28:1])

#Vemos que hay poca variación en las esquinas.

#Esto tiene sentido.

#Escribiríamos los dígitos en el centro.

#Por lo tanto, podríamos eliminar características que no tienen variación, ya que estas no pueden ayudarnos a predecir mucho.

#En el curso básico de R, describimos las operaciones utilizadas para extraer columnas.

#Aquí hay un ejemplo que muestra las columnas 351 y 352 y las filas.

x[ ,c(351,352)]


#Aquí están la segunda y tercera fila.

x[c(2,3),]


#También podemos usar índices lógicos para determinar qué columnas o filas mantener.

#Entonces, si quisiéramos eliminar predictores no informativos de nuestra Matriz, podríamos escribir esta línea de código, así.

new_x <- x[ ,colSds(x) > 60]
dim(new_x)

#Solo se mantienen las columnas para las cuales la desviación estándar es superior a 60.

#Aquí agregamos una advertencia importante relacionada con el subconjunto de matrices.

#Si selecciona una columna o una fila, el resultado ya no es una matriz, sino un vector.

#Aquí hay un ejemplo.

class(x[,1])

dim(x[1,])


#Esto podría ser un problema si está asumiendo que las operaciones en matrices resultarán en matrices.

#Sin embargo, podemos preservar la clase de matriz usando el argumento drop, como este.

class(x[ , 1, drop=FALSE])
dim(x[, 1, drop=FALSE])
