#S03_C07_Bin_Smoothing_Kernels
#Bins, Smootings y Kernels

library(dslabs)
library(tidyverse)
library(caret)

data("polls_2008")

#La idea general del suavizado de bin es agrupar los puntos de datos en estratos en los que se puede suponer que el valor de f de x es constante.

#Podemos suponer esto porque pensamos que f de x cambia lentamente.

#Y como resultado, f de x es casi constante en pequeñas ventanas de tiempo.

#Un ejemplo de esta idea es suponer para los datos de la encuesta que la opinión pública permanece aproximadamente igual en el plazo de una semana.

#Con esta suposición establecida, tenemos varios puntos de datos con el mismo valor esperado.

#Entonces, si arreglamos un día para estar en el centro de nuestra semana, llámelo x0, entonces, para cualquier día x, de modo que el valor absoluto de x menos x0 sea menor que 3.5, asumimos que f de x es una constante.

#Llamémoslo mu.

#Esta suposición implica que el valor esperado de y dado x es aproximadamente mu cuando la distancia entre x i y x0 es menor que 3.5.

#En el suavizado, llamamos al tamaño del intervalo que satisface la condición, la distancia entre xi y x0 es menor que 3.5 el tamaño de la ventana, el ancho de banda o el lapso.

#Todos estos son sinónimos.

#Ahora, esta suposición implica que una buena estimación para f de x es el promedio de los valores de y en la ventana.

#Si definimos A0 como el conjunto de índices i tal que xi menos x0 es menor que 3.5 en valor absoluto y N0 como el número de índices en A0, entonces nuestra estimación viene dada por esta fórmula.

#Es simplemente el promedio en la ventana.

#La idea detrás del suavizado de bin es hacer este cálculo para cada valor de x.

#Entonces hacemos que cada valor de x sea el centro y recalculemos ese promedio.

#Entonces, en el ejemplo de la encuesta, para cada día, calcularíamos el promedio de los valores dentro de una semana del día que estamos considerando.

#Veamos dos ejemplos.

#Establezcamos el centro en negativo 125 y luego también en negativo 55.

#Así es como se ven los datos.

#Los puntos negros son los puntos que se utilizan para calcular el promedio en esos dos puntos.

#La línea azul representa el promedio que se calculó.

#Al calcular este promedio para cada punto, formamos una estimación de la curva subyacente f de x.

#En esta animación, vemos que ocurre el procedimiento, comenzando en 155 negativos hasta el día de las elecciones, día 0.

#En cada valor de x0, mantenemos la estimación de f0x y pasamos al siguiente punto.

#El resultado final, que puede calcular utilizando este código, se ve así.


span <- 7

fit <- with(polls_2008, ksmooth(day, margin, x.points = day, kernel = "box", bandwidth = span))

polls_2008 %>% mutate(smooth= fit$y) %>% 
  ggplot(aes(day, margin)) + 
  geom_point(size = 3, alpha = .5, color = "blue") +
  geom_line(aes(day, smooth), color = "red")


#Tenga en cuenta que el resultado final para el bin suavizador es bastante ondulante.

#Una razón para esto es que cada vez que la ventana se mueve, cambian dos puntos.

#Entonces, si comenzamos con siete puntos y cambiamos dos, ese es un porcentaje sustancial de puntos que están cambiando.

#Podemos atenuar esto un poco tomando promedios ponderados que le dan al centro de un punto más peso que aquellos que están lejos del centro, con los dos puntos en los bordes recibiendo muy poco peso.

#Llamamos a las funciones a partir de las cuales calculamos estos pesos el KERNEL.

#Tenga en cuenta que puede pensar en el bin suavizador como un enfoque que utiliza un kernel o nucleo.

#La fórmula se ve así.

#Cada punto recibe un peso, en el caso de los suavizadores de contenedores, entre 0 para los puntos que están fuera de la ventana y 1 dividido por N0 para los puntos dentro de la ventana, con N0 el número de puntos en esa semana.

#En el código que mostramos, le dijimos a la función k-smooth que usara el "cuadro" del núcleo.

#Esto se debe a que el núcleo que nos da un bin más suave con esta formulación parece una caja.

#Aquí hay una foto.

#Ahora, la función k-smooth proporciona una forma de obtener una estimación más uniforme.

#Esto es mediante el uso de la densidad normal o gaussiana para asignar pesos.

#Entonces el núcleo será la densidad normal, que podemos ver aquí.

#En esta animación, el tamaño de los puntos representa los pesos que obtienen en el promedio ponderado.

#Puede ver que los puntos cerca de los bordes reciben poco peso.

#El resultado final, que puede obtener usando este código, se ve así.

span <- 7
fit <- with(polls_2008, ksmooth(day, margin,  x.points = day, kernel="normal", bandwidth = span))
polls_2008 %>% mutate(smooth = fit$y) %>%
  ggplot(aes(day, margin)) +
  geom_point(size = 3, alpha = .5, color = "blue") + 
  geom_line(aes(day, smooth), color="red")




#Tenga en cuenta que la estimación final se ve más suave ahora.

#Ahora, hay varias funciones en R que implementan suavizadores de bin o enfoques de kernel.

#Un ejemplo, el que mostramos, es k-smooth.

#Sin embargo, en la práctica, generalmente preferimos métodos que usan modelos ligeramente más complejos que ajustar una constante.

#El resultado final que vimos para el bin bin liso aún es algo ondulante.

#Puede ver en algunas partes, por ejemplo, de 125 negativo a 75 negativo, vemos que la función es más flexible de lo que realmente esperamos.

#Ahora vamos a aprender acerca de los enfoques que mejoran en esto.