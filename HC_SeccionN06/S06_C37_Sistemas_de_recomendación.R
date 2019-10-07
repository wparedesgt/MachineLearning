#S06_C37_Sistemas_de_recomendación
#Sistemas de recomendación

#Los sistemas de recomendación utilizan clasificaciones que los usuarios han dado elementos para hacer recomendaciones específicas a los usuarios.

#Las empresas como Amazon que venden muchos productos a muchos clientes y permiten que estos clientes califiquen sus productos pueden recopilar conjuntos de datos masivos que pueden usarse para predecir qué calificación otorgará un usuario determinado a un artículo específico.

#Los elementos para los que se predice una calificación alta para usuarios específicos se recomiendan a ese usuario.

#Netflix utiliza sistemas de recomendación para predecir cuántas estrellas dará un usuario a una película específica.

#Aquí proporcionamos los conceptos básicos de cómo se predicen estas recomendaciones, motivados por algunos de los enfoques adoptados por los ganadores del desafío de Netflix.

#¿Cuál es el desafío de Netflix?
  
#En octubre de 2006, Netflix ofreció un desafío a la comunidad de ciencia de datos.

#Mejore nuestro algoritmo de recomendación en un 10% y gane $ 1 millón.

#En septiembre de 2009, se anunciaron los ganadores.

#Puede seguir este enlace para ver el artículo de noticias.

#Puede leer un buen resumen de cómo se creó el algoritmo ganador siguiendo este enlace.

#Lo incluiremos en el material de la clase.

#Y una explicación más detallada siguiendo este enlace, también incluida en el material de la clase.

#Aquí le mostramos algunas de las estrategias de análisis de datos utilizadas por el equipo ganador.

#Desafortunadamente, los datos de Netflix no están disponibles públicamente.

#Pero el laboratorio de investigación de GroupLens generó su propia base de datos con más de 20 millones de calificaciones para más de 27,000 películas por más de 138,000 usuarios.

#Ponemos a disposición un pequeño subconjunto de estos datos a través del paquete dslabs.

#Puedes subirlo así.

#Podemos ver que la tabla de lentes de película es ordenada y contiene miles de filas.

#Cada fila representa una calificación dada por un usuario a una película.

#Podemos ver la cantidad de usuarios únicos que proporcionan calificaciones y la cantidad de películas únicas que les proporcionaron utilizando este código.

#Si multiplicamos esos dos números, obtenemos un número mucho mayor que 5 millones.

#Sin embargo, nuestra tabla de datos tiene alrededor de 100,000 filas.

#Esto implica que no todos los usuarios calificaron todas las películas.

#Así que podemos pensar en estos datos como una matriz muy grande con usuarios en las filas y películas en las columnas con muchas celdas vacías.

#La función de recopilación nos permite convertir a este formato, pero si intentamos hacerlo para toda la matriz, se bloqueará R. Entonces, veamos un subconjunto más pequeño.

#Esta tabla muestra un subconjunto muy pequeño de siete usuarios y cinco películas.

#Puede ver las clasificaciones que cada usuario le dio a cada película y también puede ver las NA para las películas que no vieron o que no calificaron.

#Puede pensar en la tarea de los sistemas de recomendación como completar los NA en la tabla que acabamos de mostrar.

#Para ver cuán escasa es la matriz completa, aquí la matriz para una muestra aleatoria de 100 películas y 100 usuarios se muestra en amarillo, lo que indica una combinación de películas de usuario para la que tenemos una calificación.

#Muy bien, así que sigamos adelante para tratar de hacer predicciones.

#El desafío del aprendizaje automático aquí es más complicado de lo que hemos estudiado hasta ahora porque cada resultado tiene un conjunto diferente de predictores.

#Para ver esto, tenga en cuenta que si estamos prediciendo la calificación de la película i por el usuario u, en principio, todas las otras calificaciones relacionadas con la película i y por el usuario u pueden usarse como predictores.

#Pero diferentes usuarios califican una cantidad diferente de películas y películas diferentes.

#Además, es posible que podamos usar información de otras películas que hemos determinado que son similares a la película i o de usuarios que se consideran similares al usuario u.

#Entonces, en esencia, toda la matriz se puede usar como predictores para cada celda.

#Entonces empecemos.

#Veamos algunas de las propiedades generales de los datos para comprender mejor el desafío.

#Lo primero que notamos es que algunas películas se califican más que otras.

#Aquí está la distribución.

#Esto no debería sorprendernos dado que hay millones de éxitos de taquilla vistos por millones y películas artísticas independientes vistas solo por unos pocos.

#Una segunda observación es que algunos usuarios son más activos que otros en la calificación de películas.

#Tenga en cuenta que algunos usuarios han calificado más de 1,000 películas, mientras que otros solo han calificado un puñado.

#Para ver cómo se trata de un desafío de aprendizaje automático, tenga en cuenta que necesitamos construir un algoritmo con los datos que hemos recopilado.

#Y este algoritmo luego será utilizado por otros cuando los usuarios busquen recomendaciones de películas.

#Entonces, creemos un conjunto de pruebas para evaluar la precisión de los modelos que implementamos, al igual que en otros algoritmos de aprendizaje automático.

#Usamos el paquete caret con este código.

#Para asegurarnos de que no incluimos usuarios y películas en el conjunto de prueba que no aparecen en el conjunto de entrenamiento, los eliminamos utilizando la función semi_join, utilizando este código simple.

#Todo está bien ahora.

#Para comparar diferentes modelos o para ver qué tan bien lo estamos haciendo en comparación con alguna línea de base, necesitamos cuantificar lo que significa hacerlo bien.

#Necesitamos una función de pérdida.

#El desafío de Netflix utilizó el error típico y, por lo tanto, decidió un ganador basado en el error cuadrático medio residual en un conjunto de prueba.

#Entonces, si definimos y_u, i como la calificación de la película i por el usuario u y y-hat_u, i como nuestra predicción, entonces el error cuadrado medio residual se define de la siguiente manera.

#Aquí n es una serie de combinaciones de películas de usuario y la suma se produce sobre todas estas combinaciones.

#Recuerde que podemos interpretar el error cuadrático medio residual similar a la desviación estándar.

#Es el error típico que cometemos al predecir una calificación de película.

#Si este número es mucho mayor que uno, generalmente nos falta una o más estrellas, lo que no es muy bueno.

#Así que escribamos rápidamente una función que calcule este error cuadrático medio para un vector de calificaciones y sus predictores correspondientes.

#Es una función simple que se ve así.

#Y ahora estamos listos para construir modelos y compararlos entre sí.
