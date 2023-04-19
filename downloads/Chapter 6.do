*
*	Chapter 6
*
*	3/27/23
* --------------------------------------------------------------------------
set scheme burd
set more off
set seed 9509902

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
use "LPW_CUP.dta", clear


* --------------------------------------------------------------------------
*		Figure 6.1a
* --------------------------------------------------------------------------
reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt legelec_r legelec_maj legelec_r_maj llegelec_r llegelec_maj llegelec_r_maj right_maj lright_maj

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
loc shocksize = 1
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj' + _b[llegelec]*`shocksize' + _b[llegelec_r]*`shocksize'*`right' + _b[llegelec_maj]*`shocksize'*`maj' + _b[llegelec_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lexpense_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
loc shocksize = 1
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj' + _b[llegelec]*`shocksize' + _b[llegelec_r]*`shocksize'*`right' + _b[llegelec_maj]*`shocksize'*`maj' + _b[llegelec_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lexpense_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
loc shocksize = 1
loc scen = 3
reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[legelec]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[legelec]*`shocksize' + _b[llegelec]*`shocksize')/(1-_b[lexpense_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_expenditures_electioninteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------

* --------------------------------------------------------------------------
*		Figure 6.1b
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev right lright majoritygovt lmajoritygovt legelec_r legelec_maj legelec_r_maj llegelec_r llegelec_maj llegelec_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
loc shocksize = 1
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj' + _b[llegelec]*`shocksize' + _b[llegelec_r]*`shocksize'*`right' + _b[llegelec_maj]*`shocksize'*`maj' + _b[llegelec_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
loc shocksize = 1
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj' + _b[llegelec]*`shocksize' + _b[llegelec_r]*`shocksize'*`right' + _b[llegelec_maj]*`shocksize'*`maj' + _b[llegelec_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
loc shocksize = 1
loc right = 0
loc maj = 0
loc scen = 3
reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,

* short run
nlcom _b[legelec]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[legelec]*`shocksize' + _b[llegelec]*`shocksize')/(1-_b[lrevenue_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_revenues_electioninteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.1c
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt legelec_r legelec_maj legelec_r_maj llegelec_r llegelec_maj llegelec_r_maj right_maj lright_maj,
* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .
* scen 1: Right Maj
loc shocksize = 1
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj' + _b[llegelec]*`shocksize' + _b[llegelec_r]*`shocksize'*`right' + _b[llegelec_maj]*`shocksize'*`maj' + _b[llegelec_r_maj]*`shocksize'*`right'*`maj')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
loc shocksize = 1
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj' + _b[llegelec]*`shocksize' + _b[llegelec_r]*`shocksize'*`right' + _b[llegelec_maj]*`shocksize'*`maj' + _b[llegelec_r_maj]*`shocksize'*`right'*`maj')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
loc shocksize = 1
loc right = 0
loc maj = 0
loc scen = 3
reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[legelec]*`shocksize' 
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[legelec]*`shocksize' + _b[llegelec]*`shocksize')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_deficits_electioninteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.1d
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt legelec_r legelec_maj legelec_r_maj llegelec_r llegelec_maj llegelec_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
loc shocksize = 1
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj' + _b[llegelec]*`shocksize' + _b[llegelec_r]*`shocksize'*`right' + _b[llegelec_maj]*`shocksize'*`maj' + _b[llegelec_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lbd1yr])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
loc shocksize = 1
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[legelec]*`shocksize' + _b[legelec_r]*`shocksize'*`right' + _b[legelec_maj]*`shocksize'*`maj' + _b[legelec_r_maj]*`shocksize'*`right'*`maj' + _b[llegelec]*`shocksize' + _b[llegelec_r]*`shocksize'*`right' + _b[llegelec_maj]*`shocksize'*`maj' + _b[llegelec_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lbd1yr])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: Left min
loc shocksize = 1
loc right = 0
loc maj = 0
loc scen = 3
reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[legelec]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[legelec]*`shocksize' + _b[llegelec]*`shocksize')/(1-_b[lbd1yr])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") 
*graph export "final-figures/chapter 6/chapter6_budchange_electioninteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.2a
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt dunemployment_r dunemployment_maj dunemployment_r_maj lunemployment_r lunemployment_maj lunemployment_r_maj right_maj lright_maj,

