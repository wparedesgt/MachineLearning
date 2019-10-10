#S06_C38_Construyendo_Sistemas_de_recomendación
#Construyendo el sistema de recomendación
#cargar la pagina S06_C37

#Los ganadores del desafío de Netflix implementaron dos clases generales de modelos.

#Uno era similar a los vecinos más cercanos (k-nn), donde encontrabas películas que eran similares entre sí y usuarios que eran similares entre sí.

#El otro se basó en un enfoque llamado factorización matricial.

#Ese es en el que nos vamos a centrar aquí.

#Entonces, comencemos a construir estos modelos.

#Comencemos construyendo el sistema de recomendación más simple posible.

#Vamos a predecir la misma calificación para todas las películas, independientemente del usuario y la película.

#Entonces, ¿qué número debemos predecir?
  
#Podemos usar un enfoque basado en modelos.

#Un modelo que asume la misma calificación para todas las películas y todos los usuarios, con todas las diferencias explicadas por la variación aleatoria, se vería así.

#Aquí epsilon representa errores independientes muestreados de la misma distribución centrada en cero, y mu representa la calificación real para todas las películas y usuarios.

#Sabemos que la estimación que minimiza el error cuadrático medio residual es la estimación de mínimos cuadrados de mu.

#Y en este caso, ese es solo el promedio de todas las calificaciones.

#Podemos calcularlo así.
options(digits = 3)

mu_hat <- mean(train_set$rating)
mu_hat

#Ese promedio es 3.54.

#Esa es la calificación promedio de todas las películas de todos los usuarios.

#Entonces, veamos qué tan bien funciona esta película.

#Calculamos este promedio en los datos de entrenamiento.

#Y luego calculamos el error cuadrático medio residual en los datos del conjunto de prueba.

#Así que estamos prediciendo todas las calificaciones desconocidas con este promedio.

native_rmse <- RMSE(test_set$rating, mu_hat)

native_rmse

#Obtenemos un error cuadrático medio residual de aproximadamente 1.05.

#Eso es bastante grande.

#Ahora tenga en cuenta que si conecta cualquier otro número, obtendrá un RMSE más alto.

#Eso es lo que se supone que debe suceder, porque sabemos que el promedio minimiza el error cuadrático medio residual cuando se usa este modelo.

#Y puedes verlo con este código.

predictions <- rep(2.5, nrow(test_set))
RMSE(test_set$rating, predictions)

#Entonces obtenemos un error cuadrático medio residual de aproximadamente 1.

#Para ganar el gran premio de $ 1 millón, un equipo participante tuvo que llegar a un error cuadrático medio residual de aproximadamente 0,857.

#Entonces definitivamente podemos hacerlo mejor.

#Ahora, a medida que avanzamos, compararemos diferentes enfoques, crearemos una tabla que almacenará los resultados que obtenemos a medida que avanzamos.

#Lo llamaremos resultados RMSE.

#Se creará con este código.


rmse_results <- tibble(method = "Just the average", RMSE = naive_rmse)

#Todo bien.

#Entonces, veamos cómo podemos hacerlo mejor.

#Sabemos por experiencia que algunas películas generalmente tienen una calificación más alta que otras.

#Podemos ver esto simplemente haciendo un diagrama de la calificación promedio que obtuvo cada película.

#Por lo tanto, nuestra intuición de que las diferentes películas se clasifican de manera diferente se confirma con datos.

#Entonces, podemos aumentar nuestro modelo anterior agregando un término, b_i, para representar la calificación promedio de la película i.

#En estadística, generalmente llamamos a estos b's, efectos.

#Pero en los documentos de desafío de Netflix, se refieren a ellos como "sesgo" "bias", por lo tanto, el b en la notación.

#Todo bien.

#De nuevo podemos usar estos cuadrados para estimar las b de la siguiente manera, así.

fit <- lm(rating ~ as.factor(userId), data = movielens)

#Sin embargo, tenga en cuenta que debido a que hay miles de b, cada película obtiene un parámetro, una estimación.

#Entonces la función lm será muy lenta aquí.

#Por lo tanto, no recomendamos ejecutar el código que acabamos de mostrar.

#Sin embargo, en esta situación particular, sabemos que la estimación de mínimos cuadrados, b-hat_i, es solo el promedio de y_u, i menos la media general de cada película, i.

