/*
This dofile accompanies the article:
	"Social ties in old age: the effect of the COVID-19 pandemic" 
	by Ashira Menashe-Oren, · Damiano Uccheddu, and · Ester Lucia Rizzi
	published in the European Journal of Ageing (2025) 
	https://doi.org/10.1007/s10433-025-00889-3
*/	

// Analysis relies on the Survey of Health, Ageing and Retirement in Europe (SHARE) data with waves of social network modules (SN) 

///////////////////////////////////////////////////////////////////////////////////////

// combining data files //


/// wave 4 ///
* open cover module cv_r
use "share 4\sharew4_rel8-0-0_cv_r.dta", clear 
gen wave = 4

** Merge modules in wave 4
*demographics module dn
merge 1:1 mergeid using "share 4\sharew4_rel8-0-0_dn.dta"  
keep if _merge == 3
drop _merge 

*social networks module  sn
merge 1:1 mergeid using "share 4\sharew4_rel8-0-0_sn.dta"
keep if _merge == 3
drop _merge 

*employment module ep
merge 1:1 mergeid using "share 4\sharew4_rel8-0-0_ep.dta"
keep if _merge == 3
drop _merge 

*social support (partly responded on by family member)
merge 1:1 mergeid using "share 4\sharew4_rel8-0-0_sp.dta"
keep if _merge == 3
drop _merge 

*housing ho (this is answered by HH respondent)
merge 1:1 mergeid using "share 4\sharew4_rel8-0-0_ho.dta"
keep if _merge == 3
drop _merge 

save "share 4\wave4.dta", replace


// wave 6 ///
* open cover module cv_r
use "share 6\sharew6_rel8-0-0_cv_r.dta", clear 
gen wave = 6

** Merge modules in wave 6
*demographics module dn
merge 1:1 mergeid using "share 6\sharew6_rel8-0-0_dn.dta"  
keep if _merge == 3
drop _merge 

*social networks module  sn
merge 1:1 mergeid using "share 6\sharew6_rel8-0-0_sn.dta"
keep if _merge == 3
drop _merge 

*employment module ep
merge 1:1 mergeid using "share 6\sharew6_rel8-0-0_ep.dta"
keep if _merge == 3
drop _merge 

*social support (partly responded on by family member)
merge 1:1 mergeid using "share 6\sharew6_rel8-0-0_sp.dta"
keep if _merge == 3
drop _merge 

*housing ho (this is answered by HH respondent)
merge 1:1 mergeid using "share 6\sharew6_rel8-0-0_ho.dta"
keep if _merge == 3
drop _merge 

save "share 6\wave6.dta", replace



********
// wave 8 ///
* open cover module cv_r
use "share 8\sharew8_rel8-0-0_cv_r.dta", clear 
gen wave = 8

** Merge modules in wave 8
*demographics module dn
merge 1:1 mergeid using "share 8\sharew8_rel8-0-0_dn.dta"  
keep if _merge == 3
drop _merge 

*social networks module  sn
merge 1:1 mergeid using "share 8\sharew8_rel8-0-0_sn.dta"
keep if _merge == 3
drop _merge 

*employment module ep
merge 1:1 mergeid using "share 8\sharew8_rel8-0-0_ep.dta"
keep if _merge == 3
drop _merge 

*social support (partly responded on by family member)
merge 1:1 mergeid using "share 8\sharew8_rel8-0-0_sp.dta"
keep if _merge == 3
drop _merge 

*housing ho (this is answered by HH respondent)
merge 1:1 mergeid using "share 8\sharew8_rel8-0-0_ho.dta"
keep if _merge == 3
drop _merge 

save "share 8\wave8.dta", replace

********
// wave 9 ///
* open cover module cv_r
use "share 9\sharew9_rel9-0-0_cv_r.dta", clear 
gen wave = 9

** Merge modules in wave 9
*demographics module dn
merge 1:1 mergeid using "share 9\sharew9_rel9-0-0_dn.dta"  
keep if _merge == 3
drop _merge 

*social networks module  sn
merge 1:1 mergeid using "share 9\sharew9_rel9-0-0_sn.dta"
keep if _merge == 3
drop _merge 

