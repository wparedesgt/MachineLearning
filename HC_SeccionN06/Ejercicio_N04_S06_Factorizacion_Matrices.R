#Ejercicio_N04_S06_Factorizacion_Matrices

#En este conjunto de ejercicios, trataremos un tema útil para comprender la factorización matricial: la descomposición de valores singulares (SVD). SVD es un resultado matemático que se usa ampliamente en el aprendizaje automático, tanto en la práctica como para comprender las propiedades matemáticas de algunos algoritmos. Este es un tema bastante avanzado y para completar este conjunto de ejercicios tendrá que estar familiarizado con los conceptos de álgebra lineal, como la multiplicación de matrices, las matrices ortogonales y las matrices diagonales.

#El SVD se puede descomponer en N x p matrix Y con p < N como Y = UDB^t

#Con U y V orthogonal de las dimensiones N x p y pXp respectivamente y Da p x p diagonal matrix con los valores de las diagonales decrecientes,

# d1,1 >- d2,2 >- .... dp,p

#En este ejercicio, veremos una de las formas en que esta descomposición puede ser útil. Para hacer esto, construiremos un conjunto de datos que represente las calificaciones de 100 estudiantes en 24 materias diferentes. El promedio general se ha eliminado, por lo que estos datos representan el punto porcentual que cada estudiante recibió por encima o por debajo del puntaje promedio de la prueba. Entonces, un 0 representa una calificación promedio (C), un 25 es una calificación alta (A +) y un -25 representa una calificación baja (F). Puede simular los datos de esta manera:

set.seed(1987, sample.kind="Rounding")
n <- 100
k <- 8
Sigma <- 64  * matrix(c(1, .75, .5, .75, 1, .5, .5, .5, 1), 3, 3) 
m <- MASS::mvrnorm(n, rep(0, 3), Sigma)
m <- m[order(rowMeans(m), decreasing = TRUE),]
y <- m %x% matrix(rep(1, k), nrow = 1) + matrix(rnorm(matrix(n*k*3)), n, k*3)
colnames(y) <- c(paste(rep("Math",k), 1:k, sep="_"),
                 paste(rep("Science",k), 1:k, sep="_"),
                 paste(rep("Arts",k), 1:k, sep="_"))


#Nuestro objetivo es describir las actuaciones de los estudiantes de la manera más sucinta posible. Por ejemplo, queremos saber si los resultados de estas pruebas son solo números aleatorios independientes. ¿Todos los estudiantes son igual de buenos? ¿Ser bueno en un tema implica que serás bueno en otro? ¿Cómo ayuda la SVD con todo esto? Iremos paso a paso para mostrar que con solo tres pares relativamente pequeños de vectores podemos explicar gran parte de la variabilidad en este conjunto de datos de 100 × 24.

dim(y)



#Q1

#Puede visualizar los 24 puntajes de las pruebas para los 100 estudiantes al trazar una imagen:


my_image <- function(x, zlim = range(x), ...){
  colors = rev(RColorBrewer::brewer.pal(9, "RdBu"))
  cols <- 1:ncol(x)
  rows <- 1:nrow(x)
  image(cols, rows, t(x[rev(rows),,drop=FALSE]), xaxt = "n", yaxt = "n",
        xlab="", ylab="",  col = colors, zlim = zlim, ...)
  abline(h=rows + 0.5, v = cols + 0.5)
  axis(side = 1, cols, colnames(x), las = 2)
}

my_image(y)


#¿Cómo describirías los datos basados en esta figura?


#Q2
#Puede examinar la correlación entre los puntajes de la prueba directamente de esta manera:


my_image(cor(y), zlim = c(-1,1))
range(cor(y))
axis(side = 2, 1:ncol(y), rev(colnames(y)), las = 2)


#Existe una correlación entre todas las pruebas, pero es mayor si las pruebas son de ciencias y matemáticas e incluso más altas dentro de cada materia.



#Q3

#Recuerde que la ortogonalidad significa que U⊤U y V⊤V son iguales a la matriz de identidad. Esto implica que también podemos reescribir la descomposición como

#YV = UD o U⊤Y = DV⊤

#Podemos pensar en YV y U⊤V como dos transformaciones de Y que preservan la variabilidad total de Y ya que U y V son ortogonales.

#Use la función svd para calcular la SVD de y. Esta función devolverá U, V y las entradas diagonales de D.


s <- svd(y)
names(s)

#Se puede ver que trabaja en el siguiente codigo:

options(digits = 3)

y_svd <- s$u %*% diag(s$d) %*% t(s$v)

max(abs(y - y_svd))


#Calcule la suma de los cuadrados de las columnas de Y y guárdelos en ss_y. Luego calcule la suma de cuadrados de columnas del YV transformado y almacénelos en ss_yv. Confirme que sum (ss_y) es igual a sum (ss_yv).