#Entonces podemos calcularlos usando este código.

mu <- mean(train_set$rating)

movie_avgs <- train_set %>% 
  group_by(movieId) %>% 
  summarize(b_i = mean(rating - mu))

#Tenga en cuenta que vamos a eliminar la notación del sombrero en el código para representar las estimaciones en el futuro, solo para hacer que el código sea más limpio.

#Entonces este código completa las estimaciones para los b.

#Podemos ver que estas estimaciones varían sustancialmente, no es sorprendente.

movie_avgs %>% qplot(b_i, geom ="histogram", bins = 10, data = ., color = I("black"))

#Algunas películas son buenas.

#Otras películas son malas.

#Recuerde, el promedio general es de aproximadamente 3.5.

#Entonces, una b i de 1.5 implica una calificación perfecta de cinco estrellas.

#Ahora veamos cuánto mejora nuestra predicción una vez que predijamos usando el modelo que acabamos de ajustar.

#Podemos usar este código y ver que nuestro error cuadrático medio residual cayó un poco.

naive_rmse <- RMSE(test_set$rating, mu_hat)

rmse_results <- data_frame(method = "Just the average", RMSE = naive_rmse)

predicted_ratings <- mu + test_set %>% 
  left_join(movie_avgs, by='movieId') %>%
  .$b_i

model_1_rmse <- RMSE(predicted_ratings, test_set$rating)
rmse_results <- bind_rows(rmse_results,
                          data_frame(method="Movie Effect Model",
                                     RMSE = model_1_rmse ))
rmse_results %>% knitr::kable()

#Ya vemos una mejora.

#¿Ahora podemos mejorarlo?

#Todo bien.

#¿Qué hay de los usuarios?

#¿Son diferentes los usuarios en términos de cómo califican las películas?

#Para explorar los datos, calculemos la calificación promedio para el usuario, u, para aquellos que han calificado más de 100 películas.

#Podemos hacer un histograma de esos valores.

#Y se ve así.

train_set %>% 
  group_by(userId) %>% 
  summarize(b_u = mean(rating)) %>% 
  filter(n()>=100) %>%
  ggplot(aes(b_u)) + 
  geom_histogram(bins = 30, color = "black")


#Tenga en cuenta que también existe una variabilidad sustancial entre los usuarios.

#Algunos usuarios son muy irritables.

#Y otros aman cada película que miran, mientras que otros están en algún lugar en el medio.

#Esto implica que una mejora adicional de nuestro modelo puede ser algo como esto.

#Incluimos un término, b_u, que es el efecto específico del usuario.

#Entonces, si un usuario malhumorado, esto es negativo, b_u califica una gran película, que tendrá un b_i positivo, los efectos se contrarrestan entre sí, y es posible que podamos predecir correctamente que este usuario le dio a una gran película un tres en lugar de un cinco , lo que sucederá.

#Y eso debería mejorar nuestras predicciones.

#Entonces, ¿cómo encajamos este modelo?

#De nuevo, podríamos usar lm.

#El código se vería así.

#lm(rating ~ as.factor(movieId) + as.factor(userId))

#Pero, de nuevo, no lo haremos, porque este es un gran modelo.

#Probablemente bloqueará nuestra computadora.

#En cambio, calcularemos nuestra aproximación calculando la media general, u-hat, los efectos de la película, b-hat_i, y luego calculando los efectos del usuario, b_u-hat, tomando el promedio de los residuos obtenidos después de eliminar la media general y El efecto de película de las clasificaciones y_u, i.

#El código se ve así.

user_avgs <- test_set %>%
  left_join(movie_avgs, by = 'movieId') %>% 
  group_by(userId) %>% 
  summarize(b_u = mean(rating - mu - b_i))

#Y ahora podemos ver qué tan bien lo hacemos con este nuevo modelo al predecir valores y calcular el error cuadrático medio residual.

model_2_rmse <- RMSE(predicted_ratings, test_set$rating)
rmse_results <- bind_rows(rmse_results,
                          data_frame(method="Movie + User Effects Model",  
                                     RMSE = model_2_rmse ))
rmse_results %>% knitr::kable()


#Vemos que ahora obtenemos una mejora adicional.

#Nuestro error cuadrado medio residual se redujo a aproximadamente 0,89.