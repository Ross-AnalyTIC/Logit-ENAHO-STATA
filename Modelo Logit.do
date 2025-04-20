*==================================
* ESTIMACIÓN DEL MODELO LOGIT 
*==================================
* By: Rossy Machaca
*-------------------

cls        
clear all
set more off

global inputs "D:\TESIS\DATA_RURAL\1_Inputs"
global outputs "D:\TESIS\DATA_RURAL\2_Outputs"
global cuadros "D:\TESIS\DATA_RURAL\2_Outputs\Cuadros"
global graficos "D:\TESIS\DATA_RURAL\2_Outputs\Graficos"
global sintax "D:\TESIS\DATA_RURAL\3_Sintax"

cd "$outputs"

*do "$sintax/Union_limpieza_2020"

use "$outputs\rural-2023", clear

describe
sum //verificar valores perdidos

*---------------------
* Correlaciones
*---------------------

global X "sexo edad mieperho log_ingper pobre neduc2 neduc3 neduc4 neduc5 idioma electricidad pc sierra selva" //

sum $X
correlate $X //para variables discretas
return list

matrix matriz_cor=r(C)
matrix list matriz_cor

putexcel set "$cuadros/correlaciones", replace
putexcel A2=matrix(matriz_cor), rownames 

* Chi cuadrado
tab sierra selva, chi2  V //Ho: Hay independencia (no hay relación)
tab sierra electricidad, chi2  V //Chi2 con V de Cramer para variables categoricas no ordinales

* Chi cuadrado
tab internet sexo, chi
tab internet pobreza, chi
tab internet niveduc, chi
tab internet idioma, chi 
tab internet electricidad, chi 
tab internet pc, chi 
tab internet regnat, chi 

* Chi cuadrado
tab internet edad, chi
tab internet mierperho, chi
tab internet ingper, chi

*---------------------
* Modelo 1 (general)
*---------------------
global xb1 "sexo edad mieperho log_ingper pobre i.niveduc idioma electricidad pc i.regnat"

logit internet $xb1  
estimates store m1 

/* Modelo 2 (sin sexo)
*----------------------------------------
global xb2 "log_ingper edad idioma mieperho pobre electricidad i.regnat i.niveduc"
 
logit internet $xb2 //
estimates store m2
lstat

*criterios de información para comparar modelos
estimates table m1 m2, stat(aic bic) // se prefiere el modelo 1
*/


** predicción de probabilidades
predict pr_logit
br pr_logit internet
sum pr_logit

** Calculo el Y predicho con corte 0.5
gen internet_est=(pr_logit>=0.5) //por defecto 
tab internet_est internet 
br internet_est internet 

** Para ver la precisión, sensibiidad y especificidad
lsens, xline(0.5)

* Matríz de confusión
lstat //ver tambien Seudo R2, es complementario pero debe de ser aceptable
lstat, cutoff(0.8)

** Curva ROC (se busca el mayor área bajo la curva)
lroc

gen internet_est2=(pr_logit>=0.25)

tab internet_est2 internet 

** calculo una variable predicha pero con corte 0.21
drop internet_est
gen internet_est=(pr_logit>=0.21) //corregido

tab  internet_est internet, col

*-----------------------
*    Efectos marginales
*-----------------------

** Promedio de los Efectos marginales
** Esto es lo que se presenta generalmente
margins, dydx(*)
*margins, eyex(log_ingper) //para variables continuas

** Efecto marginal en el punto promedio
logit internet $xb1
margins, dydx(*) atmean 

** Probabilidad de Y=1 en un punto especifico
*logit internet $xb2
*margins, at(niveduc=2 sexo=0 electricidad=1)
*margins, at(niveduc=2 sexo=1 electricidad=1)

** Predicción de probabilidades
predict xbb, xb 
label var xbb "xb-logit"
scatter internet pr_logit xbb, symbol(+ o) jitter(2) l1title("Pr Logit")

** Comparando modelos logit y probit
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

** Comparar efectos marginales
*---------------------------------

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


* ODS Ratio
*-----------

logistic internet $xb1


** Calcular los factores de inflación de la varianza (VIF)
** primero corremos una regresión estat
reg internet $xb1
estat vif

** verificación de bondad de ajuste
logit internet $xb1
estat gof


** breushc pegan"
predict uhat, residuals
regress uhat $xb1
estat hettest
