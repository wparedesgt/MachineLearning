#Vectores

subjet_name <- c("John Doe", "Jane Doe", "Steve Graves")
temperature <- c(98.1, 98.6, 101.4)
flu_status <- c(FALSE, FALSE, TRUE)

#Factores

gender <- factor(c("MALE","FEMALE", "MALE"))

gender

blood <- factor(c("O", "AB", "A"), levels = c("A", "B", "AB", "O"))

blood

symtoms <- factor(c("SEVERE", "MILD", "MODERATE"), levels = c("MILD", "MODERATE", "SEVERE"), ordered = TRUE)

symtoms

symtoms > "MODERATE"


#Listas

subjet_name[1]
temperature[1]
flu_status[1]
gender[1]
blood[1]
syntoms[1]

subject1 <- list(fullname = subjet_name[1], 
                 temperature = temperature[1], 
                 flu_status = flu_status[1], 
                 gender = gender[1], 
                 blood = blood[1], 
                 symtoms = symtoms[1])

subject1

subject1[2]

#Elimina el encabezado

subject1[[2]]

#Acceso directo

subject1$temperature

subject1[c("temperature", "flu_status")]


#Data Frames


pt_data <- data.frame(subjet_name, temperature, flu_status, gender, blood, symtoms, stringsAsFactors = FALSE)

pt_data

pt_data$subjet_name

pt_data[c("temperature", "flu_status")]

pt_data[2:3]

#Segunda Columna Tercer Registro

pt_data[[2:3]]

pt_data[1,2]

pt_data[c(1,3), c(2,4)]

#Todas los datos de la primer columna

pt_data[,1]

#todos los datos de la primera linea

pt_data[1,]

#extraer todo

pt_data[,]

#Matrices y Arreglos

m <- matrix(c(1,2,3,4), nrow = 2)

m

m <- matrix(c(1,2,3,4,5,6), nrow = 2)

m

#En columnas

m <- matrix(c(1,2,3,4,5,6), ncol = 2)

m


#Guardar y Leer


save(m, file = "data/mydata.RData")

load("data/mydata.RData")

m


#lista el contenido de la sesion.

ls()

#Remover

rm(m)

#remover la lista

rm(list = ls())

#Cargando las librerias



library(tidyverse)

usedcars <- read.csv("data/usedcars.csv", stringsAsFactors = FALSE)

str(usedcars)

usedcars %>% head(15)

usedcars %>% tail(15)

summary(usedcars$year)

names(usedcars)

summary(usedcars[c("price", "mileage")])

#Rango de Precios

range(usedcars$price)

#Diferencia de Precion

diff(range(usedcars$price))

#Interquantile

IQR(usedcars$price)

#Quantiles

quantile(usedcars$price)

#Probabilidades

quantile(usedcars$price, probs = c(0.01, 0.99))

#secuencias

quantile(usedcars$price, seq(from = 0, to = 1, by = 0.20))

#creando un boxplot

boxplot(usedcars$price, main = "Boxplot of Used Car Prices", ylab = "odometer (mi.)")
boxplot(usedcars$mileage, main = "Boxplot of Used Car Mileage", ylab = "Odometer (mi.)")


# Histograma

hist(usedcars$price, main = "Histograma", xlab = "Price ($)")
hist(usedcars$mileage, main = "Histogram", xlab = "Odometer (mi.)")

#table salida produce una secuencia de un vector o factor

table(usedcars$year)

table(usedcars$model)

table(usedcars$color)

#generar proporciones

model_table <- table(usedcars$model)
prop.table(model_table)

#Creando porcentajes

color_pct <- table(usedcars$color)
color_pct <- prop.table(color_pct) * 100
round(color_pct, digits = 1)

#scatterplot millas vrs precio

plot(x = usedcars$mileage, y = usedcars$price, main = "Scatterplot", 
     xlab = "Used Car Odometer mi.", ylab = "Used Car Price ($)")




