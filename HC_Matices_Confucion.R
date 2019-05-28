#matrices de Confución

#Trayendo datos del ejercicio anterior HC_carret

library(tidyverse)
library(caret)
library(dslabs)
library(e1071)
data("heights")

y <- heights$sex
x <- heights$height

set.seed(2)
test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)

train_set <- heights[-test_index,]
test_set <- heights[test_index,]


y_hat <- sample(c("Male", "Female"),
                length(test_index), replace = TRUE) %>% 
  factor(levels(test_set$sex))

y_hat <- ifelse(x > 62, "Male", "Female") %>% 
  factor(levels = levels(test_set$sex))

cutoff <- seq(61,70)
accuracy <- map_dbl(cutoff, function(x) {
  y_hat <- ifelse(train_set$height > x, "Male", "Female") %>% 
    factor(levels = levels(test_set$sex))
  mean(y_hat == train_set$sex)
} )

best_cutoff <- cutoff[which.max(accuracy)]

best_cutoff

y_hat <- ifelse(test_set$height > best_cutoff, "Male", "Female") %>% 
  factor(levels = levels(test_set$sex)) 

y_hat <- factor(y_hat)

mean(y_hat == test_set$sex)


#Anteriormente, desarrollamos una regla de decisión que predice el sexo masculino si el estudiante es más alto que 64 pulgadas.

#Ahora, dado que la hembra promedio es de aproximadamente 65 pulgadas, esta regla de predicción parece incorrecta.

#¿Que pasó?
  
# Si un estudiante es la altura de la mujer promedio, ¿no deberíamos predecir la mujer?
  
#En términos generales, la precisión general puede ser una medida engañosa.

#Para ver esto, comenzaremos por construir lo que se conoce como la matriz de confusión, que básicamente tabula cada combinación de predicción y valor real.

#Podemos hacer esto en R usando la funcion table(), así.

table(predicted = y_hat, actual = test_set$sex)

#Si estudiamos esta tabla de cerca, revela un problema.

#Si calculamos la precisión por separado para cada sexo, obtenemos lo siguiente.

test_set %>% 
  mutate(y_hat = y_hat) %>%
  group_by(sex) %>%
  summarize(accuracy = mean(y_hat == sex))

#Obtenemos que obtenemos una precisión muy alta para los hombres, 93%, pero una precisión muy baja para las mujeres, 42%.

#Hay un desequilibrio en la precisión para hombres y mujeres.

#Se predice que muchas hembras son masculinas.

#De hecho, estamos llamando a cerca de medias hembras machos.

#¿Cómo puede ser tan alta nuestra precisión general, entonces?
  
#Esto se debe a la prevalencia.

#Hay más machos en los conjuntos de datos que hembras.

#Estas alturas se recopilaron de tres cursos de ciencia de datos, dos de los cuales tenían más hombres inscritos.

#Al final, obtuvimos que el 77% de los estudiantes eran hombres.

prev <- mean(y == "Male")
prev

#Entonces, al calcular la precisión general, el alto porcentaje de errores cometidos por las mujeres se ve superado por las ganancias en las llamadas correctas para los hombres.

#Esto puede ser realmente un gran problema en el aprendizaje automático.

#Si sus datos de entrenamiento están sesgados de alguna manera, es probable que desarrolle un algoritmo también sesgado.

#El hecho de que evaluemos en un conjunto de pruebas no importa, porque ese conjunto de pruebas también se derivó del conjunto de datos sesgados original.

#Esta es una de las razones por las que consideramos métricas distintas de la precisión general al evaluar un algoritmo de aprendizaje automático.

#Existen varias métricas que podemos usar para evaluar un algoritmo de manera tal que la prevalencia no nubla nuestras evaluaciones.

#Y todos estos pueden derivarse de lo que se llama la matriz de confusión.

#Una mejora general en el uso de precisión excesiva es estudiar la sensibilidad y la especificidad por separado.

#Para definir sensibilidad y especificidad, necesitamos un resultado binario.

#Cuando los resultados son categóricos, podemos definir estos términos para una categoría específica.

#En el ejemplo de dígitos, podemos solicitar la especificidad en el caso de predecir correctamente 2 en lugar de algún otro dígito.

#Una vez que especificamos una categoría de interés, podemos hablar de resultados positivos, cuando y es 1, y resultados negativos, cuando y es cero.

#En general, la sensibilidad se define como la capacidad de un algoritmo para predecir un resultado positivo cuando el resultado real es positivo.

