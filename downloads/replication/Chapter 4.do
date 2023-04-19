* Chapter 4: 
*
*
* 3/22/23
* -----------------------------------------------------------------------------
set scheme burd
set more off

*	Set directory paths by commenting out
global user "AndyCU"
*global user "Andy"
*global user "Guy1"
*global user "Guy2"

if "$user" == "AndyCU"	{
	global path "/Users/aqpimac/Dropbox/"
}
if "$user" == "Guy1"	{
	global path "C:/Users/g-whitten/Dropbox/"
	set matsize 2000
	set maxvar 32767 
}
if "$user" == "Guy2"	{
	global path "C:/Users/Guy Whitten/Dropbox/"
	set matsize 2000
	set maxvar 32767 
}

cd "${path}/Lipsmeyer_Philips_Whitten/Cambridge Book Project/data/figures/FINAL/"

* Run our program (w/ 90/95% CIs):
do "${path}/Lipsmeyer_Philips_Whitten/Cambridge Book Project/Programs/dspcstsldvany2.ado"

use "LPW_CUP.dta", clear
xtset

global effectsplot "twoway rspike var_pie_ul_sr_ var_pie_ll_sr sort_sr, horizontal lcolor(black) lwidth(medthin) || rspike var_pie_ul_lr_ var_pie_ll_lr_ sort_lr, horizontal lcolor(black) lwidth(medthin) || rspike var_pie_ul90_sr_ var_pie_ll90_sr sort_sr, horizontal lcolor(black) lwidth(medthick) || rspike var_pie_ul90_lr_ var_pie_ll90_lr_ sort_lr, horizontal lcolor(black) lwidth(medthick) || scatter  sort_sr mid_sr, msymbol(T) mcolor("27 158 119") msize(medlarge) || scatter sort_lr mid_lr, msymbol(O) mcolor("117 112 179") msize(medlarge) xline(0, lcolor(black) lstyle(solid))  yscale(axis(1) noline) xlabel(, grid glcolor(gs15)) plotregion(style(none)) legend(order(5 "Short-Run" 6 "Long-Run") ) xtitle("Predicted Change from Baseline")  ylabel(1 "Social Protection" 2 "Religion & Culture" 3 "Housing" 4 "Health" 5 "Govt. Administration" 6 "Education" 7 "Econ. Affairs" 8 "Defense")"
 
