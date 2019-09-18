#S04_C19_k_fold_Cross_Validation

#En cursos anteriores, hemos descrito cómo el objetivo del aprendizaje automático a menudo es encontrar un algoritmo que produzca predictores, para un resultado y, que minimice el error cuadrático medio.

#MSE = Minimal Square Error

#\mbox{MSE} = \mbox{E}\left\{ \frac{1}{N}\sum_{i=1}^N (\hat{Y}_i - Y_i)^2 \right\}

#Cuando todo lo que tenemos a nuestra disposición es un conjunto de datos, podemos estimar el error cuadrático medio con el error cuadrático medio observado de esta manera.

#\hat{\mbox{MSE}} = \frac{1}{N}\sum_{i=1}^N (\hat{y}_i - y_i)^2

#Estas dos cantidades a menudo se denominan error verdadero y error aparente respectivamente.

#Hay dos características importantes del error aparente que siempre debemos tener en cuenta.

#Primero, es una variable aleatoria ya que nuestros datos son aleatorios.

#Por ejemplo, el conjunto de datos que tenemos puede ser una muestra aleatoria de una población más grande.

#Entonces, un algoritmo que tiene un error aparente más bajo que otro puede deberse a la suerte.

#Segundo, si entrenamos un algoritmo en el mismo conjunto de datos que usamos para calcular el error aparente, podríamos estar sobreentrenando.

#En general, cuando hacemos esto, el error aparente será una subestimación del error verdadero.

#Vimos un ejemplo extremo de esto con los vecinos k más cercanos cuando dijimos que k es igual a 1.

#La validación cruzada es una técnica que nos permite aliviar estos dos problemas.

#Hay varios enfoques.

#Voy a repasar algunos de ellos aquí.

#Para comprender la validación cruzada, es útil pensar en el error verdadero, una cantidad teórica, como el promedio de muchos, muchos errores aparentes obtenidos al aplicar el algoritmo a, digamos, B, nuevas muestras aleatorias de los datos, ninguno de ellos solían entrenar el algoritmo.

#Cuando pensamos de esta manera, podemos pensar en el error verdadero como el promedio de los errores aparentes obtenidos en cada una de las muestras aleatorias.

#La fórmula sería así.

#\frac{1}{B} \sum_{b=1}^B \frac{1}{N}\sum_{i=1}^N \left(\hat{y}_i^b - y_i^b\right)^2

#Aquí B es un gran número que puede considerarse prácticamente infinito.

#Ahora, esta es una cantidad teórica porque solo podemos ver un conjunto de resultados.

#No podemos verlos una y otra vez.

#La idea de la validación cruzada es imitar esta configuración teórica lo mejor que podamos con los datos que tenemos.

#Para hacer esto, tenemos que generar una serie de diferentes muestras aleatorias.

#Hay varios enfoques para hacer esto.

#Pero la idea general para todos ellos es generar aleatoriamente conjuntos de datos más pequeños que no se usan para el entrenamiento y en su lugar se usan para estimar el error verdadero.

#El primero que describimos, y en el que nos enfocamos en este curso, es la validación cruzada k-fold.

#Vamos a describirlo

#Recuerde, en términos generales, un desafío de aprendizaje automático comienza con un conjunto de datos.

#Y necesitamos construir un algoritmo usando este conjunto de datos que eventualmente se usará en un conjunto de datos completamente independiente.

#Así que aquí tenemos el conjunto de datos que tenemos en azul y el conjunto de datos independiente que nunca veremos en amarillo.

#Entonces no vemos el amarillo, entonces todo lo que vemos es el azul.

#Entonces, como ya hemos descrito, para imitar la situación, forjamos una parte de nuestro conjunto de datos y pretendemos que sea un conjunto de datos independiente.

#Dividimos el conjunto de datos en conjunto de entrenamiento, azul, y un conjunto de prueba, rojo.

