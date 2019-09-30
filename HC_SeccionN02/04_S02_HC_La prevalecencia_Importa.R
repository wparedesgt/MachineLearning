#La prevalencia importa en la práctica

#Un algoritmo de aprendizaje automático con muy alta sensibilidad y especificidad puede no ser útil en la práctica cuando la prevalencia es cercana a 0 o 1.

#Para ver esto, considere el caso de un médico que se especializa en una enfermedad rara y esta interesado en desarrollar un algoritmo para predecir quién tiene la enfermedad.

#El médico comparte datos con usted y usted desarrolla un algoritmo con una sensibilidad muy alta.

#Explica que esto significa que si un paciente tiene una enfermedad, es muy probable que el algoritmo prediga correctamente.

#También le dice al médico que está preocupado porque, según el conjunto de datos que analizó, aproximadamente la mitad de los pacientes tienen la enfermedad, la probabilidad de que Y sea igual a 1/2.

#pr(Y^ = 1) = 1/2


#El médico no está preocupado ni impresionado y explica que lo importante es la precisión de la prueba, la probabilidad de que y sea igual a 1 dado que "Y hat" es igual a 1.

#pr(Y = 1 | Y^ = 1)

#Usando el teorema de Bayes, podemos conectar las dos medidas.

#La probabilidad de que Y sea igual a Y es igual a 1 es igual a la probabilidad de que Y hat sea igual a 1 dado que Y es igual a 1 la probabilidad de que Y sea igual a 1 dividido por la probabilidad de que Y hat sea igual a 1.

#pr(Y|Y^= 1) = pr(Y^= 1 | Y =1) pr(Y=1)/pr(Y^= 1)


#El médico sabe que la prevalencia de la enfermedad es de 5 en 1.000.

#La prevalencia de la enfermedad en su conjunto de datos fue del 50%.

#Esto implica que en esa proporción, la probabilidad de que Y es igual a 1 dividida por la proporción de Y que es igual a 1 es aproximadamente 1 en 100.

#pr(Y=1)/pr(Y^ = 1) = 1/100


#Y por lo tanto, la posición de su algoritmo es menor que 0.01.

#El médico no tiene mucho uso para su algoritmo.