* get variable == 1 for all other IVs not missing:
gen tabbb = 1
foreach var of varlist $dvs growth dSOP dunemployment unemployment dopenness ADR_nov18 total_hostlev sop_exp_nov18 deficit_gdp majoritygovt right legelec {
	replace tabbb = 0 if `var' == .
}

xtset imf year
 
global dvs "socialp_house recr_house health_house edu_house econaff_house defense_house pubserv_house" // 7 dvs, 8 categories



* --------------------------------------------------------------------------
*			Figure 4.6a
* --------------------------------------------------------------------------
set seed 29202094
* shock of an election under left majority govt
matrix smat = J(100,29,.) // t=100, k = 29
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "deficit_gdp" "ldeficit_gdp" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt"  "lmajoritygovt" "right_maj" "lright_maj" "total_hostlev" "ltotal_hostlev" "year" "legelec_r" "llegelec_r" "legelec_maj" "llegelec_maj" "legelec_r_maj" "llegelec_r_maj"
local r = rowsof(smat)

* GDP growth and L.GDP growth: means
su growth if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',1] = r(mean)
	mat smat[`i',2] = r(mean)
}
* d.Unemployment and L.Unemployment: 0 and mean, respectively
su lunemployment if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',3] = 0
	mat smat[`i',4] = r(mean)
}
* d.Openness and dL.openness: mean
su dopenness if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',5] = r(mean)
	mat smat[`i',6] = r(mean)
}
* Deficit and L.deficit: mean
su deficit_gdp if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',7] = r(mean)
	mat smat[`i',8] = r(mean)
}
* d.SOP expenditures and L.SOP: 0 and mean, respectively
su lsop_exp_nov18 if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',9] = 0
	mat smat[`i',10] = r(mean)
}
* ADR and L.ADR: mean
su ADR_nov18 if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',11] = r(mean)
	mat smat[`i',12] = r(mean)
}
* Election Year and L.election year: 0
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',13] = 1
	}
	else {
		mat smat[`i',13] = 0
	}
	if `i' == 56 {
		mat smat[`i',14] = 1
	}
	else {
		mat smat[`i',14] = 0
	}
}
* Right and l.Right: 0
forv i = 1/`r' {
	mat smat[`i',15] = 0
	mat smat[`i',16] = 0	
}
* Majority Govt and L.majority: 1
forv i = 1/`r' {
	mat smat[`i',17] = 1
	mat smat[`i',18] = 1
}
* Right x Maj and L.Right x Maj : 0
forv i = 1/`r' {	
	mat smat[`i',19] = 0
	mat smat[`i',20] = 0
}
* total_hostlev and L.hostlev: mean
su total_hostlev if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',21] = r(mean)
	mat smat[`i',22] = r(mean)
}
* Year trend; keep at 1995
forv i = 1/`r' {
	mat smat[`i',23] = 1995
}
* Right*election and 'right*election: = 0
forv i = 1/`r' {
	mat smat[`i',24] = 0
	mat smat[`i',25] = 0
}
* majority*election and 'majority*election: = 1 only at election at t=55 (and l. = t = 56), 0 otherwise
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',26] = 1
	}
	else {
		mat smat[`i',26] = 0
	}
	if `i' == 56 {
		mat smat[`i',27] = 1
	}
	else {
		mat smat[`i',27] = 0
	}
}
* maj*Right*election and lmaj*right*election: 0
forv i = 1/`r' {
	mat smat[`i',28] = 0
	mat smat[`i',29] = 0
}
mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year legelec_r llegelec_r legelec_maj llegelec_maj legelec_r_maj llegelec_r_maj, shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
preserve
use dynsimpie_results.dta, clear
* re-sort to get alphabetical
gen sort2 = sort
replace sort = 1 if sort2 == 1 // social protect
replace sort = 2 if sort2 == 2 // relig/culture
replace sort = 3 if sort2 == 8 // housing
replace sort = 4 if sort2 == 3 // health
replace sort = 5 if sort2 == 7 // govt admin
replace sort = 6 if sort2 == 4 // education
replace sort = 7 if sort2 == 5 // econ affairs
replace sort = 8 if sort2 == 6 // defense
sort sort
drop sort_sr sort_lr
gen sort_sr = sort+.2
gen sort_lr = sort-.2
$effectsplot xlabel(-01 (.5) 1.5)
*graph export "final-figures/chapter 3/Ch3_expenditures_election_left_majority_effectsplot.pdf", as(pdf) replace
restore 
* --------------------------------------------------------------------------



* --------------------------------------------------------------------------
*			Figure 4.6b
* --------------------------------------------------------------------------
* shock of an election under right majority govt
matrix smat = J(100,29,.) // t=100, k = 29
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "deficit_gdp" "ldeficit_gdp" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt"  "lmajoritygovt" "right_maj" "lright_maj" "total_hostlev"  "ltotal_hostlev" "year" "legelec_r" "llegelec_r" "legelec_maj" "llegelec_maj" "legelec_r_maj" "llegelec_r_maj"
local r = rowsof(smat)

* GDP growth and L.GDP growth: means
su growth if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',1] = r(mean)
	mat smat[`i',2] = r(mean)
}
* d.Unemployment and L.Unemployment: 0 and mean, respectively
su lunemployment if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',3] = 0
	mat smat[`i',4] = r(mean)
}
* d.Openness and dL.openness: mean
su dopenness if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',5] = r(mean)
	mat smat[`i',6] = r(mean)
}
* Deficit and L.deficit: mean
su deficit_gdp if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',7] = r(mean)
	mat smat[`i',8] = r(mean)
}
* d.SOP expenditures and L.SOP: 0 and mean, respectively
su lsop_exp_nov18 if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',9] = 0
	mat smat[`i',10] = r(mean)
}
* ADR and L.ADR: mean
su ADR_nov18 if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',11] = r(mean)
	mat smat[`i',12] = r(mean)
}
* Election Year and L.election year: 0
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',13] = 1
	}
	else {
		mat smat[`i',13] = 0
	}
	if `i' == 56 {
		mat smat[`i',14] = 1
	}
	else {
		mat smat[`i',14] = 0
	}
}
* Right and l.Right: 1 
forv i = 1/`r' {
	mat smat[`i',15] = 1
	mat smat[`i',16] = 1	
}
* Majority Govt and L.majority: 1
forv i = 1/`r' {
	mat smat[`i',17] = 1
	mat smat[`i',18] = 1
}
* Right x Maj and L.Right x Maj : 1
forv i = 1/`r' {	
	mat smat[`i',19] = 1
	mat smat[`i',20] = 1
}
* total_hostlev and L.hostlev: mean
su total_hostlev if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',21] = r(mean)
	mat smat[`i',22] = r(mean)
}
* Year trend; keep at 1995
forv i = 1/`r' {
	mat smat[`i',23] = 1995
}
* Right*election and l.right*election: = 1 only at election at t=55 (and l. = t = 56), 0 otherwise
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',24] = 1
	}
	else {
		mat smat[`i',24] = 0
	}
	if `i' == 56 {
		mat smat[`i',25] = 1
	}
	else {
		mat smat[`i',25] = 0
	}
}
* majority*election and l.majority*election: = 1 only at election at t=55 (and l. = t = 56), 0 otherwise
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',26] = 1
	}
	else {
		mat smat[`i',26] = 0
	}
	if `i' == 56 {
		mat smat[`i',27] = 1
	}
	else {
		mat smat[`i',27] = 0
	}
}
* maj*Right*election and lmaj*right*election: = 1 only at election at t=55 (and l. = t = 56), 0 otherwise 
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',28] = 1
	}
	else {
		mat smat[`i',28] = 0
	}
	if `i' == 56 {
		mat smat[`i',29] = 1
	}
	else {
		mat smat[`i',29] = 0
	}
}
mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year  legelec_r llegelec_r legelec_maj llegelec_maj legelec_r_maj llegelec_r_maj, shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
preserve
use dynsimpie_results.dta, clear
* re-sort to get alphabetical
gen sort2 = sort
replace sort = 1 if sort2 == 1 // social protect
replace sort = 2 if sort2 == 2 // relig/culture
replace sort = 3 if sort2 == 8 // housing
replace sort = 4 if sort2 == 3 // health
replace sort = 5 if sort2 == 7 // govt admin
replace sort = 6 if sort2 == 4 // education
replace sort = 7 if sort2 == 5 // econ affairs
replace sort = 8 if sort2 == 6 // defense
sort sort
drop sort_sr sort_lr
gen sort_sr = sort+.2
gen sort_lr = sort-.2
$effectsplot xlabel(-01 (.5) 1.5)
*graph export "final-figures/chapter 3/Ch3_expenditures_election_right_majority_effectsplot.pdf", as(pdf) replace
restore
* --------------------------------------------------------------------------



* --------------------------------------------------------------------------
*			Figure 4.7a
* --------------------------------------------------------------------------
set seed 90939284

* +1 SD shock to unemployment under left-majority govt
matrix smat = J(100,29,.) // t=100, k = 29
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt" "lmajoritygovt" "right_maj" "lright_maj" "unemployment_r" "lunemployment_r" "unemployment_maj" "lunemployment_maj" "unemployment_r_maj" "lunemployment_r_maj" "deficit_gdp" "ldeficit_gdp" "year" "total_hostlev" "ltotal_hostlev"  
local r = rowsof(smat)

* GDP growth and l.GDP growth : mean
su growth if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',1] = r(mean)
	mat smat[`i',2] = r(mean)
}
* d.Unemployment: 0 + 1sd at t = 55
su unemployment if tabbb == 1
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',3] = 0 + r(sd)
	} 
	else {
		mat smat[`i',3] = 0 
	}
}
* l.Unemployment: mean + 1sd at t = 56
su unemployment if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',4] = r(mean) + r(sd)
	} 
	else {
		mat smat[`i',4] = r(mean) 
	}
}
* d.openness and ld.openness : mean
su dopenness if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',5] = r(mean)
	mat smat[`i',6] = r(mean)
}
* d.SOP expenditures and L.SOP : 0 and mean, respectively
su lsop_exp_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',7] = 0
	mat smat[`i',8] = r(mean)
}
* ADR and lADR: mean
su ADR_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',9] =r(mean)
	mat smat[`i',10] =r(mean)
}
* Election Year and l.election: 0
forv i = 1/`r' {
	mat smat[`i',11] = 0
	mat smat[`i',12] = 0
}
* Right and l.right: 0 
forv i = 1/`r' {
	mat smat[`i',13] = 0
	mat smat[`i',14] = 0
}
* Majority Govt and l.majority: 1
forv i = 1/`r' {
	mat smat[`i',15] = 1
	mat smat[`i',16] = 1
}
* Right x Maj and l.(right x majority): 0
forv i = 1/`r' {
	mat smat[`i',17] = 0
	mat smat[`i',18] = 0
}
* unemp_nov18 x right: 0
su unemployment if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',19] = 0
}
* l.unemp x right: 0
su unemployment if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',20] = 0
}
* d.unemp x majority: 0 + 1 SD at t = 55
su unemployment if tabbb == 1
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',21] =0 + r(sd)
	} 
	else {
		mat smat[`i',21] = 0
	}
}
* l.unemp x majority: mean + 1 SD at t = 55
su unemployment if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',22] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',22] = r(mean) 
	}
}
* unemp x right x majority: 0
su unemployment if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',23] = 0
}
* l.unemp x right x majority: 0
su unemployment if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',24] = 0
}
* deficit and L.deficit: mean 
su deficit_gdp if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',25] = r(mean)
	mat smat[`i',26] = r(mean)
}
* Year trend; keep at 1995
forv i = 1/`r' {
	mat smat[`i',27] = 1995
}
* hostility and l.hostility: mean throughout
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',28] = r(mean)
	mat smat[`i',29] = r(mean)
}

mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj unemployment_r lunemployment_r unemployment_maj lunemployment_maj unemployment_r_maj lunemployment_r_maj deficit_gdp ldeficit_gdp year total_hostlev ltotal_hostlev , shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
preserve
use dynsimpie_results.dta, clear
* re-sort to get alphabetical
gen sort2 = sort
replace sort = 1 if sort2 == 1 // social protect
replace sort = 2 if sort2 == 2 // relig/culture
replace sort = 3 if sort2 == 8 // housing
replace sort = 4 if sort2 == 3 // health
replace sort = 5 if sort2 == 7 // govt admin
replace sort = 6 if sort2 == 4 // education
replace sort = 7 if sort2 == 5 // econ affairs
replace sort = 8 if sort2 == 6 // defense
sort sort
drop sort_sr sort_lr
gen sort_sr = sort + .2
gen sort_lr = sort - .2
$effectsplot xlabel(-10 (2) 10)
*graph export "final-figures/chapter 4/Ch4_expenditures_unemp_x_left_majority_effectsplot.pdf", as(pdf) replace
restore
* --------------------------------------------------------------------------




* --------------------------------------------------------------------------
*		Figure 4.7b
* --------------------------------------------------------------------------
* +1 SD shock to unemployment under right-majority govt
matrix smat = J(100,29,.) // t=100, k = 29
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt" "lmajoritygovt" "right_maj" "lright_maj" "unemployment_r" "lunemployment_r" "unemployment_maj" "lunemployment_maj" "unemployment_r_maj" "lunemployment_r_maj" "deficit_gdp" "ldeficit_gdp" "year" "total_hostlev" "ltotal_hostlev"  
local r = rowsof(smat)

* GDP growth and l.GDP growth : mean
su growth if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',1] = r(mean)
	mat smat[`i',2] = r(mean)
}
* d.Unemployment: 0 + 1sd at t = 55
su unemployment if tabbb == 1
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',3] = 0 + r(sd)
	} 
	else {
		mat smat[`i',3] = 0 
	}
}
* l.Unemployment: mean + 1sd at t = 56
su unemployment if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',4] = r(mean) + r(sd)
	} 
	else {
		mat smat[`i',4] = r(mean) 
	}
}
* d.openness and ld.openness : mean
su dopenness if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',5] = r(mean)
	mat smat[`i',6] = r(mean)
}
* d.SOP expenditures and L.SOP : 0 and mean, respectively
su lsop_exp_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',7] = 0
	mat smat[`i',8] = r(mean)
}
* ADR and lADR: mean
su ADR_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',9] =r(mean)
	mat smat[`i',10] =r(mean)
}
* Election Year and l.election: 0
forv i = 1/`r' {
	mat smat[`i',11] = 0
	mat smat[`i',12] = 0
}
* Right and l.right: 1 
forv i = 1/`r' {
	mat smat[`i',13] = 1
	mat smat[`i',14] = 1
}
* Majority Govt and l.majority: 1
forv i = 1/`r' {
	mat smat[`i',15] = 1
	mat smat[`i',16] = 1
}
* Right x Maj and l.(right x majority): 1
forv i = 1/`r' {
	mat smat[`i',17] = 1
	mat smat[`i',18] = 1
}
* d.unemp_nov18 x right: 0 + 1 SD at t = 55
su unemployment if tabbb == 1
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',19] = 0 + r(sd)
	} 
	else {
		mat smat[`i',19] = 0
	}
}
* l.unemp x right: mean + 1 SD at t = 56
su unemployment if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',20] = r(mean) + r(sd)
	} 
	else {
		mat smat[`i',20] = r(mean) 
	}
}
* d.unemp x majority: 0 + 1 SD at t = 55
su unemployment if tabbb == 1
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',21] = 0 + r(sd)
	} 
	else {
		mat smat[`i',21] = 0
	}
}
* l.unemp x majority: mean + 1 SD at t = 55
su unemployment if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',22] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',22] = r(mean) 
	}
}
* d.unemp x right x majority: 0 + 1 SD at t = 55
su unemployment if tabbb == 1
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',23] = 0 + r(sd)
	} 
	else {
		mat smat[`i',23] = 0
	}
}
* l.unemp x right x majority: mean + 1 SD at t = 55
su unemployment if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',24] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',24] = r(mean) 
	}
}
* deficit and L.deficit: mean 
su deficit_gdp if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',25] = r(mean)
	mat smat[`i',26] = r(mean)
}
* Year trend; keep at 1995
forv i = 1/`r' {
	mat smat[`i',27] = 1995
}
* hostility and l.hostility: mean throughout
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',28] = r(mean)
	mat smat[`i',29] = r(mean)
}

mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj unemployment_r lunemployment_r unemployment_maj lunemployment_maj unemployment_r_maj lunemployment_r_maj deficit_gdp ldeficit_gdp year total_hostlev ltotal_hostlev , shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
preserve
use dynsimpie_results.dta, clear
* re-sort to get alphabetical
gen sort2 = sort
replace sort = 1 if sort2 == 1 // social protect
replace sort = 2 if sort2 == 2 // relig/culture
replace sort = 3 if sort2 == 8 // housing
replace sort = 4 if sort2 == 3 // health
replace sort = 5 if sort2 == 7 // govt admin
replace sort = 6 if sort2 == 4 // education
replace sort = 7 if sort2 == 5 // econ affairs
replace sort = 8 if sort2 == 6 // defense
sort sort
drop sort_sr sort_lr
gen sort_sr = sort + .2
gen sort_lr = sort - .2
$effectsplot xlabel(-10 (2) 10)
*graph export "final-figures/chapter 4/Ch4_expenditures_unemp_x_right_majority_effectsplot.pdf", as(pdf) replace
restore
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 4.8a
* --------------------------------------------------------------------------
* +1 SD shock to growth under left-majority govt
matrix smat = J(100,29,.) // t=100, k = 29
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt" "lmajoritygovt" "right_maj" "lright_maj" "growth_r" "lgrowth_r" "growth_maj" "lgrowth_maj" "growth_r_maj" "lgrowth_r_maj" "deficit_gdp" "ldeficit_gdp" "year" "total_hostlev" "ltotal_hostlev"  
local r = rowsof(smat)

* GDP growth :  mean + 1sd at t = 55
su growth if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',1] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',1] = r(mean) 
	}
}
* l.GDP growth : mean + 1sd at t = 56
su growth if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',2] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',2] = r(mean) 
	}
}
* d.Unemployment and L.Unemployment: 0 and mean, respectively
su lunemployment if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',3] = 0
	mat smat[`i',4] = r(mean)
}
* d.openness and ld.openness: mean
su dopenness if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',5] =r(mean)
	mat smat[`i',6] =r(mean)
}
* d.SOP expenditures and L.SOP : 0 and mean, respectively
su lsop_exp_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',7] = 0
	mat smat[`i',8] = r(mean)
}
* ADR and lADR: mean 
su ADR_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',9] =r(mean)
	mat smat[`i',10] =r(mean)
}
* Election Year and l.election: 0
forv i = 1/`r' {
	mat smat[`i',11] = 0
	mat smat[`i',12] = 0
}
* Right and l.right: 0
forv i = 1/`r' {
	mat smat[`i',13] = 0
	mat smat[`i',14] = 0
}
* Majority Govt and l.majority: 1
forv i = 1/`r' {
	mat smat[`i',15] = 1
	mat smat[`i',16] = 1
}
* Right x Maj and l.(right x majority): 0
forv i = 1/`r' {
	mat smat[`i',17] = 0
	mat smat[`i',18] = 0
}
* growth x right: 0
su growth if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',19] = 0
}
* l.growth x right: 0
su growth if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',20] = 0
}
* growth x majority: mean + 1 SD at t = 55
su growth if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',21] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',21] = r(mean) 
	}
}
* l.growth x majority: mean + 1 SD at t = 55
su growth if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',22] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',22] = r(mean) 
	}
}
* growth x right x majority: 0
su growth if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',23] = 0
}
* l.growth x right x majority: 0
su growth if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',24] = 0
}
* deficit and L.deficit: mean 
su deficit_gdp if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',25] = r(mean)
	mat smat[`i',26] = r(mean)
}
* Year trend; keep at 1995
forv i = 1/`r' {
	mat smat[`i',27] = 1995
}
* hostility and l.hostility: mean throughout
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',28] = r(mean)
	mat smat[`i',29] = r(mean)
}

mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj growth_r lgrowth_r growth_maj lgrowth_maj growth_r_maj lgrowth_r_maj deficit_gdp ldeficit_gdp year total_hostlev ltotal_hostlev , shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
preserve
use dynsimpie_results.dta, clear
* re-sort to get alphabetical
gen sort2 = sort
replace sort = 1 if sort2 == 1 // social protect
replace sort = 2 if sort2 == 2 // relig/culture
replace sort = 3 if sort2 == 8 // housing
replace sort = 4 if sort2 == 3 // health
replace sort = 5 if sort2 == 7 // govt admin
replace sort = 6 if sort2 == 4 // education
replace sort = 7 if sort2 == 5 // econ affairs
replace sort = 8 if sort2 == 6 // defense
sort sort
drop sort_sr sort_lr
gen sort_sr = sort + .2
gen sort_lr = sort - .2
$effectsplot 
*graph export "final-figures/chapter 4/Ch4_expenditures_growth_x_left_majority_effectsplot.pdf", as(pdf) replace
restore 
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 4.8b
* --------------------------------------------------------------------------
* +1 SD shock to growth under right-majority govt
matrix smat = J(100,29,.) // t=100, k = 29
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt" "lmajoritygovt" "right_maj" "lright_maj" "growth_r" "lgrowth_r" "growth_maj" "lgrowth_maj" "growth_r_maj" "lgrowth_r_maj" "deficit_gdp" "ldeficit_gdp" "year" "total_hostlev" "ltotal_hostlev"  
local r = rowsof(smat)

* GDP growth :  mean + 1sd at t = 55
su growth if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',1] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',1] = r(mean) 
	}
}

