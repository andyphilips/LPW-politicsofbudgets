* Chapter 3:
*
*
* 3/22/23
* -----------------------------------------------------------------------------
set scheme burd
set more off
set seed 29202094

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

* set global plot options
global effectsplot "twoway rspike var_pie_ul_sr_ var_pie_ll_sr sort_sr, horizontal lcolor(black) lwidth(medthin) || rspike var_pie_ul_lr_ var_pie_ll_lr_ sort_lr, horizontal lcolor(black) lwidth(medthin) || rspike var_pie_ul90_sr_ var_pie_ll90_sr sort_sr, horizontal lcolor(black) lwidth(medthick) || rspike var_pie_ul90_lr_ var_pie_ll90_lr_ sort_lr, horizontal lcolor(black) lwidth(medthick) || scatter  sort_sr mid_sr, msymbol(T) mcolor("27 158 119") msize(medlarge) || scatter sort_lr mid_lr, msymbol(O) mcolor("117 112 179") msize(medlarge) xline(0, lcolor(black) lstyle(solid))  yscale(axis(1) noline) xlabel(, grid glcolor(gs15)) plotregion(style(none)) legend(order(5 "Short-Run" 6 "Long-Run") ) xtitle("Predicted Change from Baseline")  ylabel(1 "Social Protection" 2 "Religion & Culture" 3 "Housing" 4 "Health" 5 "Govt. Administration" 6 "Education" 7 "Econ. Affairs" 8 "Defense")"

* set global DVs
global dvs "socialp_house recr_house health_house edu_house econaff_house defense_house pubserv_house" 

