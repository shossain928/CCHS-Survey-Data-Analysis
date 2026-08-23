


***** merging the two data sets ****** 

merge 1:1 adm_rno1 using "D:\UofC\Semester\Winter 2026\MDCH 740\Assignment\Final Analysis Plan\cchs_escc_bsw.dta"


******** Data cleaning ******** 
****** Outcome variable ***********

codebook cccdgcar

tab cccdgcar

**\\ generate new variable for cadriovascular**//

generate cardio=.

replace cardio=1 if cccdgcar==1
replace cardio=0 if cccdgcar==2

label define cardiol 1 "Has CVD" 0 "Has no CVD" 
label values cardio cardiol

*add a label to your variable name
label variable cardio "CVD status" 

codebook cardio 

prop cardio


******** Exposure variable ***********

codebook alc_015

tab alc_015

gen drink_alcohol=.

replace drink_alcohol=1 if alc_015==7
replace drink_alcohol=0 if inlist(alc_015, 1,2,3,4,5,6)

label define aldvttmld 1 "drank alcohol everyday" 0 "drank alcohol not everyday" 
label define aldvttmld 1 "drank (everyday)" 0 "drank (not everyday)", modify 

label values drink_alcohol aldvttmld 

codebook drink_alcohol 

prop drink_alcohol


********** Variable Explorations ***********

*** Anxiety Disorder 
tab ccc_200

gen anxiety =.

replace anxiety=1 if ccc_200==1 
replace anxiety=0 if ccc_200==2

label define ax 1 "Has Anxiety" 0 "No Anxiety" 
label values anxiety ax 

tab anxiety 

** Smoking Status 

tab smk_005

gen smoke=. 

replace smoke=1 if inlist(smk_005, 1,2)
replace smoke=0 if smk_005==3 

label define sm 1 "smoke (Daily/Occasionally)" 0 "smoke (Not at all)"
label values smoke sm 

tab smoke

** Age 

tab dhhgage 

label define age 1 "12 to 17 years" 2 "18 to 34 years" 3 "35 to 49 years" 4 "50 to 64 years" 5 "65 and older"
label values dhhgage age 

recode dhhgage (1=0 "12 1o 17 years")(2=1 "18 to 34 years")(3=2 "35 to 49 years")(4=3 "50 to 64 years")(5=4 "65+ and older"), gen(age)

tab age 


** Sex 

tab dhh_sex 

label define sex 1 "Male" 2 "Female"
label values dhh_sex sex 



*** Level of Education

gen educ2=. 
replace educ2=0 if inlist(ehg2dvh3, 1,2)
replace educ2=1 if ehg2dvh3==3

label define educs 0 "Less than Seconday/secondary" 1 "Post secondary" 
label values educ2 educs

tab educ2

*** Stress at work 

tab gen_025 

gen stress=. 

replace stress=0 if inlist(gen_025,1,2)
replace stress=1 if inlist(gen_025,3,4)
replace stress=2 if inlist(gen_025,5)

label define stress 0 "Not stressful" 1 "Quite a bit stressful" 2 "Extreme Stress" 

label values stress stress 

tab stress 

*** Physical activities (WHO)

tab paadvwho

gen PA=. 

replace PA=0 if inlist(paadvwho,1,2)
replace PA=1 if inlist(paadvwho,3,4)

label define PhyAct 0 "Sedentary to some activity" 1 "moderate to vigorous activity"
label values PA  PhyAct 

tab PA 

label variable PA "Physical Activities" 


***high blood pressure 

tab ccc_065

gen blood_pressure=. 

replace blood_pressure=1 if ccc_065==1
replace blood_pressure=0 if ccc_065==2

label define blood 1 "Has blood pressure" 0 "No blood pressure" 
label values blood_pressure blood 

tab blood_pressure 

*** mental health 

tab gen_015 

gen mental=.

replace mental=0 if inlist(gen_015, 1,2,3,4)
replace mental=1 if gen_015==5 

label define me 0 "Perceived Mental Health(Excellent/very good/good/fair)" 1 "Poor Mental Health"
label values mental me 

prop mental 


**** Adjust for Weight using svyset ****