#Entrenaremos nuestro algoritmo exclusivamente en el conjunto de entrenamiento y usaremos el conjunto de prueba solo para fines de evaluación.

#Por lo general, intentamos seleccionar una pequeña parte del conjunto de datos para tener la mayor cantidad de datos posible para entrenar.

#Sin embargo, también queremos que un conjunto de pruebas sea grande para que podamos obtener estimaciones estables de la pérdida.

#Opciones típicas para usar para el tamaño de la prueba que son del 10% al 20% del conjunto de datos original.

#Reiteremos que es indispensable que no usemos el conjunto de prueba para entrenar nuestro algoritmo, no para filtrar filas, no para seleccionar características, nada.

#Ahora, esto presenta un nuevo problema.

#Debido a que para la mayoría de los algoritmos de aprendizaje automático, debemos seleccionar parámetros, por ejemplo, el número de vecinos k en el algoritmo de vecinos k más cercanos.

#Aquí nos referiremos al conjunto de parámetros como lambda.

#Por lo tanto, debemos optimizar los parámetros del algoritmo lambda sin utilizar nuestro conjunto de pruebas.

#Y sabemos que si optimizamos y evaluamos en el mismo conjunto de datos, sobreentrenaremos.

#Entonces aquí es donde usamos la validación cruzada.

#Aquí es donde la polinización cruzada es más útil.

#Así que describamos la validación cruzada de k-fold.

#Para cada conjunto de parámetros de algoritmo que se considera, queremos estimar el MSE.

#Y luego elegiremos los parámetros con el MSE más pequeño.

#La validación cruzada proporcionará esta estimación.

#Primero, es importante que antes de comenzar el procedimiento de validación cruzada arreglemos todos los parámetros del algoritmo.

#Estamos calculando el MSE para un parámetro dado.

#Entonces, como describimos más adelante, entrenaremos el algoritmo en un conjunto de conjuntos de entrenamiento.

#El parámetro lambda será el mismo en todos estos conjuntos de entrenamiento.

#Usaremos la notación y sombrero i paréntesis lambda para denotar la predicción obtenida cuando usamos un parámetro lambda para observación i.

#Y^i(lamda)

#Entonces, si vamos a imitar la definición de la pérdida esperada, podríamos escribirla así.

#\mbox{MSE}(\lambda) = \frac{1}{B} \sum_{b=1}^B \frac{1}{N}\sum_{i=1}^N \left(\hat{y}_i^b(\lambda) - y_i^b\right)^2


#Para esta fórmula, queremos considerar conjuntos de datos que puedan considerarse como muestras aleatorias independientes.

#Y querrás hacer esto varias veces.

#Con k-fold cross-validation, lo hacemos k veces.

#En las graficas que mostramos, usamos como ejemplo k es igual a 5.

#Finalmente terminaremos con k muestras.

#Pero comencemos describiendo cómo construir el primero.

#Simplemente elegimos N dividido K redondeado al entero más cercano.

#Llamemos a eso M. Entonces tenemos M observaciones que elegimos al azar y las consideramos como una muestra aleatoria.

#M = N/K

#Podríamos denotarlos usando esta ecuación.

#y1^b,......,yM^b

#Y aquí b es igual a 1.

#b = 1

#Es el primero, lo que llamamos, doblar.

#Así que esto es lo que parece gráficamente.

#Tenemos nuestro conjunto de entrenamiento.

#Separamos el conjunto de prueba.

#Y luego tomamos nuestro conjunto de entrenamiento, y tomamos una pequeña muestra del mismo, que llamaremos el conjunto de validación, el primero.

#Y ahí es donde vamos a probar.

#Ahora podemos ajustar el modelo en el conjunto de entrenamiento, con el conjunto de validación separado, y calcular el error aparente en el conjunto independiente como este.

#\hat{\mbox{MSE}}_b(\lambda) = \frac{1}{M}\sum_{i=1}^M \left(\hat{y}_i^b(\lambda) - y_i^b\right)^2

