#S06_C41_SVD_PCA


library(dslabs)
library(tidyverse)
library(caret)
data("movielens")



train_small <- movielens %>% 
  group_by(movieId) %>%
  filter(n() >= 50 | movieId == 3252) %>% ungroup() %>% #3252 is Scent of a Woman used in example
  group_by(userId) %>%
  filter(n() >= 50) %>% ungroup()

y <- train_small %>% 
  select(userId, movieId, rating) %>%
  spread(movieId, rating) %>%
  as.matrix()


#Para facilitar la exploración, agregamos nombres de fila y columna.

rownames(y)<- y[,1]

y <- y[,-1]



colnames(y) <- with(train_small, title[match(colnames(y), movieId)])


#La descomposición de factorización matricial que mostramos en el video anterior que se parece a esto está muy relacionada con la descomposición de valores singulares y PCA.

#La descomposición de valores singulares y el análisis de componentes principales son conceptos complicados, pero una forma de entenderlos es pensar, por ejemplo, en la descomposición de valores singulares como un algoritmo que encuentra los vectores "p" y "q" que nos permiten escribir la matriz de residuos "r" con "m" filas y "n" columnas de la siguiente manera.

#Pero con la ventaja adicional de que la variabilidad de estos términos está disminuyendo y también de que los "p" no están correlacionados entre sí.

#El algoritmo también calcula estas variabilidades para que podamos saber qué parte de la variabilidad total de la matriz se explica a medida que agregamos nuevos términos.

#Esto puede permitirnos ver que con solo unos pocos términos, podemos explicar la mayor parte de la variabilidad.

#Veamos un ejemplo con nuestros datos de películas.

#Para calcular la descomposición, hará que todas las NA sean cero.

#Entonces escribiremos este código.

y[is.na(y)] <- 0

y <- sweep(y, 1, rowMeans(y))

pca <- prcomp(y)

#Los vectores "q" se denominan componentes principales y se almacenan en esta matriz.

dim(pca$rotation)

#Mientras que los vectores "p", que son los efectos del usuario, se almacenan en esta matriz.

#La función PCA devuelve un componente con la variabilidad de cada uno de los componentes principales y podemos acceder a él así y trazarlo.

dim(pca$x)

plot(pca$sdev)

#También podemos ver que solo con algunos de estos componentes principales ya explicamos un gran porcentaje de los datos.

var_explained <- cumsum(pca$sdev^2/sum(pca$sdev^2))
plot(var_explained)


#Entonces, por ejemplo, con solo 50 componentes principales, ya estamos explicando aproximadamente la mitad de la variabilidad de un total de más de 300 componentes principales.

#Para ver que los componentes principales realmente están capturando algo importante sobre los datos, podemos hacer un diagrama de, por ejemplo, los dos primeros componentes principales, pero ahora etiquete los puntos con la película con la que cada uno de esos puntos está relacionado.

library(ggrepel)
pcs <- data.frame(pca$rotation, name = colnames(y))
pcs %>%  ggplot(aes(PC1, PC2)) + geom_point() + 
  geom_text_repel(aes(PC1, PC2, label=name),
                  data = filter(pcs, 
                                PC1 < -0.1 | PC1 > 0.1 | PC2 < -0.075 | PC2 > 0.1))

#Con solo mirar los tres primeros en cada dirección, vemos patrones significativos.

#El primer componente principal muestra la diferencia entre las películas aclamadas por la crítica en un lado.

#Aquí están los extremos del componente principal.

options(digits = 3)

pcs %>% select(name, PC1) %>% arrange(PC1) %>% slice(1:10)

#Puedes ver Pulp Fiction, Seven, Fargo, Taxi Driver y los éxitos de taquilla de Hollywood en el otro.

#Entonces, este componente principal tiene películas aclamadas por la crítica por un lado y éxitos de taquilla por el otro.

pcs %>% select(name, PC1) %>% arrange(desc(PC1)) %>% slice(1:10)


#Está separando las películas que tienen estructura y las determinan los usuarios que les gustan más que estas y otras que les gustan más que eso.

#También podemos ver que el segundo componente principal también parece capturar la estructura en los datos.

pcs %>% select(name, PC2) %>% arrange(PC2) %>% slice(1:10)



#Si observamos un extremo de este componente principal, vemos películas artísticas independientes como Little Miss Sunshine, Truman Show y Slumdog Millionaire.

#Cuando miramos el otro extremo, vemos lo que yo llamaría favoritos nerd, El señor de los anillos, Star Wars, The Matrix.

pcs %>% select(name, PC2) %>% arrange(desc(PC2)) %>% slice(1:10)

#Entonces, utilizando el análisis de componentes principales, hemos demostrado que un enfoque de factorización matricial puede encontrar una estructura importante en nuestros datos.

#Ahora, ajustar el modelo de factorización de matriz que presentamos anteriormente que tiene en cuenta que faltan datos, que faltan celdas en la matriz, es un poco más complicado.

#Para aquellos interesados, recomendamos probar el paquete de laboratorio recomendado que se ajuste a estos modelos.