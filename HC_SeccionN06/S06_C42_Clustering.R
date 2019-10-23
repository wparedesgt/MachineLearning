#S06_C42_Clustering
#Agrupaciones

#Los algoritmos que hemos descrito hasta ahora son ejemplos de un enfoque general denominado aprendizaje automático supervisado. El nombre proviene del hecho de que usamos los resultados en un conjunto de entrenamiento para supervisar la creación de nuestro algoritmo de predicción. Hay otro subconjunto de aprendizaje automático denominado no supervisado. En este subconjunto no necesariamente conocemos los resultados y, en cambio, estamos interesados en descubrir grupos. 

#Estos algoritmos también se conocen como algoritmos de agrupación(clustering), ya que los predictores se utilizan para definir agrupaciones (clusters).

#En los dos ejemplos que hemos mostrado aquí, la agrupación no sería muy útil. En el primer ejemplo, si simplemente se nos dan las alturas, no podremos descubrir dos grupos, hombres y mujeres, porque la intersección es grande. En el segundo ejemplo, podemos ver al trazar los predictores que descubrir los dos dígitos, dos y siete, será un desafío:

library(tidyverse)
library(dslabs)
data("mnist_27")
mnist_27$train %>% qplot(x_1, x_2, data = .)


#Sin embargo, existen aplicaciones en las que el aprendizaje no supervisado puede ser una técnica poderosa, en particular como una herramienta exploratoria.

#Un primer paso en cualquier algoritmo de agrupamiento es definir una distancia entre observaciones o grupos de observaciones. Luego, debemos decidir cómo unir las observaciones en grupos. Hay muchos algoritmos para hacer esto. Aquí presentamos dos como ejemplos: jerárquico y k-means.

#Construiremos un ejemplo simple basado en clasificaciones de películas. Aquí construimos rápidamente una matriz x que tiene clasificaciones para las 50 películas con la mayor cantidad de clasificaciones.



data("movielens")

top <- movielens %>% 
  group_by(movieId) %>% 
  summarize(n = n(), title = first(title)) %>% 
  top_n(50, n) %>% 
  pull(movieId)

x <- movielens %>% 
  filter(movieId %in% top) %>% 
  group_by(userId) %>% 
  filter(n() >= 25) %>% 
  ungroup() %>% 
  select(title, userId, rating) %>% 
  spread(userId, rating)

row_names <- str_remove(x$title, ": Episode") %>% str_trunc(20)

x <- x[,-1] %>% as.matrix()

x <- sweep(x, 2, colMeans(x, na.rm = TRUE))

x <- sweep(x, 1, rowMeans(x, na.rm = TRUE))

rownames(x) <- row_names

#Queremos utilizar estos datos para averiguar si hay grupos de películas basadas en las clasificaciones de 139 calificadores de películas. Un primer paso es encontrar la distancia entre cada par de películas usando la función dist:

d <- dist(x)


#Agrupación jerárquica

#Con la distancia calculada entre cada par de películas, necesitamos algoritmos para definir grupos a partir de estas. La agrupación jerárquica comienza definiendo cada observación como un grupo separado, luego los dos grupos más cercanos se unen en un grupo de forma iterativa hasta que solo haya un grupo que incluya todas las observaciones. La función hclust implementa este algoritmo y toma una distancia como entrada.

h <- hclust(d)

#Ahora podemos ver los resultados de la agrupacion usando un dendrograma.

plot(h, cex = 0.65)


#Para interpretar este gráfico hacemos lo siguiente. Para encontrar la distancia entre dos películas, busque la primera ubicación de arriba a abajo que las películas se dividen en dos grupos diferentes. La altura de esta ubicación es la distancia entre los grupos. Entonces, la distancia entre las películas de Star Wars es de 8 o menos, mientras que la distancia entre Raiders of the Lost of Arc y Silence of the Lambs es de aproximadamente 17.

#Para generar grupos reales, podemos hacer una de dos cosas: 1) decidir la distancia mínima necesaria para que las observaciones estén en el mismo grupo o 2) decidir la cantidad de grupos que desea y luego encontrar la distancia mínima que logra esto. La función cutree se puede aplicar a la salida de hclust para realizar cualquiera de estas dos operaciones y generar grupos.

groups <- cutree(h, k = 10)

split(names(groups), groups)


#Tenga en cuenta que la agrupación proporciona algunas ideas sobre los tipos de películas. Podemos cambiar el tamaño del grupo haciendo k más grande o h más pequeño. También podemos explorar los datos para ver si hay grupos de evaluadores de películas.

h_2 <- dist(t(x)) %>% hclust()

plot(h_2, cex = 0.35)


#K-means


#Para usar el algoritmo de agrupamiento k-means tenemos que predefinir k, el número de grupos que queremos definir. El algoritmo k-means es iterativo. El primer paso es definir k centros. 

#Luego, cada observación se asigna al grupo con el centro más cercano a esa observación. En un segundo paso, los centros se redefinen utilizando la observación en cada grupo: los medios de columna se utilizan para definir un centroide. Repetimos estos dos pasos hasta que los centros converjan.

#La función kmeans incluida en R-base no maneja NAs. Con fines ilustrativos, completaremos las NA con 0. En general, la elección de cómo completar los datos faltantes, o si uno debería hacerlo, debe hacerse con cuidado.


x_0 <- x

x_0[is.na(x_0)] <- 0

k <- kmeans(x_0, centers = 10)


#Los asignamientos de las agrupaciones estan en el componente cluster.

groups <- k$cluster

split(names(groups), groups)

#Tenga en cuenta que debido a que el primer centro se elige al azar, los grupos finales son aleatorios. Imponemos cierta estabilidad al repetir todo varias veces y promediar los resultados.

k <- kmeans(x_0, centers = 10, nstart = 25)

groups <- k$cluster

split(names(groups), groups)