* l.GDP growth : mean + 1sd at t = 56
su growth if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',2] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',2] = r(mean) 
	}
}
* d.Unemployment and L.Unemployment: 0 and mean, respectively
su lunemployment if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',3] = 0
	mat smat[`i',4] = r(mean)
}
* d.openness and ld.openness: mean
su dopenness if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',5] =r(mean)
	mat smat[`i',6] =r(mean)
}
* d.SOP expenditures and L.SOP : 0 and mean, respectively
su lsop_exp_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',7] = 0
	mat smat[`i',8] = r(mean)
}
* ADR and lADR: mean 
su ADR_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',9] =r(mean)
	mat smat[`i',10] =r(mean)
}
* Election Year and l.election: 0
forv i = 1/`r' {
	mat smat[`i',11] = 0
	mat smat[`i',12] = 0
}
* Right and l.right: 1 
forv i = 1/`r' {
	mat smat[`i',13] = 1
	mat smat[`i',14] = 1
}
* Majority Govt and l.majority: 1
forv i = 1/`r' {
	mat smat[`i',15] = 1
	mat smat[`i',16] = 1
}
* Right x Maj and l.(right x majority): 1
forv i = 1/`r' {
	mat smat[`i',17] = 1
	mat smat[`i',18] = 1
}
* growth x right: mean + 1 SD at t = 55
su growth if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',19] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',19] = r(mean) 
	}
}
* l.growth x right: mean + 1 SD at t = 56
su growth if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',20] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',20] = r(mean) 
	}
}
* growth x majority: mean + 1 SD at t = 55
su growth if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',21] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',21] = r(mean) 
	}
}
* l.growth x majority: mean + 1 SD at t = 55
su growth if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',22] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',22] = r(mean) 
	}
}
* growth x right x majority: mean + 1 SD at t = 55
su growth if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',23] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',23] = r(mean) 
	}
}
* l.growth x right x majority: mean + 1 SD at t = 55
su growth if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',24] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',24] = r(mean) 
	}
}
* deficit and L.deficit: mean 
su deficit_gdp if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',25] = r(mean)
	mat smat[`i',26] = r(mean)
}
* Year trend; keep at 1995
forv i = 1/`r' {
	mat smat[`i',27] = 1995
}
* hostility and l.hostility: mean throughout
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',28] = r(mean)
	mat smat[`i',29] = r(mean)
}

mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj growth_r lgrowth_r growth_maj lgrowth_maj growth_r_maj lgrowth_r_maj deficit_gdp ldeficit_gdp year total_hostlev ltotal_hostlev , shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
preserve
use dynsimpie_results.dta, clear
* re-sort to get alphabetical
gen sort2 = sort
replace sort = 1 if sort2 == 1 // social protect
replace sort = 2 if sort2 == 2 // relig/culture
replace sort = 3 if sort2 == 8 // housing
replace sort = 4 if sort2 == 3 // health
replace sort = 5 if sort2 == 7 // govt admin
replace sort = 6 if sort2 == 4 // education
replace sort = 7 if sort2 == 5 // econ affairs
replace sort = 8 if sort2 == 6 // defense
sort sort
drop sort_sr sort_lr
gen sort_sr = sort + .2
gen sort_lr = sort - .2
$effectsplot 
*graph export "final-figures/chapter 4/Ch4_expenditures_growth_x_right_majority_effectsplot.pdf", as(pdf) replace
restore 
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 4.9a
* --------------------------------------------------------------------------
* +1 SD shock to openness under left-majority govt
matrix smat = J(100,29,.) // t=100, k = 29
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt" "lmajoritygovt" "right_maj" "lright_maj" "dopenness_r" "ldopenness_r" "dopenness_maj" "ldopenness_maj" "dopenness_r_maj" "ldopenness_r_maj" "deficit_gdp" "ldeficit_gdp" "year" "total_hostlev" "ltotal_hostlev"  
local r = rowsof(smat)

* GDP growth and l.GDP growth : mean
su growth if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',1] = r(mean)
	mat smat[`i',2] = r(mean)
}
* d.Unemployment and L.Unemployment: 0 and mean, respectively
su lunemployment if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',3] = 0
	mat smat[`i',4] = r(mean)
}
* d.openness : mean + 1sd at t = 55
su dopenness if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',5] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',5] = r(mean) 
	}
}
* ld.openness : mean + 1sd at t = 56
su dopenness if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',6] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',6] = r(mean) 
	}
}
* d.SOP expenditures and L.SOP : 0 and mean, respectively
su lsop_exp_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',7] = 0
	mat smat[`i',8] = r(mean)
}
* ADR and lADR: mean 
su ADR_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',9] =r(mean)
	mat smat[`i',10] =r(mean)
}
* Election Year and l.election: 0
forv i = 1/`r' {
	mat smat[`i',11] = 0
	mat smat[`i',12] = 0
}
* Right and l.right: 0
forv i = 1/`r' {
	mat smat[`i',13] = 0
	mat smat[`i',14] = 0
}
* Majority Govt and l.majority: 1
forv i = 1/`r' {
	mat smat[`i',15] = 1
	mat smat[`i',16] = 1
}
* Right x Maj and l.(right x majority): 0
forv i = 1/`r' {
	mat smat[`i',17] = 0
	mat smat[`i',18] = 0
}
* dopenness x right: 0
su dopenness if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',19] = 0
}
* l.dopenness x right: 0
su dopenness if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',20] = 0
}
* dopenness x majority: mean + 1 SD at t = 55
su dopenness if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',21] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',21] = r(mean) 
	}
}
* l.dopenness x majority: mean + 1 SD at t = 55
su dopenness if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',22] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',22] = r(mean) 
	}
}
* dopenness x right x majority: 0
su dopenness if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',23] = 0
}
* l.dopenness x right x majority: 0
su dopenness if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',24] = 0
}
* deficit and L.deficit: mean 
su deficit_gdp if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',25] = r(mean)
	mat smat[`i',26] = r(mean)
}
* Year trend; keep at 1995
forv i = 1/`r' {
	mat smat[`i',27] = 1995
}
* hostility and l.hostility: mean throughout
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',28] = r(mean)
	mat smat[`i',29] = r(mean)
}

mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj dopenness_r ldopenness_r dopenness_maj ldopenness_maj dopenness_r_maj ldopenness_r_maj deficit_gdp ldeficit_gdp year total_hostlev ltotal_hostlev , shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
preserve
use dynsimpie_results.dta, clear
* re-sort to get alphabetical
gen sort2 = sort
replace sort = 1 if sort2 == 1 // social protect
replace sort = 2 if sort2 == 2 // relig/culture
replace sort = 3 if sort2 == 8 // housing
replace sort = 4 if sort2 == 3 // health
replace sort = 5 if sort2 == 7 // govt admin
replace sort = 6 if sort2 == 4 // education
replace sort = 7 if sort2 == 5 // econ affairs
replace sort = 8 if sort2 == 6 // defense
sort sort
drop sort_sr sort_lr
gen sort_sr = sort + .2
gen sort_lr = sort - .2
$effectsplot xlabel(-4 (1) 4)
*graph export "final-figures/chapter 4/Ch4_expenditures_openness_x_left_majority_effectsplot.pdf", as(pdf) replace
restore 
* --------------------------------------------------------------------------





* --------------------------------------------------------------------------
*		Figure 4.9b
* --------------------------------------------------------------------------
* +1 SD shock to openness under right-majority govt
matrix smat = J(100,29,.) // t=100, k = 29
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt" "lmajoritygovt" "right_maj" "lright_maj" "dopenness_r" "ldopenness_r" "dopenness_maj" "ldopenness_maj" "dopenness_r_maj" "ldopenness_r_maj" "deficit_gdp" "ldeficit_gdp" "year" "total_hostlev" "ltotal_hostlev"  
local r = rowsof(smat)

* GDP growth and l.GDP growth : mean
su growth if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',1] = r(mean)
	mat smat[`i',2] = r(mean)
}
* d.Unemployment and L.Unemployment: 0 and mean, respectively
su lunemployment if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',3] = 0
	mat smat[`i',4] = r(mean)
}
* d.openness : mean + 1sd at t = 55
su dopenness if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',5] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',5] = r(mean) 
	}
}
* ld.openness : mean + 1sd at t = 56
su dopenness if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',6] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',6] = r(mean) 
	}
}
* d.SOP expenditures and L.SOP : 0 and mean, respectively
su lsop_exp_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',7] = 0
	mat smat[`i',8] = r(mean)
}
* ADR and lADR: mean 
su ADR_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',9] =r(mean)
	mat smat[`i',10] =r(mean)
}
* Election Year and l.election: 0
forv i = 1/`r' {
	mat smat[`i',11] = 0
	mat smat[`i',12] = 0
}
* Right and l.right: 1 
forv i = 1/`r' {
	mat smat[`i',13] = 1
	mat smat[`i',14] = 1
}
* Majority Govt and l.majority: 1
forv i = 1/`r' {
	mat smat[`i',15] = 1
	mat smat[`i',16] = 1
}
* Right x Maj and l.(right x majority): 1
forv i = 1/`r' {
	mat smat[`i',17] = 1
	mat smat[`i',18] = 1
}
* dopenness x right: mean + 1 SD at t = 55
su dopenness if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',19] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',19] = r(mean) 
	}
}
* l.dopenness x right: mean + 1 SD at t = 56
su dopenness if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',20] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',20] = r(mean) 
	}
}
* dopenness x majority: mean + 1 SD at t = 55
su dopenness if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',21] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',21] = r(mean) 
	}
}
* l.dopenness x majority: mean + 1 SD at t = 55
su dopenness if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',22] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',22] = r(mean) 
	}
}
* dopenness x right x majority: mean + 1 SD at t = 55
su dopenness if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',23] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',23] = r(mean) 
	}
}
* l.dopenness x right x majority: mean + 1 SD at t = 55
su dopenness if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',24] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',24] = r(mean) 
	}
}
* deficit and L.deficit: mean 
su deficit_gdp if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',25] = r(mean)
	mat smat[`i',26] = r(mean)
}
* Year trend; keep at 1995
forv i = 1/`r' {
	mat smat[`i',27] = 1995
}
* hostility and l.hostility: mean throughout
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',28] = r(mean)
	mat smat[`i',29] = r(mean)
}

mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj dopenness_r ldopenness_r dopenness_maj ldopenness_maj dopenness_r_maj ldopenness_r_maj deficit_gdp ldeficit_gdp year total_hostlev ltotal_hostlev , shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
preserve
use dynsimpie_results.dta, clear
* re-sort to get alphabetical
gen sort2 = sort
replace sort = 1 if sort2 == 1 // social protect
replace sort = 2 if sort2 == 2 // relig/culture
replace sort = 3 if sort2 == 8 // housing
replace sort = 4 if sort2 == 3 // health
replace sort = 5 if sort2 == 7 // govt admin
replace sort = 6 if sort2 == 4 // education
replace sort = 7 if sort2 == 5 // econ affairs
replace sort = 8 if sort2 == 6 // defense
sort sort
drop sort_sr sort_lr
gen sort_sr = sort + .2
gen sort_lr = sort - .2
$effectsplot xlabel(-4 (1) 4)
*graph export "final-figures/chapter 4/Ch4_expenditures_openness_x_right_majority_effectsplot.pdf", as(pdf) replace
restore 
* --------------------------------------------------------------------------



* --------------------------------------------------------------------------
*		Figure 4.10a
* --------------------------------------------------------------------------
* +1 SD shock to hostility under left-majority govt
matrix smat = J(100,29,.) // t=100, k = 29
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt" "lmajoritygovt" "right_maj" "lright_maj" "total_hostlev_r" "ltotal_hostlev_r" "total_hostlev_maj" "ltotal_hostlev_maj" "total_hostlev_r_maj" "ltotal_hostlev_r_maj" "deficit_gdp" "ldeficit_gdp" "year" "total_hostlev" "ltotal_hostlev"  
local r = rowsof(smat)

* GDP growth and l.GDP growth:  mean
su growth if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',1] =r(mean)
	mat smat[`i',2] =r(mean)
}
* d.Unemployment and L.Unemployment: 0 and mean, respectively
su lunemployment if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',3] = 0
	mat smat[`i',4] = r(mean)
}
* d.openness and ld.openness: mean
su dopenness if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',5] =r(mean)
	mat smat[`i',6] =r(mean)
}
* d.SOP expenditures and l.SOP expenditures: 0 and mean, respectively
su lsop_exp_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',7] = 0
	mat smat[`i',8] =r(mean) 	
}
* ADR and lADR: mean 
su ADR_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',9] =r(mean)
	mat smat[`i',10] =r(mean)
}
* Election Year and l.election: 0
forv i = 1/`r' {
	mat smat[`i',11] = 0
	mat smat[`i',12] = 0
}
* Right and l.right: 0 
forv i = 1/`r' {
	mat smat[`i',13] = 0
	mat smat[`i',14] = 0
}
* Majority Govt and l.majority: 1
forv i = 1/`r' {
	mat smat[`i',15] = 1
	mat smat[`i',16] = 1
}
* Right x Maj and l.(right x majority): 0
forv i = 1/`r' {
	mat smat[`i',17] = 0
	mat smat[`i',18] = 0
}
* hostility x right: 0
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',19] = 0
}
* l.total_hostlev x right: 0
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',20] = 0
}
* total_hostlev x majority: mean + 1 SD at t = 55
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',21] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',21] = r(mean) 
	}
}
* l.total_hostlev x majority: mean + 1 SD at t = 55
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',22] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',22] = r(mean) 
	}
}
* total_hostlev x right x majority: 0
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',23] = 0
}
* l.total_hostlev x right x majority: 0
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',24] = 0
}
* deficit and l.deficit: mean
su deficit_gdp if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',25] = r(mean)
	mat smat[`i',26] = r(mean)
}
* Year trend; keep at 1995
forv i = 1/`r' {
	mat smat[`i',27] = 1995
}
* hostility: mean + 1 SD at t = 55
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {	
	if `i' >= 55 {
		mat smat[`i',28] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',28] = r(mean) 
	}
}
* l.hostility: mean + 1 SD at t = 56
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {	
	if `i' >= 56 {
		mat smat[`i',29] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',29] = r(mean) 
	}
}

mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev_r ltotal_hostlev_r total_hostlev_maj ltotal_hostlev_maj total_hostlev_r_maj ltotal_hostlev_r_maj deficit_gdp ldeficit_gdp year total_hostlev ltotal_hostlev , shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
preserve
use dynsimpie_results.dta, clear
* re-sort to get alphabetical
gen sort2 = sort
replace sort = 1 if sort2 == 1 // social protect
replace sort = 2 if sort2 == 2 // relig/culture
replace sort = 3 if sort2 == 8 // housing
replace sort = 4 if sort2 == 3 // health
replace sort = 5 if sort2 == 7 // govt admin
replace sort = 6 if sort2 == 4 // education
replace sort = 7 if sort2 == 5 // econ affairs
replace sort = 8 if sort2 == 6 // defense
sort sort
drop sort_sr sort_lr
gen sort_sr = sort + .2
gen sort_lr = sort - .2
$effectsplot xlabel(-4 (2) 4)
*graph export "final-figures/chapter 4/Ch4_expenditures_hostility_x_left_majority_effectsplot.pdf", as(pdf) replace
restore 
* --------------------------------------------------------------------------




* --------------------------------------------------------------------------
*		Figure 4.10b
* --------------------------------------------------------------------------
* +1 SD shock to hostility under right-majority govt
matrix smat = J(100,29,.) // t=100, k = 29
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt" "lmajoritygovt" "right_maj" "lright_maj" "total_hostlev_r" "ltotal_hostlev_r" "total_hostlev_maj" "ltotal_hostlev_maj" "total_hostlev_r_maj" "ltotal_hostlev_r_maj" "deficit_gdp" "ldeficit_gdp" "year" "total_hostlev" "ltotal_hostlev"  
local r = rowsof(smat)

