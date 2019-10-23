#S06_C40_Factorizacion_Matriz

#La factorización matricial es un concepto ampliamente utilizado en el aprendizaje automático.

#Está muy relacionado con el análisis factorial, la composición de un solo valor y el análisis de componentes principales o PCA.

#Aquí describimos el concepto en el contexto de los sistemas de recomendación de películas.

#Anteriormente hemos descrito el siguiente modelo que explica las diferencias de películas y películas a través de los parámetros b_i, y las revisiones o diferencias de los usuarios a través de los parámetros b_u.

#Pero este modelo omite una fuente importante de variación relacionada con el hecho de que los grupos de películas tienen patrones de calificación similares y los grupos de usuarios también tienen patrones de calificación similares.

#Descubriremos estos patrones al estudiar los residuos obtenidos después de ajustar nuestro modelo.

#Estos residuos

#Para estudiar estos residuos, convertiremos los datos en una matriz para que cada usuario obtenga una fila y cada película obtenga una columna.

#Entonces y_u, i es la entrada en la fila u y la columna i.

#Usuario u, película i.

#Con fines ilustrativos, solo consideraremos un pequeño subconjunto de películas con muchas clasificaciones y usuarios que han calificado muchas películas.

#Utilizaremos este código para generar nuestros datos de entrenamiento.

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

head(y)

#Los nombres de las columnas serán los nombres de las películas.

#Y convertimos estos residuos eliminando los promedios de columna y fila.

#Aquí está el código.

y <- sweep(y, 1, rowMeans(y, na.rm = TRUE))
y <- sweep(y, 2, colMeans(y, na.rm = TRUE))

head(y)

#Si el modelo que hemos estado utilizando describe todas las señales y las adicionales son solo ruido, entonces los residuos de las diferentes películas deberían ser independientes entre sí.

#Pero no lo son.

#Aquí hay un ejemplo.

#Aquí hay una grafica de los residuos de The Godfather y The Godfather II.

m_1 <- "Godfather, The"
m_2 <- "Godfather: Part II, The"
qplot(y[ ,m_1], y[,m_2], xlab = m_1, ylab = m_2)


#Están muy correlacionados

#Esta grafica dice que los usuarios a los que les gustó el padrino más de lo que el modelo espera que les basen en la película y los efectos del usuario también les gusta The Godfather II más de lo esperado.

#Lo mismo es cierto para El Padrino y Goodfellas.

#Puedes verlo en esta grafica.

m_1 <- "Godfather, The"
m_3 <- "Goodfellas"
qplot(y[ ,m_1], y[,m_3], xlab = m_1, ylab = m_3)


#Aunque no es tan fuerte, todavía existe una correlación.

#También vemos una correlación entre otras películas.

#Por ejemplo, aquí hay una correlación entre You Have Got Mail y Sleepless en Seattle.

m_4 <- "You've Got Mail" 
m_5 <- "Sleepless in Seattle" 
qplot(y[ ,m_4], y[,m_5], xlab = m_4, ylab = m_5)

#Podemos ver un patrón.

#Si observamos la correlación por pares para estas cinco películas, podemos ver que hay una correlación positiva entre las películas de gángsters Godfathers y Goodfellas, y luego hay una correlación positiva entre las comedias románticas You Have Got Mail y Sleepless en Seattle.


cor(y[, c(m_1, m_2, m_3, m_4, m_5)], use="pairwise.complete") %>% 
  knitr::kable()


#También vemos una correlación negativa entre las películas de gángsters y las comedias románticas.

#Esto significa que a los usuarios que les gustan mucho las películas de gángsters no les gustan las comedias románticas y viceversa.

#Este resultado nos dice que hay una estructura en los datos que el modelo no tiene en cuenta.

#Entonces, ¿cómo modelamos esto?
  
#Aquí es donde usamos la factorización matricial.

#Vamos a definir factores.

#Aquí hay una ilustración de cómo podríamos usar alguna estructura para predecir los residuos.

set.seed(1)
options(digits = 2)
Q <- matrix(c(1 , 1, 1, -1, -1), ncol=1)
rownames(Q) <- c(m_1, m_2, m_3, m_4, m_5)
P <- matrix(rep(c(2,0,-2), c(3,5,4)), ncol=1)
rownames(P) <- 1:nrow(P)

