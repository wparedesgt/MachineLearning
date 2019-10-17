#S06_C39_Regularizacion

library(dslabs)
library(tidyverse)
library(caret)
data("movielens")
set.seed(755)
test_index <- createDataPartition(y = movielens$rating, times = 1,
                                  p = 0.2, list = FALSE)
train_set <- movielens[-test_index,]
test_set <- movielens[test_index,]
test_set <- test_set %>% 
  semi_join(train_set, by = "movieId") %>%
  semi_join(train_set, by = "userId")
RMSE <- function(true_ratings, predicted_ratings){
  sqrt(mean((true_ratings - predicted_ratings)^2))
}
mu_hat <- mean(train_set$rating)
naive_rmse <- RMSE(test_set$rating, mu_hat)
rmse_results <- data_frame(method = "Just the average", RMSE = naive_rmse)
mu <- mean(train_set$rating) 
movie_avgs <- train_set %>% 
  group_by(movieId) %>% 
  summarize(b_i = mean(rating - mu))
predicted_ratings <- mu + test_set %>% 
  left_join(movie_avgs, by='movieId') %>%
  .$b_i
model_1_rmse <- RMSE(predicted_ratings, test_set$rating)
rmse_results <- bind_rows(rmse_results,
                          data_frame(method="Movie Effect Model",
                                     RMSE = model_1_rmse ))
user_avgs <- test_set %>% 
  library(tidyverse)
library(dslabs)

data("movielens")


library(caret)
set.seed(755)
test_index <- createDataPartition(y = movielens$rating, times = 1,
                                  p = 0.2, list = FALSE)
train_set <- movielens[-test_index,]
test_set <- movielens[test_index,]

test_set <- test_set %>% 
  semi_join(train_set, by = "movieId") %>%
  semi_join(train_set, by = "userId")


mu <- mean(train_set$rating)

movie_avgs <- train_set %>% 
  group_by(movieId) %>% 
  summarize(b_i = mean(rating - mu))

  left_join(movie_avgs, by='movieId') %>%
  group_by(userId) %>%
  summarize(b_u = mean(rating - mu - b_i))
predicted_ratings <- test_set %>% 
  left_join(movie_avgs, by='movieId') %>%
  left_join(user_avgs, by='userId') %>%
  mutate(pred = mu + b_i + b_u) %>%
  .$pred
model_2_rmse <- RMSE(predicted_ratings, test_set$rating)
rmse_results <- bind_rows(rmse_results,
                          data_frame(method="Movie + User Effects Model",  
                                     RMSE = model_2_rmse ))


options(digits = 3)


#En este video, presentaremos el concepto de regularización y mostraremos cómo puede mejorar aún más nuestros resultados.

#Esta es una de las técnicas que utilizaron los ganadores del desafío de Netflix.

#Todo bien.

#¿Entonces, cómo funciona?
  
#Tenga en cuenta que a pesar de la gran variación de película a película, nuestra mejora en el error cuadrático medio residual cuando solo incluimos el efecto de película fue solo de aproximadamente 5%.

#Entonces, veamos por qué sucedió esto.

#Veamos por qué no era más grande.

#Exploremos dónde cometimos errores en nuestro primer modelo cuando solo usamos películas.

#Aquí hay 10 de los errores más grandes que cometimos cuando solo usamos los efectos de película en nuestros modelos.

#Aquí están.

test_set %>% 
  left_join(movie_avgs, by = 'movieId') %>% 
  mutate(residual = rating - (mu + b_i)) %>%
  arrange(desc(abs(residual))) %>% 
  select(title, residual) %>% slice(1:10) %>% knitr::kable()


#Tenga en cuenta que todas estas películas parecen oscuras y, en nuestro modelo, muchas de ellas obtuvieron grandes predicciones.

#¿Entonces porque paso esto?
  
#Para ver lo que está sucediendo, echemos un vistazo a las 10 mejores películas de las 10 peores películas según las estimaciones del efecto de película b-hat_i.

movie_titles <- movielens %>% 
  select(movieId, title) %>% 
  distinct()

#Para que podamos ver los títulos de las películas, vamos a crear una base de datos que incluya la identificación de la película y los títulos usando este código muy simple.

movie_avgs %>% left_join(movie_titles, by = 'movieId') %>%
  arrange(desc(b_i)) %>% 
  select(title, b_i) %>% 
  slice(1:10) %>% 
  knitr::kable()


#Así que aquí están las 10 mejores películas según nuestras estimaciones.

#"Lamerica" es el número uno, "Love & Human Remains" también es el número uno, "L'Enfer" es el número uno.

#Mira el resto de las películas en esta tabla.

#Y aquí están las 10 peores películas principales.

movie_avgs %>% left_join(movie_titles, by = 'movieId') %>%
  arrange(b_i) %>% 
  select(title, b_i) %>% 
  slice(1:10) %>% 
  knitr::kable()

