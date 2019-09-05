#S03_C06_Introduccion_Smoothing
#Introduccion a Smoothing

#Antes de continuar con los algoritmos de aprendizaje automático, presentamos el importante concepto de suavizado.

#El suavizado es una técnica muy poderosa utilizada en todo el análisis de datos.

#Otros nombres dados a esta técnica son ajuste de curva y filtrado de paso de banda baja.

#Está diseñado para detectar tendencias en presencia de datos ruidosos en casos en los que se desconoce la forma de la tendencia.

#El nombre de suavizado proviene del hecho de que para lograr esta hazaña suponemos que la tendencia es suave, como en una superficie lisa, y el ruido es impredecible y tambaleante.

#Algo como esto.

#Parte de lo que explicamos aquí son los supuestos que nos permiten extraer una tendencia del ruido.

#Para comprender por qué cubrimos este tema, tenga en cuenta que los conceptos detrás de las técnicas de suavizado son extremadamente útiles en el aprendizaje automático porque las expectativas y probabilidades condicionales pueden considerarse tendencias de formas desconocidas que necesitamos estimar en presencia de incertidumbre.

#Para explicar estos conceptos, nos centraremos primero en un problema con un solo predictor.

#Específicamente tratamos de estimar la tendencia temporal en el voto popular de las elecciones de 2008, la diferencia entre Obama y McCain.

#Puede cargar los datos de esta manera y podemos ver un diagrama aquí.

data("polls_2008")
qplot(day, margin, data = polls_2008)

head(polls_2008)

#Para los propósitos de este ejemplo, no lo piense como un problema de pronóstico.

#Simplemente estamos interesados en aprender la forma de la tendencia después de recopilar todos los datos.

#Suponemos que para cualquier día x, existe una verdadera preferencia entre el electorado, f de x, pero debido a la incertidumbre introducida por el sondeo, cada punto de datos viene con un error, épsilon.

#Un modelo matemático para el margen de encuesta observado, y, es y es igual a f de x más épsilon.

#Y_i = f(x_i) + \varepsilon_i

#Para pensar en esto como un problema de aprendizaje automático, considere que queremos predecir y dado el día x.

#Y que si lo supiéramos, usaríamos la expectativa condicional, f de x es igual a la expectativa de y dado x.

#Pero no lo sabemos, así que tenemos que estimarlo.

#Vamos a comenzar usando la regresión, el único método que conocemos, para ver como le va.

#La línea que vemos no parece describir muy bien la tendencia.

#Tenga en cuenta, por ejemplo, que el 4 de septiembre, este es el día negativo 62, 62 días hasta el día de las elecciones, se celebró la Convención Republicana.

#Esto pareció darle a McCain un impulso en las encuestas, que se puede ver claramente en los datos.

#La línea de regresión no captura esto.

#Para ver aún más la falta de ajuste, observamos que los puntos sobre la línea ajustada, azul, y los que están debajo, rojo, no están distribuidos uniformemente.

#Por lo tanto, necesitamos una alternativa, un enfoque más flexible.
