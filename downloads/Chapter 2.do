*
*
* Chapter 2.do
* Last updated: 2/16/23
* -----------------------------------------------------------------------------

set scheme burd
set more off
set seed 90939284

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
xtset

* get sumstats for not missing (for expenditures):
gen tabbb_exp = 1
foreach var of varlist socialp_house recr_house health_house edu_house econaff_house defense_house pubserv_house growth dSOP dunemployment dopenness ADR_nov18 deficit_gdp sop_exp_nov18 majoritygovt right legelec total_hostlev unemployment {
	replace tabbb_exp = 0 if `var' == .
}

* -----------------------------------------------------------------------------
** Fig 2.1: Economic Affairs spending as a percentage of Total Expenditures in 5 nations, 1975-2010
* -----------------------------------------------------------------------------
* Economic Affairs plot across 5 countries
twoway (connected i_econaffairs_comb_pie year if CountryName=="Austria" & year >= 1975 & year <= 2010, msize(small) msymbol(none) lwidth(medthin) lpattern(solid)) ///
	(connected i_econaffairs_comb_pie year if CountryName=="Denmark" & year >= 1975 & year <= 2010, msize(small) msymbol(none) lwidth(medthin) lpattern(dash)) ///
	(connected i_econaffairs_comb_pie year if CountryName=="France" & year >= 1975 & year <= 2010, msize(small) msymbol(none) lwidth(medthin) lpattern(dash_dot)) ///
	(connected i_econaffairs_comb_pie year if CountryName=="Sweden" & year >= 1975 & year <= 2010, msize(small) msymbol(T) lwidth(medthin) lpattern(solid)) ///
	(connected i_econaffairs_comb_pie year if CountryName=="United Kingdom" & year >= 1975 & year <= 2010, msize(small) msymbol(O) lwidth(medthin)) ///
	, xlabel(1975(5)2010, labsize(small))  xtitle("  ") ///
	legend(position(12) ring(0) rows(1) symxsize(*1.5) size(small) order(1 "Austria" 2 "Denmark" 3 "France" 4 "Sweden" 5 "United Kingdom")) ///
	ytitle("Percentage of Total Expenditures", size(small) orientation(vertical))
*graph export "final-figures/chapter 2/Ch2_Des5Country_exp_economicaffairs.pdf", replace
* -----------------------------------------------------------------------------



* -----------------------------------------------------------------------------
** Fig 2.2: Measuring distributions of budgetary changes
* -----------------------------------------------------------------------------
* Fig 2.2a: 
twoway (connected expense_nov18 year if CountryName=="Denmark" & year >= 1975 & year <= 2010, msymbol(none) msize(vsmall) lpattern(solid) lwidth(medthick)) ///
		(connected expense_nov18 year if CountryName=="Spain" & year >= 1975 & year <= 2010, msymbol(none) msize(vsmall) lpattern(dash) lwidth(medthick)) ///
,   xlabel(1975(5)2010, labsize(small))  xtitle("  ") ///
	legend(position(3) ring(0) cols(1) size(small) order(1 "Denmark" 2 "Spain" )) ///
	ytitle("Total Expenditures as a Percentage of GDP", size(small) orientation(vertical))
*graph export "${path}/Lipsmeyer_Philips_Whitten/Cambridge Book Project/book/figures/Ch2_DenmarkSpainTotalSpending.pdf", as(pdf) replace

* Fig 2.2b	
gen dexpense = d.expense_nov18
su dexpense if CountryName=="Spain" & tabbb_exp == 1, det // obtain kurtosis values
su dexpense if CountryName=="Denmark" & tabbb_exp == 1, det
twoway (histogram dexpense if CountryName=="Denmark" & tabbb_exp == 1, bin(20)) (function y=normalden(x), range(-10 10) lwidth(thick)) ///
	, legend(off) ///
	ytitle("Density", size(small) orientation(vertical)) ///
	xtitle("Percent Change" "  " "kurtosis=3.91", size(small)) ///
	title("Denmark") saving(ChTotSpHist_Denmark, replace)

twoway (histogram dexpense if CountryName=="Spain" & tabbb_exp == 1, bin(20)) (function y=normalden(x), range(-10 10) lwidth(thick)) ///
		, legend(off) ///
		ytitle("Density", size(small) orientation(vertical)) ///
		xtitle("Percent Change" "  " "kurtosis=12.36", size(small)) ///
		title("Spain") saving(ChTotSpHist_Spain, replace)

graph combine ChTotSpHist_Denmark.gph ChTotSpHist_Spain.gph, cols(1)
*graph export "${path}/Lipsmeyer_Philips_Whitten/Cambridge Book Project/book/figures/Ch2_ChTotSpHist_DenmarkSpain.pdf", as(pdf) replace
* -----------------------------------------------------------------------------



* -----------------------------------------------------------------------------
** Fig 2.3: UK categorical spending and budgetary change measures
* -----------------------------------------------------------------------------
* Fig 2.3a
twoway connected i_publicservices_comb_pie year if CountryName == "United Kingdom" & tabbb_exp==1, lpattern(solid) msymbol(T) msize(small) lwidth(medthin) || ///
	connected i_defense_comb_pie year if CountryName == "United Kingdom" & tabbb_exp==1, lpattern(dash) msymbol(none) msize(small) lwidth(medthin) || ///
	connected i_econaffairs_comb_pie year if CountryName == "United Kingdom" & tabbb_exp==1, lpattern(solid) msymbol(none)  msize(small) lwidth(medthin) || ///
	connected i_education_comb_pie year if CountryName == "United Kingdom" & tabbb_exp==1, lpattern(dash_dot) msymbol(none)  msize(small) lwidth(medthin) || ///
	connected i_health_comb_pie year if CountryName == "United Kingdom" & tabbb_exp==1, lpattern(shortdash) msymbol(none)  msize(small) lwidth(medthin) || ///
	connected i_recreation_comb_pie year if CountryName == "United Kingdom" & tabbb_exp==1, lpattern(shortdash_dot) msymbol(none)  msize(small) lwidth(medthin) || ///
	connected i_socialprotection_comb_pie year if CountryName == "United Kingdom" & tabbb_exp==1, lpattern(solid) msymbol(S)  msize(small) lwidth(medthin) || ///
	connected i_housing_comb_pie year if CountryName == "United Kingdom" & tabbb_exp==1, msymbol(longdash_dot) msize(small) lwidth(medthin) xlabel(1975(5)2010, labsize(small)) legend(symxsize(*1.5) position(12) cols(4) size(small) order(1 "Govt. Administration" 2 "Defense" 3 "Economic Affairs" 4 "Education" 5 "Health" 6 "Religion & Culture" 7 "Social Protection" 8 "Housing")) xtitle("  ")  ///
	ytitle("Budget Percentage", size(small) orientation(vertical)) 
*graph export "${path}/Lipsmeyer_Philips_Whitten/Cambridge Book Project/book/figures/Ch2_DesUKexp.pdf", as(pdf) replace

* Fig 2.3b
twoway connected bd1yr year if CountryName=="United Kingdom" & tabbb_exp==1 & year>1975, msize(small) msymbol(none) lpattern(solid) lwidth(medthick) || ///
       connected bd4yr year if CountryName=="United Kingdom" & tabbb_exp==1 & year>1978, msize(small) msymbol(none) lpattern(dash) lwidth(medthick) ///
	   xlabel(1975(5)2010, labsize(small)) legend(position(1) symxsize(*2) ring(0) cols(1) size(small) order(1 "1 year change" 2 "4 year change" )) xtitle("  ")  ///
	ytitle("Brender & Drazen Change Measures", size(small) orientation(vertical))
*graph export "${path}/Lipsmeyer_Philips_Whitten/Cambridge Book Project/book/figures/Ch2_BrDrUKexp.pdf", as(pdf) replace
* -----------------------------------------------------------------------------



* -----------------------------------------------------------------------------
** Fig 2.4: An illustration of budgetary components in Finland
* -----------------------------------------------------------------------------
* Fig 2.4a
twoway line expense_nov18 year if CountryName == "Finland" & year >= 1975 & year <= 2010, lwidth(medthick) || ///
	line revenue_nov18 year if CountryName == "Finland" & year >= 1975 & year <= 2010, lwidth(medthick) lpattern(dash) ytitle("% of GDP") ///
	xtitle("Year")  xlabel(1975(5)2010) legend(order(1 "Expenditures" 2 "Revenues") rows(1))
*graph export "${path}/Lipsmeyer_Philips_Whitten/Cambridge Book Project/book/figures/Ch2_finland_revexpplot.pdf", as(pdf) replace

* Fig 2.4a
twoway line deficit_gdp year if CountryName == "Finland" & year >= 1975 & year <= 2010, ///
	lwidth(medthick) lpattern(dotdash) lcolor(green) ytitle("% of GDP") ///
	xtitle("Year") xlabel(1975(5)2010) yline(0, lcolor(black) ///
	lpattern(solid) lwidth(medthin)) ylabel(-5(5)20, format("%2.0f"))
*graph export "${path}/Lipsmeyer_Philips_Whitten/Cambridge Book Project/book/figures/Ch2_finland_debtplot.pdf", as(pdf) replace
* -----------------------------------------------------------------------------



* -----------------------------------------------------------------------------
** Fig 2.8: Interconnected budgetary components in Finland
* -----------------------------------------------------------------------------
twoway line bd1yr year if CountryName == "Finland" & year >= 1975 & year <= 2010, ///
	lwidth(medthick) lpattern(dot) lcolor(black) ///
	ytitle("Budgetary Volatility") xtitle("Year") xlabel(1975(5)2010) ///
	lpattern(solid) lwidth(medthick) saving(Ch2_finland_exchplot4, replace)

twoway line deficit_gdp year if CountryName == "Finland" & year >= 1975 & year <= 2010, ///
	lwidth(medthick) lpattern(dotdash) lcolor(green) ///
	ytitle("Budget Deficit (% of GDP)") xtitle("Year") xlabel(1975(5)2010) ///
	yline(0, lcolor(black) lpattern(solid) lwidth(medthin)) ///
	ylabel(-5(5)20, format("%2.0f")) saving(Ch2_finland_debtplot4, replace)

twoway line revenue_nov18 year if CountryName == "Finland" & year >= 1975 & year <= 2010, ///
	lwidth(medthick) lcolor(red) ytitle("Revenues (% of GDP)") ///
	xtitle("Year") xlabel(1975(5)2010) saving(Ch2_finland_revplot4, replace)

twoway line expense_nov18 year if CountryName == "Finland" & year >= 1975 & year <= 2010, ///
	lwidth(medthick) ytitle("Expenditures(% of GDP)") xtitle("Year") ///
	xlabel(1975(5)2010) saving(Ch2_finland_expplot4, replace) 

graph combine Ch2_finland_exchplot4.gph  Ch2_finland_expplot4.gph Ch2_finland_debtplot4.gph Ch2_finland_revplot4.gph, rows(2)
*graph export "${path}/Lipsmeyer_Philips_Whitten/Cambridge Book Project/book/figures/Ch2_finland_4plot.pdf", as(pdf) replace
* -----------------------------------------------------------------------------



* -----------------------------------------------------------------------------
** Table 2.2: Country-year coverage
* -----------------------------------------------------------------------------
* Expenditure column:
qui reg expense_nov18 revenue_nov18 bd1yr deficit_gdp growth unemployment openness ADR_nov18 legelec right majoritygovt total_hostlev
sort CountryName year
bysort CountryName: list year if e(sample)
bysort CountryName: su year if e(sample)

* Revenue column:
qui reg revenue_nov18 expense_nov18 deficit_gdp growth unemployment openness ADR_nov18 legelec total_hostlev bd1yr right majoritygovt 
sort CountryName year
bysort CountryName: list year if e(sample)
bysort CountryName: su year if e(sample)

* Deficit column:
qui reg deficit_gdp growth unemployment openness expense_nov18 revenue_nov18 ADR_nov18 legelec total_hostlev bd1yr right majoritygovt 
sort CountryName year
bysort CountryName: list year if e(sample)
bysort CountryName: su year if e(sample)
* -----------------------------------------------------------------------------




