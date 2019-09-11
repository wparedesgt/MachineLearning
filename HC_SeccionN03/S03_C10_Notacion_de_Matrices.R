#S03_C10_Notacion_de_Matrices

#Ojo Cargar antes S03_C09_Matrices

#Notacion de las Matrices

#En álgebra matricial tenemos tres tipos principales de objetos, escalares, vectores y matrices.

#Un escalar es solo un número.

#Por ejemplo, a es igual a uno, a es escalar.

#Para denotar escalares en notación matricial, usualmente usamos una letra minúscula y no la ponemos en negrita.

#Los vectores son como los vectores numéricos que definimos en r.

#Incluyen varias entradas escalares.

#Por ejemplo, la columna que contiene el primer píxel es un vector.

#Tiene una longitud de 1000.

#Aquí está el código que lo muestra.

length(x[,1])

#En álgebra matricial utilizamos la siguiente notación para definir vectores, como este.

#Del mismo modo, podemos usar la notación matemática para representar matemáticamente diferentes características agregando un índice.

#Así que aquí está x1, la primera característica y x2, la segunda característica.

#Ambos son vectores.

#Si estamos escribiendo una columna como x1, en una oración a menudo usamos la notación x1 a xn y luego tenemos el símbolo de transposición t.

#Esta operación de transposición convierte columnas en filas y filas en columnas.

#Una matriz se puede definir como una serie de vectores del mismo tamaño unidos, formando una columna cada uno.

#Entonces, en nuestro código, podemos escribirlo así.

x_1 <- 1:5
x_2 <- 6:10
cbind(x_1, x_2)


#Matemáticamente, los representamos con letras mayúsculas en negrita como esta.

#La dimensión de una matriz es a menudo una característica importante necesaria para asegurar que se puedan realizar ciertas operaciones.

#La dimensión es un resumen de dos números definido como el número de filas y el número de columnas.

#En r podemos extraer las dimensiones de la matriz con la función dim como esta.

dim(x)

#Tenga en cuenta que los vectores pueden considerarse como n por 1 matrices.

#Sin embargo, en r, un vector no tiene dimensiones.

#Puedes verlo escribiendo esto.

dim(x_1)


#Sin embargo, podemos convertir explícitamente un vector en una matriz usando la función as.matrix.

#Entonces, si hacemos eso, entonces vemos que, de hecho, esta es una matriz de 5 por 1.

dim(as.matrix(x_1))

#Podemos usar esta notación para denotar un número arbitrario de predictores con la siguiente matriz n por p.

#Por ejemplo, si tenemos 784 columnas podríamos hacer esto.

#P es 784, aquí está la matriz arbitraria que representa nuestros datos.

#Almacenamos esto en x.

#Entonces, cuando haces dim x, puedes ver que es 1000 por 784.

dim(x)
