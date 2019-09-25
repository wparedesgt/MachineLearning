#S05_C31_Tuneando_Parametros_Caret
#Tuneando los parametros con el paquete caret


#Cuando un algoritmo incluye un parámetro de ajuste, train usa automáticamente la validación cruzada para decidir entre algunos valores predeterminados.

#Para saber qué parámetro o parámetros están optimizados, puede leer esta página que lo explica.

#Incluiremos el enlace en el curso.

#O estudie la salida del siguiente código.

#La función de obtener información del modelo se puede usar para obtener información del método que le interesa.

#Puede realizar una búsqueda rápida utilizando la función de búsqueda de modelos como esta.

#Cuando ejecutamos este código, vemos que para knn, el parámetro que está optimizado es k.

#Entonces, si ejecutamos la funcion train() con valores predeterminados, puede ver rápidamente los resultados de la validación cruzada utilizando la función ggplot.

#Puede usar el argumento highlight para resaltar el parámetro que optimiza el algoritmo.

#Entonces puedes escribir esto.

#De forma predeterminada, la validación cruzada se realiza mediante pruebas en 25 muestras de arranque que comprenden el 25% de las observaciones.

#Además, para el método knn, el valor predeterminado es probar k = 5, 7 y 9.

#Ya vimos que 9 maximiza esto.

#Pero tal vez hay otra k que es aún mejor.

#Entonces, para cambiar esto, necesitamos usar el parámetro tunegrid en la función train().

#La cuadrícula de valores que se van a comparar debe ser suministrada por un marco de datos con los nombres de columna especificados por los parámetros que obtiene en la salida de búsqueda del modelo.

#Aquí presentamos un ejemplo probando 30 valores entre 9 y 67.

#Necesitamos usar una columna en k, por lo que el marco de datos que usaremos será este.

#Ahora, tenga en cuenta que al ejecutar este código, estamos ajustando 30 versiones de knn a 25 muestras de arranque, por lo que estamos ajustando modelos de 750 knn.

#Y así, ejecutar este código tomará varios segundos.

#Aquí está el código.

#En la gráfica, podemos ver la k que maximiza la precisión, pero también podemos acceder a ella usando este código.

#El componente bestTune nos proporciona el parámetro que maximiza la precisión.

#También podemos acceder al modelo de mejor rendimiento utilizando este código.

#Ahora, si aplica la función predict() a la salida de la función de train(), utilizará este modelo de mejor rendimiento para hacer predicciones.

#Tenga en cuenta que el mejor modelo se obtuvo utilizando el conjunto de entrenamiento.

#No utilizamos el conjunto de prueba en absoluto.

#La validación cruzada se realizó en el conjunto de entrenamiento.

#Entonces, si queremos ver la precisión que obtenemos en el conjunto de prueba, que no se ha utilizado, podemos usar el siguiente código.

#A veces nos gusta cambiar la forma en que realizamos la validación cruzada.

#Podríamos cambiar el método, podríamos cambiar cómo hacemos las particiones, etc.

#Si queremos hacer esto, necesitamos usar una función trainControl().

#Entonces, por ejemplo, podemos hacer que el código que acabamos de mostrar sea un poco más rápido mediante la validación cruzada 10 veces.

#Esto significa que vamos a tener 10 muestras de validación que usan el 10% de las observaciones cada una.

#Observe que si graficamos la precisión estimada versus la gráfica k, notamos que las estimaciones de precisión son más variables que en el ejemplo anterior.

#Ahora esto se espera ya que cambiamos una cantidad de muestras que usamos para estimar la precisión.

#En el primer ejemplo, usamos 25 muestras de bootstrap, y en este ejemplo, usamos validación cruzada 10 veces.

#Una cosa más para señalar.

#Tenga en cuenta que la función train() también proporciona valores de desviación estándar para cada parámetro que se probó.

#Esto se obtiene de los diferentes conjuntos de validación.

#Entonces podemos hacer un diagrama como este que muestre las estimaciones puntuales de la precisión junto con las desviaciones estándar.

#Para finalizar este ejemplo, observemos que el modelo knn que mejor se ajusta se aproxima bastante bien a la verdadera condición de probabilidad.

#Sin embargo, vemos que el límite es algo ondulado.

#Esto se debe a que knn, al igual que el bin bin liso, no utiliza un núcleo liso.

#Para mejorar esto, podríamos intentarlo.

#Al leer los modelos disponibles del paquete caret, al que puede acceder a través de este enlace, que incluimos en el material del curso, vemos que podemos usar el método gamLoess.

#También desde el enlace de documentación de caret puede acceder aquí y ver que necesitamos instalar el paquete gam si aún no lo hemos hecho.

#Entonces escribiremos algo como esto.

#Luego veremos que tenemos dos parámetros para optimizar si usamos este método en particular.

#Puede ver esto con la función de búsqueda de modelos, como esta.

#Para este ejemplo, mantendremos el grado fijo en uno.

#No probaremos el grado dos.

#Pero para probar diferentes valores para el lapso, todavía tenemos que incluir una columna en la tabla con el grado nombrado.

#Este es un requisito del paquete caret.

#Por lo tanto, definiríamos una cuadrícula utilizando la función expand.grid, como esta.

#Ahora, utilizamos los parámetros de control de validación cruzada predeterminados, por lo que escribimos código como este para entrenar nuestro modelo.

#Luego, seleccione el modelo con mejor rendimiento, y ahora podemos ver el resultado final.

#Se realiza de manera similar a knn.

#Sin embargo, podemos ver que la estimación de probabilidad condicional es más suave de lo que obtenemos con knn.

#Tenga en cuenta que no todos los parámetros en los algoritmos de aprendizaje automático están ajustados.

#Por ejemplo, en modelos de regresión o en LDA, ajustamos el mejor modelo utilizando las estimaciones de cuadrados o las estimaciones de máxima verosimilitud.

#Esos no son parámetros de ajuste.

#Obtuvimos los que usan mínimos cuadrados, o MLE, o alguna otra técnica de optimización.

#Los parámetros que se ajustan son parámetros que podemos cambiar y luego obtener una estimación del modelo para cada uno.

#Entonces, en k-vecinos más cercanos, el número de vecinos es un parámetro de ajuste.

#En la regresión, el número de predictores que incluimos podría considerarse un parámetro optimizado.

#Entonces, en el paquete caret, en la función train(), solo optimizamos los parámetros que son ajustables.

#Por lo tanto, no será el caso de que, por ejemplo, en los modelos de regresión, el paquete caret optimice los coeficientes de regresión que se estiman.

#En cambio, solo estimará usando mínimos cuadrados.

#Esta es una distinción importante que se debe hacer al usar el paquete caret sabiendo qué parámetros están optimizados y cuáles no.