#¿Cuál es el valor de sum (ss_y) (y también el valor de sum (ss_yv))?

ss_y <- apply(y^2, 2, sum)
ss_yv <- apply((y%*%s$v)^2, 2, sum)
sum(ss_y)
sum(ss_yv)

#Q4

#Vemos que se conserva la suma total de cuadrados. Esto se debe a que V es ortogonal. Ahora para comenzar a entender cómo YV es útil, trace ss_y contra el número de columna y luego haga lo mismo para ss_yv.

#Que observas

plot(ss_y)
plot(ss_yv)


#Q5

#Ahora observe que no tuvimos que calcular ss_yv porque ya tenemos la respuesta. ¿Cómo? Recuerde que YV = UD y porque U es ortogonal, sabemos que la suma de los cuadrados de las columnas de UD son las entradas diagonales de D al cuadrado. Confirme esto trazando la raíz cuadrada de ss_yv versus las entradas diagonales de D.

data.frame(x = sqrt(ss_yv), y = s$d) %>%
  ggplot(aes(x,y)) +
  geom_point()


plot(sqrt(ss_yv), s$d)
abline(0,1)


#Q6

#Entonces, de lo anterior, sabemos que la suma de cuadrados de las columnas de \ (Y \) (la suma total de cuadrados) se suma a la suma de s $ d ^ 2 y que la transformación \ (YV \) nos da columnas con sumas de cuadrados iguales a s $ d ^ 2. Ahora calcule el porcentaje de la variabilidad total que se explica solo por las tres primeras columnas de \ (YV \).

#¿Qué proporción de la variabilidad total se explica por las tres primeras columnas de \ (YV \)?

sum(s$d[1:3]^2) / sum(s$d^2)


#Q7

#Antes de continuar, vamos a mostrar un truco computacional útil para evitar crear la matriz diag(s$d). Para motivar esto, notamos que si escribimos U en sus columnas [U1, U2, ..., Up] entonces UD es igual a

# UD = [U1d1, U2d2, ... , Updp,p]

#Use la funcion sweep() para calcular UD sin contruir diag(s$d) o usar una multiplicacion de matriz.

#Cual codigo es el correcto?

identical(s$u %*% diag(s$d), sweep(s$u, 2, s$d, FUN = "*"))


#Q8

#Sabemos que U1d1,1, la primera columna de UD, tiene la mayor variabilidad de todas las columnas de UD. Anteriormente vimos una imagen de Y usando my_image (y), en la que vimos que la variabilidad de estudiante a estudiante es bastante grande y que los estudiantes que son buenos en una materia tienden a ser buenos en todos. Esto implica que el promedio (en todas las asignaturas) de cada alumno debería explicar en gran medida la variabilidad. Calcule el puntaje promedio de cada estudiante, compárelo con U1d1,1 y describa lo que encuentre.

#Que observas

plot(-s$u[,1]*s$d[1], rowMeans(y))

#No hay relación entre el puntaje promedio de cada estudiante y U1d1,1.

#Existe una relación linealmente decreciente entre el puntaje promedio de cada estudiante y U1d1,1.

# Respuesta : #Hay una relación linealmente creciente entre el puntaje promedio de cada estudiante y U1d1,1.

#Existe una relación exponencialmente creciente entre el puntaje promedio de cada estudiante y U1d1,1.

#Existe una relación exponencialmente decreciente entre el puntaje promedio de cada estudiante y U1d1,1.


#Q9

#Notamos que los signos en SVD son arbitrarios porque:
  
#UDV⊤ = (- U) D (−V) ⊤
  
  
#Con esto en mente, vemos que la primera columna de UD es casi idéntica a la puntuación promedio de cada estudiante, excepto por el signo.

#Esto implica que multiplicar Y por la primera columna de V debe realizar una operación similar a tomar el promedio. Haga un diagrama de imagen de V y describa la primera columna en relación con otras y cómo se relaciona esto con tomar un promedio.

#¿Cómo se relaciona la primera columna con las otras, y cómo se relaciona esto con tomar un promedio?

my_image(s$v)

#La primera columna es muy variable, lo que implica que la primera columna de YV es la suma de las filas de Y multiplicada por alguna función no constante y, por lo tanto, no es proporcional a un promedio.

#La primera columna es muy variable, lo que implica que la primera columna de YV es la suma de las filas de Y multiplicada por alguna función no constante y, por lo tanto, es proporcional a un promedio.

#Respuesta: #La primera columna está muy cerca de ser una constante, lo que implica que la primera columna de YV es la suma de las filas de Y multiplicada por alguna constante y, por lo tanto, es proporcional a un promedio.

#Las tres primeras columnas están muy cerca de ser una constante, lo que implica que estas columnas son la suma de las filas de Y multiplicadas por alguna constante y, por lo tanto, son proporcionales a un promedio.
