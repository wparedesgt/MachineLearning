#S03_C15_Vectorizacion_Matrices_Operaciones_Algebra_Matricial
#Vectorizacion para matrices y operaciones de algebra lineal

library(tidyverse)
library(dslabs)
library(matrixStats)

#Para nuestro desafío final en el que estamos estandarizando las filas o las columnas, vamos a utilizar la vectorización.

#En R, restamos un vector de una matriz, el primer elemento de cada vector se resta de la primera fila de la matriz.

#El segundo elemento del vector se resta de la segunda fila de la matriz y así sucesivamente.

#Entonces, usando la notación matemática, la escribiríamos así.

#Esto es lo que hace R cuando resta un vector de una matriz.

#Lo mismo es válido para otras operaciones aritméticas.

#Esto implica que podemos escalar cada fila de una matriz usando este código simple.


#scale each row of a matrix
(x - rowMeans(x)) / rowSds(x)


#Ahora, si desea escalar cada columna, tenga cuidado porque no funciona para las columnas.

#Para las columnas, tendríamos que transponer una matriz.

#Entonces tendríamos que hacerlo así.

#scale each column
t(t(x) - colMeans(x))


#Transponemos la matriz, restamos las columnas y luego la volvemos a transponer.

#Para esta tarea, también podemos usar una funcion llamada sweep(), que funciona de manera similar que la funcion apply().

#Toma cada entrada de un vector y lo resta de la fila o columna correspondiente.

#Entonces, por ejemplo, en este código, tomamos cada columna.

#take each entry of a vector and subtracts it from the corresponding row or column
x_mean_0 <- sweep(x, 2, colMeans(x))

head(x_mean_0)

#Hay dos allí.

#Eso te dice que es una columna.

#Y resta la media de la columna de cada columna y devuelve la nueva matriz.

#Ahora, la funcion sweep() tiene otro argumento que le permite definir la operación aritmética.

#Por defecto, es resta.

#Pero podemos cambiarlo.

#Entonces, para dividir por la desviación estándar, podemos hacer lo siguiente.

#divide by the standard deviation
x_mean_0 <- sweep(x, 2, colMeans(x))
x_standardized <- sweep(x_mean_0, 2, colSds(x), FUN = "/")


#Así que hemos visto formas poderosas en las que podemos usar el álgebra matricial en R para realizar ciertas tareas.

#Finalmente, aunque no cubrimos las operaciones de álgebra matricial, como la multiplicación matricial, compartimos aquí los comandos relevantes para aquellos que conocen las matemáticas y desean aprender el código.

#La multiplicación de matrices se realiza con la siguiente operación por ciento de porcentaje de estrella.

#Entonces, el producto cruzado, por ejemplo, puede escribirse así.

t(x) %*% x



#Podemos calcular el producto cruzado directamente con la función con ese nombre. crossprod() x nos da como producto cruzado.

crossprod(x)

#Para calcular el inverso de una función, usamos la funcion solve().

solve(crossprod(x))

#Aquí se aplica al producto cruzado.

#Finalmente, la descomposición qr está fácilmente disponible usando la función qr() como esta.

qr(x)