* SR effects:
su dunemployment if e(sample)
loc shocksize = r(sd)
* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su dunemployment if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[dunemployment]*`shocksize' + _b[dunemployment_r]*`shocksize'*`right' + _b[dunemployment_maj]*`shocksize'*`maj' + _b[dunemployment_r_maj]*`shocksize'*`right'*`maj' // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[lunemployment]*`shocksize' + _b[lunemployment_r]*`shocksize'*`right' + _b[lunemployment_maj]*`shocksize'*`maj' + _b[lunemployment_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lexpense_nov18]) // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su dunemployment if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[dunemployment]*`shocksize' + _b[dunemployment_r]*`shocksize'*`right' + _b[dunemployment_maj]*`shocksize'*`maj' + _b[dunemployment_r_maj]*`shocksize'*`right'*`maj' // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[lunemployment]*`shocksize' + _b[lunemployment_r]*`shocksize'*`right' + _b[lunemployment_maj]*`shocksize'*`maj' + _b[lunemployment_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lexpense_nov18]) // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Scen 3: uninteracted effect of X:
su dunemployment if e(sample)
loc shocksize = r(sd)
loc scen = 3
reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year ///
 right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[dunemployment]*`shocksize' // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[lunemployment]*`shocksize')/(1-_b[lexpense_nov18]) // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_expenditures_unemploymentinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.2b
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt growth_r growth_maj growth_r_maj lgrowth_r lgrowth_maj lgrowth_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su growth if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj' + _b[lgrowth]*`shocksize' + _b[lgrowth_r]*`shocksize'*`right' + _b[lgrowth_maj]*`shocksize'*`maj' + _b[lgrowth_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lexpense_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su growth if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj' + _b[lgrowth]*`shocksize' + _b[lgrowth_r]*`shocksize'*`right' + _b[lgrowth_maj]*`shocksize'*`maj' + _b[lgrowth_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lexpense_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su growth if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year ///
 right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[growth]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[growth]*`shocksize' + _b[lgrowth]*`shocksize')/(1-_b[lexpense_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_expenditures_gdpgrowthinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.3a
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev right lright majoritygovt lmajoritygovt dunemployment_r dunemployment_maj dunemployment_r_maj lunemployment_r lunemployment_maj lunemployment_r_maj right_maj lright_maj,

* SR effects:
su dunemployment if e(sample)
loc shocksize = r(sd)

* ----------------------------------------------------------------------------
* now to figure out how to obtain these:
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su dunemployment if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[dunemployment]*`shocksize' + _b[dunemployment_r]*`shocksize'*`right' + _b[dunemployment_maj]*`shocksize'*`maj' + _b[dunemployment_r_maj]*`shocksize'*`right'*`maj' // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[lunemployment]*`shocksize' + _b[lunemployment_r]*`shocksize'*`right' + _b[lunemployment_maj]*`shocksize'*`maj' + _b[lunemployment_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18]) // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su dunemployment if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[dunemployment]*`shocksize' + _b[dunemployment_r]*`shocksize'*`right' + _b[dunemployment_maj]*`shocksize'*`maj' + _b[dunemployment_r_maj]*`shocksize'*`right'*`maj' // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[lunemployment]*`shocksize' + _b[lunemployment_r]*`shocksize'*`right' + _b[lunemployment_maj]*`shocksize'*`maj' + _b[lunemployment_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18]) // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su dunemployment if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,

* short run
nlcom _b[dunemployment]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[lunemployment]*`shocksize')/(1-_b[lrevenue_nov18]) // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_revenues_unemploymentinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.3b
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev right lright majoritygovt lmajoritygovt growth_r growth_maj growth_r_maj lgrowth_r lgrowth_maj lgrowth_r_maj right_maj lright_maj,
* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su growth if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj' + _b[lgrowth]*`shocksize' + _b[lgrowth_r]*`shocksize'*`right' + _b[lgrowth_maj]*`shocksize'*`maj' + _b[lgrowth_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su growth if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj' + _b[lgrowth]*`shocksize' + _b[lgrowth_r]*`shocksize'*`right' + _b[lgrowth_maj]*`shocksize'*`maj' + _b[lgrowth_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su growth if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,

* short run
nlcom _b[growth]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[growth]*`shocksize' + _b[lgrowth]*`shocksize')/(1-_b[lrevenue_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_revenues_gdpgrowthinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.4a
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt dunemployment_r dunemployment_maj dunemployment_r_maj lunemployment_r lunemployment_maj lunemployment_r_maj right_maj lright_maj,

* SR effects:
su dunemployment if e(sample)
loc shocksize = r(sd)

* ----------------------------------------------------------------------------
* now to figure out how to obtain these:
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su dunemployment if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[dunemployment]*`shocksize' + _b[dunemployment_r]*`shocksize'*`right' + _b[dunemployment_maj]*`shocksize'*`maj' + _b[dunemployment_r_maj]*`shocksize'*`right'*`maj' // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[lunemployment]*`shocksize' + _b[lunemployment_r]*`shocksize'*`right' + _b[lunemployment_maj]*`shocksize'*`maj' + _b[lunemployment_r_maj]*`shocksize'*`right'*`maj')/(1-_b[ldeficit_gdp]) // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su dunemployment if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[dunemployment]*`shocksize' + _b[dunemployment_r]*`shocksize'*`right' + _b[dunemployment_maj]*`shocksize'*`maj' + _b[dunemployment_r_maj]*`shocksize'*`right'*`maj' // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[lunemployment]*`shocksize' + _b[lunemployment_r]*`shocksize'*`right' + _b[lunemployment_maj]*`shocksize'*`maj' + _b[lunemployment_r_maj]*`shocksize'*`right'*`maj')/(1-_b[ldeficit_gdp]) // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su dunemployment if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[dunemployment]*`shocksize' 
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[lunemployment]*`shocksize')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") 
*graph export "final-figures/chapter 6/chapter6_deficits_unemploymentinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.4b
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt growth_r growth_maj growth_r_maj lgrowth_r lgrowth_maj lgrowth_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su growth if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj' + _b[lgrowth]*`shocksize' + _b[lgrowth_r]*`shocksize'*`right' + _b[lgrowth_maj]*`shocksize'*`maj' + _b[lgrowth_r_maj]*`shocksize'*`right'*`maj')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su growth if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj' + _b[lgrowth]*`shocksize' + _b[lgrowth_r]*`shocksize'*`right' + _b[lgrowth_maj]*`shocksize'*`maj' + _b[lgrowth_r_maj]*`shocksize'*`right'*`maj')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su growth if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,

* short run
nlcom _b[growth]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[growth]*`shocksize' + _b[lgrowth]*`shocksize')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_deficits_gdpgrowthinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.5a
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt dunemployment_r dunemployment_maj dunemployment_r_maj lunemployment_r lunemployment_maj lunemployment_r_maj right_maj lright_maj

* SR effects:
su dunemployment if e(sample)
loc shocksize = r(sd)

* ----------------------------------------------------------------------------
* now to figure out how to obtain these:
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su dunemployment if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[dunemployment]*`shocksize' + _b[dunemployment_r]*`shocksize'*`right' + _b[dunemployment_maj]*`shocksize'*`maj' + _b[dunemployment_r_maj]*`shocksize'*`right'*`maj' // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[lunemployment]*`shocksize' + _b[lunemployment_r]*`shocksize'*`right' + _b[lunemployment_maj]*`shocksize'*`maj' + _b[lunemployment_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lbd1yr]) // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su dunemployment if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[dunemployment]*`shocksize' + _b[dunemployment_r]*`shocksize'*`right' + _b[dunemployment_maj]*`shocksize'*`maj' + _b[dunemployment_r_maj]*`shocksize'*`right'*`maj' // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[lunemployment]*`shocksize' + _b[lunemployment_r]*`shocksize'*`right' + _b[lunemployment_maj]*`shocksize'*`maj' + _b[lunemployment_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lbd1yr]) // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su dunemployment if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year ///
 right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[dunemployment]*`shocksize' // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[lunemployment]*`shocksize')/(1-_b[lbd1yr]) // for right maj
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") 
*graph export "final-figures/chapter 6/chapter6_budchange_unemploymentinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.5b
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt growth_r growth_maj growth_r_maj lgrowth_r lgrowth_maj lgrowth_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su growth if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj' + _b[lgrowth]*`shocksize' + _b[lgrowth_r]*`shocksize'*`right' + _b[lgrowth_maj]*`shocksize'*`maj' + _b[lgrowth_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lbd1yr])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su growth if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[growth]*`shocksize' + _b[growth_r]*`shocksize'*`right' + _b[growth_maj]*`shocksize'*`maj' + _b[growth_r_maj]*`shocksize'*`right'*`maj' + _b[lgrowth]*`shocksize' + _b[lgrowth_r]*`shocksize'*`right' + _b[lgrowth_maj]*`shocksize'*`maj' + _b[lgrowth_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lbd1yr])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su growth if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[growth]*`shocksize' 
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[growth]*`shocksize' + _b[lgrowth]*`shocksize')/(1-_b[lbd1yr])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid))  ///
ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_budchange_gdpgrowthinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.6a
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt dopenness_r dopenness_maj dopenness_r_maj ldopenness_r ldopenness_maj ldopenness_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su dopenness if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj' + _b[ldopenness]*`shocksize' + _b[ldopenness_r]*`shocksize'*`right' + _b[ldopenness_maj]*`shocksize'*`maj' + _b[ldopenness_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lexpense_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su dopenness if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj' + _b[ldopenness]*`shocksize' + _b[ldopenness_r]*`shocksize'*`right' + _b[ldopenness_maj]*`shocksize'*`maj' + _b[ldopenness_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lexpense_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su dopenness if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year ///
 right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[dopenness]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[dopenness]*`shocksize' + _b[ldopenness]*`shocksize')/(1-_b[lexpense_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_expenditures_opennessinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.6b
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev right lright majoritygovt lmajoritygovt dopenness_r dopenness_maj dopenness_r_maj ldopenness_r ldopenness_maj ldopenness_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su dopenness if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj' + _b[ldopenness]*`shocksize' + _b[ldopenness_r]*`shocksize'*`right' + _b[ldopenness_maj]*`shocksize'*`maj' + _b[ldopenness_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su dopenness if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj' + _b[ldopenness]*`shocksize' + _b[ldopenness_r]*`shocksize'*`right' + _b[ldopenness_maj]*`shocksize'*`maj' + _b[ldopenness_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su dopenness if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,

* short run
nlcom _b[dopenness]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[dopenness]*`shocksize' + _b[ldopenness]*`shocksize')/(1-_b[lrevenue_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_revenues_opennessinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.6c
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt dopenness_r dopenness_maj dopenness_r_maj ldopenness_r ldopenness_maj ldopenness_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su dopenness if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj' + _b[ldopenness]*`shocksize' + _b[ldopenness_r]*`shocksize'*`right' + _b[ldopenness_maj]*`shocksize'*`maj' + _b[ldopenness_r_maj]*`shocksize'*`right'*`maj')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su dopenness if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj' + _b[ldopenness]*`shocksize' + _b[ldopenness_r]*`shocksize'*`right' + _b[ldopenness_maj]*`shocksize'*`maj' + _b[ldopenness_r_maj]*`shocksize'*`right'*`maj')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su dopenness if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,

* short run
nlcom _b[dopenness]*`shocksize' 
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[dopenness]*`shocksize' + _b[ldopenness]*`shocksize')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_deficits_opennessinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.6d
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt dopenness_r dopenness_maj dopenness_r_maj ldopenness_r ldopenness_maj ldopenness_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su dopenness if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj' + _b[ldopenness]*`shocksize' + _b[ldopenness_r]*`shocksize'*`right' + _b[ldopenness_maj]*`shocksize'*`maj' + _b[ldopenness_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lbd1yr])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su dopenness if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[dopenness]*`shocksize' + _b[dopenness_r]*`shocksize'*`right' + _b[dopenness_maj]*`shocksize'*`maj' + _b[dopenness_r_maj]*`shocksize'*`right'*`maj' + _b[ldopenness]*`shocksize' + _b[ldopenness_r]*`shocksize'*`right' + _b[ldopenness_maj]*`shocksize'*`maj' + _b[ldopenness_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lbd1yr])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su dopenness if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[dopenness]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[dopenness]*`shocksize' + _b[ldopenness]*`shocksize')/(1-_b[lbd1yr])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid))  ///
ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") 
*graph export "final-figures/chapter 6/chapter6_budchange_opennessinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.7a
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt total_hostlev_r total_hostlev_maj total_hostlev_r_maj ltotal_hostlev_r ltotal_hostlev_maj ltotal_hostlev_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su total_hostlev if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj' + _b[ltotal_hostlev]*`shocksize' + _b[ltotal_hostlev_r]*`shocksize'*`right' + _b[ltotal_hostlev_maj]*`shocksize'*`maj' + _b[ltotal_hostlev_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lexpense_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su total_hostlev if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj' + _b[ltotal_hostlev]*`shocksize' + _b[ltotal_hostlev_r]*`shocksize'*`right' + _b[ltotal_hostlev_maj]*`shocksize'*`maj' + _b[ltotal_hostlev_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lexpense_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted effect of X:
su total_hostlev if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year ///
 right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[total_hostlev]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[total_hostlev]*`shocksize' + _b[ltotal_hostlev]*`shocksize')/(1-_b[lexpense_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_expenditures_hostilityinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.7b
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev right lright majoritygovt lmajoritygovt total_hostlev_r total_hostlev_maj total_hostlev_r_maj ltotal_hostlev_r ltotal_hostlev_maj ltotal_hostlev_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su total_hostlev if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj' + _b[ltotal_hostlev]*`shocksize' + _b[ltotal_hostlev_r]*`shocksize'*`right' + _b[ltotal_hostlev_maj]*`shocksize'*`maj' + _b[ltotal_hostlev_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su total_hostlev if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj' + _b[ltotal_hostlev]*`shocksize' + _b[ltotal_hostlev_r]*`shocksize'*`right' + _b[ltotal_hostlev_maj]*`shocksize'*`maj' + _b[ltotal_hostlev_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su total_hostlev if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,

* short run
nlcom _b[total_hostlev]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[total_hostlev]*`shocksize' + _b[ltotal_hostlev]*`shocksize')/(1-_b[lrevenue_nov18])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") 
*graph export "final-figures/chapter 6/chapter6_revenues_hostilityinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.7c
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt total_hostlev_r total_hostlev_maj total_hostlev_r_maj ltotal_hostlev_r ltotal_hostlev_maj ltotal_hostlev_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su total_hostlev if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj' + _b[ltotal_hostlev]*`shocksize' + _b[ltotal_hostlev_r]*`shocksize'*`right' + _b[ltotal_hostlev_maj]*`shocksize'*`maj' + _b[ltotal_hostlev_r_maj]*`shocksize'*`right'*`maj')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su total_hostlev if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj' + _b[ltotal_hostlev]*`shocksize' + _b[ltotal_hostlev_r]*`shocksize'*`right' + _b[ltotal_hostlev_maj]*`shocksize'*`maj' + _b[ltotal_hostlev_r_maj]*`shocksize'*`right'*`maj')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su total_hostlev if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[total_hostlev]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[total_hostlev]*`shocksize' + _b[ltotal_hostlev]*`shocksize')/(1-_b[ldeficit_gdp])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect")
*graph export "final-figures/chapter 6/chapter6_deficits_hostilityinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Figure 6.7d
* --------------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt total_hostlev_r total_hostlev_maj total_hostlev_r_maj ltotal_hostlev_r ltotal_hostlev_maj ltotal_hostlev_r_maj right_maj lright_maj,

* ----------------------------------------------------------------------------
* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
su total_hostlev if e(sample)
loc shocksize = r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj' + _b[ltotal_hostlev]*`shocksize' + _b[ltotal_hostlev_r]*`shocksize'*`right' + _b[ltotal_hostlev_maj]*`shocksize'*`maj' + _b[ltotal_hostlev_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lbd1yr])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 2: Left Maj
su total_hostlev if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 1
loc scen = 2
* short run
nlcom _b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[total_hostlev]*`shocksize' + _b[total_hostlev_r]*`shocksize'*`right' + _b[total_hostlev_maj]*`shocksize'*`maj' + _b[total_hostlev_r_maj]*`shocksize'*`right'*`maj' + _b[ltotal_hostlev]*`shocksize' + _b[ltotal_hostlev_r]*`shocksize'*`right' + _b[ltotal_hostlev_maj]*`shocksize'*`maj' + _b[ltotal_hostlev_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lbd1yr])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* scen 3: uninteracted
su total_hostlev if e(sample)
loc shocksize = r(sd)
loc right = 0
loc maj = 0
loc scen = 3
reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,
* short run
nlcom _b[total_hostlev]*`shocksize'
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace sr_effect = effect if scenario == `scen'
replace sr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace sr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace sr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse
* long-run
nlcom (_b[total_hostlev]*`shocksize' + _b[ltotal_hostlev]*`shocksize')/(1-_b[lbd1yr])
return list
mata: effect = st_matrix("r(b)")
mata: effectse = sqrt(diagonal(st_matrix("r(V)")))
getmata effect effectse, force
carryforward effect effectse, replace
replace lr_effect = effect if scenario == `scen'
replace lr_effect_ll =  effect - invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ul =  effect + invttail(e(df_r),0.025)*effectse if scenario == `scen'
replace lr_effect_ll90 =  effect - invttail(e(df_r),0.05)*effectse if scenario == `scen'
replace lr_effect_ul90 =  effect + invttail(e(df_r),0.05)*effectse if scenario == `scen'
drop effect effectse

* Now plot:
replace scenario = . if scenario > 3
gen scenario2 = scenario+.2
replace scenario = 0.5 in 4 // pad
replace scenario = 3.5 in 5 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid)) ylabel(1 "Right Majority" 2 "Left Majority" 3 "No Interaction", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") 
*graph export "final-figures/chapter 6/chapter6_budchange_hostilityinteraction_june21.pdf", as(pdf) replace
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Table 6.1
* --------------------------------------------------------------------------
* FOR EXPENDITURES
eststo clear
reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,
est sto Pooled
xtreg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj, mle
est sto RE
xtreg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj, fe
est sto FE
*estout Pooled RE FE using tab1.tex, replace style(tex) cells("b(star fmt(3)) se(par fmt(3))")
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Table 6.2
* --------------------------------------------------------------------------
* FOR REVENUES
eststo clear
* our revenues model, pooled
reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,
est sto Pooled
* revenues, RE
xtreg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj, mle
est sto RE
* revenues, FE
xtreg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj, fe
est sto FE
*estout Pooled RE FE using tab1.tex, replace style(tex) cells("b(star fmt(3)) se(par fmt(3))") 
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Table 6.3
* --------------------------------------------------------------------------
* FOR DEFICITS
eststo clear
* Our model:
reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj,
est sto Pooled
xtreg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj, mle
est sto RE
xtreg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj, fe
est sto FE
*estout Pooled RE FE using tab1.tex, replace style(tex) cells("b(star fmt(3)) se(par fmt(3))")
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Table 6.4
* --------------------------------------------------------------------------
* FOR BUDGETARY VOLATILITY
eststo clear
reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj, 
est sto Pooled
xtreg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj, mle
est sto RE
xtreg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj, fe
est sto FE
*estout Pooled RE FE using tab1.tex, replace style(tex) cells("b(star fmt(3)) se(par fmt(3))") 
* --------------------------------------------------------------------------


* --------------------------------------------------------------------------
*		Table 6.5
* --------------------------------------------------------------------------
* globals of each regression specification:
global expenditures "expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj"
global revenues "revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj"
global deficits "deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj"
global budvol "bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt right_maj lright_maj"

* Column 1
qui xtreg $expenditures
xtqptest, lags(1) 
qui xtreg $revenues
xtqptest, lags(1)
qui xtreg $deficits
xtqptest, lags(1)
qui xtreg $budvol
xtqptest, lags(1)

* Column 2
qui xtreg $expenditures, fe
xtqptest, lags(1) 
qui xtreg $revenues, fe
xtqptest, lags(1)
qui xtreg $deficits, fe
xtqptest, lags(1)
qui xtreg $budvol, fe
xtqptest, lags(1)

* Column 3
qui xtreg $expenditures
xtqptest, order(1) 
qui xtreg $revenues
xtqptest, order(1)
qui xtreg $deficits
xtqptest, order(1)
qui xtreg $budvol
xtqptest, order(1)

* Column 4
qui xtreg $expenditures, fe
xtqptest, order(1) 
qui xtreg $revenues, fe
xtqptest, order(1)
qui xtreg $deficits, fe
xtqptest, order(1)
qui xtreg $budvol, fe
xtqptest, order(1)

* Column 5
qui xtreg $expenditures
xthrtest 
qui xtreg $revenues
xthrtest
qui xtreg $deficits
xthrtest
qui xtreg $budvol
xthrtest

* Column 6
qui xtreg $expenditures, fe
xthrtest 
qui xtreg $revenues, fe
xthrtest
qui xtreg $deficits, fe
xthrtest
qui xtreg $budvol, fe
xthrtest
* --------------------------------------------------------------------------
