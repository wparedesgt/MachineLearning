#S03_C14_Indexado_Matrices_Binarizando_Data
#Indexacion con matrices y binzarizacion de datos


#Para nuestro próximo desafío, queremos poder ver un histograma de todos nuestros píxeles.

#Ya vimos cómo podemos convertir los vectores en matrices, pero también podemos deshacer esto y convertir las matrices en vectores.

#Así es como funciona.

#Es la función as.vector().

#Aquí hay un ejemplo.

mat <- matrix(1:15, 5, 3)
as.vector(mat)
mat

#Entonces, para ver un histograma de todos nuestros predictores, simplemente podemos escribir este código.

qplot(as.vector(x), bins = 30, color = I("black"))


#Cuando miramos este diagrama, vemos una clara dicotomía que se explica como partes con tinta y partes sin tinta.

#Si creemos que los valores a continuación, por ejemplo, 25, son manchas, podemos hacerlos rápidamente cero usando este código muy simple.

new_x <- x
new_x[new_x < 50] <- 0


#Para ver qué hace esto, veamos una matriz más pequeña en un ejemplo más pequeño.

#Escriba este código y observe lo que sucede.

mat <- matrix(1:15, 5, 3)
mat[mat < 3] <- 0
mat


#Cambia todos los valores que son menos de tres a cero.

#También podemos usar operaciones lógicas más complicadas con matrices como esta.

mat <- matrix(1:15, 5, 3)
mat[mat > 6 & mat < 12] <- 0
mat

#Aquí hay un ejemplo donde ponemos a cero todos los valores que están entre 6 y 12.

#Ahora para el próximo desafío, queremos binarizar los datos.

#El histograma que acabamos de ver sugiere que estos datos son principalmente binarios píxeles, son tinta o no tinta.

#Usando lo que hemos aprendido, podemos binarizar los datos usando solo operaciones matriciales.

#Por ejemplo, usando este código convertimos todos los valores por debajo de 255 divididos por 2 a 0 y por encima de él a 1.

bin_x <- x
bin_x[bin_x < 255/2] <- 0
bin_x[bin_x > 255/2] <- 1


#Pero también podemos convertirlo en una matriz usando lógicas y obligarlo a números como este.


bin_X <- (x > 255/2)*1


#Aquí hay un ejemplo que muestra que al convertir las cosas en 0 y 1 no perdemos tanta información.

#La figura de la izquierda incluye todos los valores de píxeles.

#La imagen de la derecha está binarizada.

grid <- matrix(x[3,], 28, 28)
grid1 <- matrix(bin_x[3,], 28,28)

image(1:28, 1:28, grid[,28:1])
image(1:28, 1:28, grid1[,28:1])


