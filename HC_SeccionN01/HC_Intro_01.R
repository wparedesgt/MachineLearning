#En el aprendizaje automático, los datos vienen en la forma del resultado que queremos predecir y las características que usaremos para predecir el resultado.

#Queremos construir un algoritmo que tome el valor de la característica como entrada y devuelva una predicción para el resultado cuando no lo sepamos.

#El enfoque de aprendizaje automático consiste en entrenar un algoritmo utilizando un conjunto de datos para el que conocemos el resultado, y luego aplicar este algoritmo en el futuro para hacer una predicción cuando no sabemos el resultado.

#Aquí usaremos Y para indicar los resultados y X's X1 a XP: para indicar las características.

#Sepa que las características a veces se denominan predictores o covariables.

#Consideramos que todos estos son sinónimos.

#Los problemas de predicción se pueden dividir en resultados categóricos y continuos.

#Para resultados categóricos, Y puede ser cualquiera de las clases de K.

#El número de clases puede variar mucho según las aplicaciones.

#Por ejemplo, en los datos del lector de dígitos, K es igual a 10, siendo las clases los dígitos 0, 1, 2, 3, 4, 5, 6, 7, 8 y 9.

#En el reconocimiento de voz, el resultado son todas las palabras posibles que intentamos detectar.

#La detección de spam tiene dos resultados: spam o no spam.

#En este curso, denotamos las k categorías con índices k es igual a 1 a través de la capital K.

#Sin embargo, para datos binarios, utilizamos 0 y 1.

#Esto es por conveniencia matemática, algo que demostraremos más adelante.


#La configuración general es la siguiente.

#Tenemos una serie de características y un resultado desconocido que queremos predecir, por lo que se parece a esto: cinco características, resultado desconocido.

#Para construir un modelo o un algoritmo que proporcione una predicción, para cualquier conjunto de valores, X1 es igual a x1 pequeño hasta x5, recopilamos datos para los cuales sabemos el resultado, por lo que obtenemos una tabla como esta.

#Usamos una notación y un sombrero para denotar la predicción.

#Usamos el término resultado real para denotar lo que terminamos observando.

#Así que queremos que la predicción y el sombrero coincidan con el resultado real.

#El resultado y puede ser "CATEGORICO" qué dígito, palabra, correo no deseado o no correo no deseado, peatón o camino vacío por delante; o 

#"CONTINUO": clasificación de la película, precio de la vivienda, valor de stock, distancia entre el automóvil sin conductor y el peatón.

#El concepto y los algoritmos que aprendemos aquí se aplican a ambos.

#Sin embargo, hay algunas diferencias en la forma en que abordamos cada caso, por lo que es importante distinguir entre los dos.

#Cuando el resultado es categórico, nos referimos a la tarea de aprendizaje automático como clasificación.

#Nuestras predicciones serán categóricas al igual que nuestros resultados, y serán correctas o incorrectas.

#Cuando el resultado es continuo, nos referiremos a la tarea como predicción.

#En este caso, nuestra predicción no será correcta ni incorrecta.

#En su lugar, cometeremos un error que es la diferencia entre la predicción y el resultado real.

#Esta terminología puede volverse confusa ya que usamos el término y hat denotan nuestras predicciones incluso cuando es un resultado categórico.

#Sin embargo, a lo largo de la conferencia, el contexto aclarará el significado.

#Pero tenga en cuenta que estos términos varían entre cursos, libros de texto y otras publicaciones, así que no permita que eso lo confunda.

#Por ejemplo, a menudo, la predicción se usa tanto para categóricos como para continuos, y la palabra regresión se usa para el caso continuo.

#Aquí, evitamos el uso de la regresión para evitar la confusión con nuestro uso anterior del término regresión lineal.

#Nuevamente, en la mayoría de los casos, será claro si nuestros resultados son categóricos o continuos, por lo que evitaremos usar estos términos cuando sea posible.


#Puntos Clave


#X1, ..., Xp denota las características, Y denota los resultados e Y ^ denota las predicciones.

#Las tareas de predicción de aprendizaje automático se pueden dividir en resultados categóricos y continuos. Nos referimos a estos como clasificación y predicción, respectivamente.
