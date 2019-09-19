#S05_C27_Arboles_Clasificacion_Regresion_CART
#Arboles de Clasificación y Regresión

library(tidyverse)
library(dslabs)
library(caret)

#Para motivar este tema, utilizaremos un nuevo conjunto de datos que incluye el desglose de la composición de la aceituna en ocho ácidos grasos.

#Puede obtener los datos de esta manera.

data("olive")
head(olive)

#Con fines ilustrativos, intentaremos predecir la región utilizando los valores de composición de ácidos grasos como predictores.

table(olive$region)

#Es el norte de Italia, Cerdeña o el sur de Italia.

#Eliminaremos la columna de área porque no la usamos como predictor.

olive <- select(olive, -area)

#Veamos muy rápidamente cómo lo hacemos usando k-vecinos más cercanos (k-nn).

#Usamos el paquete caret para adaptarnos al modelo, y obtenemos una precisión de aproximadamente 0,97, bastante buena.

fit <- train(region ~ . , method = "knn", 
             tuneGrid = data.frame(k = seq(1,15,2)), 
             data = olive)

ggplot(fit)


#Sin embargo, un poco de exploración de datos revela que deberíamos poder hacerlo aún mejor.

#Por ejemplo, si observamos la distribución de cada predictor estratificado por región, vemos que uno de los ácidos grasos solo está presente en el sur de Italia, y luego otro separa el norte de Italia de Cerdeña.

olive %>% gather(fatty_acid, percentage, -region) %>%
  ggplot(aes(region, percentage, fill = region)) +
  geom_boxplot() +
  facet_wrap(~fatty_acid, scales = "free") +
  theme(axis.text.x = element_blank())


#Esto implica que deberíamos ser capaces de construir un algoritmo que prediga perfectamente.

#Podemos ver esto claramente al trazar los valores de estos dos ácidos grasos.

# plot values for eicosenoic and linoleic

p <- olive %>% 
  ggplot(aes(eicosenoic, linoleic, color = region)) + 
  geom_point()
p + geom_vline(xintercept = 0.065, lty = 2) + 
  geom_segment(x = -0.2, y = 10.54, xend = 0.065, yend = 10.54, color = "black", lty = 2)


#Podemos, a simple vista, construir una regla de predicción de las particiones del espacio predictor como este.

#Específicamente, definimos la siguiente regla de decisión.

#Si el primer predictor es mayor que 0.065, B, pronostique el sur de Italia.

#Si no, entonces mira el segundo predictor.

#Y si es mayor que 10.535, pronostique Cerdeña y el norte de Italia de lo contrario.

#Podemos dibujar esto como un árbol de decisión como este.

#Los árboles de decisión como este a menudo se usan en la práctica.

#Por ejemplo, para decidir si una persona en riesgo de sufrir un ataque cardíaco, un médico usará un árbol de decisión como este.

#La idea general es definir un algoritmo que use datos para crear árboles como los que acabamos de mostrar.

#Los árboles de regresión y decisión operan al predecir una variable de resultado y al dividir el espacio del predictor.

#Cuando el resultado es continuo, llamamos a este tipo de algoritmos árboles de regresión.

#Usaremos un caso continuo, los datos de la encuesta de 2008 presentados anteriormente, para describir la idea básica de cómo construimos estos algoritmos.

#Intentaremos estimar la expectativa condicional: la llamaremos f de x, el valor esperado de y dado x con y, el margen de la encuesta yx, el día.

#Aquí hay un gráfico de los datos.

data("polls_2008")
qplot(day, margin, data = polls_2008)


#La idea general aquí es construir un árbol de decisión.

#Y al final de cada nodo, tendremos una predicción diferente Y hat.

#Así es como lo hacemos.

#Primero dividimos el espacio en j regiones no superpuestas, R1, R2, hasta Rj.

#Para cada observación que sigue dentro de una región, digamos, región Rj, predecimos el Y hat con el promedio de todas las observaciones de entrenamiento en esa región.

#Pero, ¿cómo decidimos las particiones R1, R2, etc.?
  
#¿Y cómo decidimos cuántos?
  
#Los árboles de regresión crean particiones recursivamente.

#Pero ¿qué significa esto?
  
#OK, supongamos que ya tenemos una partición.

#Luego tenemos que decidir qué predictor j usar para hacer la siguiente partición y dónde hacerlo dentro de ese predictor.

#Supongamos que ya tenemos una partición para que cada observación esté exactamente en una de estas particiones.

#Para cada una de estas particiones, dividiremos más usando el siguiente algoritmo.

#Primero necesitamos encontrar un predictor j y un valor s que definan dos nuevas particiones.

#Llamémoslos R1 y R2.

#Estas dos particiones dividirán nuestras observaciones en los siguientes dos conjuntos.

#Luego, en cada uno de estos dos conjuntos, definiremos un promedio y los utilizaremos como nuestras predicciones.

#Los promedios serán los promedios de las observaciones en cada una de las dos particiones.

#Entonces podríamos hacer esto por muchos Js y Ss.

#Entonces, ¿cómo los elegimos?
  
#Escogemos la combinación que minimiza la suma residual de cuadrados definida por esta fórmula.

#Esto se aplica recursivamente.

#Seguimos encontrando nuevas regiones para dividir en dos.

