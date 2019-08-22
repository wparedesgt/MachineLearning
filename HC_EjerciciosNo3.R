#Ejercicio No. 3

#En un módulo anterior, cubrimos el teorema de Bayes y el paradigma bayesiano. Las probabilidades condicionales son una parte fundamental de esta regla cubierta anterior.

#P (A | B) = P (B | A) P (A) P (B)

#Primero revisamos un ejemplo simple para repasar las probabilidades condicionales.

#Suponga que un paciente ingresa al consultorio del médico para evaluar si tiene una enfermedad en particular.

#La prueba es positiva el 85% del tiempo cuando se prueba en un paciente con la enfermedad (alta sensibilidad): P (prueba + | enfermedad) = 0.85

#La prueba es negativa el 90% del tiempo cuando se prueba en un paciente sano (alta especificidad): P (prueba− | heathy) = 0.90
#La enfermedad es prevalente en aproximadamente el 2% de la comunidad: P (enfermedad) = 0.02

#Usando el teorema de Bayes, calcule la probabilidad de que tenga la enfermedad si la prueba es positiva.

#P(enfermedad | prueba +) = P(prueba + | enfermedad) x P(enfermedad) / P(test+) 

#que es igual a 

#P(test+|enfermedad) * P(enfermedad) / P(test+|enfermedad) X P(enfermedad) + P(test+|saludable) X P(saludable)

p <- (0.85 * 0.02) / ((0.85 * 0.02) + (0.10 * 0.98))


#Las siguientes 4 preguntas (Q2-Q5) se relacionan con la implementación de este cálculo utilizando R.

#Tenemos una población hipotética de 1 millón de individuos con las siguientes probabilidades condicionales como se describe a continuación:
  
#La prueba es positiva el 85% del tiempo cuando se prueba en un paciente con la enfermedad (alta sensibilidad): P (prueba + | enfermedad) = 0.85

#La prueba es negativa el 90% del tiempo cuando se prueba en un paciente sano (alta especificidad): P (prueba− | heathy) = 0.90

#La enfermedad es prevalente en aproximadamente el 2% de la comunidad: P (enfermedad) = 0.02

#Aquí hay un código de muestra para comenzar:

set.seed(1)
disease <- sample(c(0,1), size=1e6, replace=TRUE, prob=c(0.98,0.02))

test <- rep(NA, 1e6)

test[disease==0] <- sample(c(0,1), size=sum(disease==0), replace=TRUE, prob=c(0.90,0.10))

test[disease==1] <- sample(c(0,1), size=sum(disease==1), replace=TRUE, prob=c(0.15, 0.85))

head(test)
str(test)


#¿Cuál es la probabilidad de que una prueba sea positiva?

summary(test)
summary(disease)
mean(test) #Respuesta Correcta


#¿Cuál es la probabilidad de que un individuo tenga la enfermedad si la prueba es negativa?

mean(disease[test==0])


#¿Cuál es la probabilidad de que tenga la enfermedad si la prueba es positiva?

mean(disease[test==1])


#Si la prueba es positiva, ¿cuál es el riesgo relativo de tener la enfermedad?

#Primero calcule la probabilidad de que la enfermedad reciba una prueba positiva, luego normalícela contra la prevalencia de la enfermedad.

mean(disease[test==1]==1) /mean(disease==1)


#Comprobación de comprensión: práctica de probabilidades condicionales

#Ahora vamos a escribir código para calcular las probabilidades condicionales de ser hombre en el conjunto de datos de alturas. Redondea las alturas a la pulgada más cercana. Trace la probabilidad condicional estimada P (x) = Pr (Hombre | altura = x) para cada x.

library(tidyverse)
library(dslabs)
data("heights")

heights %>% 
  mutate(height = round(height)) %>%
  group_by(height) %>%
  summarize(p = mean(sex == "Male")) %>% qplot(height, p, data =.)


