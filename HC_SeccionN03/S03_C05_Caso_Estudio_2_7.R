#S03_C05_Caso_Estudio_2_7
#Caso de Estudio es un dos o un siete?

library(dslabs)
library(tidyverse)
library(caret)
#En los ejemplos simples que hemos examinado hasta ahora, solo teníamos un predictor.

#En realidad, no consideramos estos desafíos de aprendizaje automático, que se caracterizan por tener muchos predictores.

#Volvamos al ejemplo de dígitos, en el que teníamos 784 predictores.

#Sin embargo, con el fin de obtener resultados, veríamos un subconjunto de este conjunto de datos, donde solo tenemos dos predictores y dos categorías.

#Queremos construir un algoritmo que pueda determinar si un dígito es un dos o un siete de los dos predictores.

#No estamos listos para construir un algoritmo con 784 predictores.

#Entonces extraeremos dos predictores simples del 784.

#Estos serán la proporción de píxeles oscuros que se encuentran en el cuadrante superior izquierdo y la proporción de píxeles que son negros en el cuadrante inferior derecho.

#Para tener un conjunto de datos más manejable, seleccionaremos una muestra aleatoria de 1,000 dígitos del conjunto de entrenamiento que tiene 60,000 dígitos.

#500 estarán en el conjunto de entrenamiento y 500 estarán en el conjunto de prueba.

#De hecho, incluimos estos ejemplos en el paquete DS Lab.

#Y puede cargarlo usando esta línea de código.

data("mnist_27")

#Podemos explorar estos datos trazando los dos predictores y usando colores para denotar las etiquetas.

#Puedes verlos aquí.


mnist_27$train %>% ggplot(aes(x_1, x_2, color = y)) + geom_point()

#Podemos ver de inmediato algunos patrones.

#Por ejemplo, si x1, el primer predictor, que representa el panel superior izquierdo, es grande, entonces el dígito es probablemente un siete.

#Además, para valores más pequeños del segundo predictor, el panel inferior derecho,
#los dos parecen estar en los valores de rango medio.


mnist <- read_mnist()
is <- mnist_27$index_train[c(which.min(mnist_27$train$x_1),        
                             which.max(mnist_27$train$x_1))]
titles <- c("smallest","largest")
tmp <- lapply(1:2, function(i){
  expand.grid(Row=1:28, Column=1:28) %>%
    mutate(label=titles[i],
           value = mnist$train$images[is[i],])
})
tmp <- Reduce(rbind, tmp)
tmp %>% ggplot(aes(Row, Column, fill=value)) +
  geom_raster() +
  scale_y_reverse() +
  scale_fill_gradient(low="white", high="black") +
  facet_grid(.~label) +
  geom_vline(xintercept = 14.5) +
  geom_hline(yintercept = 14.5)


#Para conectar estas ideas a los datos originales, veamos las imágenes de los dígitos con los valores más grandes y más pequeños de x1.

data("mnist_27")
mnist_27$train %>% ggplot(aes(x_1, x_2, color = y)) + geom_point()

is <- mnist_27$index_train[c(which.min(mnist_27$train$x_2),        
                             which.max(mnist_27$train$x_2))]
titles <- c("smallest","largest")
tmp <- lapply(1:2, function(i){
  expand.grid(Row=1:28, Column=1:28) %>%
    mutate(label=titles[i],
           value = mnist$train$images[is[i],])
})
tmp <- Reduce(rbind, tmp)
tmp %>% ggplot(aes(Row, Column, fill=value)) +
  geom_raster() +
  scale_y_reverse() +
  scale_fill_gradient(low="white", high="black") +
  facet_grid(.~label) +
  geom_vline(xintercept = 14.5) +
  geom_hline(yintercept = 14.5)

#Aquí están las imágenes.
#Esto tiene mucho sentido.


#La imagen de la izquierda, que es un siete, tiene mucha oscuridad en el cuadrante superior izquierdo.

#Entonces x1 es grande.

#El dígito de la derecha, que es un dos, no tiene negro en el cuadrante de la esquina superior izquierda.

#Entonces x1 es pequeño.

#Ahora veamos las imágenes originales correspondientes a los valores más grandes y más pequeños del segundo predictor, x2, que representa el cuadrante inferior derecho.

#Aquí vemos que ambos son sietes.

#El siete de la izquierda tiene mucho negro en el cuadrante inferior derecho.

#El siete a la derecha tiene muy poco negro en el cuadrante inferior derecho.

#Entonces podemos comenzar a tener una idea de por qué estos predictores son informativos, pero también por qué el problema será un tanto desafiante.

#Así que intentemos construir un algoritmo de aprendizaje automático con lo que tenemos.

#Realmente no hemos aprendido ningún algoritmo todavía.

#Entonces, comencemos con la regresión logística.

#El modelo será simplemente así.

#p(x_1, x_2) = \mbox{Pr}(Y=1 \mid X_1=x_1 , X_2 = x_2) = 
#  \beta_0 + \beta_1 x_1 + \beta_2 x_2


