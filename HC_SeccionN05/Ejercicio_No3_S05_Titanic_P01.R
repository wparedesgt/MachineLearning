#Ejercicio_No3_S05_Titanic_P01

#Ejercicios Barco Titanic

library(dslabs)
library(tidyverse)
library(rpart)
library(caret)
library(purrr)
library(randomForest)
library(titanic)

#Estos ejercicios cubren todo lo que has aprendido en este curso hasta ahora. Utilizará la información de fondo proporcionada para entrenar varios tipos diferentes de modelos en este conjunto de datos.

#Antecedentes

#El Titanic fue un transatlántico británico que chocó contra un iceberg y se hundió en su viaje inaugural en 1912 desde el Reino Unido a Nueva York. Más de 1,500 de los 2,224 pasajeros y tripulantes estimados murieron en el accidente, convirtiéndose en uno de los mayores desastres marítimos fuera de la guerra. El barco transportaba una amplia gama de pasajeros de todas las edades y de ambos sexos, desde viajeros de lujo en primera clase hasta inmigrantes en las clases bajas. Sin embargo, no todos los pasajeros tenían la misma probabilidad de sobrevivir al accidente. Utilizará datos reales sobre una selección de 891 pasajeros para predecir qué pasajeros sobrevivieron.

#Librerias y Datos

 #Library(titanic)

# 3 significant digits

options(digits = 3)

#Limpiando los datos

titanic_clean <- titanic_train %>%
  mutate(Survived = factor(Survived),
         Embarked = factor(Embarked),
         Age = ifelse(is.na(Age), median(Age, na.rm = TRUE), Age), # NA age to median age
         FamilySize = SibSp + Parch + 1) %>%    # count family members
  select(Survived,  Sex, Pclass, Age, Fare, SibSp, Parch, FamilySize, Embarked)

names(titanic_clean)
str(titanic_clean)
summary(titanic_clean)

#Q1


#Divida titanic_clean en conjuntos de prueba y entrenamiento: después de ejecutar el código de configuración, debe tener 891 filas y 9 variables.

#Establezca la semilla en 42, luego use el paquete caret para crear una partición de datos del 20% basada en la columna Sobrevivido. Asigne la partición del 20% a test_set y la partición restante del 80% a train_set.

set.seed(42)

y <- titanic_clean$Survived

index_20 <- createDataPartition(y, times = 1, p = 0.20, list = FALSE)


train_set <- titanic_clean %>% slice(-index_20)
test_set <- titanic_clean %>% slice(index_20)

#¿Cuántas observaciones hay en el conjunto de entrenamiento?

nrow(train_set)

#¿Cuántas observaciones hay en el conjunto de prueba?

nrow(test_set)


train_set$Survived
table(train_set$Survived)

#¿Qué proporción de individuos en el conjunto de entrenamiento sobrevivió?


mean(train_set$Survived == 1)

#Q2

#Pregunta 2: Predicción de referencia al adivinar el resultado


#El método de predicción más simple es adivinar el resultado al azar sin utilizar predictores adicionales. Estos métodos nos ayudarán a determinar si nuestro algoritmo de aprendizaje automático funciona mejor que el azar. ¿Cuán precisos son dos métodos para adivinar la supervivencia de los pasajeros del Titanic?
  
#Establezca la semilla en 3. Para cada individuo en el conjunto de prueba, adivine aleatoriamente si esa persona sobrevivió o no mediante el muestreo del vector c(0,1). Suponga que cada persona tiene la misma oportunidad de sobrevivir o no sobrevivir.

#¿Cuál es la precisión de este método de adivinanzas?

set.seed(3)

y_hat <- sample(c(0,1), 
                length(index_20), 
                replace = TRUE)

mean(y_hat == test_set$Survived)


#Q3 Predecir la supervivencia por sexo


#Use el conjunto de entrenamiento (train_set) para determinar si los miembros de un sexo determinado tenían más probabilidades de sobrevivir o morir. Aplique esta información para generar predicciones de supervivencia en el conjunto de prueba (test_set).

#Que proporcion de mujeres sobrevivieron

train_set %>%
  group_by(Sex) %>%
  summarize(Survived = mean(Survived == 1)) %>%
  filter(Sex == "female") %>%
  pull(Survived)

#Que proporcion de Hombres sobrevivieron

train_set %>%
  group_by(Sex) %>%
  summarize(Survived = mean(Survived == 1)) %>%
  filter(Sex == "male") %>%
  pull(Survived)


