#S03_C09_Matrices
#Matrices


#En el aprendizaje automático, las situaciones en las que todos los predictores son numéricos, o pueden convertirse a numéricos de manera significativa, son comunes.

#El conjunto de datos de dígitos es un ejemplo.

#Cada píxel registra un número entre 0 y 255.

#De hecho, podemos cargar los 60,000 dígitos usando este código.

library(tidyverse)
library(dslabs)
if(!exists("mnist")) mnist <- read_mnist()



#En estos casos, a menudo es conveniente guardar los predictores en una matriz y los resultados en un vector en lugar de utilizar un dataframe.

#De hecho, podemos ver que el conjunto de datos que acabamos de descargar hace esto.

#Puede ver que la imagen de datos de entrenamiento es una matriz escribiendo este código.

class(mnist$train$images)


#Esta matriz representa 60,000 dígitos.

#Es una matriz bastante grande.

#Entonces, para el ejemplo, en este video, tomaremos un subconjunto más manejable.

#Tomaremos los primeros 1,000 predictores y las primeras 1,000 etiquetas, lo cual podemos hacer usando este código.


x <- mnist$train$images[1:1000,] 
y <- mnist$train$labels[1:1000]


#En el aprendizaje automático, la razón principal para usar matrices es que ciertas operaciones matemáticas necesarias para desarrollar un código eficiente se pueden realizar utilizando técnicas de una rama de las matemáticas llamada álgebra lineal.

#De hecho, el álgebra lineal y la notación matricial son elementos clave del lenguaje utilizado en trabajos académicos que describen técnicas de aprendizaje automático.

#No cubriremos el álgebra lineal en detalle aquí, pero demostraremos cómo usar matrices en R, para que pueda aplicar las técnicas de álgebra lineal ya implementadas en R Base y otros paquetes.

#Para motivar el uso de matrices, plantearemos cinco desafíos.

#Primero, vamos a estudiar la distribución de la oscuridad total de los píxeles y cómo varía según los dígitos.

#En segundo lugar, estudiaremos la variación de cada píxel y eliminaremos predictores, columnas, asociadas con píxeles que no cambian mucho y, por lo tanto, no pueden proporcionar mucha información para la clasificación.

#Tercero, vamos a poner a cero los valores bajos que probablemente sean manchas.

#Primero, veremos la distribución de todos los valores de píxeles, use esto para elegir un límite para definir el espacio no escrito, luego haga que todo lo que esté debajo de ese límite sea cero.

#Cuarto, vamos a binarizar los datos.

#Primero veremos la distribución de todos los valores de píxeles, usaremos esto para elegir un límite y distinguiremos entre escribir y no escribir.

#Luego, convierta todas las entradas en cero o en una.

#Luego, finalmente, vamos a escalar cada uno de los predictores en cada entrada para tener el mismo promedio y desviación estándar.

#Para completar esto, tendremos que realizar operaciones matemáticas que involucren varias variables.

#El tidyverse no está desarrollado para realizar este tipo de operación matemática.

#Para esta tarea, es conveniente usar matrices.

#Antes de atacar los desafíos, presentaremos la notación matricial y el código R básico para definir y operar en matrices.


