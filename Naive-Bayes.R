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

sms_dtm2 <- DocumentTermMatrix(sms_corpus, control = list(tolower = TRUE, removeNumbers = TRUE,
                                                          stopwords = TRUE,
                                                          removePunctuation = TRUE,
                                                          stemming = TRUE))


#Esto aplica los mismos pasos de preprocesamiento al corpus de SMS en el mismo orden que
#hecho antes Sin embargo, al comparar sms_dtm con sms_dtm2, vemos una ligera diferencia
#en el número de términos en la matriz:

sms_dtm
sms_dtm2


#El motivo de esta discrepancia tiene que ver con una diferencia menor en el ordenamiento de
#Los pasos de preprocesamiento. La función DocumentTermMatrix () aplica su limpieza
#funciona en las cadenas de texto solo después de que se hayan dividido en palabras. Así,
#Utiliza una función de eliminación de palabras de parada ligeramente diferente. En consecuencia, 
#algunas palabras se dividen de forma diferente a cuando se limpian antes de la tokenización.

#Dividiremos los datos en dos partes: 75 por ciento para entrenamiento y 25 por ciento para
#pruebas. Dado que los mensajes SMS están ordenados al azar, simplemente podemos tomar 
#los primeros 4,169 para entrenamiento y dejar los 1,390 restantes para probar. 
#Afortunadamente, el objeto DTM se parece mucho a un marco de datos y se puede dividir 
#utilizando las operaciones estándar [row, col]. Como nuestro DTM almacena los mensajes 
#SMS como filas y las palabras como columnas, debemos solicitar un rango específico de 
#filas y todas las columnas para cada una:

sms_dtm_train <- sms_dtm[1:4169, ]
sms_dtm_test <- sms_dtm[4170:5559, ]

#Para mayor comodidad, también es útil guardar un par de vectores con etiquetas para
#Cada una de las filas en las matrices de entrenamiento y prueba. Estas etiquetas no se almacenan en
#el DTM, por lo que tendríamos que extraerlos del marco de datos sms_raw original:


sms_train_labels <- sms_raw[1:4169, ]$type

sms_test_labels <- sms_raw[4170:5559, ]$type

#Para confirmar que los subconjuntos son representativos del conjunto completo de datos SMS, vamos a
#Comparar la proporción de spam en los marcos de datos de prueba y entrenamiento:


prop.table(table(sms_test_labels))

prop.table(table(sms_train_labels))


#Ambos contienen el 13% de Spam