#Una vez que hayamos terminado de dividir el espacio del predictor en regiones, en cada región, se realiza una predicción utilizando las observaciones en esa región.

#Básicamente calculas un promedio.

#Echemos un vistazo a lo que hace este algoritmo en los datos de la encuesta de elecciones presidenciales de 2008.

#Usaremos la función rpart en el paquete rpart.

#Simplemente escribimos esto.

library(rpart)

fit <- rpart(margin ~ ., data = polls_2008)

#Aquí solo hay un predictor.

#Por lo tanto, no tenemos que decidir por qué predictor j dividir.

#Simplemente tenemos que decidir qué valores utilizamos para dividir.

#Podemos ver visualmente dónde se hicieron las divisiones utilizando este fragmento de código.

plot(fit, margin = 0.1)
text(fit, cex = 0.75)

#Aquí hay un árbol.

#La primera división se realiza el día 39.5.

#Entonces, una de esas dos regiones se divide en el día 86.5.

#Las dos nuevas particiones resultantes se dividen el día 49.5 y 117.5 respectivamente, y así sucesivamente.

#Terminamos con ocho particiones.

#La estimación final de f de x se ve así.

polls_2008 %>% 
  mutate(y_hat = predict(fit)) %>% 
  ggplot() +
  geom_point(aes(day, margin)) +
  geom_step(aes(day, y_hat), col="red")

#Ahora, ¿por qué el algoritmo dejó de particionar a las ocho?
  
#Hay algunos detalles del algoritmo que no explicamos.

#Vamos a explicarlos ahora.

#Tenga en cuenta que cada vez que dividimos y definimos dos nuevas particiones, nuestro conjunto de entrenamiento disminuye la suma residual de cuadrados.

#Esto se debe a que con más particiones, nuestro modelo tiene más flexibilidad para adaptarse a los datos de entrenamiento.

#De hecho, si divide hasta que cada punto sea su propia partición, la suma residual de los cuadrados se reduce a cero, ya que el promedio de un valor es el mismo valor.

#Para evitar este sobreentrenamiento, el algoritmo establece un mínimo de cuánto debe mejorar la suma residual de cuadrados para que se agregue otra partición.

#Este parámetro se conoce como parámetro de complejidad o CP.

#La suma residual de cuadrados debe mejorar por un factor de CP la nueva partición que se agregará.

#Otro aspecto del algoritmo que no describimos es que establece un número mínimo de observaciones para ser particionadas.

#En el paquete rpart, esa función rpart tiene un argumento llamado minsplit que le permite definir esto.

#El valor predeterminado es 20.

#El algoritmo también establece un mínimo en el número de observaciones en cada partición.

#En la función rpart, este argumento se llama minbucket.

#Entonces, si la división óptima resulta en una partición con menos observación que este mínimo, no se considera.

#El valor predeterminado para este parámetro es minplit dividido por 3 redondeado al entero más cercano.

#Bien, veamos qué sucede si establecemos CP en 0 y minsplit en 2.

#¿Qué pasará entonces?
  
#Bueno, nuestra predicción son nuestros datos originales porque el árbol seguirá dividiéndose y dividiéndose hasta que el RSS se minimice a cero.

#Aquí están los datos con el ajuste resultante.

fit <- rpart(margin ~ ., data = polls_2008, control = rpart.control(cp = 0, minsplit = 2))

polls_2008 %>% 
  mutate(y_hat = predict(fit)) %>% 
  ggplot() +
  geom_point(aes(day, margin)) +
  geom_step(aes(day, y_hat), col="red")

#Ahora, tenga en cuenta que en esta metodología, también podemos podar árboles cortando particiones que no cumplen con un criterio de CP.

#Entonces podemos cultivar un árbol muy, muy grande y luego podar las ramas para hacer un árbol más pequeño.

#Usamos la funcion prune() que significa podar.

#Aquí hay un código de cómo hacer esto.

pruned_fit <- prune(fit, cp = 0.01)


polls_2008 %>% 
  mutate(y_hat = predict(pruned_fit)) %>% 
  ggplot() +
  geom_point(aes(day, margin)) +
  geom_step(aes(day, y_hat), col="red")

#Con el código que acabamos de escribir, aquí está la estimación resultante.

#OK, ¿pero ahora es el valor predeterminado de CP el mejor?
  
#¿Cómo elegimos CP?
  
#Bueno, podemos usar validación cruzada, al igual que con cualquier otro parámetro de ajuste.

#Podemos usar la función train() del paquete caret, por ejemplo.

#Podemos escribir este código, luego trazar el resultado y elegir el mejor CP.

train_rpart <- train(margin ~ . , 
                     method = "rpart", 
                     tuneGrid = data.frame(cp = seq(0,0.05,len = 25)), 
                     data = polls_2008)

ggplot(train_rpart) 

#Para ver el árbol resultante que minimiza el error cuadrático medio, podemos acceder a él a través del modelo final del componente.

#Si lo trazamos, podemos ver el árbol.

#Aquí está.

#Y debido a que solo tenemos un predictor, en realidad podemos trazar una f de x.


polls_2008 %>% 
  mutate(y_hat = predict(train_rpart)) %>% 
  ggplot() +
  geom_point(aes(day, margin)) +
  geom_step(aes(day, y_hat), col="red")

#Aquí está.

#Puedes ver que el ajuste se ve razonable.