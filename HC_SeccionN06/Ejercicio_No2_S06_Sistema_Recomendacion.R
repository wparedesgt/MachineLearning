#Ejercicio_No2_S06_Sistema_Recomendacion

#Los siguientes ejercicios funcionan con los datos de movielens, que se pueden cargar con el siguiente código:

library(tidyverse)
library(caret)
library(dslabs)

data("movielens")


#Q1

#Calcule el número de calificaciones para cada película y luego compárelo con el año en que salió la película. Use la transformación de raíz cuadrada en los recuentos.

#¿En qué año tiene el mayor número medio de calificaciones?


head(movielens)

movielens %>% group_by(movieId) %>%
  summarize(n = n(), year = as.character(first(year))) %>%
  qplot(year, n, data = ., geom = "boxplot") + 
  coord_trans(y = "sqrt") +
  theme(axis.text = element_text(angle = 90, hjust = 1))

#Q2

#Vemos que, en promedio, las películas que salieron después de 1993 obtienen más calificaciones. También vemos que con las películas más nuevas, a partir de 1993, el número de calificaciones disminuye con el año: cuanto más reciente es una película, menos tiempo han tenido los usuarios para calificarla.

#Entre las películas que salieron en 1993 o más tarde, seleccione las 25 mejores películas con el mayor número promedio de calificaciones por año (n / año) y calcule la calificación promedio de cada una de ellas. Para calcular el número de calificaciones por año, use 2018 como el año final.

#¿Cuál es la calificación promedio de la película The Shawshank Redemption?

names(movielens)

movielens %>% filter(year >= 1993) %>% 
  group_by(movieId) %>%
  summarize(n = n(), years = 2018 - first(year), 
            title = title[1], 
            rating = mean(rating)) %>%
  mutate(rate = n/years) %>%
  top_n(25, rate) %>% 
  arrange(desc(rate))


#¿Cuál es el número promedio de calificaciones por año para la película Forrest Gump?


#Q3

#De la tabla construida en Q2, podemos ver que las películas clasificadas con más frecuencia tienden a tener calificaciones superiores al promedio. Esto no es sorprendente: más personas miran películas populares. Para confirmar esto, estratifique las películas posteriores a 1993 por calificaciones por año y calcule sus calificaciones promedio. Para calcular el número de calificaciones por año, use 2018 como el año final. Haga un gráfico de calificación promedio versus calificaciones por año y muestre una estimación de la tendencia.

#¿Qué tipo de tendencia observas?

movielens %>% 
  filter(year >= 1993) %>%
  group_by(movieId) %>%
  summarize(n = n(), years = 2017 - first(year),
            title = title[1],
            rating = mean(rating)) %>%
  mutate(rate = n/years) %>%
  ggplot(aes(rate, rating)) +
  geom_point() +
  geom_smooth()



#Q4

#Suponga que está haciendo un análisis predictivo en el que necesita completar las calificaciones faltantes con algún valor.

#Dadas sus observaciones en el ejercicio del tercer trimestre, ¿cuál de las siguientes estrategias sería la más adecuada?




#Q5

#El conjunto de datos movielens también incluye una marca de tiempo. Esta variable representa el tiempo y los datos en los que se proporcionó la calificación. Las unidades son segundos desde el 1 de enero de 1970. Cree una nueva fecha de columna con la fecha.

#¿Qué código crea correctamente esta nueva columna?

library(tidyverse)
library(lubridate)

movielens <- mutate(movielens, date = as_datetime(timestamp))


#Calcule la calificación promedio de cada semana y calcule este promedio contra el día. Sugerencia: use la función round_date antes de group_by.

#¿Qué tipo de tendencia observas?

movielens %>% mutate(date = round_date(date, unit = "week")) %>%
  group_by(date) %>%
  summarize(rating = mean(rating)) %>%
  ggplot(aes(date, rating)) +
  geom_point() +
  geom_smooth()


#Q8

#Los datos de movielens también tienen una columna de géneros. Esta columna incluye todos los géneros que se aplican a la película. Algunas películas pertenecen a varios géneros. Defina una categoría como cualquier combinación que aparezca en esta columna. Mantenga solo categorías con más de 1,000 calificaciones. Luego calcule el error promedio y estándar para cada categoría. Trace estos como diagramas de barras de error.

#¿Qué género tiene la calificación promedio más baja?

summary(movielens)

movielens %>% group_by(genres) %>%
  summarize(n = n(), avg = mean(rating), se = sd(rating)/sqrt(n())) %>%
  filter(n >= 1000) %>% 
  mutate(genres = reorder(genres, avg)) %>%
  ggplot(aes(x = genres, y = avg, ymin = avg - 2*se, ymax = avg + 2*se)) + 
  geom_point() +
  geom_errorbar() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
