# Curvas de recuperación de precisión y ROC

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

#Al comparar dos o más métodos, por ejemplo, adivinar versus usar un corte de altura en nuestro ejemplo de predicción de sexo con altura, observamos la precisión y la F1.

#El segundo método, el que usaba la altura, superó claramente.

#Sin embargo, mientras que para el segundo método consideramos varios cortes, para el primero solo consideramos un enfoque, adivinando con igual probabilidad.

#Tenga en cuenta que adivinar al hombre con mayor probabilidad nos daría una mayor precisión debido al sesgo en la muestra.

#Puedes ver esto escribiendo este código, que predice el sexo masculino.

p <- 0.9

y_hat <- sample(c("Male", "Female"), length(test_index), replace = TRUE, 
                prob = c(p, 1-p)) %>%
  factor(levels = levels(test_set$sex))

mean(y_hat == test_set$sex)

#Al adivinar el 90% del tiempo, hacemos que nuestra precisión suba a 0.72.

#Pero como se describió anteriormente, esto tendría un costo de menor sensibilidad.

#Las curvas que describimos en este video nos ayudarán a ver esto.

#Tenga en cuenta que para cada uno de estos parámetros, podemos obtener una sensibilidad y especificidad diferentes.

#Por esta razón, un enfoque muy común para evaluar métodos es compararlos gráficamente mediante el trazado de ambos.

#Un gráfico ampliamente utilizado que hace esto es la característica operativa del receptor o la curva ROC.(receiver operating characteristic) curve

#La curva ROC más la sensibilidad, la tasa positiva verdadera, frente a una especificidad menos, o la tasa positiva falsa.

#Aquí hay una curva ROC para adivinar el sexo, pero usando diferentes probabilidades de adivinar el sexo masculino.

#La curva ROC para adivinar siempre se ve así, como la línea de identidad.

#Tenga en cuenta que un algoritmo perfecto dispararía directamente a uno y permanecería arriba, sensibilidad perfecta para todos los valores de especificidad.

#Entonces, ¿cómo se compara nuestro segundo enfoque?
  
#Podemos construir una curva ROC para el enfoque basado en altura utilizando este código.

cutoffs <- c(50, seq(60,75),80)

cutoffs

height_cutoff <- map_df(cutoffs, function(x){
  y_hat <- ifelse(test_set$height > x, "Male", "Female") %>% 
    factor(levels = c("Female", "Male"))
  list(method = "Height Cutoff", 
       FPR = 1 - specificity(y_hat, test_set$sex),
       TPR = sensitivity(y_hat, test_set$sex))
})



#Al trazar ambas curvas juntas, podemos comparar la sensibilidad para diferentes valores de especificidad.

#Podemos ver que obtenemos una mayor sensibilidad con el enfoque basado en la altura para todos los valores de especificidad, lo que implica que, de hecho, es un método mejor.

#Tenga en cuenta que al hacer curvas ROC, a menudo es bueno agregar el corte usado a los puntos.

#Se vería así.

#Las curvas ROC son bastante útiles para comparar métodos.

#Sin embargo, tienen una debilidad, y es que ninguna de las medidas trazadas depende de la prevalencia.

#En los casos en que la prevalencia importa, podemos hacer un gráfico de recuperación de precisión.

#Precision-recall plot

probs <- c(50, seq(60,75),80)

guessing <- map_df(probs, function(p){
  y_hat <- sample(c("Male", "Female"), length(test_index), 
                  replace = TRUE, prob = c(p , 1-p)) %>% 
    factor(levels = c("Female", "Male"))
  list(method = "Guess", 
       recall = sensitivity(y_hat, test_set$sex),
       precision = precision(y_hat, test_set$sex))
})

height_cutoff <- map_df(cutoffs, function(x){
  y_hat <- ifelse(test_set$height > x, "Male", "Female") %>% 
    factor(levels = c("Female", "Male"))
  list(method = "Height cutoff", 
       recall = sensitivity(y_hat, test_set$sex), 
       precision = precision(y_hat, test_set$sex))
})


#La idea es similar, pero en cambio trazamos precisión contra el recall.

#Esto es lo que parece la trama comparando nuestros dos métodos.

#De esta trama, vemos inmediatamente que la precisión de la adivinación no es alta.

#Esto se debe a que la prevalencia es baja.

#Si cambiamos los positivos para que sean masculinos en lugar de femeninos, la curva ROC sigue siendo la misma, pero la gráfica de recuperación de precisión cambia.

#Y se parece a esto.