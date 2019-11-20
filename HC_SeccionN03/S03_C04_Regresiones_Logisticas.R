#S03_C04_Regresiones_Logisticas
#Regresiones Logisticas

library(dslabs)
library(tidyverse)
library(caret)



data("heights")

y <- heights$height
set.seed(2, sample.kind = "Rounding")

test_index <- createDataPartition(y, times = 1, p= 0.5, list = FALSE)
train_set <- heights %>% slice(-test_index)
test_set <- heights %>% slice(test_index)

#Tenga en cuenta que la función beta 0 más beta 1x puede tomar cualquier valor, incluidos los negativos y valores superiores a 1.

#De hecho, la estimación que obtuvimos para nuestra probabilidad condicional usando regresión lineal va de 0,4 negativo a 1,12.

#Pero estamos estimando una probabilidad que está entre 0 y 1.

#Entonces, ¿podemos evitar esto?
  
# La regresión logística es una extensión de la regresión lineal que nos asegura que la estimación de la probabilidad condicional está, de hecho, entre 0 y 1.

#Este enfoque hace uso de la transformación logística introducida en el curso de visualización de datos, que puede ver aquí.

#La transformación logística convierte las probabilidades en probabilidades de registro.

#Como se discutió en el curso de visualización de datos, las probabilidades nos dicen cuánto más probable es que algo suceda en comparación con lo que no suceda.

#Entonces, si p es igual a 0.5, esto significa que las probabilidades son de 1 a 1.

#Por lo tanto, las probabilidades son 1.

#Si p es 0.75, las probabilidades son de 3 a 1.

#Una buena característica de esta transformación es que transforma las probabilidades para que sean simétricas alrededor de 0.

#Aquí hay una gráfica de la transformación logística versus la probabilidad.

#Ahora, ¿cómo encajamos este modelo?
  
#Ya no podemos usar mínimos cuadrados.

#En cambio, calculamos algo llamado estimación de máxima verosimilitud.

#Puede obtener más información sobre este concepto en un libro de texto de teoría estadística.

#En R, podemos ajustar el modelo de regresión logística con la función GLM, que significa modelos lineales generalizados.

#Esta función es más general que la regresión logística, por lo que debemos especificar el modelo que queremos.


#Hacemos esto a través del parámetro familiar.

#Aquí está el código que se ajusta a un modelo de regresión logística a nuestros datos.

glm_fit <- train_set %>% 
  mutate(y = as.numeric(sex == "Female")) %>%
  glm(y ~ height, data=., family = "binomial")

glm_fit

#Al igual que con la regresión lineal, podemos obtener predicciones usando la función de predicción.

#Sin embargo, una vez que leemos el ?predic.glm, nos damos cuenta de que cuando usamos predic() con un objeto GLM, tenemos que especificar que queremos que el tipo sea igual a la respuesta si queremos las probabilidades condicionales.

#Esto se debe a que el valor predeterminado es devolver los valores de transformación logística.

p_hat_logit <- predict(glm_fit, newdata = test_set, type = "response")

#Ahora que lo hemos hecho, podemos ver qué tan bien se ajusta nuestro modelo.

#Tenga en cuenta que este modelo se ajusta a los datos un poco mejor que la línea.

#Debido a que tenemos una estimación de la probabilidad condicional, podemos obtener predicciones usando un código como este.


y_hat_logit <- ifelse(p_hat_logit > 0.5, "Female", "Male") %>% factor

confusionMatrix(y_hat_logit, test_set$sex)$overall[["Accuracy"]]

#Y una vez que miramos la matriz de confusión, vemos que nuestra precisión ha aumentado ligeramente hasta aproximadamente el 80%.

#Tenga en cuenta que las predicciones resultantes son similares.

#Esto se debe a que las dos estimaciones de nuestra probabilidad condicional son mayores que la mitad en aproximadamente las mismas regiones.

#Puedes ver eso en este grafico.

#Tanto la regresión lineal como la logística proporcionan una estimación de la expectativa condicional, que, en el caso de los datos binarios, es equivalente a una probabilidad condicional.

#Entonces podemos usarlo en aplicaciones de aprendizaje automático.

#Sin embargo, una vez que pasemos a ejemplos más complejos, veremos que la regresión lineal y la regresión logística son limitadas y no lo suficientemente flexibles como para ser útiles.

#Las técnicas que aprenderemos son esencialmente enfoques para estimar probabilidades condicionales o expectativas condicionales de manera más flexible.

