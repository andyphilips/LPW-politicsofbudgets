* Chapter 5
*
*
* 3/24/23
* --------------------------------------------------------------------
set scheme burd
set more off
set seed 4903409

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


* --------------------------------------------------------------------
*		Figure 5.2
* --------------------------------------------------------------------
pvar zdexpense zdrevenue zddeficit zbd1yr, exog(zgrowth zunemp zdopenness zADR_nov18 legelec zhost year right majoritygovt) overid instlags(1/3) lags(2) gmmstyle
* IRF for Expenditures
pvarirf, mc(500) step(8) impulse(zdexpense) save("temp1", replace) nodraw level(95)
pvarirf, mc(500) step(8) impulse(zdexpense) save("temp2", replace) nodraw level(90)
preserve
use temp1.dta, clear
rename ll ll_95
rename ul ul_95
joinby _step impres using "temp2.dta", unmatched(both)
drop _merge
rename ll ll_90
rename ul ul_90
decode impres, generate(shock)
twoway rarea ll_95 ul_95 _step if shock == "zdexpense : zdexpense", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zdexpense : zdexpense", color(blue%70) || line irf _step if shock == "zdexpense : zdexpense", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Expenditures")
graph save g1.gph, replace
twoway rarea ll_95 ul_95 _step if shock == "zdexpense : zdrevenue", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zdexpense : zdrevenue", color(blue%70) || line irf _step if shock == "zdexpense : zdrevenue", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Revenues")
graph save g2.gph, replace
twoway rarea ll_95 ul_95 _step if shock == "zdexpense : zddeficit", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zdexpense : zddeficit", color(blue%70) || line irf _step if shock == "zdexpense : zddeficit", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Deficit")
graph save g3.gph, replace
twoway rarea ll_95 ul_95 _step if shock == "zdexpense : zbd1yr", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zdexpense : zbd1yr", color(blue%70) || line irf _step if shock == "zdexpense : zbd1yr", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Budgetary Volatility")
graph save g4.gph, replace
graph combine g1.gph g2.gph g3.gph g4.gph, rows(2) ycommon
*graph export "final-figures/chapter 5/pvar-IRF-expenditure.pdf", as(pdf) replace
restore
* --------------------------------------------------------------------


* --------------------------------------------------------------------
*		Figure 5.3
* --------------------------------------------------------------------
pvarirf, mc(500) step(8) impulse(zdrevenue) save("temp1", replace) nodraw level(95)
pvarirf, mc(500) step(8) impulse(zdrevenue) save("temp2", replace) nodraw level(90)
preserve
use temp1.dta, clear
rename ll ll_95
rename ul ul_95
joinby _step impres using "temp2.dta", unmatched(both)
drop _merge
rename ll ll_90
rename ul ul_90
decode impres, generate(shock)
twoway rarea ll_95 ul_95 _step if shock == "zdrevenue : zdexpense", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zdrevenue : zdexpense", color(blue%70) || line irf _step if shock == "zdrevenue : zdexpense", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Expenditures")
graph save g1.gph, replace
twoway rarea ll_95 ul_95 _step if shock == "zdrevenue : zdrevenue", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zdrevenue : zdrevenue", color(blue%70) || line irf _step if shock == "zdrevenue : zdrevenue", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Revenues")
graph save g2.gph, replace
twoway rarea ll_95 ul_95 _step if shock == "zdrevenue : zddeficit", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zdrevenue : zddeficit", color(blue%70) || line irf _step if shock == "zdrevenue : zddeficit", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Deficit")
graph save g3.gph, replace
twoway rarea ll_95 ul_95 _step if shock == "zdrevenue : zbd1yr", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zdrevenue : zbd1yr", color(blue%70) || line irf _step if shock == "zdrevenue : zbd1yr", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Budgetary Volatility")
graph save g4.gph, replace
graph combine g1.gph g2.gph g3.gph g4.gph, rows(2) ycommon
*graph export "final-figures/chapter 5/pvar-IRF-revenue.pdf", as(pdf) replace
restore
* --------------------------------------------------------------------


* --------------------------------------------------------------------
*		Figure 5.4
* --------------------------------------------------------------------
pvarirf, mc(500) step(8) impulse(zddeficit) save("temp1", replace) nodraw level(95)
pvarirf, mc(500) step(8) impulse(zddeficit) save("temp2", replace) nodraw level(90)
preserve
use temp1.dta, clear
rename ll ll_95
rename ul ul_95
joinby _step impres using "temp2.dta", unmatched(both)
drop _merge
rename ll ll_90
rename ul ul_90
decode impres, generate(shock)
twoway rarea ll_95 ul_95 _step if shock == "zddeficit : zdexpense", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zddeficit : zdexpense", color(blue%70) || line irf _step if shock == "zddeficit : zdexpense", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Expenditures")
graph save g1.gph, replace
twoway rarea ll_95 ul_95 _step if shock == "zddeficit : zdrevenue", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zddeficit : zdrevenue", color(blue%70) || line irf _step if shock == "zddeficit : zdrevenue", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Revenues")
graph save g2.gph, replace
twoway rarea ll_95 ul_95 _step if shock == "zddeficit : zddeficit", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zddeficit : zddeficit", color(blue%70) || line irf _step if shock == "zddeficit : zddeficit", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Deficit")
graph save g3.gph, replace
twoway rarea ll_95 ul_95 _step if shock == "zddeficit : zbd1yr", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zddeficit : zbd1yr", color(blue%70) || line irf _step if shock == "zddeficit : zbd1yr", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Budgetary Volatility")
graph save g4.gph, replace
graph combine g1.gph g2.gph g3.gph g4.gph, rows(2) ycommon
*graph export "final-figures/chapter 5/pvar-IRF-debt.pdf", as(pdf) replace
restore
* --------------------------------------------------------------------


