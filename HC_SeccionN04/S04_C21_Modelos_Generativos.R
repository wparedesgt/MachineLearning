#S04_C21_Modelos_Generativos
#Modelos Generativos

library(dslabs)
library(tidyverse)
library(caret)
library(purrr)
library(gridExtra)

#Hemos descrito cómo cuando se usa la pérdida cuadrada, la expectativa o las probabilidades condicionales proporcionan el mejor enfoque para desarrollar una regla de decisión.

#En un caso binario, lo mejor que podemos hacer es llamar la regla de Bayes, que es una regla de decisión basada en la probabilidad condicional verdadera, probablemente y es igual a uno dados los predictores x.

#p(x) = Pr(Y=1|X=x)

#Hemos descrito varios enfoques para estimar esta probabilidad condicional.

#Tenga en cuenta que en todos estos enfoques, estimamos la probabilidad condicional directamente y no consideramos la distribución de los predictores.

#En el aprendizaje automático, estos se denominan enfoques discriminativos.

#Sin embargo, el teorema de Bayes nos dice que conocer la distribución de los predictores x puede ser útil.

#Los métodos que modelan la distribución conjunta de "y" y los predictores "x" se denominan modelos generativos.

#Comenzamos describiendo el modelo generativo más general ingenuo Bayes (naive bayes) y luego procedemos a describir algunos casos más específicos, análisis discriminante cuadrático QDA (quqdrantic Discrimitive Analisis) y análisis discriminante lineal LDA(lineal Descriminative Analisis).

#Recuerde que el teorema de Bayes nos dice que podemos reescribir la probabilidad condicional como esta con las f que representan las funciones de distribución de los predictores x para las dos clases "y" es igual a 1 y cuando "y" es igual a 0.

#p(x) = Pr(Y=1|X=x)


#La fórmula implica que si podemos estimar estas distribuciones condicionales, los predictores, podemos desarrollar un poderoso ámbito de decisión.

#Sin embargo, este es un gran si (big if) como condicionante.

#A medida que avanzamos, encontraremos ejemplos en los que los predictores "x" tienen muchas dimensiones y no tenemos mucha información sobre su distribución.

#Por lo tanto, será muy difícil estimar esas distribuciones condicionales.

#En estos casos, Bayes ingenuo sería prácticamente imposible de implementar.

#Sin embargo, hay casos en los que tenemos un pequeño número de predictores, no más de dos, y muchas categorías en las que los modelos generados pueden ser bastante potentes.

#Describimos dos ejemplos específicos y utilizamos nuestro estudio de caso descrito anteriormente para ilustrarlos.
