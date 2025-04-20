*===============================
* ANÁLISIS GRÁFICO (2020-2023)
*===============================

cls        
clear all
set more off

global inputs "D:\DATA_RURAL\1_Inputs"
global outputs "D:\DATA_RURAL\2_Outputs"
global graficos "D:\DATA_RURAL\2_Outputs\Graficos"

cd "$outputs"

*---------------------------------
* 2020
*---------------------------------
*do "$sintax/Union_limpieza_2020"

use "rural-2020", clear

// Cantidad de hogares de la muestra
count if p203==1

// Hogares con acceso Internet
fre internet if p203==1

// Personas con Internet según sexo
tab internet sexo

// Distribución de edad
tab edad
graph box edad

lab def r_edad 1 "[6,14]" 2 "[15,25]" 3 "[26,41]" 4 "[42,56]" 5 "[57,98]", replace
lab val r_edad r_edad
tab r_edad

// Personas con Internet según grupós de edad
recode edad (0/19=1 "0-19")(20/39=2 "20-39")(40/59=3 "40-49")(60/98=4 "60-98"), g(r_edad)
tab r_edad if internet==1

// Composición del hogar
tab mieperho
graph box mieperho, over(internet)

// Ingreso percapita mensual
histogram ingper, by(internet) bin(7)
histogram log_ingper, by(internet) bin(15)

// Pobreza
tab pobre internet if p203==1, row nofreq

// Porcentaje de hogares con Internet según nivel educativo
tab niveduc internet if p203==1 //

// Idioma nativo
tab internet if idioma==1 //

// Energía
tab internet electricidad if p203==1, row nofreq //

// PC
tab internet p612 if p203==1, miss row nofreq //

// Porcentaje de hogares según región natural
tab internet regnat if p203==1, col nofreq


*---------------------------------
* 2021
*---------------------------------
*do "$sintax/Union_limpieza_2021"

use "rural-2021", clear

// Cantidad de hogares de la muestra
count if p203==1

// Hogares con acceso Internet
fre internet if p203==1

// Personas con Internet según sexo
tab internet sexo

// Distribución de edad
tab edad
graph box edad

// Personas con Internet según grupós de edad
recode edad (0/19=1 "0-19")(20/39=2 "20-39")(40/59=3 "40-49")(60/98=4 "60-98"), g(r_edad)
tab r_edad if internet==1

// Composición del hogar
tab mieperho
graph box mieperho, over(internet)

// Ingreso percapita mensual
histogram ingper, by(internet) bin(7)
histogram log_ingper, by(internet) bin(15)

// Pobreza
tab pobre internet if p203==1, row nofreq

// Porcentaje de hogares con Internet según nivel educativo
tab niveduc internet if p203==1 //

// Idioma nativo
tab internet if idioma==1 //

// Energía
tab internet electricidad if p203==1, row nofreq //

// PC
tab internet p612 if p203==1, miss row nofreq //

// Porcentaje de hogares según región natural
tab internet regnat if p203==1, col nofreq


*---------------------------------
* 2022
*---------------------------------
*do "$sintax/Union_limpieza_2022"

use "rural-2022", clear

// Cantidad de hogares de la muestra
count if p203==1

// Hogares con acceso Internet
fre internet if p203==1

// Personas con Internet según sexo
tab internet sexo 

// Distribución de edad
tab edad
graph box edad

// Personas con Internet según grupós de edad
recode edad (0/19=1 "0-19")(20/39=2 "20-39")(40/59=3 "40-49")(60/98=4 "60-98"), g(r_edad)
tab r_edad if internet==1

// Composición del hogar
tab mieperho
graph box mieperho, over(internet)

// Ingreso percapita mensual
histogram ingper, by(internet) bin(7)
histogram log_ingper, by(internet) bin(15)

// Pobreza
tab pobre internet if p203==1, row nofreq

// Energía
tab internet electricidad if p203==1, row nofreq //

// PC
tab internet p612 if p203==1, miss row nofreq //

// Porcentaje de hogares con Internet según nivel educativo
tab niveduc internet if p203==1 //

// Idioma nativo
tab internet if idioma==1 //

// Porcentaje de hogares según región natural
tab internet regnat if p203==1, col nofreq


*---------------------------------
* 2023
*---------------------------------
*do "$sintax/Union_limpieza_2023"

use "rural-2023", clear

// Cantidad de hogares de la muestra
count if p203==1

// Hogares con acceso Internet
fre internet if p203==1

// Personas con Internet según sexo
tab internet sexo

// Distribución de edad
tab edad
graph box edad

// Personas con Internet según grupós de edad
recode edad (0/19=1 "0-19")(20/39=2 "20-39")(40/59=3 "40-49")(60/98=4 "60-98"), g(r_edad)
tab r_edad if internet==1

// Composición del hogar
tab mieperho
graph box mieperho, over(internet)

// Ingreso percapita mensual
histogram ingper, by(internet) bin(7)
histogram log_ingper, by(internet) bin(15)

// Pobreza
tab pobre internet if p203==1, row nofreq

// Porcentaje de hogares con Internet según nivel educativo
tab niveduc internet if p203==1 //

// Idioma nativo
tab internet if idioma==1 //

// Energía
tab internet electricidad if p203==1, row nofreq //

// PC
tab internet p612 if p203==1, miss row nofreq //

// Porcentaje de hogares según región natural
tab internet regnat if p203==1, col nofreq


