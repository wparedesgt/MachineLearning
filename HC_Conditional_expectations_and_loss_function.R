#Expectativas condicionales y función de pérdida.

#En este video, hacemos una conexión entre las probabilidades condicionales y las expectativas condicionales.

#Para datos binarios, puede pensar que el condicional probablemente de y es igual a 1 cuando x es igual a x como una proporción de 1 en el estrato de la población para la que x es igual a x.

#Muchos de los algoritmos que aprenderemos se pueden aplicar tanto a datos categóricos como a datos continuos debido a la conexión entre las probabilidades condicionales y las expectativas condicionales.

#Debido a que la expectativa es el promedio de los valores, y1 a través de yn en la población, en el caso en que y's sean 0s o 1s, la expectativa es equivalente a la probabilidad de escoger aleatoriamente un 1 ya que el promedio es simplemente la proporción de 1s.

#Por lo tanto, la expectativa condicional es igual a la probabilidad condicional.

#Por lo tanto, a menudo solo usamos la expectativa para denotar tanto la probabilidad condicional como la expectativa condicional.

#Entonces, ¿por qué nos importa la expectativa condicional?

#Al igual que con los resultados categóricos, en la mayoría de las aplicaciones, los mismos predictores observados no garantizan el mismo resultado continuo.

#En cambio, asumimos que el resultado sigue la misma distribución condicional, y ahora explicaremos por qué observamos y usamos las expectativas condicionales para definir nuestros predictores.

#Antes de comenzar a describir los enfoques para optimizar la forma en que construimos el algoritmo para obtener resultados continuos, primero debemos definir a qué nos referimos cuando decimos que un enfoque es mejor que el otro.

#Con los resultados binarios, ya hemos descrito cómo la sensibilidad, la especificidad, la precisión y la F1 se pueden usar como cuantificaciones.

#Sin embargo, estas métricas no son útiles para resultados continuos.

#El enfoque general de definir mejor en aprendizaje automático es definir una función de pérdida.

#La más utilizada es la función de pérdida al cuadrado.

#Si y hat es nuestro predictor e y es nuestro resultado real, la función de pérdida al cuadrado es simplemente la diferencia al cuadrado.

#Debido a que a menudo tenemos un conjunto de pruebas con muchas observaciones, digamos n observaciones, usamos el error cuadrático medio dado por esta fórmula.

#Tenga en cuenta que si los resultados son binarios, el error de la media al cuadrado es equivalente a la precisión, ya que yhat menos y al cuadrado es una de las predicciones correctas y 0 en caso contrario.

#Y el promedio es simplemente tomando la proporción de predicciones correctas.

#En general, nuestro objetivo es crear un algoritmo que minimice la pérdida para que sea lo más cercano posible a 0.

#Debido a que nuestros datos suelen ser una muestra aleatoria, el error cuadrático medio es una variable aleatoria.

#Por lo tanto, es posible que un algoritmo minimice el error cuadrático medio en un dato específico para buscar, pero que, en general, otro algoritmo funcionará mejor.

#Por lo tanto, tratamos de encontrar algoritmos que minimicen el error de la media al cuadrado en promedio.

#Es decir, queremos el algoritmo que minimiza el promedio de la pérdida al cuadrado en muchas, muchas muestras aleatorias.

#La ecuación matemática para esto es esto aquí.

#La expectativa del error al cuadrado.

#Tenga en cuenta que este es un concepto teórico porque, en principio, solo tenemos un conjunto de datos con el que trabajar.

#Sin embargo, más adelante aprenderemos sobre técnicas que nos permiten estimar esta cantidad.

#Antes de continuar, tenga en cuenta que existen otras funciones de pérdida distintas de la pérdida al cuadrado.

#Por ejemplo, podemos usar el valor absoluto en lugar de cuadrar los errores.

#Pero en este curso, nos enfocamos en minimizar la pérdida al cuadrado ya que es la más utilizada.

#Entonces, ¿por qué nos importa la expectativa condicional en el aprendizaje automático?

#Esto se debe a que el valor esperado tiene una propiedad matemática atractiva.

#Minimiza la pérdida al cuadrado esperada.

#Específicamente, de todos los posibles sombreros y, la expectativa condicional de y dado x minimiza la pérdida esperada dada x.

#Debido a esta propiedad, una breve descripción de la tarea principal del aprendizaje automático es que usamos datos para estimar la probabilidad condicional de cualquier conjunto de características x1 a xp.

#Esto, por supuesto, es más fácil decirlo que hacerlo ya que esta función puede tomar cualquier forma yp, el número de covarianza, puede ser muy grande.

#De acuerdo, considere un caso en el que solo tenemos un predictor x.

#La expectativa de y dada x puede ser cualquier función de x una línea, una parábola, una onda sinusoidal, una función de paso, cualquier cosa.

#Se vuelve aún más complicado cuando consideramos los casos con mayor número de covarianza, en cuyo caso, f de x es una función de un vector x multidimensional.

#Por ejemplo, en nuestro ejemplo de lector de dígitos, el número de covarianza fue de 784.

##La principal forma en que los algoritmos de aprendizaje automático de la competencia difieren está en el enfoque para estimar esta expectativa condicional, y vamos a aprender algunos de esos enfoques.