*employment module ep
merge 1:1 mergeid using "share 9\sharew9_rel9-0-0_ep.dta"
keep if _merge == 3
drop _merge 

*social support (partly responded on by family member)
merge 1:1 mergeid using "share 9\sharew9_rel9-0-0_sp.dta"
keep if _merge == 3
drop _merge 

*housing  (this is answered by HH respondent)
merge 1:1 mergeid using "share 9\sharew9_rel9-0-0_ho.dta"
keep if _merge == 3
drop _merge 

save "share 9\wave9.dta", replace


*************************
// append waves

use "share 4\wave4.dta", clear
append using "share 6\wave6.dta"
append using "share 8\wave8.dta"
append using "share 9\wave9.dta"

save "SHARE_combined.dta", replace

**************************

// add SHARE generated variables 

use "share 4\sharew4_rel8-0-0_gv_networks.dta", clear
gen wave=4
append using "share 6\sharew6_rel8-0-0_gv_networks.dta" ,gen(ap6) 
replace wave=6 if wave!=4 & ap6==1
append using "share 8\sharew8_rel8-0-0_gv_networks.dta" ,gen(ap8) 
replace wave=8 if wave==. & ap8==1
append using "share 9\sharew9_rel9-0-0_gv_networks.dta" ,gen(ap9) 
replace wave=9 if wave==. & ap9==1
save "generated_networks_combined.dta", replace 

merge 1:1  wave mergeid using "SHARE_combined.dta"
drop _merge

save "SHARE_networks.dta", replace


// add weights 

use "share 4\sharew4_rel8-0-0_gv_weights.dta", clear
gen wave=4
append using "share 6\sharew6_rel8-0-0_gv_weights.dta" ,gen(ap6)
replace wave=6 if wave!=4 & ap6==1
append using "share 8\sharew8_rel8-0-0_gv_weights.dta" ,gen(ap8)
replace wave=8 if wave==. & ap8==1
append using "share 9\sharew9_rel9-0-0_gv_weights.dta" ,gen(ap9)
replace wave=9 if wave==. & ap9==1

merge 1:1  wave mergeid using "SHARE_networks.dta"
drop _merge

save "SHARE_networks.dta", replace

// add imputed variables of education & marital status
//note: for multiple imputation, individual's missing data is imputed 5 times (implicat), so these can be used directly in analysis (mi commands in stata), or can use themean of the imputed variables if continuous

use "share 4\sharew4_rel8-0-0_gv_imputations.dta" , clear
gen wave=4
append using "share 6\sharew6_rel8-0-0_gv_imputations.dta" ,gen(ap6)
replace wave=6 if wave!=4 & ap6==1
append using "share 8\sharew8_rel8-0-0_gv_imputations.dta" ,gen(ap8)
replace wave=8 if wave==. & ap8==1
append using "share 9\sharew9_rel9-0-0_gv_imputations.dta" ,gen(ap9)
replace wave=9 if wave==. & ap9==1

*to keep only one observation per individual - mean of imputations 
bys mergeid: egen yrsedu_imputedmean =mean(yedu)
bys mergeid: egen martialstatus_imputedmean =mode(mstat)
lab val martialstatus_imputedmean mstat

keep if implicat==1

keep wave mergeid martialstatus_imputedmean yrsedu_imputedmean
duplicates drop
merge 1:1  wave mergeid using "SHARE_networks.dta"
drop _merge

save "SHARE_networks.dta", replace


// add info on housing (city/town/rural and living arrangements for elderly)

use "share 4\sharew4_rel8-0-0_gv_housing.dta" ,clear
gen wave=4
append using "share 6\sharew6_rel8-0-0_gv_housing.dta" ,gen(ap6)
replace wave=6 if wave!=4 & ap6==1
append using "share 8\sharew8_rel8-0-0_gv_housing.dta" ,gen(ap8)
replace wave=8 if wave==. & ap8==1
append using "share 9\sharew9_rel9-0-0_gv_housing.dta" ,gen(ap9)
replace wave=9 if wave==. & ap9==1

keep wave mergeid typebldgi areabldgi
merge 1:1  wave mergeid using "SHARE_networks.dta"
drop _merge