#La probabilidad condicional de ser un siete dados los dos predictores x1 y x2 será una función lineal de x1 y x2 después de la transformación logística.

#Podemos ajustarlo usando la función glm de esta manera.

fit <- glm(y ~ x_1 + x_2, data=mnist_27$train, family = "binomial")

#Y ahora podemos construir una regla de decisión basada en la estimación de la probabilidad condicional.

#Siempre que sea mayor que 0.5, predecimos un siete.

#Cuando no es así, predecimos un dos.

#Entonces escribimos este código.

p_hat <- predict(fit, newdata = mnist_27$test)
y_hat <- factor(ifelse(p_hat > 0.5, 7, 2))

#Luego calculamos la matriz de confusión y vemos que logramos una precisión del 79%.

confusionMatrix(data = y_hat, reference = mnist_27$test$y)


#No está mal para nuestro primer intento.

#¿Pero podemos hacerlo mejor?
  
#Ahora, antes de continuar, quiero señalar que, para este conjunto de datos en particular, sé la verdadera probabilidad condicional.

#Esto se debe a que construí este ejemplo usando el conjunto completo de 60,000 dígitos.

#Lo uso para construir la verdadera probabilidad condicional p de x1, x2.

#Ahora tenga en cuenta que esto es algo a lo que no tenemos acceso en la práctica, pero incluido aquí en este ejemplo porque nos permite comparar estimaciones con nuestras probabilidades condicionales verdaderas.

#Y esto nos enseña las limitaciones de los diferentes algoritmos.

#Entonces hagamos eso aquí.

#Podemos acceder y trazar la verdadera probabilidad condicional.

#Podemos usar este código.

#Y se ve así.

mnist_27$true_p %>% ggplot(aes(x_1, x_2, fill = p)) + geom_raster()


#Mejoraremos este grafico eligiendo mejores colores.

#Y también dibujaremos una curva que separe los pares, x1, x2, para los cuales la probabilidad condicional es mayor que 0.5 y menor que 0.5.

#Usamos este código.

mnist_27$true_p %>% ggplot(aes(x_1, x_2, z= p, fill = p)) + geom_raster() +
  scale_fill_gradientn(colors = c("#F8766D", "white", "#00BFC4")) +
  stat_contour(breaks = c(0.5), color = "black")


#Y ahora la grafica se ve así.

#Entonces podemos ver la verdadera probabilidad condicional.

#Entonces, para comenzar a comprender las limitaciones de la regresión logística, podemos comparar la probabilidad condicional verdadera con la probabilidad condicional estimada.

#Calculemos el límite que divide los valores de x1 y x2 que hacen que el condicional estimado sea probablemente menor que 0.5 y mayor que 0.5.

#Entonces, en este límite, la probabilidad condicional será igual a 0.5.

#Ahora podemos hacer un poco de matemática, como se muestra aquí.


fit_glm <- glm(y ~ x_1 + x_2, data=mnist_27$train, family = "binomial")
p_hat_glm <- predict(fit_glm, mnist_27$test)
y_hat_glm <- factor(ifelse(p_hat_glm > 0.5, 7, 2))
confusionMatrix(data = y_hat_glm, reference = mnist_27$test$y)$overall["Accuracy"]

p_hat <- predict(fit_glm, newdata = mnist_27$true_p)
mnist_27$true_p %>%
  mutate(p_hat = p_hat) %>%
  ggplot(aes(x_1, x_2,  z=p_hat, fill=p_hat)) +
  geom_raster() +
  scale_fill_gradientn(colors=c("#F8766D","white","#00BFC4")) +
  stat_contour(breaks=c(0.5),color="black") 


#Y si hacemos esto, veremos que el límite no puede ser otra cosa que una línea recta, lo que implica que nuestro enfoque de regresión logística no tiene posibilidades de capturar la naturaleza no lineal de nuestra verdadera probabilidad condicional.

#Puedes ver que el límite de la probabilidad condicional verdadera es una curva.

#Ahora, para ver dónde se cometieron los errores, nuevamente podemos trazar los datos de prueba con x1 y x2 trazados entre sí y con el color utilizado para mostrar la etiqueta. Si hacemos esto, podemos ver dónde se cometen los errores.

p_hat <- predict(fit_glm, newdata = mnist_27$true_p)
mnist_27$true_p %>%
  mutate(p_hat = p_hat) %>%
  ggplot() +
  stat_contour(aes(x_1, x_2, z=p_hat), breaks=c(0.5), color="black") +
  geom_point(mapping = aes(x_1, x_2, color=y), data = mnist_27$test)



#Debido a que la regresión logística divide los sietes y los dos con una línea, perderemos varios puntos que esta forma no puede capturar.

#Entonces necesitamos algo más flexible.

#La regresión logística obliga a nuestras estimaciones a ser un plano y nuestro límite a ser una línea.

#Necesitamos un método que permita otras formas.

#Comenzaremos describiendo el algoritmo vecino más cercano y algunos enfoques del núcleo.

#Para presentar los conceptos detrás de estos enfoques, comenzaremos nuevamente con un ejemplo unidimensional simple y describiremos el concepto de suavizado.