#El primero comenzó con "Santa con músculos".

#Ahora todos tienen algo en común.

#Todos son bastante oscuros.

#Así que veamos con qué frecuencia fueron calificados.

train_set %>% count(movieId) %>% 
  left_join(movie_avgs) %>% 
  left_join(movie_titles, by = 'movieId') %>% 
  arrange(desc(b_i)) %>% 
  select(title, b_i, n) %>% 
  slice(1:10) %>% 
  knitr::kable()


#Aquí está la misma tabla, pero ahora incluimos el número de calificaciones que recibieron en nuestro conjunto de entrenamiento.

#Podemos ver lo mismo para las malas películas.


train_set %>% count(movieId) %>% 
  left_join(movie_avgs) %>% 
  left_join(movie_titles, by = 'movieId') %>% 
  arrange(b_i) %>% 
  select(title, b_i, n) %>% 
  slice(1:10) %>% 
  knitr::kable()

#Así que las supuestas mejores y peores películas fueron calificadas por muy pocos usuarios, en la mayoría de los casos solo uno.


#Estas películas eran en su mayoría oscuras.

#Esto se debe a que con solo unos pocos usuarios, tenemos más incertidumbre, por lo tanto, mayores estimaciones de bi, negativo o positivo, son más probables cuando menos usuarios califican las películas.

#Estas son básicamente estimaciones ruidosas en las que no debemos confiar, especialmente cuando se trata de predicciones.

#Los errores grandes pueden aumentar nuestro error cuadrático medio residual, por lo que preferimos ser conservadores cuando no estamos seguros.

#Anteriormente aprendimos a calcular errores estándar y construir intervalos de confianza para tener en cuenta los diferentes niveles de incertidumbre.

#Sin embargo, cuando hacemos predicciones necesitamos un número, una predicción, no un intervalo.

#Para esto, presentamos el concepto de regularización.

#La regularización nos permite penalizar grandes estimaciones que provienen de pequeños tamaños de muestra.

#Tiene puntos en común con los enfoques bayesianos que redujeron las predicciones.

#La idea general es agregar una penalización para valores grandes de b a la suma de las ecuaciones de cuadrados que minimizamos.

#Por lo tanto, tener muchos B grandes hace que sea más difícil minimizar la ecuación que estamos tratando de minimizar.

#Una forma de pensar en esto es que si tuviéramos que ajustar un efecto a cada calificación, podríamos, por supuesto, hacer la ecuación de la suma de los cuadrados simplemente haciendo que cada b coincida con su calificación respectiva y.

#Esto produciría una estimación inestable que cambia drásticamente con nuevas instancias de y.

#Recuerde que y es una variable aleatoria.

#Pero al penalizar la ecuación, optimizamos para ser más grandes cuando las estimaciones b están lejos de cero.

#Luego reducimos las estimaciones a cero.

#Nuevamente, esto es similar al enfoque bayesiano que hemos visto antes.

#Entonces esto es lo que hacemos.

#Para estimar los b en lugar de minimizar la suma residual de cuadrados como se hace por mínimos cuadrados, ahora minimizamos esta ecuación.

#Tenga en cuenta el plazo de penalización.

#El primer término es solo la suma residual de los cuadrados y el segundo es una penalización que aumenta cuando muchas b son grandes.

#Con el cálculo, podemos mostrar que los valores de b que minimizan esta ecuación están dados por esta fórmula, donde n_i es un número de clasificaciones b para la película i.

#Tenga en cuenta que este enfoque tendrá el efecto deseado.

#Cuando n_i es muy grande, lo que nos dará una estimación estable, entonces lambda se ignora efectivamente porque n_i más lambda es casi igual a n_i.

#Sin embargo, cuando n_i es pequeño, la estimación de b_i se reduce a cero.

#Cuanto más grande es la lambda, más nos encogemos.

#Entonces, calculemos estas estimaciones regularizadas de b_i usando lambda igual a 3.0.

#Más adelante vemos por qué elegimos este número.

#Entonces aquí está el código.

lambda <- 3

mu <- mean(train_set$rating)

movie_reg_avgs <- train_set %>% 
  group_by(movieId) %>% 
  summarize(b_i = sum(rating - mu)/(n() + lambda), n_i = n() )



#Para ver cómo se reducen las estimaciones, hagamos un gráfico de la estimación regularizada versus las estimaciones de mínimos cuadrados con el tamaño del círculo que nos dice qué tan grande era ni.

tibble(original = movie_avgs$b_i, 
           regularlized = movie_reg_avgs$b_i, 
           n = movie_reg_avgs$n_i) %>%
  ggplot(aes(original, regularlized, size=sqrt(n))) + 
  geom_point(shape=1, alpha=0.5)