#Tenga en cuenta que esta es solo una muestra y, por lo tanto, devolverá una estimación ruidosa del error verdadero.

#Es por eso que tomamos k muestra no solo una.

#Entonces gráficamente se vería así.

#En k-fold cross-validation, dividimos aleatoriamente las observaciones en k conjuntos no superpuestos.

#Así que ahora repetimos este cálculo para cada uno de estos conjuntos, b va desde 1 hasta k.

#b = 1,....,K

#Entonces obtenemos k estimaciones del MSE.

#\hat{\mbox{MSE}}(\lambda) = \frac{1}{B} \sum_{b=1}^K \hat{\mbox{MSE}}_b(\lambda)

#En nuestra estimación final, calculamos el promedio de esta manera.

#Y esto nos da una estimación de nuestra pérdida.

#Un paso final sería seleccionar la lambda, los parámetros, que minimizan el MSE.

#Así es como usamos la validación cruzada para optimizar los parámetros.

#Sin embargo, ahora tenemos que tener en cuenta el hecho de que la optimización se produjo en los datos de entrenamiento.

#Por lo tanto, debemos calcular una estimación de nuestro algoritmo final en función de los datos que no se utilizaron para optimizar esta elección.

#Y es por eso que separamos el conjunto de prueba.

#Ahí es donde calcularemos nuestra estimación final del MSE.

#Tenga en cuenta que podemos hacer una validación cruzada nuevamente.

#Tenga en cuenta que esto no es para fines de optimización.

#Esto es simplemente para saber cuál es el MSE de nuestro algoritmo final.

#Hacer esto nos daría una mejor estimación.

#Sin embargo, tenga en cuenta que para hacer esto, tenemos que pasar por todo el proceso de optimización k veces.

#Pronto aprenderá que realizar tareas de aprendizaje automático puede llevar tiempo porque estamos realizando muchos cálculos complejos.

#Y, por lo tanto, siempre estamos buscando formas de reducir esto.

#Entonces, para la evaluación final, a menudo solo usamos un conjunto de pruebas.

#Utilizamos validación cruzada para optimizar nuestro algoritmo.

#Pero una vez que lo hemos optimizado, hemos terminado y queremos tener una idea de cuál es nuestro MSE, solo usamos este último conjunto de pruebas.

#Una vez que estemos satisfechos con este modelo, y queramos que esté disponible para otros, podríamos reajustar el modelo en todo el conjunto de datos, pero sin cambiar los parámetros.

#Ahora, ¿cómo elegimos la validación cruzada k?
  
#Usamos cinco en estos ejemplos.

#Podríamos usar otros números.

#Los valores grandes de k son preferibles porque los datos de entrenamiento imitan mejor los datos originales.

#Sin embargo, los valores más grandes de k tendrán un tiempo de cálculo mucho menor.

#Por ejemplo, la validación cruzada cien veces será 10 veces más lenta que la validación cruzada diez veces.

#Por esta razón, las elecciones de k equivalen a 5 y 10 son bastante populares.

#Ahora, una forma en que podemos mejorar la varianza de nuestra estimación final es tomar más muestras.

#Para hacer esto, ya no necesitaríamos que el conjunto de entrenamiento se dividiera en conjuntos no superpuestos.

#En cambio, simplemente elegiríamos k conjuntos de algún tamaño al azar.

#Una versión popular de esta técnica, en cada pliegue, selecciona observaciones al azar con reemplazo, lo que significa que la misma observación puede aparecer dos veces.

#Este enfoque tiene algunas ventajas que no se discuten aquí, generalmente se conoce como el enfoque de arranque.

#De hecho, este es el enfoque predeterminado en el paquete caret.

#En otro video, describiremos el concepto de bootstrap.

#Es el promedio sobre muestras B que hemos tomado del MSE que obtenemos en los datos separados como un conjunto de prueba.