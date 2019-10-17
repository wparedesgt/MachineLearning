#Ejercicio_No3_S06_Regularizacion

#Los ejercicios en Q1-Q8 funcionan con un conjunto de datos simulado para 1000 escuelas. Esta configuración previa al ejercicio lo guía a través del código necesario para simular el conjunto de datos.

#Un experto en educación aboga por escuelas más pequeñas. El experto basa esta recomendación en el hecho de que entre las mejores escuelas, muchas son escuelas pequeñas. Simulemos un conjunto de datos para 1000 escuelas. Primero, simulemos el número de estudiantes en cada escuela, usando el siguiente código:

library(tidyverse)
library(caret)

set.seed(1986, sample.kind = "Rounding")
n <- round(2^rnorm(1000, 8, 1))


#Ahora asignemos una verdadera calidad para cada escuela que sea completamente independiente del tamaño. Este es el parámetro que queremos estimar en nuestro análisis. La verdadera calidad se puede asignar utilizando el siguiente código:

set.seed(1, sample.kind="Rounding")

mu <- round(80 + 2*rt(1000, 5))
range(mu)
schools <- tibble(id = paste("PS",1:1000),
                      size = n,
                      quality = mu,
                      rank = rank(-mu))

#Ver el top 10 de las escuelas


schools %>% top_n(10, quality) %>% arrange(desc(quality))


#Ahora hagamos que los estudiantes en la escuela tomen un examen. Existe una variabilidad aleatoria en la toma de exámenes, por lo que simularemos los puntajes de los exámenes como normalmente se distribuyen con el promedio determinado por la calidad de la escuela con una desviación estándar de 30 puntos porcentuales. Este código simulará los puntajes de las pruebas:


set.seed(1, sample.kind="Rounding")

mu <- round(80 + 2*rt(1000, 5))

scores <- sapply(1:nrow(schools), function(i){
  scores <- rnorm(schools$size[i], schools$quality[i], 30)
  scores
})
schools <- schools %>% mutate(score = sapply(scores, mean))


#¿Cuáles son las mejores escuelas según el puntaje promedio? Muestra solo la identificación, el tamaño y el puntaje promedio.

#Informe la identificación de la escuela superior y el puntaje promedio de la décima escuela.

#¿Cuál es la identificación de la escuela superior?

#Tenga en cuenta que las identificaciones de la escuela se dan en la forma "PS x", donde x es un número. Informe solo el número.

head(scores)
head(schools)


schools %>% top_n(10, score) %>% arrange(desc(score)) %>% select(id, size, score)

#Compare el tamaño medio de la escuela con el tamaño medio de las 10 mejores escuelas según el puntaje.

#¿Cuál es el tamaño promedio de la escuela en general?

options(digits = 10)

schools_tp10 <- schools %>% top_n(10, score) %>% arrange(desc(score)) %>% select(id, size, score)

median(schools$size)
schools %>% top_n(10, score) %>% .$size %>% median()


#Q3

#Según este análisis, parece que las escuelas pequeñas producen mejores puntajes en las pruebas que las escuelas grandes. Cuatro de las 10 mejores escuelas tienen 100 o menos estudiantes. ¿Pero como puede ser ésto? Construimos la simulación para que la calidad y el tamaño fueran independientes. Repita el ejercicio para las peores 10 escuelas.

#¿Cuál es el tamaño medio de escuela de las 10 escuelas inferiores según el puntaje?

median(schools$size)
schools %>% top_n(-10, score) %>% .$size %>% median()


#Q4

#De este análisis, vemos que las peores escuelas también son pequeñas. Trace el puntaje promedio versus el tamaño de la escuela para ver qué está pasando. Destaque las 10 mejores escuelas según la verdadera calidad.


schools %>% ggplot(aes(size, score)) +
  geom_point(alpha = 0.5) +
  geom_point(data = filter(schools, rank<=10), col = 2) 


#Podemos ver que el error estándar de la puntuación tiene una mayor variabilidad cuando la escuela es más pequeña. Esta es una realidad estadística básica que aprendimos en PH125.3x: Ciencia de datos: probabilidad y PH125.4x: Ciencia de datos: ¡Inferencia y cursos de modelado! Tenga en cuenta también que varias de las 10 mejores escuelas basadas en la calidad real también se encuentran en las 10 mejores escuelas según la puntuación del examen: 


schools %>% top_n(10, score) %>% arrange(desc(score))


#Q5

#Usemos la regularización para elegir las mejores escuelas. Recuerde que la regularización reduce las desviaciones del promedio hacia 0. Para aplicar la regularización aquí, primero debemos definir el promedio general para todas las escuelas, utilizando el siguiente código:

overall <- mean(sapply(scores, mean))


#Luego, debemos definir, para cada escuela, cómo se desvía de ese promedio.

#Escriba un código que calcule el puntaje por encima del promedio de cada escuela pero dividiéndolo entre n + α en lugar de n, con n el tamaño de la escuela y α un parámetro de regularización. Prueba α = 25.

#¿Cuál es la identificación de la escuela superior con regularización?

#Tenga en cuenta que las identificaciones de la escuela se dan en la forma "PS x", donde x es un número. Informe solo el número.

a <- 25

score_reg <- sapply(scores, function(x)  overall + sum(x-overall)/(length(x)+a))


schools %>% mutate(score_reg = score_reg) %>%
  top_n(10, score_reg) %>% arrange(desc(score_reg))


#Q6

#Tenga en cuenta que esto mejora un poco las cosas. El número de escuelas pequeñas que no están altamente clasificadas ahora es menor. ¿Hay una mejor α? Usando valores de α de 10 a 250, encuentre la α que minimiza el RMSE.

#RMSE = 11000∑i = 11000 (quality - estimate)2

#¿Qué valor de α da el mínimo RMSE?

alphas <- seq(10,250,1)

rmse <- sapply(alphas, function(a) {
  score_reg <- sapply(scores, function(x) overall + sum(x-overall) / (length(x)+a))
  mean((score_reg - schools$quality)^2)
})
plot(alphas, rmse)
alphas[which.min(rmse)]


#Q7

#Clasifique las escuelas según el promedio obtenido con la mejor α. Tenga en cuenta que ninguna escuela pequeña se incluye incorrectamente.

#¿Cuál es la identificación de la mejor escuela ahora?

a <- 135

score_reg <- sapply(scores, function(x)  overall + sum(x-overall)/(length(x)+a))


schools %>% mutate(score_reg = score_reg) %>%
  top_n(10, score_reg) %>% arrange(desc(score_reg))


#Q8

#Un error común al usar la regularización es reducir los valores hacia 0 que no están centrados alrededor de 0. Por ejemplo, si no restamos el promedio general antes de reducir, en realidad obtenemos un resultado muy similar. Confirme esto volviendo a ejecutar el código del ejercicio en Q6 pero sin eliminar la media general.

#¿Qué valor de α da el mínimo RMSE aquí?


alphas <- seq(10,250)
rmse <- sapply(alphas, function(alpha){
  score_reg <- sapply(scores, function(x) sum(x)/(length(x)+alpha))
  mean((score_reg - schools$quality)^2)
})
plot(alphas, rmse)
alphas[which.min(rmse)]  