X <- jitter(P%*%t(Q))
X %>% knitr::kable(align = "c")

#Supongamos que los residuos se ven así.

#Esta es una simulación.

#Parece que hay un patrón aquí.

#Se basa en lo que vimos con los datos reales.

#Hay un efecto de película de gángsters y hay un efecto de comedia romántica.

#De hecho, vemos un patrón de correlación muy fuerte, que podemos ver aquí.

cor(X)



#Esta estructura podría explicarse utilizando los siguientes coeficientes.

#Asignamos un 1 a las películas de gángsters y un menos a las comedias románticas.

t(Q) %>% knitr::kable(aling="c")

#En este caso, podemos reducir las películas a dos grupos, gángster y comedia romántica.

#Tenga en cuenta que también podemos reducir los usuarios a tres grupos, los que les gustan las películas de gángsters pero odian las comedias románticas, a la inversa, y los que no les importa.

P

#El punto principal aquí es que podemos reconstruir estos datos que tienen 60 valores con un par de vectores que suman 17 valores.

#Esos dos vectores que acabamos de mostrar pueden usarse para formar la matriz con 60 valores.

#Podemos modelar los 60 residuos con el modelo de 17 parámetros como este.

#Y aquí es donde entra el nombre de factorización.

#Tenemos una matriz r y la factorizamos en dos cosas, el vector p y el vector q.

#Ahora deberíamos poder explicar mucho más la varianza si utilizamos un modelo como este.

#Ahora la estructura en nuestros datos de películas parece ser mucho más complicada que la película de gángsters versus las comedias románticas.

#Tenemos otros factores

#Por ejemplo, y esta es una simulación, supongamos que tenemos la película Scent of a Woman, y ahora los datos se ven así.

set.seed(1)
options(digits = 2)
m_6 <- "Scent of a Woman"
Q <- cbind(c(1 , 1, 1, -1, -1, -1), 
           c(1 , 1, -1, -1, -1, 1))
rownames(Q) <- c(m_1, m_2, m_3, m_4, m_5, m_6)
P <- cbind(rep(c(2,0,-2), c(3,5,4)), 
           c(-1,1,1,0,0,1,1,1,0,-1,-1,-1))/2
rownames(P) <- 1:nrow(X)

X <- jitter(P%*%t(Q), factor=1)
X %>% knitr::kable(align = "c")

cor(X)

#Ahora vemos otro factor, un factor que divide a los usuarios en aquellos que aman, aquellos que odian y aquellos que no se preocupan por Al Pacino.

#La correlación es un poco más complicada ahora.

#Podemos verlo aquí.

t(Q) %>% knitr::kable(aling="c")


#Ahora para explicar la estructura, necesitamos dos factores.

#Aquí están.

#El primero divide las películas de gángsters de las comedias románticas.

#El segundo factor divide las películas de Al Pacino y las películas que no son de Al Pacino.

#Y también tenemos dos conjuntos de coeficientes para describir a los usuarios.

#puedes verlo aqui.

P

#El modelo ahora tiene más parámetros, pero aún menos que los datos originales.

#Por lo tanto, deberíamos poder ajustar este modelo utilizando, por ejemplo, el método de mínimos cuadrados.

#Sin embargo, para el desafío de Netflix, utilizaron la regularización y penalizaron no solo al usuario y los efectos de la película, sino también a grandes valores de los factores p o q.

#Ahora, ¿esta simulación coincide con los datos reales?
  
#Aquí está la correlación que obtenemos para las películas que acabamos de mostrar, pero usando los datos reales.

six_movies <- c(m_1, m_2, m_3, m_4, m_5, m_6)
tmp <- y[,six_movies]
cor(tmp, use="pairwise.complete")

#Tenga en cuenta que la estructura es similar.

#Sin embargo, si queremos encontrar la estructura utilizando los datos en lugar de construirla nosotros mismos como lo hicimos en el ejemplo, debemos ajustar los modelos a los datos.

#Así que ahora tenemos que descubrir cómo estimar los factores a partir de los datos en lugar de definirlos nosotros mismos.

#Una forma de hacer esto es ajustar modelos, pero también podemos usar el análisis de componentes principales o, de manera equivalente, la descomposición de valores singulares para estimar los factores a partir de los datos.

#Y vamos a mostrar eso en el próximo video.