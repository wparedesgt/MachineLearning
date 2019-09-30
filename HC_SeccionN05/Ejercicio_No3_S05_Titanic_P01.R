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
mean(pred_class == test_set$Survived)    # calculate accuracy


#Agrupe a los pasajeros por sexo y clase de pasajero.
#¿Qué combinaciones de sexo y clase tenían más probabilidades de sobrevivir que morir?

train_set %>%
  group_by(Sex, Pclass) %>% 
  summarize(Survived = mean(Survived == 1)) 


#Predecir la supervivencia utilizando el sexo y la clase de pasajero en el conjunto de prueba. Predecir la supervivencia si la tasa de supervivencia para una combinación de sexo / clase es superior a 0,5; de lo contrario, predecir la muerte.

#¿Cuál es la precisión de este método de predicción basado en el sexo y la clase en el conjunto de prueba?



sex_class_model <- ifelse(test_set$Sex == "female" & test_set$Pclass <= 2, 1, 0)    # predict Survived=1 if female, 0 if male

mean(pred_sex_class == test_set$Survived)    # calculate accuracy


#Use la función confusionMatrix para crear matrices de confusión para el modelo sexual, el modelo de clase y el modelo combinado de sexo y clase. Deberá convertir las predicciones y el estado de supervivencia en factores para utilizar esta función.

#¿Cuál es la clase "positiva" utilizada para calcular las métricas de la matriz de confusión?

test_set$Survived <- factor(test_set$Survived)
sex_model <- factor(sex_model)
class_model <- factor(class_model)
sex_class_model <- factor(sex_class_model)

confusionMatrix(sex_model, reference = test_set$Survived)
confusionMatrix(class_model, reference = test_set$Survived)
confusionMatrix(sex_class_model, reference = test_set$Survived)
