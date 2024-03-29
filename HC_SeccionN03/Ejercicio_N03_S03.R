#Ejercicio_NO3_S03

#Obtenemos la morandand de Puerto Rico del 2015-2018

library(tidyverse)
library(lubridate)
library(purrr)
library(pdftools)


fn <- system.file("extdata", "RD-Mortality-Report_2015-18-180531.pdf", package="dslabs")

dat <- map_df(str_split(pdf_text(fn), "\n"), function(s){
  s <- str_trim(s)
  header_index <- str_which(s, "2015")[1]
  tmp <- str_split(s[header_index], "\\s+", simplify = TRUE)
  month <- tmp[1]
  header <- tmp[-1]
  tail_index  <- str_which(s, "Total")
  n <- str_count(s, "\\d+")
  out <- c(1:header_index, which(n==1), which(n>=28), tail_index:length(s))
  s[-out] %>%
    str_remove_all("[^\\d\\s]") %>%
    str_trim() %>%
    str_split_fixed("\\s+", n = 6) %>%
    .[,1:5] %>%
    as_data_frame() %>% 
    setNames(c("day", header)) %>%
    mutate(month = month,
           day = as.numeric(day)) %>%
    gather(year, deaths, -c(day, month)) %>%
    mutate(deaths = as.numeric(deaths))
}) %>%
  mutate(month = recode(month, "JAN" = 1, "FEB" = 2, "MAR" = 3, "APR" = 4, "MAY" = 5, "JUN" = 6, 
                        "JUL" = 7, "AGO" = 8, "SEP" = 9, "OCT" = 10, "NOV" = 11, "DEC" = 12)) %>%
  mutate(date = make_date(year, month, day)) %>%
  filter(date <= "2018-05-01")


head(dat)


dat %>% ggplot(aes(date, deaths)) +
  geom_point() + 
  geom_smooth(color="red", span = 0.15, method.args = list(degree=1))


#Use la función loess para obtener una estimación uniforme del número esperado de muertes en función de la fecha. Trace esta función suave resultante. Haz el lapso de unos dos meses.



span <- 60 / as.numeric(diff(range(dat$date)))
fit <- dat %>% mutate(x = as.numeric(date)) %>% loess(deaths ~ x, data = ., span = span, degree = 1)
dat %>% mutate(smooth = predict(fit, as.numeric(date))) %>%
  ggplot() +
  geom_point(aes(date, deaths)) +
  geom_line(aes(date, smooth), lwd = 2, col = 2)


#Trabaje con los mismos datos que en Q1 para trazar estimaciones uniformes con respecto al día del año, todo en el mismo diagrama, pero con diferentes colores para cada año.

#¿Qué código produce la grafica deseada?


dat %>% 
  mutate(smooth = predict(fit, as.numeric(date)), day = yday(date), year = as.character(year(date))) %>%
  ggplot(aes(day, smooth, col = year)) +
  geom_line(lwd = 2)


#Supongamos que queremos predecir 2s y 7s en el conjunto de datos mnist_27 con solo la segunda covariable. ¿Podemos hacer esto? En la primera inspección parece que los datos no tienen mucho poder predictivo.

#De hecho, si ajustamos una regresión logística regular, ¡el coeficiente para x_2 no es significativo!
  
#Esto se puede ver usando este código:

library(broom)
mnist_27$train %>% glm(y ~ x_2, family = "binomial", data = .) %>% tidy()


#Trazar un diagrama de dispersión aquí no es útil ya que y es binario:

qplot(x_2, y, data = mnist_27$train)


#Ajuste una línea de loess a los datos anteriores y trace los resultados. Que observas