#Use el conjunto de entrenamiento para determinar si los miembros de un sexo determinado tenían más probabilidades de sobrevivir o morir. Aplique esta información para generar predicciones de supervivencia en el conjunto de prueba.

#Predecir la supervivencia utilizando el sexo en el conjunto de prueba: si la tasa de supervivencia de un sexo es superior a 0,5, pronostique la supervivencia de todas las personas de ese sexo y prediga la muerte si la tasa de supervivencia de un sexo es inferior a 0,5.

#¿Cuál es la (accuracy) precisión de este método de predicción basado en el sexo en el conjunto de prueba?


pred <- test_set$Sex == "female"
mean(pred == (test_set$Survived == "1"))

#Respuesta de consulta

sex_model <- ifelse(test_set$Sex == "female", 1, 0)    # predict Survived=1 if female, 0 if male
mean(sex_model == test_set$Survived)    # calculate accuracy


#¿En qué clase (es) (Pclass) fueron los pasajeros más propensos a sobrevivir que morir?

train_set %>%
  group_by(Pclass) %>%
  summarize(Survived = mean(Survived == 1)) 
  #filter(Sex == "female") %>%
  #pull(Survived)

          
#Predecir la supervivencia utilizando la clase de pasajero en el conjunto de prueba: predecir la supervivencia si la tasa de supervivencia para una clase es superior a 0,5; de lo contrario, predecir la muerte

#¿Cuál es la precisión de este método de predicción basado en clases en el conjunto de prueba?

head(test_set)


class_model <- ifelse(test_set$Pclass == 1, 1, 0)    # predict Survived=1 if female, 0 if male
mean(class_model == test_set$Survived)    # calculate accuracy


#Agrupe a los pasajeros por sexo y clase de pasajero.
#¿Qué combinaciones de sexo y clase tenían más probabilidades de sobrevivir que morir?

train_set %>%
  group_by(Sex, Pclass) %>% 
  summarize(Survived = mean(Survived == 1)) 


#Predecir la supervivencia utilizando el sexo y la clase de pasajero en el conjunto de prueba. Predecir la supervivencia si la tasa de supervivencia para una combinación de sexo / clase es superior a 0,5; de lo contrario, predecir la muerte.

#¿Cuál es la precisión de este método de predicción basado en el sexo y la clase en el conjunto de prueba?



sex_class_model <- ifelse(test_set$Sex == "female" & test_set$Pclass <= 2, 1, 0)    # predict Survived=1 if female, 0 if male

mean(sex_class_model == test_set$Survived)    # calculate accuracy


#Use la función confusionMatrix para crear matrices de confusión para el modelo sexual, el modelo de clase y el modelo combinado de sexo y clase. Deberá convertir las predicciones y el estado de supervivencia en factores para utilizar esta función.

#¿Cuál es la clase "positiva" utilizada para calcular las métricas de la matriz de confusión?

#test_set$Survived <- factor(test_set$Survived)
sex_model <- factor(sex_model)
class_model <- factor(class_model)
sex_class_model <- factor(sex_class_model)

confusionMatrix(sex_model, reference = test_set$Survived)
confusionMatrix(class_model, reference = test_set$Survived)
confusionMatrix(sex_class_model, reference = test_set$Survived)

#Q6

#Use la función F_meas para calcular las puntuaciones F1 para el modelo de sexo, el modelo de clase y el modelo combinado de sexo y clase. Deberá convertir las predicciones en factores para utilizar esta función.

#¿Qué modelo tiene la puntuación más alta de F1?


F_meas(data = sex_model, reference = factor(test_set$Survived))
F_meas(data = class_model, reference = factor(test_set$Survived))
F_meas(data = sex_class_model, reference = factor(test_set$Survived))


#Q7

#Entrene un modelo usando el análisis discriminante lineal (LDA) con el método de carret lda usando fare como único predictor.

#¿Cuál es la precisión en el conjunto de prueba para el modelo LDA?

set.seed(42)

train_lda <- train(Survived ~ Fare, data = train_set, method = "lda")
predict_lda <- predict(train_lda, test_set)
mean(predict_lda == test_set$Survived)

confusionMatrix(predict_lda, test_set$Survived)$overall[["Accuracy"]]


train_qda <- train(Survived ~ Fare, data = train_set, method = "qda")
predict_qda <- predict(train_qda, test_set)
mean(predict_qda == test_set$Survived)


confusionMatrix(predict_qda, test_set$Survived)$overall[["Accuracy"]]

confusionMatrix(predict(train_qda, test_set), 
                test_set$Survived)$overall["Accuracy"]


