#S05_C30_Paquete_Caret
#Paquete Caret

library(dslabs)
library(tidyverse)
library(caret)

#Ya hemos aprendido acerca de la regresión, la regresión logística y los vecinos k más cercanos como algoritmos de aprendizaje automático.

#En secciones posteriores, aprendemos varios otros.

#Y esto es solo un pequeño subconjunto de todos los algoritmos disponibles.

#Muchos de estos algoritmos se implementan en R. Sin embargo, se distribuyen a través de diferentes paquetes, desarrollados por diferentes autores, y a menudo usan una sintaxis diferente.

#El paquete caret intenta consolidar estas diferencias y proporcionar consistencia.

#Actualmente incluye 237 métodos diferentes, que se resumen en el siguiente sitio.

url <- "https://topepo.github.io/caret/available-models.html"

#Incluiremos el enlace en el curso.

#Tenga en cuenta que caret no instala automáticamente los paquetes necesarios para ejecutar estos métodos.

#Entonces, para implementar un paquete a través de caret, aún necesita instalar la biblioteca.

#El paquete requerido para cada método se incluye en esta página.

url2 <- "https://topepo.github.io/caret/train-models-by-tag.html"

#Incluiremos el enlace en el curso.

#El paquete caret también proporciona una función que realiza validación cruzada para nosotros.

#Aquí proporcionamos algunos ejemplos que muestran cómo utilizamos este paquete increíblemente útil.

#Usaremos el ejemplo de 2 o 7 para ilustrar esto.

#Puedes cargarlo así.

data("mnist_27")

#La función de train nos permite entrenar diferentes algoritmos utilizando una sintaxis similar.

#Entonces, por ejemplo, podemos entrenar un modelo de regresión logística o un modelo k-NN usando una sintaxis muy similar, como esta.

train_glm <- train(y ~., method = "glm", data = mnist_27$train)
train_knn <- train(y ~., method = "knn", data = mnist_27$train)


#Ahora, para hacer predicciones, podemos usar la salida de esta función directamente sin necesidad de mirar los detalles de predict.glm o predict.knn.

#En cambio, podemos aprender cómo obtener predicciones de la función predict.train().

#Una vez que leamos esta página de ayuda, sabemos cómo usar una función de predicción para estos objetos.

#Aquí está el código para obtener las predicciones para la regresión logística y el k-NN.

y_hat_glm <- predict(train_glm, mnist_27$test, type = "raw")
y_hat_knn <- predict(train_knn, mnist_27$test, type = "raw")

#Tenga en cuenta que la sintaxis es muy similar.

#También podemos estudiar muy rápidamente la matriz de confusión.

#Por ejemplo, podemos comparar la precisión de estos dos métodos como este.

confusionMatrix(y_hat_glm, mnist_27$test$y)$overall["Accuracy"]
confusionMatrix(y_hat_knn, mnist_27$test$y)$overall["Accuracy"]