#Puede ver que cuando n es pequeño, los valores se reducen más hacia cero.

#Muy bien, así que ahora veamos nuestras 10 mejores películas basadas en las estimaciones que obtuvimos al usar la regularización.

train_set %>% 
  count(movieId) %>% 
  left_join(movie_reg_avgs) %>% 
  left_join(movie_titles, by = 'movieId') %>% 
  arrange(desc(b_i)) %>% 
  select(title, b_i, n) %>% 
  slice(1:10) %>% 
  knitr::kable()


#Tenga en cuenta que las cinco películas principales ahora son "All About Eve", "Shawshank Redemption", "The Godfather", "The Godfather II" y "The Maltese Falcons".

#Esto tiene mucho más sentido.


train_set %>% 
  count(movieId) %>% 
  left_join(movie_reg_avgs) %>% 
  left_join(movie_titles, by = 'movieId') %>% 
  arrange(b_i) %>% 
  select(title, b_i, n) %>% 
  slice(1:10) %>% 
  knitr::kable()

#También podemos ver las peores películas y las peores cinco son "Battlefield Earth", "Joe's Apartment", "Speed 2: Cruise Control", "Super Mario Bros" y "Police Academy 6: City Under Siege".

#De nuevo, esto tiene sentido.

#Entonces, ¿mejoramos nuestros resultados?
  
#Ciertamente lo hacemos.

predicted_ratings <- test_set %>% 
  left_join(movie_reg_avgs, by = 'movieId') %>% 
  mutate(pred = mu+ b_i) %>% 
  .$pred
  
model_3_rmse <- RMSE(predicted_ratings, test_set$rating)

rmse_results <- bind_rows(rmse_results,
                          data_frame(method="Regularized Movie Effect Model",  
                                     RMSE = model_3_rmse ))


rmse_results %>% knitr::kable()

#Obtenemos el error cuadrático medio residual hasta 0.885 desde 0.986.

#Entonces esto proporciona una mejora muy grande.

#Ahora tenga en cuenta que lambda es un parámetro de ajuste.

#Podemos usar validación cruzada para elegirlo.

#Podemos usar este código para hacer esto.


lambdas <- seq(0,10,0.25)

mu <- mean(train_set$rating)

just_the_sum <- train_set %>% 
  group_by(movieId) %>% 
  summarize(s = sum(rating - mu), n_i = n())

rmses <- sapply(lambdas, function(l){
  predicted_ratings <- test_set %>% 
    left_join(just_the_sum, by='movieId') %>% 
    mutate(b_i = s/(n_i+l)) %>%
    mutate(pred = mu + b_i) %>%
    .$pred
  return(RMSE(predicted_ratings, test_set$rating))
})


qplot(lambdas, rmses)

lambdas[which.min(rmses)]

#Y vemos por qué elegimos 3.0 como lambda.

#Un punto importante

#Tenga en cuenta que mostramos esto como una ilustración y, en la práctica, deberíamos usar la validación cruzada completa solo en un conjunto de entrenamiento sin usar el conjunto de prueba hasta la evaluación final.

#También podemos usar la regularización para estimar el efecto del usuario.

#La ecuación que minimizaríamos sería esta ahora.

#Incluye los parámetros para los efectos del usuario también.

#Las estimaciones que minimizan esto se pueden encontrar de manera similar a lo que hicimos anteriormente.

#Aquí nuevamente usamos validación cruzada para ehead(schools)legir lambda.

#El código se ve así, y vemos qué lambda minimiza nuestra ecuación.

lambdas <- seq(0,10,0.25)

rmses <- sapply(lambdas, function(l) {
  mu <- mean(train_set$rating)
  
  b_i <- train_set %>%
    group_by(movieId) %>% 
    summarize(b_i = sum(rating - mu)/(n() +l))
  
  b_u <- train_set %>% 
    left_join(b_i, by = 'movieId') %>% 
    group_by(userId) %>% 
    summarize(b_u = sum(rating - b_i - mu )/(n()+l))
  
  predicted_ratings <- 
    test_set %>%
    left_join(b_i, by = 'movieId') %>% 
    left_join(b_u, by = 'userId') %>% 
    mutate(pred = mu + b_i + b_u) %>% 
    .$pred
  return(RMSE(predicted_ratings, test_set$rating))
  
})

qplot(lambdas, rmses)

#Para el modelo completo que incluye películas y efectos de usuario, el lambda óptimo es 3.75.

lambda <- lambdas[which.min(rmses)]

lambda

#Y podemos ver que efectivamente mejoramos nuestro error cuadrático medio residual.

#Ahora es 0.881.

rmse_results <- bind_rows(rmse_results,
                          data_frame(method="Regularized Movie + User Effect Model",  
                                     RMSE = min(rmses)))
rmse_results %>% knitr::kable()
