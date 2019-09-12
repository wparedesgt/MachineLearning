#S04_C16_Distancia
#Distancia

#El concepto de distancia es bastante intuitivo.

#Por ejemplo, cuando agrupamos animales en subgrupos, reptiles, anfibios, mamíferos, estamos definiendo implícitamente una distancia que nos permite decir qué animales están cerca unos de otros.

#Muchas técnicas de aprendizaje automático se basan en la capacidad de definir la distancia entre observaciones utilizando características o predictores.

#Como revisión, definamos la distancia entre dos puntos, A y B, en el plano cartesiano, como estos dos.

#sea (Ax, Ay) (Bx,By)


#La distancia euclidiana entre AB simplemente está dada por esta fórmula.

#dist(A,B) = sqrt((Ax-Bx)^2 + (Ay - By)^2)

#Tenga en cuenta que esta definición se aplica al caso de una dimensión.

#En cuyo caso, la distancia entre dos números es simplemente el valor absoluto de su diferencia.

#Entonces, si nuestros dos números unidimensionales son A y B, la distancia es simplemente esto, que se convierte en el valor absoluto.

#dist(A,B) = sqrt((A-B)^2 = |A-B)


#En un video anterior, presentamos un conjunto de datos de entrenamiento con mediciones de matriz de características de 784 características.

#Con fines ilustrativos, observamos muestras aleatorias de 2s y 7s.

#Podemos generar este conjunto de datos utilizando este fragmento de código.


library(tidyverse)
library(dslabs)
if(!exists("mnist")) mnist <- read_mnist()

set.seed(1995)
ind <- which(mnist$train$labels %in% c(2,7)) %>% sample(500)

#the predictors are in x and the labels in y
x <- mnist$train$images[ind,]
y <- mnist$train$labels[ind]


#Los predictores están en "x"y las etiquetas están en "y".

#Para los propósitos de, por ejemplo, suavizado, estamos interesados en describir distancias entre observaciones.

#En este caso, dígitos.

#Más adelante, con el propósito de seleccionar características, también podríamos estar interesados en encontrar píxeles que se comporten de manera similar en todas las muestras.

#Ahora, para definir la distancia, necesitamos saber qué son los puntos, ya que la distancia matemática se calcula entre dos puntos.

#Con datos de alta dimensión, los puntos ya no están en el plano cartesiano.

#En cambio, los puntos son de dimensiones superiores.

#Ya no podemos visualizarlos y necesitamos pensar de manera abstracta.

#Por ejemplo, en nuestro ejemplo de dígitos, un predictor, xi, se define como un punto en el espacio dimensional 784.

#Podemos escribirlo así.

#Xi = (Xi,1,...,Xi.784)

#Una vez que definimos los puntos de esta manera, la distancia euclidiana se define de manera muy similar al caso bidimensional.

#Por ejemplo, la distancia entre las observaciones 1 y 2 viene dada por esta fórmula.

#dist(1,2) = sqrt(sum(784 * j =1)* (X1,j - X2,j)^2)


#Tenga en cuenta que estse es un número no negativo, tal como lo es para las dos dimensiones.

#Entonces, dos observaciones, hay una distancia y es solo un número.

#Ahora veamos un ejemplo.

#Veamos las primeras tres observaciones.


y[1:3]

#Veamos sus etiquetas.

#Este es un 2, un 7 y un 2.

#El vector de predictores para cada una de estas observaciones se guardará en estos tres objetos.

x_1 <- x[1,]
x_2 <- x[2,]
x_3 <- x[3,]

#Ahora echemos un vistazo a las distancias.

#Y recuerde, los dos primeros números son un 7 y el tercero es un 2.

#Esperamos que las distancias entre el mismo número, como este, sean más pequeñas que entre números diferentes.

#Y eso es lo que pasa.

sqrt(sum((x_1 - x_2)^2))

#Podemos verlo aquí.

sqrt(sum((x_1 - x_3)^2))
sqrt(sum((x_2 - x_3)^2))

#Como se esperaba, los 7 están más cerca uno del otro.


#Ahora, si conoce el álgebra matricial, tenga en cuenta que una forma más rápida de calcular esto es usar el producto cruzado.

#Entonces podemos escribir esto.

sqrt(crossprod(x_1 - x_2))
sqrt(crossprod(x_1 - x_3))
sqrt(crossprod(x_2 - x_3))



#También podemos calcular todas las distancias entre todas las observaciones a la vez de manera relativamente rápida utilizando la función dist().

#Si lo alimenta con una matriz, la función dist calcula la distancia entre cada fila y produce un objeto de clase dist.

#Aquí está el código que demuestra esto.

d <- dist(x)

class(d)

#Ahora hay varias funciones relacionadas con el aprendizaje automático en R que toman objetos de clase dist como entrada.

#Pero para acceder a las entradas usando índices de fila y columna, necesitamos forzar este objeto en una matriz.

#Podemos hacer esto así.

as.matrix(d)[1:3,1:3]


#Si miramos las primeras tres entradas, podemos ver que las distancias que calculamos coinciden con lo que calcula la función, dist.

#También podemos ver rápidamente una imagen de estas distancias usando la función de image().

#Entonces escribimos esto.

image(as.matrix(d))

#Vemos una representación visual de la distancia entre cada par de observaciones.

#Si ordenamos esas distancias por etiquetas, podemos ver que, en general, los 2 están más cerca uno del otro y los 7 están más cerca el uno del otro.

#Podemos lograr esto usando este código.

image(as.matrix(d)[order(y), order(y)])

#Esos cuadrados rojos demuestran que los dígitos que son iguales están más cerca uno del otro.

#Pero otra cosa que surge de esta trama es que parece haber más uniformidad en la forma en que se dibujan los 7 ya que parecen estar más cerca.

#Está más rojo allá arriba.

#Ahora, también podemos calcular la distancia entre predictores.

#Si N es el número de observaciones, la distancia entre dos predictores, digamos el primero y el segundo, se puede calcular de esta manera.

#Para calcular la distancia entre todos los pares de los predictores 784, primero podemos transponer la matriz y luego usar la función dist.

#Podemos escribir este código.

d <- dist(t(x))
dim(as.matrix(d))


#Tenga en cuenta que la dimensión de la matriz de distancia resultante es una matriz de 784 por 784.

#Una cosa interesante a tener en cuenta aquí es que, si elegimos un predictor, un píxel, podemos ver qué píxeles están cerca, lo que significa que están tintados o no tienen tinta juntos.

#Entonces, como ejemplo, veamos el píxel 492 y veamos las distancias entre cada píxel y el píxel 492.

#Así es como se ve.

d_492 <- as.matrix(d)[492,]
image(1:28, 1:28, matrix(d_492, 28, 28))


#Podemos ver el patrón espacial.

#No es sorprendente que los píxeles que están físicamente cerca de la imagen también lo estén matemáticamente.

#En resumen, el concepto de distancia es importante en el aprendizaje automático.

#Y veremos esto a medida que aprendamos más sobre algoritmos específicos.