* GDP growth and l.GDP growth:  mean
su growth if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',1] =r(mean)
	mat smat[`i',2] =r(mean)
}
* d.Unemployment and L.Unemployment: 0 and mean, respectively
su lunemployment if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',3] = 0
	mat smat[`i',4] = r(mean)
}
* d.openness and ld.openness: mean
su dopenness if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',5] =r(mean)
	mat smat[`i',6] =r(mean)
}
* d.SOP expenditures and l.SOP expenditures: 0 and mean, respectively
su lsop_exp_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',7] = 0
	mat smat[`i',8] =r(mean) 	
}
* ADR and lADR: mean 
su ADR_nov18 if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',9] =r(mean)
	mat smat[`i',10] =r(mean)
}
* Election Year and l.election: 0
forv i = 1/`r' {
	mat smat[`i',11] = 0
	mat smat[`i',12] = 0
}
* Right and l.right: 1 
forv i = 1/`r' {
	mat smat[`i',13] = 1
	mat smat[`i',14] = 1
}
* Majority Govt and l.majority: 1
forv i = 1/`r' {
	mat smat[`i',15] = 1
	mat smat[`i',16] = 1
}
* Right x Maj and l.(right x majority): 1
forv i = 1/`r' {
	mat smat[`i',17] = 1
	mat smat[`i',18] = 1
}
* hostility x right: mean + 1 SD at t = 55
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',19] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',19] = r(mean) 
	}
}
* l.total_hostlev x right: mean + 1 SD at t = 56
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',20] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',20] = r(mean) 
	}
}
* total_hostlev x majority: mean + 1 SD at t = 55
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',21] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',21] = r(mean) 
	}
}
* l.total_hostlev x majority: mean + 1 SD at t = 55
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',22] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',22] = r(mean) 
	}
}
* total_hostlev x right x majority: mean + 1 SD at t = 55
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',23] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',23] = r(mean) 
	}
}
* l.total_hostlev x right x majority: mean + 1 SD at t = 55
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',24] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',24] = r(mean) 
	}
}
* deficit and l.deficit: mean
su deficit_gdp if tabbb == 1
forv i = 1/`r' {
	mat smat[`i',25] = r(mean)
	mat smat[`i',26] = r(mean)
}
* Year trend; keep at 1995
forv i = 1/`r' {
	mat smat[`i',27] = 1995
}
* hostility: mean + 1 SD at t = 55
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {	
	if `i' >= 55 {
		mat smat[`i',28] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',28] = r(mean) 
	}
}
* l.hostility: mean + 1 SD at t = 56
su ltotal_hostlev if tabbb == 1
forv i = 1/`r' {	
	if `i' >= 56 {
		mat smat[`i',29] =r(mean) + r(sd)
	} 
	else {
		mat smat[`i',29] = r(mean) 
	}
}

mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev_r ltotal_hostlev_r total_hostlev_maj ltotal_hostlev_maj total_hostlev_r_maj ltotal_hostlev_r_maj deficit_gdp ldeficit_gdp year total_hostlev ltotal_hostlev , shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
preserve
use dynsimpie_results.dta, clear
* re-sort to get alphabetical
gen sort2 = sort
replace sort = 1 if sort2 == 1 // social protect
replace sort = 2 if sort2 == 2 // relig/culture
replace sort = 3 if sort2 == 8 // housing
replace sort = 4 if sort2 == 3 // health
replace sort = 5 if sort2 == 7 // govt admin
replace sort = 6 if sort2 == 4 // education
replace sort = 7 if sort2 == 5 // econ affairs
replace sort = 8 if sort2 == 6 // defense
sort sort
drop sort_sr sort_lr
gen sort_sr = sort + .2
gen sort_lr = sort - .2
$effectsplot xlabel(-4 (2) 4)
*graph export "final-figures/chapter 4/Ch4_expenditures_hostility_x_right_majority_effectsplot.pdf", as(pdf) replace
restore 
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*			Figure 4.11
* --------------------------------------------------------------------------
set seed 29202094
matrix smat = J(100,21,.) // t=100, k = 21
matrix colnames smat = "growth" "lgrowth" "dunemployment"  "lunemployment" "dopenness" "ldopenness" "deficit_gdp" "ldeficit_gdp" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right"  "lright" "majoritygovt"  "lmajoritygovt" "total_hostlev"  "ltotal_hostlev" "year" 
  