* --------------------------------------------------------------------
*		Figure 5.5
* --------------------------------------------------------------------
pvarirf, mc(500) step(8) impulse(zbd1yr) save("temp1", replace) nodraw level(95)
pvarirf, mc(500) step(8) impulse(zbd1yr) save("temp2", replace) nodraw level(90)
preserve
use temp1.dta, clear
rename ll ll_95
rename ul ul_95
joinby _step impres using "temp2.dta", unmatched(both)
drop _merge
rename ll ll_90
rename ul ul_90
decode impres, generate(shock)
twoway rarea ll_95 ul_95 _step if shock == "zbd1yr : zdexpense", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zbd1yr : zdexpense", color(blue%70) || line irf _step if shock == "zbd1yr : zdexpense", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Expenditures")
graph save g1.gph, replace
twoway rarea ll_95 ul_95 _step if shock == "zbd1yr : zdrevenue", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zbd1yr : zdrevenue", color(blue%70) || line irf _step if shock == "zbd1yr : zdrevenue", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Revenues")
graph save g2.gph, replace
twoway rarea ll_95 ul_95 _step if shock == "zbd1yr : zddeficit", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zbd1yr : zddeficit", color(blue%70) || line irf _step if shock == "zbd1yr : zddeficit", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Deficit")
graph save g3.gph, replace
twoway rarea ll_95 ul_95 _step if shock == "zbd1yr : zbd1yr", color(blue%40)  || rarea ll_90 ul_90 _step if shock == "zbd1yr : zbd1yr", color(blue%70) || line irf _step if shock == "zbd1yr : zbd1yr", lwidth(medthick) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Budgetary Volatility")
graph save g4.gph, replace
graph combine g1.gph g2.gph g3.gph g4.gph, rows(2) ycommon
*graph export "final-figures/chapter 5/pvar-IRF-budgetchange.pdf", as(pdf) replace
restore
* --------------------------------------------------------------------

* --------------------------------------------------------------------
*		Table 5.2
* --------------------------------------------------------------------
pvargranger // Granger causality table
* --------------------------------------------------------------------



