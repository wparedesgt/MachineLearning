#S04_C23_Controlando_Prevalencia
#Controlando la Prevalencia

library(dslabs)
library(tidyverse)
library(caret)
library(purrr)
library(gridExtra)


data("heights")
y<- heights$height

set.seed(2)

test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)

train_set <- heights %>% slice(-test_index)
test_set <- heights %>% slice(test_index)



params <- train_set %>% 
  group_by(sex) %>% 
  summarize(avg = mean(height), sd = sd(height))


pi <- train_set %>% 
  summarize(pi = mean(sex == "Female")) %>%
  .$pi


x <- test_set$height

f0 <- dnorm(x, params$avg[2], params$sd[2])
f1 <- dnorm(x, params$avg[1], params$sd[1])

p_hat_bayes <- f1*pi / (f1*pi + f0*(1-pi))



#Una buena característica del enfoque Naive Bayes es que incluye un parámetro para tener en cuenta las diferencias en la prevalencia.

#Usando nuestra muestra, estimamos las probabilidades condicionales y la prevalencia pi.

#Si usamos sombreros para denotar las estimaciones, podemos reescribir la estimación de la probabilidad condicional con esta fórmula.

#Como discutimos, nuestra muestra tiene una prevalencia mucho menor que la población general.

#Solo tenemos un 23% de mujeres.

#Entonces, si usamos nuestra regla de que la probabilidad condicional tiene que ser mayor que 0.5 para predecir las mujeres, nuestra precisión se verá afectada debido a la baja sensibilidad, que podemos ver al escribir este código.

y_hat_bayes <- ifelse(p_hat_bayes > 0.5, "Female", "Male")

sensitivity(data = factor(y_hat_bayes), reference = factor(test_set$sex))

#Nuevamente, esto se debe a que el algoritmo da más peso a la especificidad para tener en cuenta la baja prevalencia.

#Puede ver que tenemos una especificidad muy alta al escribir este código.

specificity(data = factor(y_hat_bayes), 
            reference = factor(test_set$sex))



#Esto se debe principalmente al hecho de que pi hat es sustancialmente menor que 0.5, por lo que tendemos a predecir el sexo masculino con más frecuencia que el femenino.

#Tiene sentido que un algoritmo de aprendizaje automático haga esto en nuestra muestra porque tenemos un mayor porcentaje de hombres.

#Pero si tuviéramos que extrapolar esto a la población general, nuestra precisión general se vería afectada por la baja sensibilidad.

#El enfoque de Naive Bayes nos da una forma directa de corregir esto, ya que simplemente podemos forzar que nuestra estimación de pi sea diferente.

#Por lo tanto, para equilibrar la especificidad y la sensibilidad, en lugar de cambiar el límite en la regla de decisión, simplemente podríamos cambiar la perspectiva.

#Aquí en este código, lo cambiamos a 0.5.

p_hat_bayes_unbiased <- f1*0.5 / (f1*0.5 + f0*(1-0.5))

y_hat_bayes_unbiased <- ifelse(p_hat_bayes_unbiased > 0.5, "Female", "Male")


#Ahora observe la diferencia en sensibilidad y el mejor equilibrio.

#Podemos verlo usando este código.

sensitivity(data = factor(y_hat_bayes_unbiased), reference = factor(test_set$sex))

#Este gráfico nos muestra que la nueva regla también nos da un límite muy intuitivo entre 66 y 67, que es aproximadamente la mitad de las alturas promedio de hombres y mujeres.

qplot(x, p_hat_bayes_unbiased, geom = "line") +
  geom_hline(yintercept = 0.5, lty = 2) +
  geom_vline(xintercept = 67, lty = 2)
