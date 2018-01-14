---
title: Un Año de Despacito
author: Maazin Ansari
date: 2018-01-14
slug: despacito-1
lang: es
category: Statistics
tags: R, YouTube, visualization
summary: Un análysis de vistas de un videoclip
output: html_document
---



La canción de Luis Fonsi, *Despacito* ft. Daddy Yankee fue la canción de 2017. Lanzado en el principio de enero, la canción fue un éxito en Latinoamérica. Después de que se involucró Justin Bieber, dominaba las listas musicales alrededor del mundo.

El videoclip de la versión original se publicó en YouTube el 12 de enero, 2017, hace un año. En solo 97 días, el vídeo recibió un mil millones de vistas. El 4 de agosto- solo 7 meses después de su publicación- el vídeo se convirtió en el primer vídeo en la historia de YouTube en alcanzar 3 mil millones de vistas. 

En este artículo voy a analizar cómo el videoclip creció tan rápido. Identifico las tendencias semanales y los momentos cuando las vistas crecían más rápido. Actualmente, no tengo mucha experiencia con las series temporales, así que esto será principalmente un análysis visual.

Los datos, scripts, y gráficos adicionales están disponibles en [mi GitHub](https://github.com/maazinansari/maazinansari/tree/master/content/R/despacito).


# Obtener los datos

YouTube ofrece estadísticas del vídeo en algunos vídeos. No estoy seguro de qué determina si un vídeo tiene las estadísticas activadas, pero parece que la mayoría de los videoclips de canciones las tienen. Esto es el gráfico de vistas diarias de Despacito:

<img src="../../static/despacito/yt-viz.png" title="center" alt="center" width="75%" style="display: block; margin: auto;" />

Podemos extraer los datos del código HTML.

Es importante notar que las estadísticas del vídeo solo están disponibles en el diseño de YouTube anterior. Por alguna razón, YouTube quitó las estadísticas del vídeo en su nuevo diseño.

<img src="../../static/despacito/oldtube.png" title="center" alt="center" width="75%" style="display: block; margin: auto;" /><img src="../../static/despacito/newtube.png" title="center" alt="center" width="75%" style="display: block; margin: auto;" />


Cuando estás en la página del videoclip y ya has abierto las estadísticas del vídeo, haz clic con el botón secundario alrededor del gráfico y elige Inspect Element. Busca `stats-chart-gviz` en el código HTML. Haz clic en las flechas hasta que encuentres la etiqueta `<table>`. Haz clic con el botón secundario y elige Copy > Copy element y pégalo en un editor de texto y guardar como un archivo .html.

<img src="../../static/despacito/html-elements.png" title="center" alt="center" width="75%" style="display: block; margin: auto;" />

# Limpiar los datos

Ahora nuestros datos están en forma de una tabla HTML. Tenemos que obtener las fechas y los valores de la tabla para hacer nuestros proprios gráficos. Necesitamos el paquete `XML` para esto. Específicamente, necesitamos la función `readHTMLTable()` para leer los datos como una hoja de datos. Luego, creamos nuevas columnas `date` y `views` que contienen las fechas y los números de vistas en formatos adecuados. 

Es importante notar que yo extraí los datos de la página inglés de YouTube. Los scripts en GitHub en su forma actual no funcionan si extraes los datos de YouTube de otro idioma.


```r
# Cleaning ----
# This script only works for data taken from the English language YouTube site.
despacito_table = readHTMLTable("despacito_table.html")
despacito_df = despacito_table[[1]]
despacito_df[["date"]] = strptime(as.character(despacito_df[["Date"]]), "%b %d, %Y") %>% as.Date
despacito_df[["views"]] = gsub(",", "", despacito_df[["value"]]) %>% as.numeric
```

Añadimos más columnas para facilitar el análysis y producir gråficos.


```r
# Cumulative views
despacito_df[["cumviews"]] = cumsum(despacito_df[["views"]])

# Change in views from previous day
change = despacito_df[["views"]] - c(despacito_df[1, "views"], despacito_df[-nrow(despacito_df), "views"])
despacito_df[["change"]] = change

# Add year, month, day of week
despacito_df[["year"]] = year(despacito_df[["date"]])
despacito_df[["month"]] = month(despacito_df[["date"]], label = TRUE)
despacito_df[["wday"]] = factor(weekdays(despacito_df[["date"]]),
                           levels= c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
```

# Análysis

Ahora tenemos los datos limpiados, y podemos producir algunos gráficos.

<img src="../../static/despacito/views-per-day.png" title="center" alt="center" style="display: block; margin: auto;" /><img src="../../static/despacito/total.png" title="center" alt="center" style="display: block; margin: auto;" />


Estos gráficos son los mismos que produce YouTube, con ciertos hitos marcados. Podemos ver algunas pautas interesantes:

- Picos semanales los viernes y sábados
- Caída de vistas diarias en febrero que pica de nuevo en marzo
- Caída de vistas diarias a mediados de abril
- Las vistas diarias aumentaban a lo largo del verano, y decrecían después de agosto, y otra vez en deciembre.

Cuando vi este gráfico por la primera vez, presumí que la caída de vistas en febrero era por la Cuaresma. Pero cuando marqué los días festivos, no había correlación.

<img src="../../static/despacito/vpd-holiday.png" title="center" alt="center" style="display: block; margin: auto;" />

Todavía, este gráfico muestra coincidencias con otros días festivos. Las vistas diarias bajaron y se establecieron durante la Semana Santa (9 - 15 de abril). El videoclip también fue popular en la Nochebuena y la Nochevieja, aunque no habían tantas vistas el resto de diciembre.

El aumento de la popularidad del videoclip puede seguir cuando la canción era popular en otros lugares. En México, la canción superó Los 40 el 11 de febrero. En EEUU, llegó a número 1 en Hot Latin Songs de Billboard para la semana de 18 de febrero. 

<img src="../../static/despacito/vpd-charts.png" title="center" alt="center" style="display: block; margin: auto;" />

Sospeché que la canción se habría levantado cuando el remix de Justin Bieber salió el 16 de abril. Las vistas sí aumentaron después de esa fecha, pero no se puede identificar si es por Justin Bieber o por la Pascua.

El 15 de mayo, la canción llegó a número 1 en Billboard's Hot 100, donde se quedaría por muchas semanas a lo largo del verano. Otra vez, no se puede ver un aumento significativo en esa fecha. 

Después de que superó 3 mil millones de vistas, un hito sin precedentes, la popularidad del videoclip disminuyó. Quizás los jóvenes ya no tenían tiempo para reproducirlo. Aun cuando la canción ganó 4 premios de Latin Grammys en noviembre, las vistas diarias seguían la típica tendencia.

Me interesa explicar los días que no siguen la tendencia. Para identificar anomalías, hice este gráfico que muestra la diferencia de vistas del día anterior.

<img src="../../static/despacito/change-vpd.png" title="center" alt="center" style="display: block; margin: auto;" />

El gráfico también muestra que las vistas diarias aumentan los viernes y sábados, y bajan los domingos y lunes. Hay algunas excepciones notables. El único sábado cuando las vistas disminuyó era el 1 de febrero. El único viernes cuando las vistas disminuyó era el 14 de abril- Viernes Santo. 

También hay algunos picos peculiares. Primero, el miércoles 8 de marzo, 2017. No puedo encontrar nada para explicar por qué había tantas vistas ese miércoles. Presiento que el algoritmo de sugerencias de YouTube escondió el vídeo desde 1 de febrero hasta 8 de marzo. Así que la gente no podía encontrar el vídeo por sus sugerencias.

Los otros picos considerables son de los domingos de la Nochebuena y la Nochevieja. No es típico tener más vistas el domingo que el sábado. 

# Predecir las vistas

Ahora intento predecir el número de vistas en el futuro. Un modelo de efectos principales con factores $\alpha$ y $\beta$ tiene la forma  

$$
y_{ijk} = \mu +\alpha_i+\beta_j+e_{ijk}
$$

donde $\mu$ es el promedio general, $\alpha_i$ y $\beta_j$ son los efectos principales de los factores, y $e_{ijk}$ es el error. Para las vistas del videoclip, presumo que el número de vistas en un día particular depende de solo el mes y el día de la semana. 

$$
\text{views}_{ijk} = \mu +\text{month}_i+\text{wday}_j+e_{ijk}
$$
Es fácil hacer esto en R.


```r
view_mod = lm(views ~ factor(month, ordered = FALSE) + wday, data = despacito_df)
summary(view_mod)[["coefficients"]]
```

```
##                                     Estimate Std. Error    t value
## (Intercept)                        6101017.5   368686.2 16.5479942
## factor(month, ordered = FALSE)Feb   504094.8   437943.9  1.1510488
## factor(month, ordered = FALSE)Mar  4354379.6   427075.1 10.1958162
## factor(month, ordered = FALSE)Apr  7317787.7   430508.1 16.9980251
## factor(month, ordered = FALSE)May  9987258.8   426805.1 23.4000478
## factor(month, ordered = FALSE)Jun 11658600.7   430508.3 27.0810138
## factor(month, ordered = FALSE)Jul 13765615.4   426940.1 32.2425001
## factor(month, ordered = FALSE)Aug 11478848.1   426940.1 26.8863215
## factor(month, ordered = FALSE)Sep  5599158.5   430508.3 13.0059252
## factor(month, ordered = FALSE)Oct  2287510.1   426805.1  5.3596133
## factor(month, ordered = FALSE)Nov   704704.9   430508.1  1.6369144
## factor(month, ordered = FALSE)Dec -1384111.2   427075.1 -3.2409078
## wdayTuesday                          74460.1   326885.8  0.2277863
## wdayWednesday                       278608.4   327092.7  0.8517719
## wdayThursday                        659271.2   327196.1  2.0149112
## wdayFriday                         2110548.1   327196.1  6.4504076
## wdaySaturday                       3672752.2   327094.4 11.2284172
## wdaySunday                         1415449.2   326990.9  4.3287110
##                                        Pr(>|t|)
## (Intercept)                        1.009681e-45
## factor(month, ordered = FALSE)Feb  2.505070e-01
## factor(month, ordered = FALSE)Mar  1.614956e-21
## factor(month, ordered = FALSE)Apr  1.548200e-47
## factor(month, ordered = FALSE)May  2.839371e-73
## factor(month, ordered = FALSE)Jun  1.723188e-87
## factor(month, ordered = FALSE)Jul 2.831538e-106
## factor(month, ordered = FALSE)Aug  9.381737e-87
## factor(month, ordered = FALSE)Sep  9.256291e-32
## factor(month, ordered = FALSE)Oct  1.526429e-07
## factor(month, ordered = FALSE)Nov  1.025575e-01
## factor(month, ordered = FALSE)Dec  1.307217e-03
## wdayTuesday                        8.199470e-01
## wdayWednesday                      3.949298e-01
## wdayThursday                       4.468707e-02
## wdayFriday                         3.759610e-10
## wdaySaturday                       3.726519e-25
## wdaySunday                         1.966222e-05
```

El resumen muestra los coeficientes del modelo. El `(Intercept)` es la base de referencia a la que los otros coeficientes comparan. Aquí es enero y lunes. Entonces, el coeficiente para febrero se puede interpretar como "504094.8 más vistas en febrero que en enero."

*Mi interpretación puede ser equivocada. Traté de verificar los valores con otros métodos, y no podía replicar los resultos. Además, me habría gustado que el resumen reflejara la forma del modelo arriba, (i.e. sin el intercepto). Usando `- 1` quita el intercepto y añade enero, pero no incluye lunes. Si alguién tenga sugerencias, por favor contáctame.*



A pesar de la interpretación, el modelo predice bien las vistas. Mira los valores ajustados (rojo) y los valores reales (negro).

<img src="../../static/despacito/predict.png" title="center" alt="center" style="display: block; margin: auto;" />

Ahora si queremos predecir cuando el vídeo llegará 5, 6, o 7 mil millones de vistas, creamos una hoja de datos que tiene el mes y el día de fechas en el futuro. 


```r
future_days = seq.Date(ymd("2018-01-13"), ymd("2020-01-01"), by = "day")
future_df = data.frame(month = month(future_days, label = TRUE),
                       wday = wday(future_days, label = TRUE, abbr = FALSE))
```


Luego, predecimos el número de vistas en cada uno de estas fechas. La suposición principal es que el vídeo seguirá el mismo pauta en el futuro.


```r
future_views = predict(view_mod, newdata = future_df)
```

Usamos la función de la suma cumulativa para ver las vistas acumulativas en cada fecha. 


```r
future_total = cumsum(future_views) + despacito_df[nrow(despacito_df), "cumviews"] # Adding current total
```

Por fin vemos las fechas cuando los hitos ocurrirán.


```r
future_milestones = c(t_5b = future_days[which(future_total >= 5e9)][1],
                      t_6b = future_days[which(future_total >= 6e9)][1],
                      t_7b = future_days[which(future_total >= 7e9)][1],
                      t_8b = future_days[which(future_total >= 8e9)][1],
                      t_9b = future_days[which(future_total >= 9e9)][1],
                      t_10b = future_days[which(future_total >= 1e10)][1])
print(future_milestones)
```

```
##         t_5b         t_6b         t_7b         t_8b         t_9b 
## "2018-02-24" "2018-05-10" "2018-07-04" "2018-08-23" "2018-11-19" 
##        t_10b 
## "2019-03-25"
```

Según este modelo, el videoclip de *Despacito* llegará a 5 mil millones de vistas el 24 de febrero, 2018 y 10 mil millones el 25 de marzo, 2019. No creo que este modelo sirva muy bien después de unos meses. Los datos que uso son del primer año de esta canción, cuando era nueva y su popularidad estaba en su máximo. Ya ha completado su dominación en las listas musicales alrededor del mundo. El año 2018 tendrá canciones y videoclips más populares, y este vídeo será una reliquia del pasado. Todavía yo volveré en marzo para ver que precisas eran mis predicciones.

# Referencias

https://www.youtube.com/watch?v=kJQP7kiw5Fk

https://es.wikipedia.org/wiki/Despacito

https://www.billboard.com/articles/columns/chart-beat/7793159/luis-fonsi-daddy-yankee-despacito-justin-bieber-number-one

http://los40.com.mx/lista40/2017/6

