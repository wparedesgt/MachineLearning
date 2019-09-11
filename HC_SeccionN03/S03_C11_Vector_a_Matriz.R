#S03_C11_Vector_a_Matriz
#Convirtiendo un vector en una Matriz

#Aprenderemos varias operaciones útiles relacionadas con el álgebra matricial.

#Usaremos algunos de los ejemplos motivadores que describimos en un video anterior para demostrar esto.

#A menudo es útil convertir un vector en una matriz.

#Por ejemplo, debido a que las variables son píxeles en una cuadrícula, podemos convertir las filas de intensidades de píxeles en una matriz que representa esta cuadrícula.

#Podemos convertir un vector en una matriz con la función de matriz y especificando el número de filas y columnas que debe tener la matriz resultante.

#La matriz se llena por columna.

#La primera columna se llena primero, y la segunda se llena segunda, y así sucesivamente.

#Así que aquí hay un ejemplo para ilustrar lo que queremos decir.

my_vector <- 1:15

#Si definimos un vector, esos son los números del 1 al 15.

#Y luego usamos la función de matriz en este factor, y digamos que tiene cinco filas y tres columnas, terminamos con la siguiente matriz.


# fill the matrix by column
mat <- matrix(my_vector, 5, 3)
mat


#Podemos completar por fila en lugar de por columna utilizando el argumento byrow.

#Entonces, por ejemplo, para transponer la matriz que acabamos de mostrar, usaríamos la función de matriz como esta.

#Ahora tenemos tres filas, cinco columnas, y lo llenamos por fila.

#Aquí está el código.

mat_t <- matrix(my_vector, 3, 5, byrow = TRUE) 
mat_t



#Esto es esencialmente transponer la matriz.

#En R, podemos usar la función t para transponer directamente una matriz.

#Ahora note que estos dos son iguales.

identical(t(mat), mat_t)


#Una advertencia importante

#La función matricial en R recicla valores en el vector sin advertencias.

#Si el producto de columnas y filas no coincide con la longitud del vector, esto sucede.

#Así que mira lo que sucede cuando trato de convertir mi vector, que tiene 15 entradas, en una matriz de 5 por 5.

matrix(my_vector, 5, 5)



#Entonces, ¿cómo podemos usar esto en la práctica?
  
#Veamos un ejemplo.

#Para poner las intensidades de píxeles de, por ejemplo, la tercera entrada, que sabemos que es un dígito que representa un 4, en una cuadrícula, podemos usar esto.

grid <- matrix(x[3,], 28, 28)

#Para confirmar que, de hecho, lo hemos hecho correctamente, podemos usar la funcion image(), que muestra una imagen del tercer argumento.

#Así es como lo usamos.

image(1:28, 1:28, grid)

#Podemos ver que esto parece un revés 4.

#Ahora se ve al revés porque la parte superior de esta imagen, el píxel uno, se muestra en la parte inferior.

#Así es como R traza las imágenes.

#Entonces está volteado.

#Si queremos voltearlo, podemos usar este código.

# flip the image back
image(1:28, 1:28, grid[, 28:1])

#Y ahora obtenemos una imagen que parece un 4.