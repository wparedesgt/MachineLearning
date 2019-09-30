#Consideremos un ejemplo, lo primero que le sucede a una carta cuando se recibe en la oficina de correos es que están ordenados por código postal.

#Originalmente los humanos tenían que ordenarlos a mano.

#Para hacer esto, tenían que leer los códigos postales de cada letra.

#Hoy, gracias a los algoritmos de aprendizaje automático, una computadora puede leer códigos postales y luego un robot clasifica las letras.

#En este curso, aprenderemos cómo construir algoritmos que puedan leer un dígito.

#El primer paso para construir un algoritmo es entender cuáles son los resultados y cuáles son las características.

#Aquí hay tres imágenes de dígitos escritos.

#Estos ya han sido leídos por un humano y se les ha asignado un resultado, Y. Se consideran conocidos y sirven como datos de entrenamiento.

#Las imágenes se convierten en 28 por 28 imágenes.

#Así que tenemos 784 píxeles.

#Y para cada píxel obtenemos una intensidad de escala de grises entre 0, que es blanca, y 255, que es negra, que consideramos continua por ahora.

#Podemos ver estos valores rehaciendo las figuras como esta.

#Para cada imagen digitalizada, i, tenemos un resultado categórico Yi, que puede ser uno de los 10 valores 0, 1, 2, 3, 4, 5, 6, 7, 8, 9.

#Y tenemos 784 características.

#Entonces tenemos X1, X2, hasta X784.

#Utilizamos negrita para las X, para distinguir el vector de predictores de los predictores individuales.

#Cuando nos referimos a un conjunto arbitrario de características, descartamos el índice i y usamos Y y negrita. Usamos variables en mayúsculas porque, en general, pensamos que los predictores son variables aleatorias.

#Usamos minúsculas, por ejemplo, podríamos decir que la X mayúscula es igual a la x minúscula para denotar los valores observados.

#Aunque cuando codificamos, nos atenemos a minúsculas.

#La tarea de aprendizaje automático es construir un algoritmo que devuelva una predicción para cualquiera de los valores posibles de las características.

#Aquí aprenderemos varios enfoques para construir estos algoritmos.

#Aunque en este punto puede parecer imposible lograr esto, comenzaremos con un ejemplo simple y desarrollaremos nuestro conocimiento hasta que podamos atacar a los más complejos.

#Para aprender los conceptos básicos, comenzaremos con ejemplos muy simples con un solo predictor, luego pasaremos a dos predictores.

#Y una vez que aprendamos esto, atacaremos más desafíos de aprendizaje automático del mundo real.


#Puntos clave
#Yi = un resultado para la observación o el índice i.

#Utilizamos negrita para X_i para distinguir el vector de predictores de los predictores individuales Xi, 1, ..., Xi, 784.

#Al referirnos a un conjunto arbitrario de características y resultados, descartamos el índice i y utilizamos Y y negrita X.

#Las mayúsculas se utilizan para referirse a variables porque pensamos que los predictores son variables aleatorias.

#Se usa minúscula para denotar los valores observados. Por ejemplo, X = x.
