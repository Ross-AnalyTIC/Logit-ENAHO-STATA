***Convertir columna Región en Variable alfanumérica (organizar la BD y distinguir a los paises a unos de otros)

Use "C:\Users\Usuario\Downloads\ROSSY\TESIS\DATA"

keep Region Año PBI TR TL EN

***(Opcional) etiquetar variable 
encode (Región), gn (Region)

=======================================================
***Verificar si los datos estan balanceados
xtset Region Año


       panel variable:  Region (strongly balanced)
        time variable:  Año, 2007 to 2020
                delta:  1 unit
=======================================================
xtdescribe
		
***Verificación de datos completos

drop if PBI == . | TR == . | TL == . | EN == .

***Paso que ya no es necesario si ya esta balanceado
xtbalance, range(2007 2020) miss(PBI TR TL EN)

===========================================================

***MACROREGIONES (dummy)

**Costa

gen costa = 1 if Región == "Ica" | Región == "La Libertad" | Región =="Lambayeque" | Región == "Lima" | Región == "Moquegua" | Región == "Piura" | Región == "Tacna" | Región == "Tumbes"

**Sierra

gen sierra = 2 if Región == "Ancash" | Región == "Apurímac" | Región == "Arequipa" | Región == "Ayacucho" | Región == "Cajamarca" | Región == "Cusco" | Región == "Huancavelica" | Región == "Huánuco" | Región == "Junín" | Región == "Pasco" | Región == "Puno"

**Selva

gen selva = 3 if Región == "Amazonas" | Región == "Loreto" | Región == "Madre de Dios" | Región == "San Martín" | Región == "Ucayali"

===========================================================

***Estadistico descriptivos
xtsum PBI TR TL EN 
		
overall (global)
between (Dinámica entre regiones - inter)
within (Dinámica individual regional en el tiempo - intra)
		
===========================================================

****Verfiicacmos si existe correlación entre lasa variables de estudio 

correlate PBI TR TL EN


             |      PBI       TR       TL       EN
-------------+------------------------------------
         PBI |   1.0000
          TR |   0.7900   1.0000
          TL |   0.8479   0.9825   1.0000
          EN |   0.8021   0.5806   0.6181   1.0000

		  **si hay correlación

===========================================================
		  
***Análisis gráfico

HISTOGRAMA 

hist PBI
hist PBI, width (5000000)
hist PBI, bin (40)

hist PBI, bin(40) percent normal ///
xtitle("Máximo PBI")            ///
ytitle("Porcentaje (%)")        ///
kdensity normopts(lcolor(green)) kdenopts(lcolor(blue))

KERNEL DE DENSIDAD

kdensity PBI if costa == 1 | sierra == 2 | selva == 3,    ///
lcolor(blue) normal normopts(lcolor(green))               ///
legend(order(1 "Densidad estimada" 2 "Normal") cols(2))   ///
xtitle("Máximo PBI")                                      ///
ytitle("Densidad")                                        

DISPERSIÓN

scatter PBI TR,                              ///
xtitle("Transporte", size(*0.8))             ///
ytitle("PBI regional", size(*0.8))           ///
msize(*0.6) mcolor(navy blue)

***usando el comando twoway (combinar)

twoway ///
(scatter PBI TR if Año == 2007, mcolor(blue) msize(*0.8) mlabel(Region) mlabcolor(blue) mlabsize(*0.8)) ///
(scatter PBI TR if Año == 2019, mcolor(green) msize(*0.8) mlabel(Region) mlabcolor(blue) mlabsize(*0.8)) ///
(scatter PBI TR if Año == 2020, mcolor(orange) msize(*0.8) mlabel(Region) mlabcolor(blue) mlabsize(*0.8)) ///
, legend(order(1 "2007" 2 "2019" 3 "2020") cols (3)) ///
xlabel(0(20)150, grid labsize(*0.5)) ///
ylabel(2(1)8, grid labsize(*0.5)) ///
xtitle("Transporte", size(*0.8))             ///
ytitle("PBI regional", size(*0.8))           ///


===========================================================

***Generamos los logaritmos de las variables (para comprimir las dispersiones)

gen lPBI=log(PBI)
gen lTR=log(TR)
gen lTL=log(TL)
gen lEN=log(EN)


reg lPBI lTR lTL lEN

***opcional instalar
findit xtcsd 

xtreg lPBI lTR lTL lEN, re

Esta prueba solo se hace con efectos aleatorios
xttest0

Breusch and Pagan Lagrangian multiplier test for random effects (Panel Largo)
Ho: Usar MCO ( > .05)
H1: Usar Panel de Datos ( < .05) Existe heterogeneidad no observada


        lPBI[Region,t] = Xb + u[Region] + e[Region,t]

        Estimated results:
                         |       Var     sd = sqrt(Var)
                ---------+-----------------------------
                    lPBI |   .9724596       .9861337
                       e |   .0314533       .1773507
                       u |   .4942306       .7030154

        Test:   Var(u) = 0
                             chibar2(01) =  1280.97
                          Prob > chibar2 =   0.0000