save "SHARE_networks.dta", replace


// adding info on chronic conditions

use "share 4\sharew4_rel8-0-0_gv_health.dta" , clear
gen wave=4
append using "share 6\sharew6_rel8-0-0_gv_health.dta" , gen(a6)
replace wave=6 if wave!=4 & a6==1
append using "share 8\sharew8_rel8-0-0_gv_health.dta" , gen(a8)
replace wave=8 if wave==. & a8==1
append using "share 9\sharew9_rel9-0-0_gv_health.dta" , gen(a9)
replace wave=9 if wave==. & a9==1

keep wave mergeid chronicw* 
merge 1:1  wave mergeid using "SHARE_networks.dta"
drop _merge

save "SHARE_networks.dta", replace

///////////////////////////////////////////////////////////////////////////////////////

// preparing data set for analysis //

use "SHARE_networks.dta",clear

** age of respondent 
replace age_int=. if age_int==-1  // dks of resp age considered missing
recode age_int (min/49 =1 "Under 50 yrs") (50/64=2 "50-64 yrs old") (65/79=3 "65-79 yrs old") (80/max=4 "80+ yrs old")  ,gen (age_gp )  

*** country- regions
/*
11	Austria
12	Germany
13	Sweden
14	Netherlands
15	Spain
16	Italy
17	France
18	Denmark
19	Greece
20	Switzerland
23	Belgium
25	Israel
28	Czech Republic
29	Poland
31	Luxembourg
32	Hungary
33	Portugal
34	Slovenia
35	Estonia
47	Croatia
48	Lithuania
51	Bulgaria
53	Cyprus
55	Finland
57	Latvia
59	Malta
61	Romania
63	Slovakia

countries with all 4 waves: austria, germany, sweden, spain, italy, france, denmark, switzerland, belgium, czech rep, poland, slovenia, estonia, croatia, 
countries without waves 4 or/& 6 or/& 8: greece,israel, luxemburg, hungary, portugal, netherlands
countries with waves 8 & 9 only: lithuania, bulgaria, cyprus, finland,  latvia, malta, romania, slovakia
*/

*region within europe
recode country (11 12 20 = 1 "Central-West") (13 18 55= 2 "Nordics") (14 17 23 31= 3 "North-West") (15 16 33 59 = 4 "South") (19 25 47 51 53= 5 "Balkans & Israel") (28 29 32 34 35 48 57 61 63= 6 "Central & Baltics") , gen(EUregion)
recode country (11 12 14 17 20 23 31= 1 "West") (13 18 35 48 55 57= 2 "North")  (15 16 19 25 33 34 47 53 59 = 3 "South") (28 29 32 51  61 63= 4 "East") , gen(EUregion4) // based on United Nations Geoscheme

*grouped by whether in all four waves or not
cap drop all_waves
recode country (11/13 15/18 20 23 28 29 34/46 =1) (14 19 25 31/33 47/63 =0) , gen(all_waves)

*individual weights 
gen weights= cciw_w4 
replace weights= cciw_w6 if wave==6
replace weights= cciw_w8_main if wave==8
replace weights= cciw_w9 if wave==9

****************************************

/// social networks ///

*** network size: up to 7
** person with whom discuss often  
*if yes- add to network size
cap drop network_size
gen network_size=1 if sn002a_1==1  //first person
forval i= 2/7 { 
	replace network_size=network_size+1 if sn002a_`i' ==1
	}
replace network_size=0 if sn002a_1==5 &  network_size==. // doesn't have first person named therefore size is zero

* size of network -share variables 
gen network_size_comb= sizeofsocialnetwork 
replace network_size_comb= sn_size_w6 if wave==6
replace network_size_comb= network_size if wave==6 & sn_size_w6==-9 //there are "does not apply" in size of wave 6 (11.2% of respondents) - replaced by my own estimate of size 
replace network_size_comb= sn_size_w8 if wave==8
replace network_size_comb= sn_size_w9 if wave==9


*** proportion of network that is female
* 1 male, 2 female -1 dk -2 refuse
cap drop count_fem
gen count_fem =(sn005a_1==2)
forval i= 2/7 { 
	replace count_fem=count_fem+1 if sn005a_`i' ==2
	}
	