svyset _n [pweight=wts_m], vce(linearized) singleunit(missing)


// **** Table 1 **** // 

drop if age==0 // dropped the age groups 12-17 years as this information is not available for every variables***// 


***** drop all missing values ***************

drop if missing(age, dhh_sex, smoke, mental, stress, educ2, drink_alcohol, cardio)


*********Descriptive statistics for all variables (unweighted)*********

proportion age 

proportion dhh_sex

proportion smoke 

proportion educ2

proportion mental

proportion stress

proportion drink_alcohol

*********Descriptive statistics for all variables (weighted)*********

proportion age [pweight = wts_m]

proportion dhh_sex[pweight = wts_m]

proportion smoke [pweight = wts_m]

proportion educ2 [pweight = wts_m]

proportion mental [pweight = wts_m]

proportion stress [pweight = wts_m]

proportion drink_alcohol [pweight = wts_m] 


******* Key differences between exposure and covariates ***************

*Weights

codebook wts_m

proportion age [pweight = wts_m], over(drink_alcohol)

proportion dhh_sex[pweight = wts_m], over(drink_alcohol)

proportion smoke [pweight = wts_m], over(drink_alcohol)

proportion educ2 [pweight = wts_m], over(drink_alcohol)

proportion mental [pweight = wts_m], over(drink_alcohol)

proportion stress [pweight = wts_m], over(drink_alcohol)



 svy: tab age drink_alcohol, pear col ci format(%7.4f)
 svy: tab dhh_sex drink_alcohol, pear col ci format(%7.4f)
 svy: tab smoke drink_alcohol, pear col ci format(%7.4f)
 svy: tab stress drink_alcohol, pear col ci format(%7.4f)
 svy: tab mental drink_alcohol, pear col ci format(%7.4f)
 svy: tab educ2 drink_alcohol, pear col ci format(%7.4f)
 
**Chi-squre between variables
 svy: tab age drink_alcohol
 svy: tab dhh_sex drink_alcohol
 svy: tab smoke drink_alcohol
 svy: tab educ2 drink_alcohol
 svy: tab mental drink_alcohol
 svy: tab stress drink_alcohol



********************* Fitting the Full model ******************************************
// After that consider the backward elimination procedures //

**** Assessing confounding for variable (Age) ****

logit cardio i.drink_alcohol i.smoke i.age i.dhh_sex i.educ2 i.mental i.stress, or 

logit cardio i.drink_alcohol i.smoke i.dhh_sex i.educ2 i.mental i.stress, or 

**** Assessing confounding for variable (Sex)****

logit cardio i.drink_alcohol i.smoke i.age i.dhh_sex i.educ2 i.mental i.stress, or 

logit cardio i.drink_alcohol i.smoke i.age i.educ2 i.mental i.stress, or 


**** Assessing confounding for variable (Smoking status)****

logit cardio i.drink_alcohol i.smoke i.age i.dhh_sex i.educ2 i.mental i.stress, or 

logit cardio i.drink_alcohol i.age i.dhh_sex i.educ2 i.mental i.stress, or 


**** Assessing confounding for variable (mental health)****

logit cardio i.drink_alcohol i.age i.dhh_sex i.educ2 i.mental i.stress, or 

logit cardio i.drink_alcohol i.age i.dhh_sex i.educ2  i.stress, or 

**** Assessing confounding for variable (education level)****

logit cardio i.drink_alcohol i.age i.dhh_sex i.educ2  i.stress, or 

logit cardio i.drink_alcohol i.age i.dhh_sex i.stress, or 


**** Assessing confounding for variable (Stress in Work)****

logit cardio i.drink_alcohol i.age i.dhh_sex i.stress, or 

logit cardio i.drink_alcohol i.age i.dhh_sex, or 



********************* Table 2***************************************

// Crude estimate //

logit cardio drink_alcohol, or 

logit cardio i.drink_alcohol i.age i.dhh_sex, or 


*************************** Calculate E values *****************************

tab1 drink_alcohol cardio 

cc drink_alcohol cardio

ssc install evalue 

evalue or 1.76, lcl(1.24) ucl(2.44)



