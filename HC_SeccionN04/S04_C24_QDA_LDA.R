#S04_C24_QDA_LDA
#Quadrantic discriminate analisis, Lineal Discriminate Analisis

library(tidyverse)
library(dslabs)
library(caret)

#El análisis discriminatorio cuadrático, o QDA, es una versión de Naive Bayes en la que suponemos que las probabilidades condicionales para los predictores son multivariadas normales.

#Entonces, el ejemplo simple que describimos en nuestro tema Naive Bayes fue en realidad QDA.

#En este tema, veremos un ejemplo un poco más complicado en el que tenemos dos predictores.

#Son los dos o siete ejemplos que hemos visto anteriormente.

#Podemos cargarlo con este código.

data("mnist_27")

#En este caso, tenemos dos predictores.

#Por lo tanto, suponemos que su distribución condicional es bivariada normal.

#Esto implica que necesitamos estimar dos promedios, dos desviaciones estándar y una correlación para cada caso, los sietes y los dos.

#Una vez que tengamos estos, podemos aproximar las distribuciones condicionales.

#Podemos estimar fácilmente estos parámetros a partir de los datos utilizando este código simple.

params <- mnist_27$train %>% 
  group_by(y) %>% 
  summarize(avg_1 = mean(x_1), avg_2 = mean(x_2), sd_1 = sd(x_1), sd_2 = sd(x_2), r = cor(x_1, x_2))

params

#También podemos demostrar visualmente el enfoque.

#Trazamos los datos y usamos gráficos de contorno para dar una idea de cómo son las dos densidades normales estimadas.

mnist_27$train %>% mutate(y = factor(y)) %>%
  ggplot(aes(x_1, x_2, fill = y, color = y)) +
  geom_point(show.legend = FALSE) +
  stat_ellipse(type="norm", lwd = 1.5)


#Mostramos una curva que representa una región que incluye el 95% de los puntos.

#Una vez que haya estimado estas dos distribuciones, esto define una estimación de la probabilidad condicional de y igual a 1, dados x1 y x2.

#Podemos usar el paquete caret para ajustar el modelo y obtener predictores.

#El código es bastante simple y se ve así.

train_qda <- train(y ~ . , method = "qda", data = mnist_27$train)

#Vemos que obtenemos una precisión relativamente buena de 0,82.

y_hat <- predict(train_qda, mnist_27$test)

confusionMatrix(data = y_hat, reference = mnist_27$test$y)$overall["Accuracy"]


#La probabilidad condicional estimada se ve relativamente similar a la distribución real, como podemos ver aquí, aunque el ajuste no es tan bueno como el que obtuvimos con los suavizadores de núcleo que filmamos en un video anterior, y hay una razón para esto.

#La razón es que podemos mostrar matemáticamente que el límite debe ser una función cuadrática de la forma x2 = a a=x1 al cuadrado + bx + c.

#Una razón por la que QDA no funciona tan bien como el método del núcleo es quizás porque las suposiciones de normalidad no se mantienen.

#Aunque para los dos la aproximación normal bivariada parece razonable, para los siete parece estar apagada.

#Observe la ligera curvatura.

mnist_27$train %>% mutate(y = factor(y)) %>%
  ggplot(aes(x_1, x_2, fill = y, color = y)) +
  geom_point(show.legend = FALSE) +
  stat_ellipse(type="norm") +
  facet_wrap(~y)

#Aunque QDA funciona bien aquí, se vuelve más difícil de usar a medida que aumenta el número de predictores.

#Aquí tenemos dos predictores y tenemos que calcular cuatro medias, cuatro desviaciones estándar y dos correlaciones.

#¿Cuántos parámetros tendríamos que estimar si, en lugar de dos predictores, tuvieramos 10?

  
#El principal problema proviene de la estimación de correlaciones para 10 predictores.

#Con 10, tenemos 45 correlaciones para cada clase.

#En general, esta fórmula nos dice cuántos parámetros tenemos que estimar, y se hace grande bastante rápido.

#Una vez que el número de parámetros se acerca al tamaño de nuestros datos, el método deja de ser práctico debido al sobreajuste.

#Una solución relativamente simple al problema de tener demasiados parámetros es asumir que la estructura de correlación es la misma para todas las clases.

#Esto reduce la cantidad de parámetros que necesitamos estimar.

#En el ejemplo que hemos estado examinando, podríamos calcular solo un par de desviaciones estándar y una correlación.

#Entonces los parámetros se verían así.

#Puede usar este código para estimarlo.

params <- mnist_27$train %>% 
  group_by(y) %>%
  summarize(avg_1 = mean(x_1), avg_2 = mean(x_2), 
            sd_1 = sd(x_1), sd_2 = sd(x_2), r = cor(x_1, x_2))

params <- params %>% mutate(sd_1 = mean(sd_1), sd_2 = mean(sd_2), r = mean(r))

params

#Ahora las distribuciones condicionales se ven así.


mnist_27$train %>% mutate(y = factor(y)) %>%
  ggplot(aes(x_1, x_2, fill = y, color = y)) +
  geom_point(show.legend = FALSE) +
  stat_ellipse(type="norm", lwd = 1.5)


#Observe cómo el tamaño de las elipses, así como los ángulos, son los mismos.

#Esto se debe a que tienen la misma desviación estándar y correlaciones.

#Esa es la suposición.

#Cuando forzamos esta suposición, podemos mostrar matemáticamente que el límite está alineado, al igual que con la regresión logística.

#Por esta razón, llamamos al método análisis discriminante lineal.

#Aquí está la estimación de la probabilidad condicional que obtenemos al usar LDA.

train_lda <- train(y ~., method = "lda", data = mnist_27$train)
y_hat <- predict(train_lda, mnist_27$test)
confusionMatrix(data = y_hat, reference = mnist_27$test$y)$overall["Accuracy"]


#En este caso, la falta de flexibilidad no nos permite obtener una buena estimación, y podemos ver que nuestra precisión es bastante baja.