egen noted_gender = rownonmiss(sn005a_2 sn005a_3 sn005a_1 sn005a_4 sn005a_5 sn005a_6 sn005a_7) // number of confidants with gender noted	
cap drop prop_network_fem
gen prop_network_fem= count_fem/noted_gender*100

*share variable of gender
recode womennet (min/-1=0) ,gen(num_fem)
gen female_net= num_fem/ network_size_comb
replace female_net=0 if num_fem==0 & network_size_comb==0
replace female_net=1 if  female_net>=1 & female_net!=.

*** avg age of network 
forval i= 1/7 { 
cap drop age_confidant_`i'
replace sn027_`i'=. if sn027_`i'<=0	
gen age_confidant_`i' = int_year - sn027_`i'
}

cap drop mean_age_confi
egen total_age_confi = rowtotal(age_confidant_1 age_confidant_2 age_confidant_3 age_confidant_4 age_confidant_5 age_confidant_6 age_confidant_7) 
egen noted_age = rownonmiss(age_confidant_1 age_confidant_2 age_confidant_3 age_confidant_4 age_confidant_5 age_confidant_6 age_confidant_7)  // number of confidants with ages
gen mean_age_confi = total_age_confi/noted_age
drop total_age_confi 

*age based on generated varaibles from share
forval i= 1/7 { 
cap drop age_conf_gv_`i'
replace year_`i'=. if year_`i'<=0 | year_`i'==99999	
gen age_conf_gv_`i' = int_year - year_`i'
}
egen total_age_confi_gv = rowtotal(age_conf_gv_1 age_conf_gv_2 age_conf_gv_3 age_conf_gv_4 age_conf_gv_5 age_conf_gv_6 age_conf_gv_7) 
gen avg_age_conf= total_age_confi_gv/network_size_comb


*** network relations - proportion family vs. non-kin
/*
								Refusal |   -2
                             Don't know |   -1
                         Spouse/Partner |   1
                                 Mother |   2
                                 Father |   3
                          Mother-in-law |   4
                          Father-in-law |   5
                             Stepmother |   6
                             Stepfather |   7
                                Brother |   8
                                 Sister |   9
                                  Child |   10
Step-child/your current partner's child |   11
                             Son-in-law |   12
                        Daughter-in-law |   13
                             Grandchild |   14
                            Grandparent |   15
                                   Aunt |   16
                                  Uncle |   17
                                  Niece |   18
                                 Nephew |   19
                         Other relative |   20
                                 Friend |   21
               (Ex-)colleague/co-worker |   22
                              Neighbour |   23
                      Ex-spouse/partner |   24
      Minister, priest, or other clergy |   25
 Therapist or other professional helper |   26
  Housekeeper/Home health care provider |   27
                          None of these |   96
*/

forval i= 1/7 { 
	cap drop confidant_relation_`i'
	recode sn005_`i'  (1=1 "Spouse/Partner") (2/20 =2 "Family") (21 = 3 "Friend") (22/27 = 4 "Other non-kin")  (96 = 5 "Other") (-1 -2=.), gen(	confidant_relation_`i')
}

* spouse in network
egen spouse= anymatch(confidant_relation_1 confidant_relation_2 confidant_relation_3 confidant_relation_4 confidant_relation_5 confidant_relation_6 confidant_relation_7) ,val(1)
replace spouse=. if sn_size_w6==-9 & spouse==0 & wave==6 // wave 6 missings

save SHARE_comb_network.dta, replace

///////////////////////////////////////////////////////////////////////////////////////

use "SHARE_comb_network.dta",clear  


****setting panel data 

** individual id needs to be numeric 
levelsof country, local(c) 
foreach i of local c {
	cap drop ind_`i'
	encode mergeid if country==`i', gen(ind_`i')  // done by country b/c otherwise error of too many values to encode
}
cap drop indID
egen indID= rowtotal(ind_11 ind_12 ind_13 ind_14 ind_15 ind_16 ind_17 ind_18 ind_19 ind_20 ind_23 ind_25 ind_28 ind_29 ind_31 ind_32 ind_33 ind_34 ind_35 ind_47 ind_48 ind_51 ind_53 ind_55 ind_57 ind_59 ind_61 ind_63), miss
gen temp="00"
cap drop ID
egen ID= concat(country  temp  indID)
destring ID, replace
drop temp
codebook ID // 123,789  unique IDs

