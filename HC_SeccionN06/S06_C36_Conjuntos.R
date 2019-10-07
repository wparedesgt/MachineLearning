#S06_C36_Conjuntos
#Conjuntos
#Cargar la info de Caso de Estudio MNIST y de preprocesamiento 


#Un enfoque muy poderoso en el aprendizaje automático es la idea de agrupar diferentes algoritmos de aprendizaje automático en uno.

#Vamos a explicar lo que queremos decir con eso.

#La idea de un conjunto es similar a la idea de combinar datos de diferentes encuestadores para obtener una mejor estimación del verdadero apoyo para diferentes candidatos.

#En el aprendizaje automático, generalmente se puede mejorar en gran medida el resultado final de nuestras predicciones combinando los resultados de diferentes algoritmos.

#Aquí presentamos un ejemplo muy simple, donde calculamos nuevas probabilidades de clase tomando el promedio de las probabilidades de clase proporcionadas por el bosque aleatorio y los vecinos k más cercanos.

#Podemos usar este código para simplemente promediar estas probabilidades.


p_rf <- predict(fit_rf, x_test[,col_index])$census
p_rf <- p_rf / rowSums(p_rf)
p_knn <- predict(fit_knn, x_test[,col_index])
p <- (p_rf + p_knn)/2
y_pred <- factor(apply(p, 1, which.max)-1)
confusionMatrix(y_pred, y_test)


#Y podemos ver que una vez que hacemos esto, cuando formamos la predicción, en realidad mejoramos la precisión sobre los vecinos más cercanos y el bosque aleatorio.

#Ahora, observe, en este ejemplo muy simple, agrupamos solo dos métodos.

#En la práctica, podríamos reunir docenas o incluso cientos de métodos diferentes.

#Y esto realmente proporciona mejoras sustanciales.