#Pregunta 8: modelos de regresión logística

#Entrene un modelo de regresión logística con el método caret glm usando la edad como único predictor.

#¿Cuál es la precisión en el conjunto de prueba usando la edad como único predictor?
names(train_set)

train_glm_age <- train(Survived ~ Age, data = train_set, method = "glm")
predict_glm_age <- predict(train_glm_age, test_set)

confusionMatrix(predict_glm_age, test_set$Survived)$overall[["Accuracy"]]

#Entrene un objeto de regresion glm usando 4 predictores, sex, class, fare and age.

#train_glm <- train(Survived ~ Sex + Pclass + Fare + Age, method = "glm", data = train_set)

train_set_4_pred <- train_set %>% select(Survived, Sex, Pclass, Fare, Age)

train_glm_scfa <- train(Survived ~ ., data = train_set_4_pred, method= "glm")
predict_glm_scfa <- predict(train_glm_scfa, test_set)

confusionMatrix(predict_glm_scfa, test_set$Survived)$overall[["Accuracy"]]

#Entrene un objeto usando el modelo glm con todos los predictores, ignore los warnings por un modelo ajustado deficiente.

train_set_all <- train(Survived ~ ., data = train_set, method  = "glm")
predict_set_all <- predict(train_set_all, test_set)

confusionMatrix(predict_set_all, test_set$Survived)$overall[["Accuracy"]]


#Pregunta No. 9 modelo Knn

#Set seed = 6, entrene un modelo Knn usando el paquete de caret. Pruebe usando el tuneo con k = seq(3,51,2)

#Cual es el valor optimo de vecinos k?

set.seed(6)

train_knn <- train(Survived ~ . , 
                   method = "knn", 
                   data = train_set, 
                   tuneGrid = data.frame(k = seq(3,51, 2)))


train_knn$bestTune

#Realice un plot y muestre cual es el mejor K

ggplot(train_knn, highlight = TRUE)


#Cual es la mejor precision encontrada.


confusionMatrix(predict(train_knn, test_set), test_set$Survived)$overall["Accuracy"]


#Pregunta 10

#Set seed = 8 y entrene un nuevo modelo knn. en lugar del control de entrenamiento predeterminado, utilice la validación cruzada (k-fold cross validation) 10 veces donde cada partición consiste en el 10% del total.


set.seed(8)

p <- 71


fit_knn <- train(x_subset, y, method = "knn", tuneGrid = data.frame(k = seq(101, 301, 25)))
ggplot(fit)

#Pregunta No. 11 Modelos de Clasificacion de Arbol

set.seed(10)
library(caret)

#Entrene un arbol de descicion con el metodo rpart. Ajuste el parametro (complexity) con cp = seq(0,0.05,0.002)

train_rpart <- train(Survived ~ . , 
                     method = "rpart", 
                     tuneGrid = data.frame(cp = seq(0,0.05,0.002)), 
                     data = train_set)

ggplot(train_rpart, highlight = TRUE) 

#Cual es el valor iptimo del parametro cp 

train_rpart$bestTune

#Cual es la mejor presicion

confusionMatrix(predict(train_rpart, test_set), test_set$Survived)$overall["Accuracy"]


#Inspeccione el modelo final y cree un plot de arboles de desicion.

train_rpart$finalModel

plot(train_rpart$finalModel)
text(train_rpart$finalModel)

#Usando las reglas de decision generadas en el modelo final, predecir si los siguientes individuos sobrevivirían.

#Los valores de prueba de mtry varían de 1 a 7. Establezca ntree en 100.


#Pregunta No. 12 Modelo de bosques aleatorios

set.seed(14)
library(caret)

train_rf <- train(Survived ~., 
                  method = "rf", 
                  tuneGrid = data.frame(mtry = c(1:7)),
                  ntree = 100,
                  data = train_set)

#¿Qué valor mtry maximiza la precisión?

ggplot(train_rf, highlight = TRUE)
train_rf$bestTune

#¿Cuál es la precisión del modelo de bosque aleatorio en el conjunto de prueba?

confusionMatrix(predict(train_rf, test_set), 
                test_set$Survived)$overall["Accuracy"]

#Use varImp en el objeto de modelo de bosque aleatorio para determinar la importancia de varios predictores para el modelo de bosque aleatorio.

#¿Cuál es la variable más importante?


imp <- varImp(train_rf)

imp$importance


tibble(term = rownames(imp$importance), 
       importance = imp$importance$Overall) %>%
  mutate(rank = rank(-importance)) %>% arrange(desc(importance)) 