bys ID wave: assert _N==1 // making sure unique ids for each panel
duplicates report ID wave // in case of duplicates - check 

xtset ID wave
sort ID wave

//countries in all waves
*grouped by whether in all four waves or not
cap drop all_waves
recode country (11/13 15/18 20 23 28 29 34/46 =1) (14 19 25 31/33 47/63 =0) , gen(all_waves)

// only countries wth 3+ waves 
*add netherlands 14, luxemburg 31, hungary 32 & greece 19, israel 25, croatia 47 to "all_waves" ; portugal 33 has 3 but not wave 8
gen three_waves=1 if country==14 | country==31 | country==32 | country==19 | country==25 | country==47 | country==33

keep if three_waves==1 | all_waves==1


******* inverse probability weights to account for attrition

*censored respondents - were in wave 4 and dropped out since (for any reason)
global model_cov "i.age_gp i.gender i.wave i.b3.residence i.b0.retired chronicN  i.country"

*identifying individuals in the sample
cap drop insample
quietly probit spouse $model_cov
gen insample=0
recode insample (0=1) if e(sample)

*variable counting number of waves each individual was observed in panel 
sort ID wave 
cap drop constant num_waves nextwave resp_allwaves
gen constant=1
by ID: egen num_waves =sum(constant) if insample==1
*indivated if individual was in next wave
sort ID wave 
by ID: gen nextwave = insample[_n+1] 
*indicator if individual was in all 4 waves  
gen resp_allwaves=.
recode resp_allwaves (.=0) if num_waves!=4 & all_waves==1
*recode resp_allwaves (.=0) if num_waves!=3 & three_waves==1
recode resp_allwaves (.=1) if num_waves ==4 & all_waves==1
*recode resp_allwaves (.=1) if num_waves==3 & three_waves==1


*logit model to get predicted values (probability of attrition) by wave
cap drop ipw* p_*
gen ipw=1 // ipw= invers probability weight - assume no weight needed

global model_cov2 "i.age_gp i.gender  i.b0.retired chronicN  i.country"  

foreach i in 6 8 9 {
	quietly logit insample  $model_cov2 if wave==`i' & all_waves==1
	predict p_`i' ,p
	gen ipw_`i'=1/p_`i'
	replace ipw=ipw_`i' if wave==`i'
}



/// social networks ///


************************************ lost and new members of network 

recode panel_new (min/-1=.), gen(new_members)
recode panel_lost (min/-1=.), gen(lost_members)

// reason lost confidant 
*** reasons lost members in network 

*number of reasons given per respondent 
egen count_reasons= rownonmiss(sn023c_* sn023_*)

* recoding into reduced categories 1=died, 2=health (of confidant/ego), 3=either moved, 4= no longer close, 5=forgot, should include, 6=other 
cap drop reason_lost*
forval i= 1/7 { 
	egen r_lost`i'= rowtotal(sn023c_`i'  sn023_`i')
	lab val r_lost`i' sn023c
	recode r_lost`i' (0=.) (-2 -1 7 9 10 11 97 =6 "Other") (1= 5 "Forgot, should include") (2 3= 	3 "Moved") (4=1 "Died") (5 6= 2 "Poor health") (8=4 "No longer close") , gen(reason_lost`i')
		}

**proportion of each reason given by country & wave 

egen lost_died = anycount(reason_lost*), val(1)
egen lost_ill = anycount(reason_lost*), val(2)
egen lost_moved = anycount(reason_lost*), val(3)
egen lost_notclose = anycount(reason_lost*), val(4)
egen lost_forgot = anycount(reason_lost*), val(5)
egen lost_other = anycount(reason_lost*), val(6)
recode lost_* (0 =.)		

gen prop_died= lost_died/count_reasons		
*twoway  lfit prop_died wave , by(country)		
 
save share_sample_3or4waves.dta, replace
 
//////////////////////////////////////////////////////////////////////////////////////


// MODELS //

