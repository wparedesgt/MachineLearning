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


#Quitando los numeros de los mensajes

sms_corpus_clean <- tm_map(sms_corpus_clean, removeNumbers)

#quitar las palabras to, and, but ya que estas no sirven para el machine learning.

#usaremos la funcion stopwords

sms_corpus_clean <- tm_map(sms_corpus_clean, removeWords, stopwords())

as.character(sms_corpus[[1]])
as.character(sms_corpus_clean[[1]])

#Ahora quitamos las puntuaciones 

sms_corpus_clean <- tm_map(sms_corpus_clean, removePunctuation)

#Revisamos nuevamente

as.character(sms_corpus[[1]])
as.character(sms_corpus_clean[[1]])


#Utilizando la libreria snowballc para usar la funcion wordstream que retorna palabras en presente perfecto.

library(SnowballC)

#Creando un ejemplo para comprension de la funcion

wordStem(c("learn", "learned", "learning", "learns"))


#Aplicando la funcion al ejercicio pero primero el stemDocument

sms_corpus_clean <- tm_map(sms_corpus_clean, stemDocument)

#Después de eliminar números, palabras de parada y puntuación, así como realizar
#De raíz, los mensajes de texto se dejan con los espacios en blanco que anteriormente se separaron.
#Las piezas que ahora faltan. El último paso en nuestro proceso de limpieza de texto es eliminar
#espacios en blanco adicionales, utilizando la transformación incorporada de stripWhitespace ():

sms_corpus_clean <- tm_map(sms_corpus_clean, stripWhitespace)

#Revisando las primeras tres lineas

as.character(sms_corpus_clean[[1]])


#Como puede suponer, el paquete tm proporciona funcionalidad para tokenizar el SMS
#corpus mensaje. La función DocumentTermMatrix () tomará un corpus y creará
#una estructura de datos denominada Matriz de Término del Documento (DTM) en la que las filas indican
#Los documentos (mensajes SMS) y las columnas indican términos (palabras).

sms_dtm <- DocumentTermMatrix(sms_corpus_clean)


#Por otro lado, si no hubiéramos realizado el preprocesamiento, podríamos hacerlo.
#aquí, proporcionando una lista de opciones de parámetros de control para anular los valores predeterminados.
#Por ejemplo, para crear un DTM directamente desde el corpus SMS sin procesar, sin procesar,
#Podemos usar el siguiente comando:

