#S03_C08_Regresion_Ponderada_Local_loess
#Regresion Ponderada Local loess

#Una limitación del enfoque de bin más suave que acabamos de describir es que necesitamos ventanas pequeñas para mantener el supuesto aproximadamente constante.

#Como resultado, terminamos con un pequeño número de puntos de datos para promediar.

#Y como resultado de esto, obtenemos estimaciones imprecisas de nuestra tendencia.

#Aquí, describimos cómo la regresión ponderada local o loess nos permite considerar ventanas más grandes.

#Para hacer esto, utilizaremos un resultado matemático conocido como el teorema de Taylor, que nos dice que si miras lo suficientemente cerca de cualquier función suave f, se ve como una línea.

#Para ver por qué esto tiene sentido, considere los bordes curvos que hacen los jardineros.

#Los hacen usando espadas que son líneas rectas para que puedan generar curvas que son líneas rectas locales.

#Entonces, en lugar de asumir que la función es aproximadamente constante en una ventana, asumimos que la función es localmente lineal.

#Con el supuesto lineal, podemos considerar tamaños de ventana más grandes que con una constante.

#Entonces, en lugar de la ventana de una semana, consideraremos una ventana más grande en la que la tendencia es aproximadamente lineal.

#Comenzamos con una ventana de tres semanas y luego consideramos habilitar otras opciones.

#Entonces, el modelo para los puntos que están en una ventana de tres semanas se ve así.

#E[Yi|Xi = xi] = B0 + B1(xi - x0)

#If |xi - x0| <= 10.5

#Suponemos que Y dado X en esa ventana es una línea.

#Ahora, para cada punto x0 loess define una ventana y luego ajusta una línea dentro de esa ventana.

#Así que aquí hay un ejemplo de esos ajustes para x0 es igual a 125 negativo y x0 es igual a 55 negativo.

library(dslabs)
library(tidyverse)

polls_2008 %>% ggplot(aes(day, margin)) +
  geom_point() + 
  geom_smooth(color="red", span = 0.15, method.args = list(degree=1))



#Los valores ajustados en x0 se convierten en nuestra estimación de la tendencia.

#En esta animación, demostramos la idea.

#El resultado final es un ajuste más suave que el bin liso ya que utilizamos tamaños de muestra más grandes para estimar nuestros parámetros locales.

#Puede obtener la estimación final utilizando este código, y se ve así.

total_days <- diff(range(polls_2008$day))
span <- 21/total_days

fit <- loess(margin ~ day, degree = 2, span = span, data = polls_2008)

polls_2008 %>% mutate(smooth = fit$fitted) %>%
  ggplot(aes(day, margin)) +
  geom_point(size = 3, alpha = .5, color = "grey") + 
  geom_line(aes(day, smooth), color = "red")


#Ahora, tenga en cuenta que diferentes tramos nos dan diferentes estimaciones.

#Podemos ver cómo diferentes tamaños de ventana conducen a diferentes estimaciones con esta animación.

#Aquí están las estimaciones finales.

#Podemos ver que con 0.1 la línea es bastante ondulada.


polls_2008 %>% ggplot(aes(day, margin)) +
  geom_point() + 
  geom_smooth(color="red", span = 0.1, method.args = list(degree=1))


#Con 0.15, es un poco menos.


polls_2008 %>% ggplot(aes(day, margin)) +
  geom_point() + 
  geom_smooth(color="red", span = 0.15, method.args = list(degree=1))



#Ahora, con 0.25, obtenemos una estimación bastante suave.


polls_2008 %>% ggplot(aes(day, margin)) +
  geom_point() + 
  geom_smooth(color="red", span = 0.25, method.args = list(degree=1))


#Y con 0.66, casi parece una línea recta.

polls_2008 %>% ggplot(aes(day, margin)) +
  geom_point() + 
  geom_smooth(color="red", span = 0.66, method.args = list(degree=1))



#Hay otras tres diferencias entre loess y el bin suavizador típico que describimos aquí.

#La primera es que, en lugar de mantener el tamaño del contenedor igual, loess mantiene el mismo número de puntos utilizados en el ajuste local.

#Este número se controla mediante el argumento span que espera una proporción.

#Entonces, por ejemplo, si N es un número de puntos de datos y el intervalo es 0.5, entonces para cualquier X dado, loess usará 0.5 veces N puntos más cercanos a X para el ajuste.

#Otra diferencia es que al ajustar una línea localmente, loess utiliza un enfoque ponderado.

#Básicamente, en lugar de mínimos cuadrados, minimizamos una versión ponderada.

#Entonces minimizaríamos esta ecuación.

#Sin embargo, en lugar del núcleo gaussiano, loess usa una función llamada el peso triple de Tukey que puedes ver aquí.

#Y para definir pesos, utilizamos esta fórmula.

#w0(xi) = W(xi - x0 / h)


#El núcleo para el peso triple se ve así.

#La tercera diferencia es que loess tiene la opción de ajustar el modelo local de manera robusta.

#Se implementa un algoritmo iterativo en el que, después de ajustar un modelo en una iteración, se detectan valores atípicos y se ponderan hacia abajo para la siguiente iteración.

#Para usar esta opción, use la familia de argumentos igual simétrica.

#Un punto más importante sobre loess.

#El teorema de Taylor también nos dice que si miras una función lo suficientemente cerca, parece una parábola y que no tienes que mirar tan cerca como lo haces para la aproximación lineal.

#Esto significa que podemos hacer que nuestras ventanas sean aún más grandes y ajustar parábolas en lugar de líneas, para que el modelo local se vea así.

#E[Yi|Xi=xi] = B0 + B1(xi-x0) + B2(xi-x0)^2

#If |xi - x0| < = h


#Este es realmente el procedimiento predeterminado para la función loess.

#Es posible que haya notado que cuando mostramos el código para loess, establecemos un grado de parámetro igual a 1 (degree = 1).

#Esto le dice a loess que se ajuste a polinomios de grado 1, un nombre elegante para líneas.

#Si lees la página de ayuda para loess, verás que el grado de argumento por defecto es 2.

#Entonces, por defecto, loess se ajusta a parábolas, no a líneas.

#Aquí hay una comparación de las líneas de ajuste, las líneas rojas discontinuas y las parábolas de ajuste, el sólido naranja.


fit <- loess(margin ~ day, degree = 2, span = span, data = polls_2008)

polls_2008 %>% mutate(smooth = fit$fitted) %>%
  ggplot(aes(day, margin)) +
  geom_point(size = 3, alpha = .5, color = "grey") + 
  geom_line(aes(day, smooth), color = "orange")



#Tenga en cuenta que el grado igual a 2 nos da un resultado más ondulante.

#Personalmente prefiero grado igual a 1, ya que es menos propenso a este tipo de ruido.

#Ahora, una nota final.

#Esto se relaciona con ggplot.

#Tenga en cuenta que ggplot usa loess y la función geom smooth.

#Entonces, si escribe esto, obtendrá sus puntos y su línea de loess ajustada.

polls_2008 %>% ggplot(aes(day, margin)) +
  geom_point() + 
  geom_smooth()

#Pero tenga cuidado con la tabla predeterminada, ya que rara vez son óptimas.

#Sin embargo, puede cambiarlos con bastante facilidad como se demuestra en este código, y ahora tenemos un mejor ajuste.

polls_2008 %>% ggplot(aes(day, margin)) +
  geom_point() + 
  geom_smooth(color="red", span = 0.15, method.args = list(degree=1))