use share_sample_3or4waves.dta, clear

keep if all_waves==1


*restrict ages to 50+
drop if age_gp==1

///////////////// setting panel data
xtset ID wave

**************

//// main models are MIXED - the poisson/ logit are for robusness tests only ////

* looping over & saving reg results in new dataset (using regsave)
*note: here for robustness check we use mixed model (fe & re) to use the inverse probability weights

** lost and new members 

estimates drop marg_*

foreach c in 11 12 13 15 16 17 18 20 23  28 29 34 35   {
  foreach g in 1 2 {
	foreach i in new_members lost_members {
		xtmixed `i' i.b3.age_gp i.b6.wave i.b3.residence i.b0.retired  chronicN network_size  || ID: [pw=ipw] if country==`c' & gender==`g', vce(robust)
		*xtpoisson `i' i.b3.age_gp i.b4.wave i.b3.residence i.b0.retired chronicN network_size if country==`c' & gender==`g', fe robust
		*eststo marg_`c'_`g'_`i': margins wave, atmeans post
		est store m_`c'_`g'_`i'
		*regsave using mixed_`i'_`c'_`g', pval ci replace
	}
 }	
}


esttab using margins_mixed_new_lost.csv , nostar cell("b se ci N")  title("marg_`c'_`g'_`i'") replace plain 

**********************************************
  
*** spouse in network - mixed models with ipw

estimates drop marg_*

foreach c in 11 12 13 15 16 17 18 20 23  28 29 34 35   {
  foreach g in 1 2 {
		xtmixed spouse i.b3.age_gp i.b4.wave i.b3.residence i.b0.retired chronicN || ID: [pw=ipw]  if country==`c' & gender==`g' , vce(robust)
		eststo marg_`c'_`g'_spouse: margins wave, atmeans post
		*xtlogit spouse i.b3.age_gp i.b4.wave i.b3.residence i.b0.retired chronicN if country==`c' & gender==`g', fe 
		*regsave using spouse_mixed_`c'_`g', pval ci replace
		}
 }	 

esttab using margins_mixed_spouse.csv , nostar cell("b se ci N")  title("marg_`c'_`g'_`i'") replace plain 


**********************************

*** models of network size 

estimates drop marg_*
 
foreach c in 11 12 13 15 16 17 18 20 23  28 29 34 35   {
  foreach g in 1 2 {
		xtmixed network_size i.b3.age_gp i.b4.wave i.b3.residence i.b0.retired  chronicN   || ID: [pw=ipw] if country==`c' & gender==`g' , vce(robust)
		eststo marg_`g'_`c'_networksize: margins wave, atmeans post
		*xtpoisson network_size i.b3.age_gp i.b4.wave i.b3.residence i.b0.retired chronicN if country==`c' & gender==`g', fe robust
		*regsave using mixed_nw_size_`c'_`g', pval ci replace
	}
 }	

esttab using margins_mixed_networksize.csv , nostar cell("b se ci N")  title("marg_`c'_`g'_networksize") replace plain  
 
******************************

*** models by age group

estimates drop marg_*
*network size, lost, new
foreach i in new_members lost_members {
  foreach a in 2 3 4 {
	foreach g in 1 2 {
		xtmixed `i' i.b6.wave i.b3.residence i.b0.retired  chronicN network_size i.country || ID: [pw=ipw] if age_gp==`a' & gender==`g', vce(robust)
		eststo marg_`g'_`i'_age`a': margins wave, atmeans post
		*regsave using mixed_`i'_g`g'_age`a', pval ci replace
	}
}
}	

esttab using margins_byage.csv , nostar cell("b se ci N")  title("marg_`i'_`g'_age`a'") replace plain  
 


******************************************
*** For robustness tests 

// Test 1: discarding march 2020 (pandemic period)
gen march2020=(wave==8 & year==2020 & int_month==3) // 7.26% of interviews from wave 8 (2,807 observations)
** add condition to models: if march2020!=1

// Test 2: pooled countries, for respondents in all waves only 
** add condition to models: if  resp_allwaves==1 (and include country in model)

// Test 3: comparison of results with only 3 waves 
** add condition to models:  if  three_waves==1