#Entonces, llamaremos "y hat" igual a 1 cuando "y" igual a 1.

#Debido a que un algoritmo que dice que todo es positivo, entonces dice que "y hat" es igual a 1 sin importar qué, tiene una sensibilidad perfecta, esta métrica por sí sola no es suficiente para juzgar un algoritmo.

#Por esta razón, también examinamos la especificidad, que generalmente se define como la capacidad de un algoritmo para no predecir lo positivo, por lo que "y hat" es igual a 0, cuando el resultado real no es positivo, "y" es igual a cero.

#Podemos resumir de la siguiente manera.

#Alta sensibilidad significa que "y" es igual a 1 implica que "y sombrero" es igual a 1.

#Alta especificidad significa que "y" es igual a 0 implica que "y sombrero" es igual a 0.

#Ahora hay otra forma de definir la especificidad, "y" es por la proporción de llamadas positivas que son realmente positivas.

#Entonces, en este caso, la alta especificidad se define como "y hat" es igual a 1 implica que "y" es igual a 1.

#Para proporcionar una definición precisa, nombramos las cuatro entradas de la matriz de confusión.

#Entonces, cuando un resultado que es realmente positivo se predice como positivo, llamamos a esto un verdadero positivo, "TP" para abreviar.

#Cuando un resultado realmente negativo se llama positivo, es predictivo positivo, entonces lo llamamos un falso positivo o "FP".

#Cuando un resultado realmente positivo se predice como negativo, lo llamamos falso negativo o "FN".

#Y cuando en realidad los resultados negativos se predicen como negativos, lo llamamos un verdadero negativo o "TN".

#Ahora podemos proporcionar definiciones más específicas.

#La sensibilidad se suele cuantificar mediante verdaderos positivos divididos por la suma de verdaderos positivos más falsos negativos, o la proporción de positivos reales, la primera columna de la matriz de confusión que se denomina positivos.


# TP/(TP+FN)

#Esta cantidad se conoce como la tasa positiva verdadera o recuerdo.

# TPR (True Positive Rate) o RECALL

#La especificidad se suele cuantificar como los verdaderos negativos divididos por la suma de los dos negativos más los falsos positivos, o las proporciones de los negativos, la segunda columna de nuestra matriz de confusión que se llaman negativos.

# TN/(TN+FP)

#Esta cantidad también se llama la tasa negativa verdadera.

# TNR (True Negative Rate)

#Ahora hay otra forma de cuantificar la especificidad, que es los verdaderos positivos divididos por la suma de los verdaderos positivos más los falsos positivos, o la proporción de resultados

# TP/(TP+FN)



#Llamados positivos, la primera fila de nuestra matriz de confusión, que en realidad son positivos.

#Esta cantidad se conoce como "precisión" y también como el valor predictivo positivo, PPV.

#Tenga en cuenta que, a diferencia de la tasa positiva verdadera y la tasa negativa verdadera, la precisión depende de la prevalencia, ya que una prevalencia más alta implica que puede obtener una precisión más alta, incluso al adivinar.

#Los nombres múltiples pueden ser confusos, por lo que incluimos una tabla para ayudarnos a recordar los términos.

#La tabla incluye una columna que muestra la definición si consideramos las proporciones como probabilidades.

#Y aquí está esa tabla.

#La matriz de confusión funciona en el carret package calcula todas estas métricas para nosotros una vez que definimos qué es un positivo.

#La función espera factores como entradas, y el primer nivel se considera el resultado positivo, o y es igual a 1.

#En nuestro ejemplo, femenino es el primer nivel porque viene antes que el masculino alfabéticamente.

#Entonces, si escribimos esta línea de código para nuestras predicciones, obtendremos toda la información de la matriz de confusión en un solo disparo.

confusionMatrix(data = y_hat, reference = test_set$sex)

#Podemos ver que la alta precisión general es posible a pesar de una sensibilidad relativamente baja.

#Como sugerimos anteriormente, la razón por la que esto sucede es la baja prevalencia, 23%.

#La proporción de hembras es baja.

#Debido a que la prevalencia es baja, al no llamar hembras reales a hembras, baja sensibilidad, no disminuye la precisión tanto como habría aumentado si se las llamara hembras de manera incorrecta.

#Este es un ejemplo de por qué es importante examinar la sensibilidad y la especificidad, y no solo la precisión.

#Antes de aplicar este algoritmo a conjuntos de datos generales, debemos preguntarnos si la prevalencia será la misma en el mundo real.