* get variable == 1 for all other IVs not missing:
gen tabbb = 1
foreach var of varlist $dvs growth dSOP dunemployment dopenness ADR_nov18 deficit_gdp sop_exp_nov18 majoritygovt right legelec total_hostlev unemployment {
	replace tabbb = 0 if `var' == .
}


* --------------------------------------------------------------------------
** Fig 3.1
* --------------------------------------------------------------------------
twoway connected i_publicservices_comb_pie year if CountryName == "United Kingdom" & tabbb==1, lpattern(solid) msymbol(T) msize(small) lwidth(medthin) || ///
	connected i_defense_comb_pie year if CountryName == "United Kingdom" & tabbb==1, lpattern(dash) msymbol(none) msize(small) lwidth(medthin) || ///
	connected i_econaffairs_comb_pie year if CountryName == "United Kingdom" & tabbb==1, lpattern(solid) msymbol(none)  msize(small) lwidth(medthin) || ///
	connected i_education_comb_pie year if CountryName == "United Kingdom" & tabbb==1, lpattern(dash_dot) msymbol(none)  msize(small) lwidth(medthin) || ///
	connected i_health_comb_pie year if CountryName == "United Kingdom" & tabbb==1, lpattern(shortdash) msymbol(none)  msize(small) lwidth(medthin) || ///
	connected i_recreation_comb_pie year if CountryName == "United Kingdom" & tabbb==1, lpattern(shortdash_dot) msymbol(none)  msize(small) lwidth(tabbb) || ///
	connected i_socialprotection_comb_pie year if CountryName == "United Kingdom" & tabbb==1, lpattern(solid) msymbol(S)  msize(small) lwidth(medthin) || ///
	connected i_housing_comb_pie year if CountryName == "United Kingdom" & tabbb==1, msymbol(longdash_dot) msize(small) lwidth(medthin) xlabel(1975(5)2010, labsize(small)) legend(symxsize(*1.5) position(12) cols(4) size(small) order(1 "Govt. Administration" 2 "Defense" 3 "Economic Affairs" 4 "Education" 5 "Health" 6 "Religion & Culture" 7 "Social Protection" 8 "Housing")) xtitle("  ")  ///
	ytitle("Budget Percentage", size(small) orientation(vertical)) 
* --------------------------------------------------------------------------




* --------------------------------------------------------------------------
*	Figure 3.4a -------------------------------------------
* --------------------------------------------------------------------------
*	t=1/50 -> burnin (dropped)
*	t = 51 -> stable base time predictions
*	t = 55 -> shock
*	t = 71 -> end of change-from baseline window
*   t = 100 -> approx. LR stable predictions
* --------------------------------------------------------------------------
xtset imf year

* --------------------------------------------------------------------------
* --------------------------------------------------------------------------
* Moving from Left majority to right majority
* Involves interacting ideology*maj govt.
matrix smat = J(100,23,.) // t=100, k = 23
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "deficit_gdp" "ldeficit_gdp" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt"  "lmajoritygovt" "right_maj" "lright_maj" "total_hostlev" "ltotal_hostlev" "year" 
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
	mat smat[`i',13] = 0
	mat smat[`i',14] = 0
}
* Right : 0 -> 1 at t = 55
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',15] = 1
	}
	else {
		mat smat[`i',15] = 0
	}
}
* L.Right : 0 -> 1 at t = 56
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',16] = 1
	}
	else {
		mat smat[`i',16] = 0
	}
}
* Majority Govt and L.majority: 1
forv i = 1/`r' {
	mat smat[`i',17] = 1
	mat smat[`i',18] = 1
}
* Right x Maj : 0 -> 1 at t = 55
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',19] = 1
	}
	else {
		mat smat[`i',19] = 0
	}
}
* L.Right x Maj : 0 -> 1 at t = 56
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',20] = 1
	}
	else {
		mat smat[`i',20] = 0
	}
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
mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year, shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
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
$effectsplot xlabel(-6 (2) 6)
*graph export "final-figures/chapter 3/Ch3_expenditures_left_to_right_majority_effectsplot.pdf", as(pdf) replace
restore 
* ----------------------------------------------


* --------------------------------------------------------------------------
*	Figure 3.4b -------------------------------------------
* --------------------------------------------------------------------------
* Moving from Right majority to Left majority
* Involves interacting ideology*maj govt.
matrix smat = J(100,23,.) // t=100, k = 23
matrix colnames smat = "growth" "lgrowth" "dunemployment"  "lunemployment" "dopenness" "ldopenness" "deficit_gdp" "ldeficit_gdp" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right"  "lright" "majoritygovt"  "lmajoritygovt" "right_maj" "lright_maj" "total_hostlev"  "ltotal_hostlev" "year" 
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
	mat smat[`i',13] = 0
	mat smat[`i',14] = 0
}
* Right : 1 -> 0 at t = 55
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',15] = 0
	}
	else {
		mat smat[`i',15] = 1
	}
}
* L.Right : 1 -> 0 at t = 56
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',16] = 0
	}
	else {
		mat smat[`i',16] = 1
	}
}
* Majority Govt and L.majority: 1
forv i = 1/`r' {
	mat smat[`i',17] = 1
	mat smat[`i',18] = 1
}
* Right x Maj : 1 -> 0 at t = 55
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',19] = 0
	}
	else {
		mat smat[`i',19] = 1
	}
}
* L.Right x Maj : 1 -> 0 at t = 56
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',20] = 0
	}
	else {
		mat smat[`i',20] = 1
	}
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
mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year, shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
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
$effectsplot xlabel(-6 (2) 6)
*graph export "final-figures/chapter 3/Ch3_expenditures_right_to_left_majority_effectsplot.pdf", as(pdf) replace
restore 
* ----------------------------------------------


* --------------------------------------------------------------------------
* Fig 3.5b (note that 3.5a is same as 3.4a)
* --------------------------------------------------------------------------
* Moving from Left minority to right minority
* Involves interacting ideology*maj govt.
matrix smat = J(100,23,.) // t=100, k = 23
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "deficit_gdp" "ldeficit_gdp" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt"  "lmajoritygovt" "right_maj" "lright_maj" "total_hostlev" "ltotal_hostlev" "year"   
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
	mat smat[`i',13] = 0
	mat smat[`i',14] = 0
}
* Right : 0 -> 1 at t = 55
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',15] = 1
	}
	else {
		mat smat[`i',15] = 0
	}
}
* L.Right : 0 -> 1 at t = 56
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',16] = 1
	}
	else {
		mat smat[`i',16] = 0
	}
}
* Majority Govt and L.majority: 0
forv i = 1/`r' {
	mat smat[`i',17] = 0
	mat smat[`i',18] = 0
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
mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year, shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
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
$effectsplot xlabel(-6 (2) 6)
*graph export "final-figures/chapter 3/Ch3_expenditures_left_to_right_minority_effectsplot.pdf", as(pdf) replace
restore 
* ----------------------------------------------


* --------------------------------------------------------------------------
* Figure 3.6b (note that Fig 3.6a is the same as 3.4b)
* --------------------------------------------------------------------------
* Moving from Right minority to Left minority
* Involves interacting ideology*maj govt.
matrix smat = J(100,23,.) // t=100, k = 23
matrix colnames smat = "growth" "lgrowth" "dunemployment" "lunemployment" "dopenness" "ldopenness" "deficit_gdp" "ldeficit_gdp" "dSOP" "lsop_exp_nov18" "ADR_nov18" "lADR_nov18" "legelec" "llegelec" "right" "lright" "majoritygovt"  "lmajoritygovt" "right_maj" "lright_maj" "total_hostlev" "ltotal_hostlev" "year" 
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
	mat smat[`i',13] = 0
	mat smat[`i',14] = 0
}
* Right : 1 -> 0 at t = 55
forv i = 1/`r' {
	if `i' >= 55 {
		mat smat[`i',15] = 0
	}
	else {
		mat smat[`i',15] = 1
	}
}
* L.Right : 1 -> 0 at t = 56
forv i = 1/`r' {
	if `i' >= 56 {
		mat smat[`i',16] = 0
	}
	else {
		mat smat[`i',16] = 1
	}
}
* Majority Govt and L.majority: 0
forv i = 1/`r' {
	mat smat[`i',17] = 0
	mat smat[`i',18] = 0
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
mat list smat

preserve
clear
svmat smat, names(col)
saveold "savedshocks.dta", replace version(11)
restore 

* Run program: -> effectplot
dspcstsldvany growth lgrowth dunemployment lunemployment dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year, shockdta(savedshocks) dvs($dvs) id(imf) basetime(51) shocktime(55) endtime(100) ladderplot
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
$effectsplot xlabel(-6 (2) 6)
*graph export "final-figures/chapter 3/Ch3_expenditures_right_to_left_minority_effectsplot.pdf", as(pdf) replace
restore 
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
* Table 3.2: Panel Unit Root tests: Dependent variables
* --------------------------------------------------------------------------
* Column 1: 1 lag, no trends
xtunitroot ips pubserv_house if tabbb == 1, lags(1)
xtunitroot ips defense_house if tabbb == 1, lags(1) 
xtunitroot ips econaff_house if tabbb == 1, lags(1) 
xtunitroot ips edu_house if tabbb == 1, lags(1)
xtunitroot ips health_house if tabbb == 1, lags(1) 
xtunitroot ips recr_house if tabbb == 1, lags(1) 
xtunitroot ips socialp_house if tabbb == 1, lags(1)

xtunitroot fisher pubserv_house if tabbb == 1, dfuller  lags(1)  
xtunitroot fisher defense_house if tabbb == 1,  dfuller  lags(1) 
xtunitroot fisher econaff_house if tabbb == 1,  dfuller  lags(1) 
xtunitroot fisher edu_house if tabbb == 1,  dfuller  lags(1)
xtunitroot fisher health_house if tabbb == 1,  dfuller  lags(1) 
xtunitroot fisher recr_house if tabbb == 1,  dfuller  lags(1) 
xtunitroot fisher socialp_house if tabbb == 1,  dfuller  lags(1)

xtunitroot fisher pubserv_house if tabbb == 1, pperron  lags(1)
xtunitroot fisher defense_house if tabbb == 1,  pperron  lags(1) 
xtunitroot fisher econaff_house if tabbb == 1,  pperron  lags(1) 
xtunitroot fisher edu_house if tabbb == 1,  pperron  lags(1)
xtunitroot fisher health_house if tabbb == 1,  pperron  lags(1) 
xtunitroot fisher recr_house if tabbb == 1,  pperron  lags(1) 
xtunitroot fisher socialp_house if tabbb == 1,  pperron  lags(1)

* Column 2: 2 lag, no trends
xtunitroot ips pubserv_house if tabbb == 1, lags(2)
xtunitroot ips defense_house if tabbb == 1, lags(2) 
xtunitroot ips econaff_house if tabbb == 1, lags(2) 
xtunitroot ips edu_house if tabbb == 1, lags(2)
xtunitroot ips health_house if tabbb == 1, lags(2) 
xtunitroot ips recr_house if tabbb == 1, lags(2) 
xtunitroot ips socialp_house if tabbb == 1, lags(2)

xtunitroot fisher pubserv_house if tabbb == 1, dfuller  lags(2)  
xtunitroot fisher defense_house if tabbb == 1,  dfuller  lags(2) 
xtunitroot fisher econaff_house if tabbb == 1,  dfuller  lags(2) 
xtunitroot fisher edu_house if tabbb == 1,  dfuller  lags(2)
xtunitroot fisher health_house if tabbb == 1,  dfuller  lags(2) 
xtunitroot fisher recr_house if tabbb == 1,  dfuller  lags(2) 
xtunitroot fisher socialp_house if tabbb == 1,  dfuller  lags(2)

xtunitroot fisher pubserv_house if tabbb == 1, pperron  lags(2)
xtunitroot fisher defense_house if tabbb == 1,  pperron  lags(2) 
xtunitroot fisher econaff_house if tabbb == 1,  pperron  lags(2) 
xtunitroot fisher edu_house if tabbb == 1,  pperron  lags(2)
xtunitroot fisher health_house if tabbb == 1,  pperron  lags(2) 
xtunitroot fisher recr_house if tabbb == 1,  pperron  lags(2) 
xtunitroot fisher socialp_house if tabbb == 1,  pperron  lags(2)

* Column 3: 3 lag, no trends
/* is NA
xtunitroot ips pubserv_house if tabbb == 1, lags(3)
xtunitroot ips defense_house if tabbb == 1, lags(3) 
xtunitroot ips econaff_house if tabbb == 1, lags(3) 
xtunitroot ips edu_house if tabbb == 1, lags(3)
xtunitroot ips health_house if tabbb == 1, lags(3) 
xtunitroot ips recr_house if tabbb == 1, lags(3) 
xtunitroot ips socialp_house if tabbb == 1, lags(3)
*/

xtunitroot fisher pubserv_house if tabbb == 1, dfuller  lags(3)  
xtunitroot fisher defense_house if tabbb == 1,  dfuller  lags(3) 
xtunitroot fisher econaff_house if tabbb == 1,  dfuller  lags(3) 
xtunitroot fisher edu_house if tabbb == 1,  dfuller  lags(3)
xtunitroot fisher health_house if tabbb == 1,  dfuller  lags(3) 
xtunitroot fisher recr_house if tabbb == 1,  dfuller  lags(3) 
xtunitroot fisher socialp_house if tabbb == 1,  dfuller  lags(3)

xtunitroot fisher pubserv_house if tabbb == 1, pperron  lags(3)
xtunitroot fisher defense_house if tabbb == 1,  pperron  lags(3) 
xtunitroot fisher econaff_house if tabbb == 1,  pperron  lags(3) 
xtunitroot fisher edu_house if tabbb == 1,  pperron  lags(3)
xtunitroot fisher health_house if tabbb == 1,  pperron  lags(3) 
xtunitroot fisher recr_house if tabbb == 1,  pperron  lags(3) 
xtunitroot fisher socialp_house if tabbb == 1,  pperron  lags(3)

* Column 4: 1 lag, w trend
xtunitroot ips pubserv_house if tabbb == 1, lags(1) trend
xtunitroot ips defense_house if tabbb == 1, lags(1) trend
xtunitroot ips econaff_house if tabbb == 1, lags(1) trend
xtunitroot ips edu_house if tabbb == 1, lags(1) trend
xtunitroot ips health_house if tabbb == 1, lags(1) trend
xtunitroot ips recr_house if tabbb == 1, lags(1) trend 
xtunitroot ips socialp_house if tabbb == 1, lags(1) trend

xtunitroot fisher pubserv_house if tabbb == 1, dfuller  lags(1)  trend
xtunitroot fisher defense_house if tabbb == 1,  dfuller  lags(1) trend
xtunitroot fisher econaff_house if tabbb == 1,  dfuller  lags(1) trend
xtunitroot fisher edu_house if tabbb == 1,  dfuller  lags(1) trend
xtunitroot fisher health_house if tabbb == 1,  dfuller  lags(1) trend
xtunitroot fisher recr_house if tabbb == 1,  dfuller  lags(1) trend
xtunitroot fisher socialp_house if tabbb == 1,  dfuller  lags(1) trend

xtunitroot fisher pubserv_house if tabbb == 1, pperron  lags(1) trend
xtunitroot fisher defense_house if tabbb == 1,  pperron  lags(1) trend
xtunitroot fisher econaff_house if tabbb == 1,  pperron  lags(1) trend
xtunitroot fisher edu_house if tabbb == 1,  pperron  lags(1) trend
xtunitroot fisher health_house if tabbb == 1,  pperron  lags(1) trend
xtunitroot fisher recr_house if tabbb == 1,  pperron  lags(1) trend
xtunitroot fisher socialp_house if tabbb == 1,  pperron  lags(1) trend

* Column 5: 2 lag, w trend
xtunitroot ips pubserv_house if tabbb == 1, lags(2) trend
xtunitroot ips defense_house if tabbb == 1, lags(2) trend
xtunitroot ips econaff_house if tabbb == 1, lags(2) trend
xtunitroot ips edu_house if tabbb == 1, lags(2) trend
xtunitroot ips health_house if tabbb == 1, lags(2) trend
xtunitroot ips recr_house if tabbb == 1, lags(2) trend
xtunitroot ips socialp_house if tabbb == 1, lags(2) trend

xtunitroot fisher pubserv_house if tabbb == 1, dfuller  lags(2)  trend
xtunitroot fisher defense_house if tabbb == 1,  dfuller  lags(2)  trend
xtunitroot fisher econaff_house if tabbb == 1,  dfuller  lags(2)  trend
xtunitroot fisher edu_house if tabbb == 1,  dfuller  lags(2) trend
xtunitroot fisher health_house if tabbb == 1,  dfuller  lags(2)  trend
xtunitroot fisher recr_house if tabbb == 1,  dfuller  lags(2)  trend
xtunitroot fisher socialp_house if tabbb == 1,  dfuller  lags(2) trend

xtunitroot fisher pubserv_house if tabbb == 1, pperron  lags(2) trend
xtunitroot fisher defense_house if tabbb == 1,  pperron  lags(2)  trend
xtunitroot fisher econaff_house if tabbb == 1,  pperron  lags(2) trend
xtunitroot fisher edu_house if tabbb == 1,  pperron  lags(2) trend
xtunitroot fisher health_house if tabbb == 1,  pperron  lags(2) trend
xtunitroot fisher recr_house if tabbb == 1,  pperron  lags(2) trend
xtunitroot fisher socialp_house if tabbb == 1,  pperron  lags(2) trend

* Column 6: 3 lag, no trends
/* is NA
xtunitroot ips pubserv_house if tabbb == 1, lags(3) trend
xtunitroot ips defense_house if tabbb == 1, lags(3) trend
xtunitroot ips econaff_house if tabbb == 1, lags(3) trend
xtunitroot ips edu_house if tabbb == 1, lags(3) trend
xtunitroot ips health_house if tabbb == 1, lags(3) trend
xtunitroot ips recr_house if tabbb == 1, lags(3) trend
xtunitroot ips socialp_house if tabbb == 1, lags(3) trend
*/

xtunitroot fisher pubserv_house if tabbb == 1, dfuller  lags(3)   trend
xtunitroot fisher defense_house if tabbb == 1,  dfuller  lags(3) trend
xtunitroot fisher econaff_house if tabbb == 1,  dfuller  lags(3) trend
xtunitroot fisher edu_house if tabbb == 1,  dfuller  lags(3) trend
xtunitroot fisher health_house if tabbb == 1,  dfuller  lags(3) trend
xtunitroot fisher recr_house if tabbb == 1,  dfuller  lags(3) trend
xtunitroot fisher socialp_house if tabbb == 1,  dfuller  lags(3) trend

xtunitroot fisher pubserv_house if tabbb == 1, pperron  lags(3) trend
xtunitroot fisher defense_house if tabbb == 1,  pperron  lags(3) trend
xtunitroot fisher econaff_house if tabbb == 1,  pperron  lags(3) trend
xtunitroot fisher edu_house if tabbb == 1,  pperron  lags(3) trend
xtunitroot fisher health_house if tabbb == 1,  pperron  lags(3) trend
xtunitroot fisher recr_house if tabbb == 1,  pperron  lags(3) trend
xtunitroot fisher socialp_house if tabbb == 1,  pperron  lags(3) trend

* --------------------------------------------------------------------------



* --------------------------------------------------------------------------
* Table 3.3: Panel Unit Root tests: Independent variables
* --------------------------------------------------------------------------
* Row 1
xtunitroot fisher growth if tabbb == 1, dfuller lags(1)  
xtunitroot fisher growth if tabbb == 1, dfuller lags(2)  
xtunitroot fisher growth if tabbb == 1, dfuller lags(3) 

xtunitroot fisher growth if tabbb == 1, pperron lags(1)  
xtunitroot fisher growth if tabbb == 1, pperron lags(2)  
xtunitroot fisher growth if tabbb == 1, pperron lags(3)

xtunitroot fisher growth if tabbb == 1, dfuller lags(1) trend
xtunitroot fisher growth if tabbb == 1, dfuller lags(2) trend
xtunitroot fisher growth if tabbb == 1, dfuller lags(3) trend

xtunitroot fisher growth if tabbb == 1, pperron lags(1) trend 
xtunitroot fisher growth if tabbb == 1, pperron lags(2) trend
xtunitroot fisher growth if tabbb == 1, pperron lags(3) trend

* Row 2
xtunitroot fisher dunemployment if tabbb == 1, dfuller lags(1)  
xtunitroot fisher dunemployment if tabbb == 1, dfuller lags(2)  
xtunitroot fisher dunemployment if tabbb == 1, dfuller lags(3) 

xtunitroot fisher dunemployment if tabbb == 1, pperron lags(1)  
xtunitroot fisher dunemployment if tabbb == 1, pperron lags(2)  
xtunitroot fisher dunemployment if tabbb == 1, pperron lags(3)

xtunitroot fisher dunemployment if tabbb == 1, dfuller lags(1) trend
xtunitroot fisher dunemployment if tabbb == 1, dfuller lags(2) trend
xtunitroot fisher dunemployment if tabbb == 1, dfuller lags(3) trend

xtunitroot fisher dunemployment if tabbb == 1, pperron lags(1) trend 
xtunitroot fisher dunemployment if tabbb == 1, pperron lags(2) trend
xtunitroot fisher dunemployment if tabbb == 1, pperron lags(3) trend

* Row 3
xtunitroot fisher unemployment if tabbb == 1, dfuller lags(1)  
xtunitroot fisher unemployment if tabbb == 1, dfuller lags(2)  
xtunitroot fisher unemployment if tabbb == 1, dfuller lags(3) 

xtunitroot fisher unemployment if tabbb == 1, pperron lags(1)  
xtunitroot fisher unemployment if tabbb == 1, pperron lags(2)  
xtunitroot fisher unemployment if tabbb == 1, pperron lags(3)

xtunitroot fisher unemployment if tabbb == 1, dfuller lags(1) trend
xtunitroot fisher unemployment if tabbb == 1, dfuller lags(2) trend
xtunitroot fisher unemployment if tabbb == 1, dfuller lags(3) trend

xtunitroot fisher unemployment if tabbb == 1, pperron lags(1) trend 
xtunitroot fisher unemployment if tabbb == 1, pperron lags(2) trend
xtunitroot fisher unemployment if tabbb == 1, pperron lags(3) trend

* Row 4
xtunitroot fisher dopenness if tabbb == 1, dfuller lags(1)  
xtunitroot fisher dopenness if tabbb == 1, dfuller lags(2)  
xtunitroot fisher dopenness if tabbb == 1, dfuller lags(3) 

xtunitroot fisher dopenness if tabbb == 1, pperron lags(1)  
xtunitroot fisher dopenness if tabbb == 1, pperron lags(2)  
xtunitroot fisher dopenness if tabbb == 1, pperron lags(3)

xtunitroot fisher dopenness if tabbb == 1, dfuller lags(1) trend
xtunitroot fisher dopenness if tabbb == 1, dfuller lags(2) trend
xtunitroot fisher dopenness if tabbb == 1, dfuller lags(3) trend

xtunitroot fisher dopenness if tabbb == 1, pperron lags(1) trend 
xtunitroot fisher dopenness if tabbb == 1, pperron lags(2) trend
xtunitroot fisher dopenness if tabbb == 1, pperron lags(3) trend

* Row 5
xtunitroot fisher dSOP if tabbb == 1, dfuller lags(1)  
xtunitroot fisher dSOP if tabbb == 1, dfuller lags(2)  
xtunitroot fisher dSOP if tabbb == 1, dfuller lags(3) 

xtunitroot fisher dSOP if tabbb == 1, pperron lags(1)  
xtunitroot fisher dSOP if tabbb == 1, pperron lags(2)  
xtunitroot fisher dSOP if tabbb == 1, pperron lags(3)

xtunitroot fisher dSOP if tabbb == 1, dfuller lags(1) trend
xtunitroot fisher dSOP if tabbb == 1, dfuller lags(2) trend
xtunitroot fisher dSOP if tabbb == 1, dfuller lags(3) trend

xtunitroot fisher dSOP if tabbb == 1, pperron lags(1) trend 
xtunitroot fisher dSOP if tabbb == 1, pperron lags(2) trend
xtunitroot fisher dSOP if tabbb == 1, pperron lags(3) trend

* Row 6
xtunitroot fisher sop_exp_nov18 if tabbb == 1, dfuller lags(1)  
xtunitroot fisher sop_exp_nov18 if tabbb == 1, dfuller lags(2)  
xtunitroot fisher sop_exp_nov18 if tabbb == 1, dfuller lags(3) 

xtunitroot fisher sop_exp_nov18 if tabbb == 1, pperron lags(1)  
xtunitroot fisher sop_exp_nov18 if tabbb == 1, pperron lags(2)  
xtunitroot fisher sop_exp_nov18 if tabbb == 1, pperron lags(3)

xtunitroot fisher sop_exp_nov18 if tabbb == 1, dfuller lags(1) trend
xtunitroot fisher sop_exp_nov18 if tabbb == 1, dfuller lags(2) trend
xtunitroot fisher sop_exp_nov18 if tabbb == 1, dfuller lags(3) trend

xtunitroot fisher sop_exp_nov18 if tabbb == 1, pperron lags(1) trend 
xtunitroot fisher sop_exp_nov18 if tabbb == 1, pperron lags(2) trend
xtunitroot fisher sop_exp_nov18 if tabbb == 1, pperron lags(3) trend

* Row 7
xtunitroot fisher ADR_nov18 if tabbb == 1, dfuller lags(1)  
xtunitroot fisher ADR_nov18 if tabbb == 1, dfuller lags(2)  
xtunitroot fisher ADR_nov18 if tabbb == 1, dfuller lags(3) 

xtunitroot fisher ADR_nov18 if tabbb == 1, pperron lags(1)  
xtunitroot fisher ADR_nov18 if tabbb == 1, pperron lags(2)  
xtunitroot fisher ADR_nov18 if tabbb == 1, pperron lags(3)

xtunitroot fisher ADR_nov18 if tabbb == 1, dfuller lags(1) trend
xtunitroot fisher ADR_nov18 if tabbb == 1, dfuller lags(2) trend
xtunitroot fisher ADR_nov18 if tabbb == 1, dfuller lags(3) trend

xtunitroot fisher ADR_nov18 if tabbb == 1, pperron lags(1) trend 
xtunitroot fisher ADR_nov18 if tabbb == 1, pperron lags(2) trend
xtunitroot fisher ADR_nov18 if tabbb == 1, pperron lags(3) trend

* Row 8
xtunitroot fisher deficit_gdp if tabbb == 1, dfuller lags(1)  
xtunitroot fisher deficit_gdp if tabbb == 1, dfuller lags(2)  
xtunitroot fisher deficit_gdp if tabbb == 1, dfuller lags(3) 

xtunitroot fisher deficit_gdp if tabbb == 1, pperron lags(1)  
xtunitroot fisher deficit_gdp if tabbb == 1, pperron lags(2)  
xtunitroot fisher deficit_gdp if tabbb == 1, pperron lags(3)

xtunitroot fisher deficit_gdp if tabbb == 1, dfuller lags(1) trend
xtunitroot fisher deficit_gdp if tabbb == 1, dfuller lags(2) trend
xtunitroot fisher deficit_gdp if tabbb == 1, dfuller lags(3) trend

xtunitroot fisher deficit_gdp if tabbb == 1, pperron lags(1) trend 
xtunitroot fisher deficit_gdp if tabbb == 1, pperron lags(2) trend
xtunitroot fisher deficit_gdp if tabbb == 1, pperron lags(3) trend

* Row 9
xtunitroot fisher total_hostlev if tabbb == 1, dfuller lags(1)  
xtunitroot fisher total_hostlev if tabbb == 1, dfuller lags(2)  
xtunitroot fisher total_hostlev if tabbb == 1, dfuller lags(3) 

xtunitroot fisher total_hostlev if tabbb == 1, pperron lags(1)  
xtunitroot fisher total_hostlev if tabbb == 1, pperron lags(2)  
xtunitroot fisher total_hostlev if tabbb == 1, pperron lags(3)

xtunitroot fisher total_hostlev if tabbb == 1, dfuller lags(1) trend
xtunitroot fisher total_hostlev if tabbb == 1, dfuller lags(2) trend
xtunitroot fisher total_hostlev if tabbb == 1, dfuller lags(3) trend

xtunitroot fisher total_hostlev if tabbb == 1, pperron lags(1) trend 
xtunitroot fisher total_hostlev if tabbb == 1, pperron lags(2) trend
xtunitroot fisher total_hostlev if tabbb == 1, pperron lags(3) trend
* --------------------------------------------------------------------------



* --------------------------------------------------------------------------
* Table 3.4: 
* --------------------------------------------------------------------------
xtset imf year
global eq1 socialp_house l.socialp_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year
global eq2 recr_house l.recr_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year
global eq3 health_house l.health_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year
global eq4 edu_house l.edu_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year
global eq5 econaff_house l.econaff_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year
global eq6 defense_house l.defense_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year
global eq7 pubserv_house l.pubserv_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev year

* Column 1: Bias-corrected BB Q(p):
xtreg $eq1 
xtqptest, lags(1) 
xtreg $eq1, fe
xtqptest, lags(1) 

xtreg $eq2
xtqptest, lags(1) 
xtreg $eq2, fe
xtqptest, lags(1) 

xtreg $eq3
xtqptest, lags(1) 
xtreg $eq3, fe
xtqptest, lags(1) 

xtreg $eq4
xtqptest, lags(1) 
xtreg $eq4, fe
xtqptest, lags(1) 

xtreg $eq5 
xtqptest, lags(1) 
xtreg $eq5, fe
xtqptest, lags(1) 

xtreg $eq6
xtqptest, lags(1) 
xtreg $eq6, fe
xtqptest, lags(1) 

xtreg $eq7
xtqptest, lags(1) 
xtreg $eq7, fe
xtqptest, lags(1) 

* Column 2: Bias-corrected BB LM(k):
xtreg $eq1 
xtqptest, order(1) 
xtreg $eq1, fe
xtqptest, order(1) 

xtreg $eq2
xtqptest, order(1) 
xtreg $eq2, fe
xtqptest, order(1) 

xtreg $eq3
xtqptest, order(1) 
xtreg $eq3, fe
xtqptest, order(1) 

xtreg $eq4
xtqptest, order(1) 
xtreg $eq4, fe
xtqptest, order(1) 

xtreg $eq5 
xtqptest, order(1) 
xtreg $eq5, fe
xtqptest, order(1) 

xtreg $eq6
xtqptest, order(1) 
xtreg $eq6, fe
xtqptest, order(1) 

xtreg $eq7
xtqptest, order(1) 
xtreg $eq7, fe
xtqptest, order(1) 

* Column 3: Het-robust BB:
xtreg $eq1 
xthrtest 
xtreg $eq1, fe
xthrtest 

xtreg $eq2
xthrtest 
xtreg $eq2, fe
xthrtest 

xtreg $eq3
xthrtest 
xtreg $eq3, fe
xthrtest 

xtreg $eq4
xthrtest 
xtreg $eq4, fe
xthrtest 

xtreg $eq5 
xthrtest 
xtreg $eq5, fe
xthrtest 

xtreg $eq6
xthrtest 
xtreg $eq6, fe
xthrtest 

xtreg $eq7
xthrtest 
xtreg $eq7, fe
xthrtest 
* --------------------------------------------------------------------------




* --------------------------------------------------------------------------
* Table 3.5: 
* --------------------------------------------------------------------------
gen faketime = year // xtregar won't let you include the xtset time var so we'll make a trick one
global eq1 socialp_house l.socialp_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev faketime
global eq2 recr_house l.recr_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev faketime
global eq3 health_house l.health_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev faketime
global eq4 edu_house l.edu_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev faketime
global eq5 econaff_house l.econaff_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev faketime
global eq6 defense_house l.defense_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev faketime
global eq7 pubserv_house l.pubserv_house growth lgrowth dunemployment lunemployment  dopenness ldopenness deficit_gdp ldeficit_gdp dSOP lsop_exp_nov18 ADR_nov18 lADR_nov18 legelec llegelec right lright majoritygovt lmajoritygovt right_maj lright_maj total_hostlev ltotal_hostlev faketime

forv i = 1/7 {
	qui xtregar ${eq`i'}
	di "Eq `i' rho under RE:" e(rho_ar) // re
	qui xtregar ${eq`i'}, fe
	di "Eq `i' rho under FE:" e(rho_ar) // re
	di ""
}
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
* Table 3.6: 
* --------------------------------------------------------------------------
sureg 	($eq1) /*
*/		($eq2) /*
*/		($eq3) /*
*/		($eq4) /*
*/		($eq5) /*
*/		($eq6) /*
*/		($eq7)
* --------------------------------------------------------------------------



* --------------------------------------------------------------------------
* Table 3.7: 
* --------------------------------------------------------------------------
sureg 	($eq1 i.imf) /*
*/		($eq2 i.imf) /*
*/		($eq3 i.imf) /*
*/		($eq4 i.imf) /*
*/		($eq5 i.imf) /*
*/		($eq6 i.imf) /*
*/		($eq7 i.imf)
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
* Table 3.8: 
* --------------------------------------------------------------------------
xtreg $eq1 // note that SUR cannot run RE, so these are eq-by-eq results
xtreg $eq2
xtreg $eq3
xtreg $eq4
xtreg $eq5
xtreg $eq6
xtreg $eq7
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
* Table 3.9: 
* --------------------------------------------------------------------------
gen imped = 0
replace imped = 1 if CountryName == "France" & year == 1994
replace imped = 1 if CountryName == "United Kingdom" & year >=1995 & year <=1996
replace imped = 1 if CountryName == "Luxembourg" & year >=1996 & year <=1997
replace imped = 1 if CountryName == "Norway" & year >=1978 & year <=1979
replace imped = 1 if CountryName == "Greece" & year >=1978 & year <=1979
replace imped = 1 if CountryName == "Spain" & year == 1986
replace imped = 1 if CountryName == "New Zealand" & year == 2003
replace imped = 1 if CountryName == "New Zealand" & year == 2008
replace imped = 1 if CountryName == "Bulgaria" & year >=1995 & year <=1997
replace imped = 1 if CountryName == "Slovenia" & year >=1997 & year <=1998
sureg 	($eq1) /*
*/		($eq2) /*
*/		($eq3) /*
*/		($eq4) /*
*/		($eq5) /*
*/		($eq6) /*
*/		($eq7) if imped != 1
* --------------------------------------------------------------------------

