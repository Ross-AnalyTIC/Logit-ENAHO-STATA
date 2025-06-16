*===================================
* ESTIMACIÓN DEL MODELO LOGIT (2023)
*===================================

cls        
clear all
set more off

global outputs "D:\DATA_RURAL\2_Outputs"
global cuadros "D:\DATA_RURAL\2_Outputs\Cuadros"
cd "$outputs"

*do "$sintax/Union_limpieza_2023"

use "$outputs\rural-2023", clear

* Chi cuadrado
tab sierra selva, chi2  V //Ho: Hay independencia (no hay relación)
tab sierra electricidad, chi2  V //Chi2 con V de Cramer para variables categoricas no ordinales

*---------------------
* Modelo 1 (general)
*---------------------
global xb1 "sexo edad mieperho log_ingper pobre i.niveduc idioma electricidad i.regnat"

logit internet $xb1  
estimates store m1 

/* Modelo 2 (sin variable sexo)

global xb2 "log_ingper edad idioma mieperho pobre electricidad i.regnat i.niveduc"
 
logit internet $xb2 
estimates store m2
lstat

*criterios de información para comparar modelos
estimates table m1 m2, stat(aic bic) // se prefiere el modelo 1
*/

*-----------------------
*    Efectos marginales
*-----------------------

* Promedio de los Efectos marginales
margins, dydx(*)
*margins, eyex(log_ingper) //para variables continuas

* Efecto marginal en el punto promedio
logit internet $xb1
margins, dydx(*) atmean 

*------------------------------
* Predicción de probabilidades
*------------------------------

predict pr_logit
br pr_logit internet
sum pr_logit

* Calculo el Y predicho con corte 0.5
gen internet_est=(pr_logit>=0.5) //por defecto 
tab internet_est internet 
br internet_est internet 

*--------------------------------------------
* Precisión, especificidad y sensibilidad
*--------------------------------------------
lsens, xline(0.5)

* Matríz de confusión (clasificación)
lstat //ver tambien Seudo R2, es complementario pero debe de ser aceptable
lstat, cutoff(0.8)

*-----------------------------------------------------
* Curva ROC (se busca el mayor área bajo la curva)
*-----------------------------------------------------
lroc
gen internet_est2=(pr_logit>=0.25)
tab internet_est2 internet 

* Cálculo una variable predicha pero con corte 0.21
drop internet_est
gen internet_est=(pr_logit>=0.21) //corregido

tab  internet_est internet, col

*--------------------------------------------
* Comparando modelos logit y probit
*--------------------------------------------

logit internet $xb1 
estimate store  modelo1

probit internet $xb1
estimate store  modelo2

*esttab modelo1 modelo2, aic bic  star(* 0.10 ** 0.05 *** 0.01)
*ssc instal fitstat

logit internet $xb1 
fitstat

probit internet $xb1 
fitstat

* Comparación de efectos marginales

quietly logit internet $xb1
lstat
margins, dydx(*) 
return list
matrix logit_dydx=r(b)'

quietly probit internet $xb1
lstat
margins, dydx(*) 
matrix probit_dydx=r(b)'

matrix unido=matrix(logit_dydx,probit_dydx)
matrix list unido

*-----------------------------------------------------------------------
* Factor de Inflación de la Varianza (VIF) y supuestos complemnetarios
*-----------------------------------------------------------------------

reg internet $xb1
estat vif

* verificación de bondad de ajuste
logit internet $xb1
estat gof

* Breusch Pagan
predict uhat, residuals
regress uhat $xb1
estat hettest
