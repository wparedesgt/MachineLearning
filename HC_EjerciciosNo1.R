#Ejercicios

#Las siguientes preguntas le piden que trabaje con el conjunto de datos que se describe a continuación.

#Los conjuntos de datos informados de alturas y alturas se recopilaron de tres clases impartidas en los Departamentos de Ciencias de la Computación y Bioestadística, así como de forma remota a través de la Escuela de Extensión.

#La clase de bioestadística se impartió en 2016 junto con una versión en línea ofrecida por la Escuela de Extensión. El 2016-01-25 a las 8:15 am, durante una de las conferencias, los instructores pidieron al estudiante que completara el cuestionario de sexo y talla que llenaba el conjunto de datos reportado de Height.

#Los estudiantes en línea completaron la encuesta durante los próximos días, después de que la conferencia se publicara en línea. Podemos usar esta información para definir una variable a la que llamaremos tipo, para indicar el tipo de estudiante, clase o en línea.

#El siguiente código configura el conjunto de datos para que los analices en los siguientes ejercicios:

library(dslabs)
library(dplyr)
library(lubridate)


data("reported_heights")




dat <- mutate(reported_heights, date_time = ymd_hms(time_stamp)) %>%
  filter(date_time >= make_date(2016, 01, 25) & date_time < make_date(2016, 02, 1)) %>%
  mutate(type = ifelse(day(date_time) == 25 & hour(date_time) == 8 & between(minute(date_time), 15, 30), "inclass","online")) %>%
  select(sex, type)

y <- factor(dat$sex, c("Female", "Male"))
x <- dat$type


#mean(y == "Female" & x == "inclass")
#mean(y == "Female" & x == "online")

#table(x,y)
#prop.table(table(x,y))

#Respuesta
datos01 <- dat %>% group_by(type) %>% summarize(mean(sex == "Female"))


dat %>% group_by(type) %>% summarize(prop_female = mean(sex == "Female"))


## Si utilizara la variable de tipo para predecir el sexo, ¿cuál sería la precisión de la predicción?

library(caret)

set.seed(2)
test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)


#Podemos usar este índice para definir el conjunto de entrenamiento y el conjunto de prueba como este.

train_set <- dat[-test_index,]
test_set <- dat[test_index,]




y_hat <- sample(c("Male", "Female"),
                length(test_index), replace = TRUE) %>%
  factor(levels = levels(test_set$sex))




mean(y_hat == test_set$sex)
