#S05_C26_Trees_Motivation
#Motivacion para Arboles de Decisión

#Describimos cómo los métodos como lda y qda no deben usarse con conjuntos de datos que tienen muchos predictores.

#Esto se debe a que el número de parámetros que necesitamos estimar se vuelve demasiado grande.

#Por ejemplo, con el ejemplo de dígitos donde tenemos 784 predictores, lda tendría que estimar más de 600,000 parámetros.

#Con qda, tendrías que multiplicar eso por el número de clases, que es 10 aquí.

#Los métodos de kernel tales como k-nn o regresión local no tienen parámetros de modelo para estimar.

#Pero también enfrentan un desafío cuando se usan predictores múltiples debido a lo que se conoce como la maldición de la dimensionalidad.

#La dimensión aquí se refiere al hecho de que cuando tenemos predictores p, la distancia entre dos observaciones se calcula en p espacio dimensional.

#Una forma útil de comprender la maldición de la dimensionalidad es considerar qué tan grande tenemos que hacer un vecindario, el vecindario que usamos para hacer las estimaciones, para incluir un porcentaje dado de los datos.

#Recuerde que con vecindarios grandes, nuestros métodos pierden flexibilidad.

#Por ejemplo, supongamos que tenemos un predictor continuo con puntos igualmente espaciados en el intervalo [0,1], y desea crear ventanas que incluyan 1/10 de los datos.

#Entonces es fácil ver que nuestras ventanas tienen que ser del tamaño 0.1.

#Puedes verlo en esta figura.

#Ahora, para dos predictores, si decidimos mantener el vecindario solo un pequeño, el 10% de cada dimensión solo incluimos un punto.

#Si queremos incluir el 10% de los datos, entonces necesitamos aumentar el tamaño de cada lado del cuadrado a la raíz cuadrada de 10 para que el área sea 10 de 100.

#Esto es ahora 0.316.

#En general, para incluir el 10% de los datos en un caso con p dimensiones, necesitamos un intervalo con cada lado que tenga un tamaño de 0,10 a 1 / p.

#Esta proporción se acerca a 1, lo que significa que estamos incluyendo prácticamente todos los datos, y ya no se suaviza muy rápidamente.

#Puedes verlo en este gráfico, trazando p versus 0.1 a 1 / p.

#Entonces, cuando llegamos a 100 predictores, el vecindario ya no es muy local, ya que cada lado cubre casi todo el conjunto de datos.

#En este tema, presentamos un conjunto de métodos elegantes y versátiles que se adaptan a dimensiones más altas y también permiten que estas regiones tomen formas más complejas, al tiempo que producen modelos que son interpretables.

#Estos son métodos muy conocidos, y estudiados.

#Nos centraremos en los árboles de regresión y decisión y su extensión, los bosques aleatorios.