local r = rowsof(smat)

* GDP growth and L.GDP growth: means
su growth if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',1] = r(mean)
	mat smat[`i',2] = r(mean)
}
* d.Unemployment and L.Unemployment: 0 and mean, respectively
su lunemployment if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',3] = 0
	mat smat[`i',4] = r(mean)
}
* d.Openness and dL.openness: mean
su dopenness if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',5] = r(mean)
	mat smat[`i',6] = r(mean)
}
* Deficit and L.deficit: mean
su deficit_gdp if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',7] = r(mean)
	mat smat[`i',8] = r(mean)
}
* d.SOP expenditures and L.SOP: 0 and mean, respectively
su lsop_exp_nov18 if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',9] = 0
	mat smat[`i',10] = r(mean)
}
* ADR and L.ADR: mean
su ADR_nov18 if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',11] = r(mean)
	mat smat[`i',12] = r(mean)
}
* Election Year and L.election year: 
forv i = 1/`r' {
	if `i' == 55 {
		mat smat[`i',13] = 1
	}
	else {
		mat smat[`i',13] = 0
	}
	if `i' == 56 {
		mat smat[`i',14] = 1
	}
	else {
		mat smat[`i',14] = 0
	}
}
* Right and l.Right: 1 
forv i = 1/`r' {
	mat smat[`i',15] = 1
	mat smat[`i',16] = 1	
}
* Majority Govt and L.majority: 1
forv i = 1/`r' {
	mat smat[`i',17] = 1
	mat smat[`i',18] = 1
}
* total_hostlev and L.hostlev: mean
su total_hostlev if tabbb == 1, meanonly
forv i = 1/`r' {
	mat smat[`i',19] = r(mean)
	mat smat[`i',20] = r(mean)
}
* Year trend; keep at 1995
forv i = 1/`r' {
	mat smat[`i',21] = 1995
}

mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt total_hostlev ltotal_hostlev year, shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
preserve
use dynsimpie_results.dta, clear
$effectsplot xlabel(-01 (.5) 1.5)
*graph export "Ch3_expenditures_election-nointeraction_effectsplot.pdf", as(pdf) replace
restore 
* --------------------------------------------------------------------------

