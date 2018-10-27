#Packete carret, entrenamiento y pruebas, y precisión general

#En este curso, usaremos el paquete caret, que tiene varias funciones útiles para construir y evaluar métodos de aprendizaje automático.

#Puedes cargarlo así.

library(caret)

#Más adelante, mostramos cómo estas funciones son útiles.

#En este video, nos centramos en describir formas en que se evalúan los algoritmos de aprendizaje automático.

#Entonces empecemos.

#Para nuestra primera introducción a los conceptos de aprendizaje automático, comenzaremos con un ejemplo simple y aburrido que predice el sexo femenino o masculino usando la altura.

#Explicamos paso a paso el aprendizaje automático y este ejemplo nos permitirá sentarnos en el primer bloque de construcción.

#Muy pronto, estaremos atacando retos más interesantes.

#Para este primer ejemplo, usaremos el conjunto de datos de alturas en el paquete ds labs, que puede cargar de esta manera.

library(dslabs)
data("heights")

#Comenzamos por definir el resultado y los predictores.

#En este ejemplo, tenemos un solo predictor.

#Entonces y es sexo y x es altura.

#Este es claramente un resultado categórico, ya que y puede ser masculino o femenino, y solo tenemos un predictor, la altura.

#Sabemos que no podremos predecir y con mucha precisión en función de x porque las alturas de hombres y mujeres no son tan diferentes en relación con la variabilidad dentro del grupo, pero ¿podemos hacerlo mejor que adivinar?
  
#La respuesta a esta pregunta, necesitamos cuantificar la definición de mejor.

#En última instancia, un algoritmo de aprendizaje automático se evalúa sobre cómo se desempeña en el mundo real con otros que ejecutan el código.

#Sin embargo, al desarrollar un algoritmo, generalmente tenemos un conjunto de datos para el cual conocemos los resultados como lo hacemos con las alturas.

#Sabemos el sexo de cada alumno.

#Por lo tanto, para imitar el proceso de evaluación final, normalmente dividimos los datos en dos y actuamos como si no conociéramos el resultado de uno de estos dos conjuntos.

#Dejamos de fingir que no sabemos el resultado para evaluar el algoritmo, pero solo después de que hayamos terminado de construirlo.

#Nos referimos a los grupos de los que conocemos el resultado y utilizamos para desarrollar el algoritmo como conjunto de entrenamiento, y al grupo para el que pretendemos que no conocemos el resultado como conjunto de prueba.

#Una forma estándar de generar los conjuntos de entrenamiento y prueba es dividir los datos al azar.

#El paquete caret incluye la función createDataPartition que nos ayuda a generar índices para dividir aleatoriamente los datos en conjuntos de entrenamiento y pruebas.

#Los tiempos de argumento en funciones se utilizan para definir cuántas muestras aleatorias de índices se devolverán.

#El argumento p se usa para definir qué proporción del índice representado y la lista de argumentos se usa para decidir si desea que los índices se devuelvan como una lista o no.

#Aquí lo vamos a utilizar así.

#Podemos usar este índice para definir el conjunto de entrenamiento y el conjunto de prueba como este.

#Ahora desarrollaremos un algoritmo utilizando solo el conjunto de entrenamiento.

#Una vez que hayamos terminado de desarrollar el algoritmo, lo congelaremos y evaluaremos utilizando las pruebas.

#La forma más sencilla de evaluar el algoritmo cuando los resultados son categóricos es simplemente informando la proporción de casos que se predijeron correctamente en los estudios de prueba.

#Esta métrica se suele denominar precisión general.

#Para demostrar el uso de la precisión general, construiremos dos algoritmos competitivos y los compararemos.

#Comencemos por desarrollar el algoritmo de aprendizaje automático más simple posible adivinando el resultado.

#Podemos hacer eso usando la función de ejemplo como esta.

#Tenga en cuenta que estamos ignorando completamente el predictor y simplemente adivinando el sexo.

#OK, sigamos adelante.

#En las aplicaciones de aprendizaje automático, es útil utilizar factores para representar los resultados categóricos.

#Nuestras funciones desarrolladas para el aprendizaje automático, como las del paquete Caret, requieren o recomiendan que los resultados categóricos se codifiquen como factores.

#Así que podemos hacer eso así.

#La precisión general se define simplemente como la proporción general que se predice correctamente.

#Podemos calcular eso usando esta simple línea de código.

#No es sorprendente que nuestra precisión sea aproximadamente del 50% que estamos adivinando.

#Ahora, ¿podemos hacerlo mejor?
  
#Los datos exploratorios como sugiere que podemos porque en promedio, los machos son un poco más altos que las hembras.

#Puedes verlo escribiendo este código.

#¿Pero cómo hacemos uso de esta visión?
  
#Probemos un enfoque simple.

#Predecir el macho si la altura está dentro de dos desviaciones estándar del macho promedio.

#Podemos hacer eso usando este código muy simple.

#La precisión aumenta de 50% a 80%, lo que podemos ver al escribir esta línea, pero ¿podemos hacerlo mejor?
  
#En el ejemplo anterior, usamos el corte de 62 pulgadas, pero podemos examinar la precisión obtenida para otros cortes y luego tomar el valor que proporciona el mejor resultado.

#Pero recuerde que es importante que elijamos el mejor valor en el conjunto de entrenamiento.

#El conjunto de prueba es solo para evaluación.

#Aunque para este ejemplo simplista, no es mucho problema.

#Más adelante, aprenderemos que la evaluación de un algoritmo en el conjunto de entrenamiento puede llevar a un sobreajuste, lo que a menudo resulta en evaluaciones peligrosamente sobre optimistas.

#OK, así que vamos a elegir un corte diferente.

#Examinamos la precisión que obtuvimos con 10 cortes diferentes y seleccionamos el que daba el mejor resultado.

#Podemos hacer eso con esta simple pieza de código.

#Podemos hacer un gráfico que muestre la precisión en el conjunto de entrenamiento para hombres y mujeres.

#Aquí está.

#Vemos que el valor máximo es un 83.6%.

#Mucho más alto que el 50%, y se maximiza con el corte de 64 pulgadas.

#Ahora, podemos probar este corte en nuestro conjunto de pruebas para asegurarnos de que la precisión no sea demasiado optimista.

#Ahora, obtenemos una precisión del 81.7%.

#Vemos que es un poco menor que la precisión observada en el conjunto de entrenamiento, pero aún así es mejor que adivinar.

#Y al realizar pruebas en un dato en el que no entrenamos, sabemos que no se debe a un ajuste excesivo.