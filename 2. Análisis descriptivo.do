*===============================
* ANÁLISIS DESCRIPTIVO (2020)
*===============================

cls        
clear all
set more off

global inputs "D:\DATA_RURAL\1_Inputs"
global outputs "D:\DATA_RURAL\2_Outputs"
global graficos "D:\DATA_RURAL\2_Outputs\Graficos"
global cuadros "D:\DATA_RURAL\2_Outputs\Cuadros"
cd "$outputs"

*---------------------------------
* Análisis gráfico
*---------------------------------
*do "$sintax/UTratamiento de datos_2020"

use "rural-2020", clear

// Cantidad de hogares de la muestra
count if p203==1

// Hogares con acceso Internet
fre internet if p203==1

// Personas con Internet según sexo del jefe de hogar
tab internet sexo

// Personas con Internet según grupos de edad
tab edad
graph box edad
recode edad (6/17=1 "6-17")(18/39=2 "18-39")(40/59=3 "40-59")(60/max=4 "60 y más"), g(r_edad)
tab r_edad if internet==1

// Composición del hogar
tab mieperho
graph box mieperho, over(internet)

// Ingreso percapita mensual
collapse (mean) prom_ingper = ingper (min) minimo_ingper= ingper (max) max_ingper = ingper if p203==1
list
histogram ingper, by(internet) bin(7)
histogram log_ingper, by(internet) bin(15)

// Pobreza
tab pobre internet if p203==1, row nofreq

// Porcentaje de hogares con Internet según nivel educativo
tab niveduc internet if p203==1 

// Idioma nativo
tab internet if idioma==1 

// Energía
tab internet electricidad if p203==1, row nofreq 

// Porcentaje de hogares según región natural
tab internet regnat if p203==1, col nofreq

// Porcentaje de hogares según departamento
tab internet dpto if p203==1, col nofreq

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
