#Aprendizaje Probabilístico - Clasificación utilizando Naive bayes

library(tidyverse)

#Leer la data spam

sms_raw <- read.csv("data/sms_spam.csv", stringsAsFactors = FALSE)

#ver la estructura

str(sms_raw)

#Cambiando el tipo a factor

sms_raw$type <- factor(sms_raw$type)

#utilizando la funcion table para ver contabilizar los tipos

table(sms_raw$type)

#Preparación de datos, limpieza y estandarizando los datos del texto.

library(tm)

#Cambiando texto a vector con la funcion vcorpus

sms_corpus <- VCorpus(VectorSource(sms_raw$text))


#Listando los operadores con la funcion inspect()

inspect(sms_corpus[1:2])

#Revisando una sola linea para verificar OJO observar el doble []


as.character(sms_corpus[[1]])


#Aplicando un procedimiento a cada elemento co lapply()

lapply(sms_corpus[1:2], as.character)


#Limpiando el texto, estandarizando las palabras removiendo las puntuaciones.

#Aplicando la funcion tm_map para realizar lo que se requiere, cambiando todo a minusculas


sms_corpus_clean <- tm_map(sms_corpus, content_transformer(tolower))

#Comparando los dos archivos para verificar que las letras mayusculas fueran eliminadas.

as.character(sms_corpus[[1]])
as.character(sms_corpus_clean[[1]])