* --------------------------------------------------------------------
*		Figure 5.7
* --------------------------------------------------------------------
reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt expense_nov18_r expense_nov18_maj expense_nov18_r_maj lexpense_nov18_r lexpense_nov18_maj lexpense_nov18_r_maj right_maj lright_maj, 
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
xtsum expense_nov18 if e(sample)
loc shocksize = r(sd_w) // r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[expense_nov18]*`shocksize' + _b[expense_nov18_r]*`shocksize'*`right' + _b[expense_nov18_maj]*`shocksize'*`maj' + _b[expense_nov18_r_maj]*`shocksize'*`right'*`maj'
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
nlcom (_b[expense_nov18]*`shocksize' + _b[expense_nov18_r]*`shocksize'*`right' + _b[expense_nov18_maj]*`shocksize'*`maj' + _b[expense_nov18_r_maj]*`shocksize'*`right'*`maj' + _b[lexpense_nov18]*`shocksize' + _b[lexpense_nov18_r]*`shocksize'*`right' + _b[lexpense_nov18_maj]*`shocksize'*`maj' + _b[lexpense_nov18_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
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

* scen 2: Right min
xtsum expense_nov18 if e(sample)
loc shocksize = r(sd_w) // r(sd)
loc right = 1
loc maj = 0
loc scen = 2
* short run
nlcom _b[expense_nov18]*`shocksize' + _b[expense_nov18_r]*`shocksize'*`right' + _b[expense_nov18_maj]*`shocksize'*`maj' + _b[expense_nov18_r_maj]*`shocksize'*`right'*`maj'
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
nlcom (_b[expense_nov18]*`shocksize' + _b[expense_nov18_r]*`shocksize'*`right' + _b[expense_nov18_maj]*`shocksize'*`maj' + _b[expense_nov18_r_maj]*`shocksize'*`right'*`maj' + _b[lexpense_nov18]*`shocksize' + _b[lexpense_nov18_r]*`shocksize'*`right' + _b[lexpense_nov18_maj]*`shocksize'*`maj' + _b[lexpense_nov18_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
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

* scen 3: Left Maj
xtsum expense_nov18 if e(sample)
loc shocksize = r(sd_w) // r(sd)
loc right = 0
loc maj = 1
loc scen = 3
* short run
nlcom _b[expense_nov18]*`shocksize' + _b[expense_nov18_r]*`shocksize'*`right' + _b[expense_nov18_maj]*`shocksize'*`maj' + _b[expense_nov18_r_maj]*`shocksize'*`right'*`maj'
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
nlcom (_b[expense_nov18]*`shocksize' + _b[expense_nov18_r]*`shocksize'*`right' + _b[expense_nov18_maj]*`shocksize'*`maj' + _b[expense_nov18_r_maj]*`shocksize'*`right'*`maj' + _b[lexpense_nov18]*`shocksize' + _b[lexpense_nov18_r]*`shocksize'*`right' + _b[lexpense_nov18_maj]*`shocksize'*`maj' + _b[lexpense_nov18_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
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

* scen 4: Left min
xtsum expense_nov18 if e(sample)
loc shocksize = r(sd_w) // r(sd)
loc right = 0
loc maj = 0
loc scen = 4
* short run
nlcom _b[expense_nov18]*`shocksize' + _b[expense_nov18_r]*`shocksize'*`right' + _b[expense_nov18_maj]*`shocksize'*`maj' + _b[expense_nov18_r_maj]*`shocksize'*`right'*`maj'
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
nlcom (_b[expense_nov18]*`shocksize' + _b[expense_nov18_r]*`shocksize'*`right' + _b[expense_nov18_maj]*`shocksize'*`maj' + _b[expense_nov18_r_maj]*`shocksize'*`right'*`maj' + _b[lexpense_nov18]*`shocksize' + _b[lexpense_nov18_r]*`shocksize'*`right' + _b[lexpense_nov18_maj]*`shocksize'*`maj' + _b[lexpense_nov18_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
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
replace scenario = . if scenario > 4
gen scenario2 = scenario+.2
replace scenario = 0.5 in 5 // pad
replace scenario = 4.5 in 6 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid))  ///
ylabel(1 "Right Majority" 2 "Right Minority" 3 "Left Majority" 4 "Left Minority", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") note("Note: 95% (thin) and 90% (thick) confidence intervals shown") xlabel(-2(2)8)
*graph export "final-figures/chapter 5/chapter5_deficit_expenditureinteraction.pdf", as(pdf) replace
* --------------------------------------------------------------------


* --------------------------------------------------------------------
*			Figure 5.8
* --------------------------------------------------------------------
* drop everything from above:
drop scenario - scenario2

reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right lright majoritygovt lmajoritygovt revenue_nov18_r revenue_nov18_maj revenue_nov18_r_maj lrevenue_nov18_r lrevenue_nov18_maj lrevenue_nov18_r_maj right_maj lright_maj,  
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
xtsum revenue_nov18 if e(sample)
loc shocksize = r(sd_w) // r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[revenue_nov18]*`shocksize' + _b[revenue_nov18_r]*`shocksize'*`right' + _b[revenue_nov18_maj]*`shocksize'*`maj' + _b[revenue_nov18_r_maj]*`shocksize'*`right'*`maj'
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
nlcom (_b[revenue_nov18]*`shocksize' + _b[revenue_nov18_r]*`shocksize'*`right' + _b[revenue_nov18_maj]*`shocksize'*`maj' + _b[revenue_nov18_r_maj]*`shocksize'*`right'*`maj' + _b[lrevenue_nov18]*`shocksize' + _b[lrevenue_nov18_r]*`shocksize'*`right' + _b[lrevenue_nov18_maj]*`shocksize'*`maj' + _b[lrevenue_nov18_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
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

* scen 2: Right min
xtsum revenue_nov18 if e(sample)
loc shocksize = r(sd_w) // r(sd)
loc right = 1
loc maj = 0
loc scen = 2
* short run
nlcom _b[revenue_nov18]*`shocksize' + _b[revenue_nov18_r]*`shocksize'*`right' + _b[revenue_nov18_maj]*`shocksize'*`maj' + _b[revenue_nov18_r_maj]*`shocksize'*`right'*`maj'
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
nlcom (_b[revenue_nov18]*`shocksize' + _b[revenue_nov18_r]*`shocksize'*`right' + _b[revenue_nov18_maj]*`shocksize'*`maj' + _b[revenue_nov18_r_maj]*`shocksize'*`right'*`maj' + _b[lrevenue_nov18]*`shocksize' + _b[lrevenue_nov18_r]*`shocksize'*`right' + _b[lrevenue_nov18_maj]*`shocksize'*`maj' + _b[lrevenue_nov18_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
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

* scen 3: Left Maj
xtsum revenue_nov18 if e(sample)
loc shocksize = r(sd_w) // r(sd)
loc right = 0
loc maj = 1
loc scen = 3
* short run
nlcom _b[revenue_nov18]*`shocksize' + _b[revenue_nov18_r]*`shocksize'*`right' + _b[revenue_nov18_maj]*`shocksize'*`maj' + _b[revenue_nov18_r_maj]*`shocksize'*`right'*`maj'
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
nlcom (_b[revenue_nov18]*`shocksize' + _b[revenue_nov18_r]*`shocksize'*`right' + _b[revenue_nov18_maj]*`shocksize'*`maj' + _b[revenue_nov18_r_maj]*`shocksize'*`right'*`maj' + _b[lrevenue_nov18]*`shocksize' + _b[lrevenue_nov18_r]*`shocksize'*`right' + _b[lrevenue_nov18_maj]*`shocksize'*`maj' + _b[lrevenue_nov18_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
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

* scen 4: Left min
xtsum revenue_nov18 if e(sample)
loc shocksize = r(sd_w) // r(sd)
loc right = 0
loc maj = 0
loc scen = 4
* short run
nlcom _b[revenue_nov18]*`shocksize' + _b[revenue_nov18_r]*`shocksize'*`right' + _b[revenue_nov18_maj]*`shocksize'*`maj' + _b[revenue_nov18_r_maj]*`shocksize'*`right'*`maj'
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
nlcom (_b[revenue_nov18]*`shocksize' + _b[revenue_nov18_r]*`shocksize'*`right' + _b[revenue_nov18_maj]*`shocksize'*`maj' + _b[revenue_nov18_r_maj]*`shocksize'*`right'*`maj' + _b[lrevenue_nov18]*`shocksize' + _b[lrevenue_nov18_r]*`shocksize'*`right' + _b[lrevenue_nov18_maj]*`shocksize'*`maj' + _b[lrevenue_nov18_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
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
replace scenario = . if scenario > 4
gen scenario2 = scenario+.2
replace scenario = 0.5 in 5 // pad
replace scenario = 4.5 in 6 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid))  ///
ylabel(1 "Right Majority" 2 "Right Minority" 3 "Left Majority" 4 "Left Minority", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") note("Note: 95% (thin) and 90% (thick) confidence intervals shown") xlabel(-6(2)2)
*graph export "final-figures/chapter 5/chapter5_deficit_revenueinteraction.pdf", as(pdf) replace
* --------------------------------------------------------------------


* --------------------------------------------------------------------
*		Figure 5.9
* --------------------------------------------------------------------
drop scenario - scenario2
reg revenue_nov18 lrevenue_nov18 growth lgrowth dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year dunemployment lunemployment deficit_gdp ldeficit_gdp right lright majoritygovt lmajoritygovt deficit_gdp_r deficit_gdp_maj deficit_gdp_r_maj ldeficit_gdp_r ldeficit_gdp_maj ldeficit_gdp_r_maj right_maj lright_maj,

* create container scenarios:
gen scenario = _n
gen sr_effect = .
gen sr_effect_ll = .
gen sr_effect_ul = .
gen sr_effect_ll90 = .
gen sr_effect_ul90 = .
gen lr_effect = .
gen lr_effect_ll = .
gen lr_effect_ul = .
gen lr_effect_ll90 = .
gen lr_effect_ul90 = .

* scen 1: Right Maj
xtsum deficit_gdp if e(sample)
loc shocksize = r(sd_w) // r(sd)
loc right = 1
loc maj = 1
loc scen = 1
* short run
nlcom _b[deficit_gdp]*`shocksize' + _b[deficit_gdp_r]*`shocksize'*`right' + _b[deficit_gdp_maj]*`shocksize'*`maj' + _b[deficit_gdp_r_maj]*`shocksize'*`right'*`maj'
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
nlcom (_b[deficit_gdp]*`shocksize' + _b[deficit_gdp_r]*`shocksize'*`right' + _b[deficit_gdp_maj]*`shocksize'*`maj' + _b[deficit_gdp_r_maj]*`shocksize'*`right'*`maj' + _b[ldeficit_gdp]*`shocksize' + _b[ldeficit_gdp_r]*`shocksize'*`right' + _b[ldeficit_gdp_maj]*`shocksize'*`maj' + _b[ldeficit_gdp_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
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

* scen 2: Right min
xtsum deficit_gdp if e(sample)
loc shocksize = r(sd_w) // r(sd)
loc right = 1
loc maj = 0
loc scen = 2
* short run
nlcom _b[deficit_gdp]*`shocksize' + _b[deficit_gdp_r]*`shocksize'*`right' + _b[deficit_gdp_maj]*`shocksize'*`maj' + _b[deficit_gdp_r_maj]*`shocksize'*`right'*`maj'
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
nlcom (_b[deficit_gdp]*`shocksize' + _b[deficit_gdp_r]*`shocksize'*`right' + _b[deficit_gdp_maj]*`shocksize'*`maj' + _b[deficit_gdp_r_maj]*`shocksize'*`right'*`maj' + _b[ldeficit_gdp]*`shocksize' + _b[ldeficit_gdp_r]*`shocksize'*`right' + _b[ldeficit_gdp_maj]*`shocksize'*`maj' + _b[ldeficit_gdp_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
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

* scen 3: Left Maj
xtsum deficit_gdp if e(sample)
loc shocksize = r(sd_w) // r(sd)
loc right = 0
loc maj = 1
loc scen = 3
* short run
nlcom _b[deficit_gdp]*`shocksize' + _b[deficit_gdp_r]*`shocksize'*`right' + _b[deficit_gdp_maj]*`shocksize'*`maj' + _b[deficit_gdp_r_maj]*`shocksize'*`right'*`maj'
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
nlcom (_b[deficit_gdp]*`shocksize' + _b[deficit_gdp_r]*`shocksize'*`right' + _b[deficit_gdp_maj]*`shocksize'*`maj' + _b[deficit_gdp_r_maj]*`shocksize'*`right'*`maj' + _b[ldeficit_gdp]*`shocksize' + _b[ldeficit_gdp_r]*`shocksize'*`right' + _b[ldeficit_gdp_maj]*`shocksize'*`maj' + _b[ldeficit_gdp_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
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

* scen 4: Left min
xtsum deficit_gdp if e(sample)
loc shocksize = r(sd_w) // r(sd)
loc right = 0
loc maj = 0
loc scen = 4
* short run
nlcom _b[deficit_gdp]*`shocksize' + _b[deficit_gdp_r]*`shocksize'*`right' + _b[deficit_gdp_maj]*`shocksize'*`maj' + _b[deficit_gdp_r_maj]*`shocksize'*`right'*`maj'
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
nlcom (_b[deficit_gdp]*`shocksize' + _b[deficit_gdp_r]*`shocksize'*`right' + _b[deficit_gdp_maj]*`shocksize'*`maj' + _b[deficit_gdp_r_maj]*`shocksize'*`right'*`maj' + _b[ldeficit_gdp]*`shocksize' + _b[ldeficit_gdp_r]*`shocksize'*`right' + _b[ldeficit_gdp_maj]*`shocksize'*`maj' + _b[ldeficit_gdp_r_maj]*`shocksize'*`right'*`maj')/(1-_b[lrevenue_nov18])
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
replace scenario = . if scenario > 4
gen scenario2 = scenario+.2
replace scenario = 0.5 in 5 // pad
replace scenario = 4.5 in 6 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid))  ///
ylabel(1 "Right Majority" 2 "Right Minority" 3 "Left Majority" 4 "Left Minority", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") note("Note: 95% (thin) and 90% (thick) confidence intervals shown")
*graph export "final-figures/chapter 5/chapter5_revenue_deficitinteraction.pdf", as(pdf) replace
* --------------------------------------------------------------------

* --------------------------------------------------------------------
*	Figure 5.10a
* --------------------------------------------------------------------
drop scenario - scenario2
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

* for left maj -> right maj
reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right_min lright_min right_maj lright_maj left_min lleft_min
loc scen = 1

* short-run
nlcom _b[right_maj]
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
nlcom (_b[right_maj] + _b[lright_maj])/(1-_b[lexpense_nov18])
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

* for left-to-right minority (scenario 2)
reg expense_nov18 lexpense_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right_maj lright_maj right_min lright_min left_maj lleft_maj
loc scen = 2

* short-run
nlcom _b[right_min]
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
nlcom (_b[right_min] + _b[lright_min])/(1-_b[lexpense_nov18])
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
replace scenario = . if scenario > 2
gen scenario2 = scenario+.2
replace scenario = 0.5 in 3 // pad
replace scenario = 2.5 in 4 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid))  ///
ylabel(1 "Left Maj -> Right Maj" 2 "Left Min -> Right Min", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") 
*graph export "final-figures/chapter 5/chapter5_expenditures_lefttorightinteraction.pdf", as(pdf) replace
* --------------------------------------------------------------------



* --------------------------------------------------------------------
*		Figure 5.10b: NOTE: The figure shown in the book is incorrect (it's the same as deficits) 
* --------------------------------------------------------------------
drop scenario - scenario2
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

* for left maj -> right maj
reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right_min lright_min right_maj lright_maj left_min lleft_min
loc scen = 1

* short-run
nlcom _b[right_maj]
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
nlcom (_b[right_maj] + _b[lright_maj])/(1-_b[lrevenue_nov18])
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

* for left-to-right minority (scenario 2)
reg revenue_nov18 lrevenue_nov18 deficit_gdp ldeficit_gdp growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right_maj lright_maj right_min lright_min left_maj lleft_maj
loc scen = 2

* short-run
nlcom _b[right_min]
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
nlcom (_b[right_min] + _b[lright_min])/(1-_b[lrevenue_nov18])
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
replace scenario = . if scenario > 2
gen scenario2 = scenario+.2
replace scenario = 0.5 in 3 // pad
replace scenario = 2.5 in 4 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid))  ///
ylabel(1 "Left Maj -> Right Maj" 2 "Left Min -> Right Min", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") 
*graph export "final-figures/chapter 5/chapter5_revenues_lefttorightinteraction.pdf", as(pdf) replace
* --------------------------------------------------------------------


* --------------------------------------------------------------------
*		Figure 5.10c
* --------------------------------------------------------------------
drop scenario - scenario2
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

* for left maj -> right maj
reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right_min lright_min right_maj lright_maj left_min lleft_min
loc scen = 1

* short-run
nlcom _b[right_maj]
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
nlcom (_b[right_maj] + _b[lright_maj])/(1-_b[ldeficit_gdp])
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

* for left-to-right minority (scenario 2)
reg deficit_gdp ldeficit_gdp expense_nov18 lexpense_nov18 revenue_nov18 lrevenue_nov18 growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right_maj lright_maj right_min lright_min left_maj lleft_maj
loc scen = 2

* short-run
nlcom _b[right_min]
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
nlcom (_b[right_min] + _b[lright_min])/(1-_b[ldeficit_gdp])
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
replace scenario = . if scenario > 2
gen scenario2 = scenario+.2
replace scenario = 0.5 in 3 // pad
replace scenario = 2.5 in 4 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid))  ///
ylabel(1 "Left Maj -> Right Maj" 2 "Left Min -> Right Min", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") 
*graph export "final-figures/chapter 5/chapter5_deficit_lefttorightinteraction.pdf", as(pdf) replace
* --------------------------------------------------------------------



* --------------------------------------------------------------------
*		Figure 5.10d
* --------------------------------------------------------------------
drop scenario - scenario2

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

* for left maj -> right maj
reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness  ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right_min lright_min right_maj lright_maj left_min lleft_min
loc scen = 1

* short-run
nlcom _b[right_maj]
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
nlcom (_b[right_maj] + _b[lright_maj])/(1-_b[lbd1yr])
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

* for left-to-right minority (scenario 2)
reg bd1yr lbd1yr growth lgrowth dunemployment lunemployment dopenness ldopenness ADR_nov18 lADR_nov18 legelec llegelec total_hostlev ltotal_hostlev year right_maj lright_maj right_min lright_min left_maj lleft_maj
loc scen = 2

* short-run
nlcom _b[right_min]
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
nlcom (_b[right_min] + _b[lright_min])/(1-_b[lbd1yr])
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
replace scenario = . if scenario > 2
gen scenario2 = scenario+.2
replace scenario = 0.5 in 3 // pad
replace scenario = 2.5 in 4 // pad

twoway rspike sr_effect_ll sr_effect_ul scenario, horizontal lcolor(black) lwidth(medthin) || rspike lr_effect_ll lr_effect_ul scenario2, lcolor(black) horizontal lwidth(medthin) || rspike sr_effect_ll90 sr_effect_ul90 scenario, horizontal lcolor(black) lwidth(medthick) || rspike lr_effect_ll90 lr_effect_ul90 scenario2, lcolor(black) horizontal lwidth(medthick) || scatter scenario sr_effect, msymbol(T) mcolor("27 158 119") msize(med) || scatter scenario2 lr_effect, msymbol(O) mcolor("117 112 179") msize(med) xline(0, lcolor(black) lpattern(solid))  ///
ylabel(1 "Left Maj -> Right Maj" 2 "Left Min -> Right Min", angle(0) labsize(small)) legend(order(5 "Short-Run" 6 "Long-Run")) xtitle("Effect") 
*graph export "final-figures/chapter 5/chapter5_budvol_lefttorightinteraction.pdf", as(pdf) replace
* --------------------------------------------------------------------



* --------------------------------------------------------------------
*		Table 5.3
* --------------------------------------------------------------------
* Row 1: Expenditures
xtunitroot ips expense_nov18, 
xtunitroot ips expense_nov18, lags(1)
xtunitroot ips expense_nov18, lags(2)

xtunitroot fisher expense_nov18, dfuller lags(1)
xtunitroot fisher expense_nov18, dfuller lags(2)
xtunitroot fisher expense_nov18, dfuller lags(3)

xtunitroot fisher expense_nov18, pperron lags(1)
xtunitroot fisher expense_nov18, pperron lags(2)
xtunitroot fisher expense_nov18, pperron lags(3)

xtunitroot ips expense_nov18, trend
xtunitroot ips expense_nov18, lags(1) trend
xtunitroot ips expense_nov18, lags(2) trend

xtunitroot fisher expense_nov18, dfuller lags(1) trend
xtunitroot fisher expense_nov18, dfuller lags(2) trend
xtunitroot fisher expense_nov18, dfuller lags(3) trend

xtunitroot fisher expense_nov18, pperron lags(1) trend
xtunitroot fisher expense_nov18, pperron lags(2) trend
xtunitroot fisher expense_nov18, pperron lags(3) trend

* Row 2: Revenues
xtunitroot ips revenue_nov18, 
xtunitroot ips revenue_nov18, lags(1)
xtunitroot ips revenue_nov18, lags(2)

xtunitroot fisher revenue_nov18, dfuller lags(1)
xtunitroot fisher revenue_nov18, dfuller lags(2)
xtunitroot fisher revenue_nov18, dfuller lags(3)

xtunitroot fisher revenue_nov18, pperron lags(1)
xtunitroot fisher revenue_nov18, pperron lags(2)
xtunitroot fisher revenue_nov18, pperron lags(3)

xtunitroot ips revenue_nov18, trend
xtunitroot ips revenue_nov18, lags(1) trend
xtunitroot ips revenue_nov18, lags(2) trend

xtunitroot fisher revenue_nov18, dfuller lags(1) trend
xtunitroot fisher revenue_nov18, dfuller lags(2) trend
xtunitroot fisher revenue_nov18, dfuller lags(3) trend

xtunitroot fisher revenue_nov18, pperron lags(1) trend
xtunitroot fisher revenue_nov18, pperron lags(2) trend
xtunitroot fisher revenue_nov18, pperron lags(3) trend

* Row 3: Deficit
*xtunitroot ips deficit_gdp, 		// Is NA
*xtunitroot ips deficit_gdp, lags(1)
*xtunitroot ips deficit_gdp, lags(2)

xtunitroot fisher deficit_gdp, dfuller lags(1)
xtunitroot fisher deficit_gdp, dfuller lags(2)
xtunitroot fisher deficit_gdp, dfuller lags(3)

xtunitroot fisher deficit_gdp, pperron lags(1)
xtunitroot fisher deficit_gdp, pperron lags(2)
xtunitroot fisher deficit_gdp, pperron lags(3)

*xtunitroot ips deficit_gdp, trend	// Is NA
*xtunitroot ips deficit_gdp, lags(1) trend
*xtunitroot ips deficit_gdp, lags(2) trend

xtunitroot fisher deficit_gdp, dfuller lags(1) trend
xtunitroot fisher deficit_gdp, dfuller lags(2) trend
xtunitroot fisher deficit_gdp, dfuller lags(3) trend

xtunitroot fisher deficit_gdp, pperron lags(1) trend
xtunitroot fisher deficit_gdp, pperron lags(2) trend
xtunitroot fisher deficit_gdp, pperron lags(3) trend

* Row 4: Budgetary Volatility
xtunitroot ips bd1yr, 
xtunitroot ips bd1yr, lags(1)
xtunitroot ips bd1yr, lags(2)

xtunitroot fisher bd1yr, dfuller lags(1)
xtunitroot fisher bd1yr, dfuller lags(2)
xtunitroot fisher bd1yr, dfuller lags(3)

xtunitroot fisher bd1yr, pperron lags(1)
xtunitroot fisher bd1yr, pperron lags(2)
xtunitroot fisher bd1yr, pperron lags(3)

xtunitroot ips bd1yr, trend
xtunitroot ips bd1yr, lags(1) trend
xtunitroot ips bd1yr, lags(2) trend

xtunitroot fisher bd1yr, dfuller lags(1) trend
xtunitroot fisher bd1yr, dfuller lags(2) trend
xtunitroot fisher bd1yr, dfuller lags(3) trend

xtunitroot fisher bd1yr, pperron lags(1) trend
xtunitroot fisher bd1yr, pperron lags(2) trend
xtunitroot fisher bd1yr, pperron lags(3) trend
* --------------------------------------------------------------------



* --------------------------------------------------------------------
*		Table 5.4
* --------------------------------------------------------------------
* p. 192: choose number of lags and instruments
pvarsoc zdexpense zdrevenue zddeficit zbd1yr, exog(zgrowth zunemp zdopenness zADR_nov18 legelec zhost year right majoritygovt) maxlag(4) pinstl(1/5) // choose p = 2
pvar zdexpense zdrevenue zddeficit zbd1yr, exog(zgrowth zunemp zdopenness zADR_nov18 legelec zhost year right majoritygovt) overid instlags(1/3) lags(2) gmmstyle
* --------------------------------------------------------------------


* --------------------------------------------------------------------
*		Figure 5.11
* --------------------------------------------------------------------
pvarstable, graph // stable
*graph export "final-figures/chapter 5/pVAR_stability.pdf", as(pdf) replace
* --------------------------------------------------------------------


* --------------------------------------------------------------------
*		Table 5.5
* --------------------------------------------------------------------
pvargranger // Granger causality table
* --------------------------------------------------------------------


* --------------------------------------------------------------------
*		Figure 5.12
* --------------------------------------------------------------------
 * OIRF for Expenditures
pvarirf, oirf porder(zdexpense zdrevenue zddeficit zbd1yr) mc(500) step(8) impulse(zdexpense) save("temp1", replace) nodraw level(95)
pvarirf, oirf porder(zdexpense zdrevenue zddeficit zbd1yr) mc(500) step(8) impulse(zdexpense) save("temp2", replace) nodraw level(90)
pvarirf, oirf porder(zdexpense zddeficit zdrevenue zbd1yr) mc(500) step(8) impulse(zdexpense) save("temp3", replace) nodraw level(95)
pvarirf, oirf porder(zdexpense zddeficit zdrevenue zbd1yr) mc(500) step(8) impulse(zdexpense) save("temp4", replace) nodraw level(90)
preserve
use temp1.dta, clear
rename irf irf_co1
rename ll ll_95_co1
rename ul ul_95_co1
joinby _step impres using "temp2.dta", unmatched(both)
drop _merge
rename ll ll_90_co1
rename ul ul_90_co1
drop irf
decode impres, generate(shock)
joinby _step impres using "temp3.dta", unmatched(both)
drop _merge
rename irf irf_co2
rename ll ll_95_co2
rename ul ul_95_co2
joinby _step impres using "temp4.dta", unmatched(both)
drop _merge
rename ll ll_90_co2
rename ul ul_90_co2 
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zdexpense : zdexpense", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zdexpense : zdexpense", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zdexpense : zdexpense", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zdexpense : zdexpense", color(red%60) || line irf_co2 _step if shock == "zdexpense : zdexpense", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zdexpense : zdexpense", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Expenditures")
graph save g1.gph, replace
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zdexpense : zdrevenue", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zdexpense : zdrevenue", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zdexpense : zdrevenue", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zdexpense : zdrevenue", color(red%60) || line irf_co2 _step if shock == "zdexpense : zdrevenue", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zdexpense : zdrevenue", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Revenues")
graph save g2.gph, replace
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zdexpense : zddeficit", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zdexpense : zddeficit", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zdexpense : zddeficit", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zdexpense : zddeficit", color(red%60) || line irf_co2 _step if shock == "zdexpense : zddeficit", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zdexpense : zddeficit", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Deficit")
graph save g3.gph, replace
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zdexpense : zbd1yr", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zdexpense : zbd1yr", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zdexpense : zbd1yr", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zdexpense : zbd1yr", color(red%60) || line irf_co2 _step if shock == "zdexpense : zbd1yr", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zdexpense : zbd1yr", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Budgetary Volatility")
graph save g4.gph, replace
graph combine g1.gph g2.gph g3.gph g4.gph, rows(2) ycommon
*graph export "final-figures/chapter 5/pvar-OIRF-expenditure.pdf", as(pdf) replace
restore
* --------------------------------------------------------------------


* --------------------------------------------------------------------
*		Figure 5.13
* --------------------------------------------------------------------
* OIRF for Revenues
pvarirf, oirf porder(zdexpense zdrevenue zddeficit zbd1yr) mc(500) step(8) impulse(zdrevenue) save("temp1", replace) nodraw level(95)
pvarirf, oirf porder(zdexpense zdrevenue zddeficit zbd1yr) mc(500) step(8) impulse(zdrevenue) save("temp2", replace) nodraw level(90)
pvarirf, oirf porder(zdexpense zddeficit zdrevenue zbd1yr) mc(500) step(8) impulse(zdrevenue) save("temp3", replace) nodraw level(95)
pvarirf, oirf porder(zdexpense zddeficit zdrevenue zbd1yr) mc(500) step(8) impulse(zdrevenue) save("temp4", replace) nodraw level(90)
preserve
use temp1.dta, clear
rename irf irf_co1
rename ll ll_95_co1
rename ul ul_95_co1
joinby _step impres using "temp2.dta", unmatched(both)
drop _merge
rename ll ll_90_co1
rename ul ul_90_co1
drop irf
decode impres, generate(shock)
joinby _step impres using "temp3.dta", unmatched(both)
drop _merge
rename irf irf_co2
rename ll ll_95_co2
rename ul ul_95_co2
joinby _step impres using "temp4.dta", unmatched(both)
drop _merge
rename ll ll_90_co2
rename ul ul_90_co2 
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zdrevenue : zdexpense", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zdrevenue : zdexpense", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zdrevenue : zdexpense", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zdrevenue : zdexpense", color(red%60) || line irf_co2 _step if shock == "zdrevenue : zdexpense", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zdrevenue : zdexpense", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Expenditures")
graph save g1.gph, replace
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zdrevenue : zdrevenue", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zdrevenue : zdrevenue", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zdrevenue : zdrevenue", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zdrevenue : zdrevenue", color(red%60) || line irf_co2 _step if shock == "zdrevenue : zdrevenue", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zdrevenue : zdrevenue", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Revenues")
graph save g2.gph, replace
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zdrevenue : zddeficit", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zdrevenue : zddeficit", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zdrevenue : zddeficit", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zdrevenue : zddeficit", color(red%60) || line irf_co2 _step if shock == "zdrevenue : zddeficit", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zdrevenue : zddeficit", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Deficit")
graph save g3.gph, replace
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zdrevenue : zbd1yr", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zdrevenue : zbd1yr", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zdrevenue : zbd1yr", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zdrevenue : zbd1yr", color(red%60) || line irf_co2 _step if shock == "zdrevenue : zbd1yr", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zdrevenue : zbd1yr", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Budgetary Volatility")
graph save g4.gph, replace
graph combine g1.gph g2.gph g3.gph g4.gph, rows(2) ycommon
*graph export "final-figures/chapter 5/pvar-OIRF-revenue.pdf", as(pdf) replace
restore
* --------------------------------------------------------------------


* --------------------------------------------------------------------
*		Figure 5.14
* --------------------------------------------------------------------
* OIRF for deficit
pvarirf, oirf porder(zdexpense zdrevenue zddeficit zbd1yr) mc(500) step(8) impulse(zddeficit) save("temp1", replace) nodraw level(95)
pvarirf, oirf porder(zdexpense zdrevenue zddeficit zbd1yr) mc(500) step(8) impulse(zddeficit) save("temp2", replace) nodraw level(90)
pvarirf, oirf porder(zdexpense zddeficit zdrevenue zbd1yr) mc(500) step(8) impulse(zddeficit) save("temp3", replace) nodraw level(95)
pvarirf, oirf porder(zdexpense zddeficit zdrevenue zbd1yr) mc(500) step(8) impulse(zddeficit) save("temp4", replace) nodraw level(90)
preserve
use temp1.dta, clear
rename irf irf_co1
rename ll ll_95_co1
rename ul ul_95_co1
joinby _step impres using "temp2.dta", unmatched(both)
drop _merge
rename ll ll_90_co1
rename ul ul_90_co1
drop irf
decode impres, generate(shock)
joinby _step impres using "temp3.dta", unmatched(both)
drop _merge
rename irf irf_co2
rename ll ll_95_co2
rename ul ul_95_co2
joinby _step impres using "temp4.dta", unmatched(both)
drop _merge
rename ll ll_90_co2
rename ul ul_90_co2 
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zddeficit : zdexpense", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zddeficit : zdexpense", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zddeficit : zdexpense", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zddeficit : zdexpense", color(red%60) || line irf_co2 _step if shock == "zddeficit : zdexpense", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zddeficit : zdexpense", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Expenditures")
graph save g1.gph, replace
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zddeficit : zdrevenue", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zddeficit : zdrevenue", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zddeficit : zdrevenue", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zddeficit : zdrevenue", color(red%60) || line irf_co2 _step if shock == "zddeficit : zdrevenue", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zddeficit : zdrevenue", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Revenues")
graph save g2.gph, replace
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zddeficit : zddeficit", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zddeficit : zddeficit", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zddeficit : zddeficit", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zddeficit : zddeficit", color(red%60) || line irf_co2 _step if shock == "zddeficit : zddeficit", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zddeficit : zddeficit", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Deficit")
graph save g3.gph, replace
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zddeficit : zbd1yr", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zddeficit : zbd1yr", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zddeficit : zbd1yr", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zddeficit : zbd1yr", color(red%60) || line irf_co2 _step if shock == "zddeficit : zbd1yr", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zddeficit : zbd1yr", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Budgetary Volatility")
graph save g4.gph, replace
graph combine g1.gph g2.gph g3.gph g4.gph, rows(2) ycommon
*graph export "final-figures/chapter 5/pvar-OIRF-deficit.pdf", as(pdf) replace
restore
* --------------------------------------------------------------------



* --------------------------------------------------------------------
*		Figure 5.15
* --------------------------------------------------------------------
* OIRF for budgetary change
pvarirf, oirf porder(zdexpense zdrevenue zddeficit zbd1yr) mc(500) step(8) impulse(zbd1yr) save("temp1", replace) nodraw level(95)
pvarirf, oirf porder(zdexpense zdrevenue zddeficit zbd1yr) mc(500) step(8) impulse(zbd1yr) save("temp2", replace) nodraw level(90)
pvarirf, oirf porder(zdexpense zddeficit zdrevenue zbd1yr) mc(500) step(8) impulse(zbd1yr) save("temp3", replace) nodraw level(95)
pvarirf, oirf porder(zdexpense zddeficit zdrevenue zbd1yr) mc(500) step(8) impulse(zbd1yr) save("temp4", replace) nodraw level(90)
preserve
use temp1.dta, clear
rename irf irf_co1
rename ll ll_95_co1
rename ul ul_95_co1
joinby _step impres using "temp2.dta", unmatched(both)
drop _merge
rename ll ll_90_co1
rename ul ul_90_co1
drop irf
decode impres, generate(shock)
joinby _step impres using "temp3.dta", unmatched(both)
drop _merge
rename irf irf_co2
rename ll ll_95_co2
rename ul ul_95_co2
joinby _step impres using "temp4.dta", unmatched(both)
drop _merge
rename ll ll_90_co2
rename ul ul_90_co2 
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zbd1yr : zdexpense", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zbd1yr : zdexpense", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zbd1yr : zdexpense", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zbd1yr : zdexpense", color(red%60) || line irf_co2 _step if shock == "zbd1yr : zdexpense", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zbd1yr : zdexpense", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Expenditures")
graph save g1.gph, replace
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zbd1yr : zdrevenue", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zbd1yr : zdrevenue", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zbd1yr : zdrevenue", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zbd1yr : zdrevenue", color(red%60) || line irf_co2 _step if shock == "zbd1yr : zdrevenue", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zbd1yr : zdrevenue", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Revenues")
graph save g2.gph, replace
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zbd1yr : zddeficit", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zbd1yr : zddeficit", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zbd1yr : zddeficit", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zbd1yr : zddeficit", color(red%60) || line irf_co2 _step if shock == "zbd1yr : zddeficit", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zbd1yr : zddeficit", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Change in Deficit")
graph save g3.gph, replace
twoway rarea ll_95_co1 ul_95_co1 _step if shock == "zbd1yr : zbd1yr", color(blue%30)  || rarea ll_90_co1 ul_90_co1 _step if shock == "zbd1yr : zbd1yr", color(blue%60) || rarea ll_95_co2 ul_95_co2 _step if shock == "zbd1yr : zbd1yr", color(red%30)  || rarea ll_90_co2 ul_90_co2 _step if shock == "zbd1yr : zbd1yr", color(red%60) || line irf_co2 _step if shock == "zbd1yr : zbd1yr", lwidth(medthick) lpattern(dash) lcolor(black) || line irf_co1 _step if shock == "zbd1yr : zbd1yr", lwidth(medthick) yline(0) lcolor(black) yline(0) lcolor(black) legend(off) xtitle("Year") ytitle("Response") title("Budgetary Volatility")
graph save g4.gph, replace
graph combine g1.gph g2.gph g3.gph g4.gph, rows(2) ycommon
*graph export "final-figures/chapter 5/pvar-OIRF-budgetchange.pdf", as(pdf) replace
restore
* --------------------------------------------------------------------