***Se debe usar un modelo de datos panel
**************************************************************************

Pesaran's test of cross sectional independence  (Panel corto)
Ho: Usar MCO ( > .05)
H1: Usar Panel de Datos ( < .05) Existe heterogeneidad no observada

xtcsd, pesaran abs


=============================================================================
***Para saber si usamos efectos fijo o aleatorios (test de hausman)

xtreg lPBI lTR lTL lEN, re
estimates store re1

xtreg lPBI lTR lTL lEN, fe
estimates store fe1

HAUSMAN TEST

hausman fe1 re1
Ho: Usar EFECTOS ALEATORIOS ( > .05). el efecto inobservable no esta correlacionado con las variables explicativas
H1: Usar EFECTOS FIJOS ( < .05) 


****Test de Autocorrelacion (Test de Wooldridge)
Ho: No Existe autocorrelacion de primer orden (>.05)
H1: Existe autocorrelacion (< .05)

Autocorrelacion
findit xtserial

****Si existe autocorrelación



xtreg lPBI lTR lTL lEN, re
xtserial lPBI lTR lTL lEN, output


heterocedasticidad (Test modificado de Wald solo con efectos fijos)
Ho: No Existe heterocedasticidad (>.05)
H1: Existe heterocedasticidad (< .05)


***Si existe heteroscedasticidad

findit xttest3

xtreg lPBI lTR lTL lEN, fe
xttest3


Para correr un modelo solo con heteroscedasticidad

xtpcse Y X1 X2 lnX3 X4, het

xtgls Y X1 X2 lnX3 X4, p(h)


Para correr un modelo con autocorrelación y heteroc
xtpcse lPBI lTR lTL lEN, het c(ar1)
xtgls lPBI lTR lTL lEN, p(h) c(ar1)


=============================================================================


***Validar previamente (opcional)
xtline Region Año

xtline lpbi if costa == 1, ttitle("") tlabel(2007(3)2020, labsize(*0.6))
ytitle("ln(PBI per cápita)") byopts(title("Macroregión costa")) 

xtline lpbi if costa == 1, ttitle("") tlabel(2007(3)2020, labsize(*0.6))
ytitle("ln(PBI per cápita)") byopts(title("Macroregión costa")) overlay

***heterogeneidad de los datos

reg lpbi tl tr en 

bysort Región: egen lpbi_mean = mean(lpbi) // promedio por region

***diferencias estructurales entre regiones

twoway ///
(scatter lpbi Region , msymbol(circle_hollow)) ///
(connected lpbi_mean Region, msymbol(diamod)) ///
, xtitle("Regiones") ytitle("ln(PBI per cápita)") ///
legend(order(1 "Promedio ln(PBI Per cápita)" 2 "lnPBI per cápita" ))

bysort Año: egen lpbi_meany = mean(lpbi) /// promedio por años

twoway ///
(scatter lpbi Año , msymbol(circle_hollow)) ///
(connected lpbi_meany Año, msymbol(diamod)) ///
, xtitle("Años") ytitle("ln(PBI per cápita)") ///
legend(order(1 "Promedio ln(PBI Per cápita)" 2 "lnPBI per cápita" ))


***Estimación por efecto fijo (controlar carcaterisiticas no observables en el tiempo)


*LSDV (MCO)
reg lpbi tl tr en i.Region 
estimates store lsdv 

*FE (adiciona test F)
xtreg lpbi tl tr en, fe
estimates store fe

*LSDV - AREG (absorber variables)
areg lpbi tl tr en, absorb(Region)
estimates store alsdv

estimates table lsdv fe alsdv, drop(i.Region)



****EFECTOS TEMPORALES (Control por año)

reg lnpbi tl tr en i.Region i.Año
estimates store lsdv_it

xtreg lpbi tl tr en i.year, fe
estimates store fe_it

areg lpbi tl tr en, absorb(Region)
estimates store alsdv_it

estimates table lsdv_it fe_it alsdv_it, drop(i.Region i.Año)

****EFCETOS ALEATORIOS

xtreg lpbi tl tr en, re

****Efectos between (paso intermedio)

xtreg lpbi tl tr en, be

==============================================
****TEST PARA LA SELECCIÓN DEL MODELO(SE RECOMIENDA EFECTOS FIJOS)

****Efectos fijo vs Datos Agrupados
xtreg lpbi tl tr en, fe


****Efectos aleatorios vs Datos Agrupados
xtreg lpbi tl tr en, re
xttest0

****Efectos aleatorios vs Efectos fijos (rechazar hipotesis nula)
xtreg lpbi tl tr en, fe
estimates store fe

xtreg lpbi tl tr en, re
estimates store re

hausman fe re

****Efectos fijos vs efectos fijos mas temporales (test sobre los parametros, se rechaza hipotesis nula)
xtreg lpbi tl tr en i.Año, fe
testparm i.Año

***Planteamiento del modelo		
reg lPBI lTR lTL lEN