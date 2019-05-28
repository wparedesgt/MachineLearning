#Probabilidades condicionales 

#En las aplicaciones de aprendizaje automático, rara vez podemos predecir los resultados a la perfección.

#Tenga en cuenta que los detectores de spam a menudo omiten correos electrónicos que son claramente spam, Siri a menudo entiende mal las palabras que decimos y su banco a menudo piensa que su tarjeta fue robada cuando no lo fue.

#En cambio, estás de vacaciones.

#La razón más común para no poder construir algoritmos perfectos es que es imposible.

#Para ver esto, tenga en cuenta que la mayoría de los conjuntos de datos incluirán grupos de observaciones con los mismos valores observados exactos para todos los predictores y, por lo tanto, resultarán en la misma predicción.

#Pero tienen diferentes resultados, lo que hace imposible hacer las predicciones correctas para todas estas observaciones.

#Vimos un ejemplo simple de esto en los videos anteriores para cualquier altura dada, x, tendrá tanto hombres como mujeres que miden x pulgadas de alto.

#Así que no puedes predecirlos bien.

#Sin embargo, nada de esto significa que no podemos construir algoritmos útiles que sean mucho mejores que adivinar, y en algunos casos, mejores que la opinión de los expertos.

#Para lograr esto de manera óptima, utilizamos representaciones probabilísticas del problema.

#Es posible que las observaciones con los mismos valores observados para los predictores no sean todas iguales, pero podemos suponer que todas tienen la misma probabilidad de esta clase o esa clase.

#Escribiremos esta idea matemáticamente para el caso de los datos categóricos.

#Usamos la notación X1 = a pequeña x1, hasta Xp = pequeña xp, para representar el hecho de que hemos observado valores, pequeños x1 hasta pequeños xp.

#Para covariables, de X1 a Xp.

#Esto no implica que el resultado, y, tome un valor específico, sino que implica una probabilidad específica.

#Específicamente, denotamos las probabilidades condicionales de cada clase, k, usando esta notación.

#Para evitar escribir todos los predictores, usaremos la siguiente notación.

#Pr(Y = k | X1 = x1, .... , Xp = xp), for k = 1, ... , K

#Usaremos letras en negrita para representar todos los predictores como este.

#X = (X1, ..., Xp)
#x = (x1, ..., xp)

#También usaremos la siguiente notación para la probabilidad condicional de estar en la clase k.

#Podemos escribirlo así.

#Pk(X)  = Pr(Y = k | X = x), for k = 1, ... , K


#Antes de continuar, una palabra de precaución.

#Usaremos la notación p(x) para representar probabilidades condicionales como funciones.

#No confunda esto con la p que usamos para representar el número de predictores.

#Ahora, continuemos.

#Conocer estas probabilidades puede guiar la construcción de un algoritmo que haga la mejor predicción.

#Para cualquier conjunto dado de predictores, x, predeciremos la clase, k, con la mayor probabilidad entre p1x, p2x, hasta p capital Kx.

#En notación matemática, podemos escribirlo así.


#Y hat = max pk (X) dividido k


#Pero no es así de simple, porque no conocemos el pk de xs.

#De hecho, estimar estas probabilidades condicionales se puede considerar como el principal desafío del aprendizaje automático.

#Cuanto mejor sean las estimaciones de nuestro algoritmo de kx, mejor será nuestro predictor.

#Entonces, cuán buena será nuestra predicción dependerá de dos cosas, cuán cerca de la probabilidad máxima sea de 1, y de cuán cerca esté nuestra estimación de las probabilidades a las probabilidades reales.


#Cuan cerca MaxPk(X) dividido k está al 1. 

#No podemos hacer nada respecto a la primera restricción, ya que está determinada por la naturaleza del problema.

#Así que nuestra energía se concentra en encontrar maneras de estimar mejor la condición de las probabilidades.

#P hat k(X) sea igual a Pk(X)

#La primera restricción implica que tenemos límites en cuanto a qué tan bien puede funcionar incluso el mejor algoritmo posible.

#Debería acostumbrarse a la idea de que, mientras que en algunos desafíos podremos lograr lectores de dígitos con una precisión casi perfecta, por ejemplo, y otros, nuestro éxito se ve limitado por la aleatoriedad de las recomendaciones de la película de proceso, por ejemplo.

#Y antes de continuar, notamos que definir nuestra predicción al maximizar la probabilidad no siempre es óptimo en la práctica y depende del contexto.

#Como se discutió anteriormente, la sensibilidad y la especificidad pueden diferir en importancia en diferentes contextos.

#Pero incluso en estos casos, bastará con tener una buena estimación de las probabilidades condicionales para construir un modelo de predicción óptimo, ya que podemos controlar la especificidad y la sensibilidad como lo deseamos.

#Por ejemplo, simplemente podemos cambiar el límite utilizado para predecir una clase en lugar de otra.