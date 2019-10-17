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

