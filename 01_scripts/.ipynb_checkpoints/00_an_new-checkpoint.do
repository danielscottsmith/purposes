*-------------------------------------------------------------------------------
* Set the critical parameters of the computing environment
*-------------------------------------------------------------------------------
	clear all 
	macro drop _all
	
	set more off
		
	global	DIR			`"/Volumes/GoogleDrive-107745440581041782819/My Drive/00_Researching/00_scientization/-03_SSH/00_replication/"'
	global	DATA		"${DIR}00_data/"
	global	IVS			"${DATA}01_ivs/"
	global	DO			"${DIR}01_scripts/"
	global	VIZ			"${DIR}02_visuals/"
	cd 					"${DIR}"
		
	
	
			
*-------------------------------------------------------------------------------
* Call script to create data frame of (mostly) VDEM IVs
*-------------------------------------------------------------------------------

	do "${DO}99_cr_ivs_hm.do"

	frame rename default analysis
	
	
*-------------------------------------------------------------------------------
* READ IN INDUSTRIALIZATION SERIES
* --------------------------------
	/*
	Source:
 	MacLeod, R, and Peter Jeffrey Collins. 1981. The Parliament of Science : 
	The British Association for the Advancement of Science, 1831-1981. 
	Northwood: Science Reviews.
	*/
*-------------------------------------------------------------------------------

	* Broadberry's agricultural & industrial output series, 1270–1870
	
		frame create b_prod
		frame change b_prod
		import delimited "${IVS}uk_prod_broadberry.csv"
		rename ag b_ag
		rename ind b_ind


	* Feinstein's agricultural & industrial output series, 1855–1965
		
		frame create f_prod
		frame change f_prod
		import delimited "${IVS}uk_prod_feinstein.csv"
		rename ag f_ag
		rename ind f_ind 
		save temp_f_prod, replace


	* Merge Feinsnteins later estimates into the Broadberry frame
	
		frame change b_prod
		merge 1:1 year using temp_f_prod
		cap drop _merge
		cap drop f_prod

		
	* Convert Feinstein's estimates in terms of Broadberry's for overlapping
	* years by computing the ratio between each series and multiplying it by
	* Feinstein's series 
	
		* Ag Series
			gen f2b_ag = b_ag/f_ag			// Feinstein -> Broadberry
			gen fqb_ag = f_ag * f2b_ag		// Feinstein qua Broadberry
		
		* Ind Series
			gen f2b_ind = b_ind/f_ind
			gen fqb_ind = f_ind * f2b_ind
			

	* Generate link factor as average ratio for overlapping years
	
		* Ag Series
			quietly su f2b_ag
			global link_ag = `r(mean)'
		
		* Ind Series 
			quietly su f2b_ind
			global link_ind = `r(mean)'

			
	* Convert Feinstein's post-1870 series in terms of Broadberry's
	* using link factor 
	
		* Ag Series
			replace fqb_ag = f_ag*$link_ag if year > 1870
			
			* intialize combo ag measure with B's
				gen fb_ag = b_ag 	
			
			* fill in with F's, in terms of B
				replace fb_ag = fqb_ag if year > 1870
		
		* Ind Series 
			replace fqb_ind = f_ind*$link_ind if year > 1870
			gen fb_ind = b_ind 
			replace fb_ind = fqb_ind if year > 1870


	* Create a relative measure of ag to ind output
		cap drop ind2ag
		gen ind2ag = fb_ind / (fb_ag + fb_ind)
		
		
	* Inspect and clean up 		
		
		* Keep 19C only 
		drop if year < 1800
		
		* Keep only combined measures
		keep year fb_ind fb_ag ind2ag
		
		* Visualize & save flor later
		/*	
			line ag2ind year ///
						, /// 
					lw(medthick) ///
					$axes ///
					xlabel(1800(30)1920, angle(45) nogrid) ///
					ylab(, nogrid) ///
					xti("") ///
					yti("") ///
					aspect(1) graphregion(margin(zero)) xsize(3) ysize(3)  ///
					text(.65 1880 "Ratio of Total Agricultural to" ///
									"Total Industrial Output")
					
			gr export "${visuals}industrialization.jpg", replace
			
			sort year
			export delimited using "${data}broadberry_feinstein_output.csv" ///
									, replace
		*/	

		fs temp*
		
		foreach f in `r(files)' {
			erase `f'
		}

	
*-------------------------------------------------------------------------------
* COMBINE DATA INTO ANALYSIS FRAME
*-------------------------------------------------------------------------------

	frame change analysis 
	
	
	* Grab industrialization 
	
		frlink 1:1 year, frame(b_prod)
		frget *, from(b_prod)

		cap frame drop b_prod
		cap frame drop f_prod
		cap drop b_prod
		cap drop _merge 


		
		
	
		
*-------------------------------------------------------------------------------
* COMBINE DATA INTO ANALYSIS FRAME
*-------------------------------------------------------------------------------
			
	
	* Merge in centrality data (DVs)
		
		merge 1:1 year using "${DATA}/00_dvs/eigen_lda.dta"
		drop if year > 1914
		drop _merge
		
		merge 1:1 year using "${DATA}/00_dvs/degree_lda.dta"
		drop _merge
			
		
		
		
*-------------------------------------------------------------------------------
* Prepare Variables
*-------------------------------------------------------------------------------
			
			
		* Lag Variables 
		
			global LAG = 1
						
			
			* Development
				global IVS	fb_ag ///
							uk_lifeexp  ///
							uk_el_pubgoods
			
							
				
				foreach var in $IVS {
					cap drop l_`var'
					sort year
					gen l_`var' = `var'[_n-$LAG ]
					cap drop gr_`var'
					sort year
					gen gr_`var' = 100*(`var' - `var'[_n-1])  ///
										/ `var'[_n-1]
				}
				
			
			
			* Predictor
				sort year
				cap drop l_scientization
				sort year
				gen l_scientization = scientization[_n-1]	
				
				
				global CNFLCT 	uk_dmst_cnflct ///
								uk_int_cnflct ///
								wst_int_cnflct
							
					
					
			* Conflict
				foreach var in $CNFLCT {
					cap drop l_`var'
					sort year
					gen l_`var' = `var'[_n-1]
				}


			
		* Lag & Standardize DVs 
		
			global nums 106 45 102 184 42 57 122
			
			foreach num of numlist $nums {
				cap drop l_dtopic`num'
				cap drop l_etopic`num'
				sort year
				gen l_dtopic`num' = dtopic`num'[_n-$LAG]
				sort year
				gen l_etopic`num' = etopic`num'[_n-$LAG]
			}
			
			
			
					
			
			
		cap drop miss
		egen miss = rowmiss(l_* gr_* dtopic106)
			

		keep if miss == 0
		drop miss 
		

		* Standardize selected variables 
		
			* DVS
			
				global nums 106 45 102 184 42 57 122
				
				foreach num of numlist $nums {
					cap drop std_dtopic`num'
					cap drop std_etopic`num'
					egen std_dtopic`num' = std(dtopic`num')
					egen std_etopic`num' = std(etopic`num')
				}
					
			
			* scientization 
			
				cap drop std_scientization
				egen std_scientization = std(l_scientization)
			
			
			
			* Gen & standardize clientelism index 
			
				cap drop programmatic 
				egen programmatic = std(l_uk_el_pubgoods)

			
		* Transform proportions to percentages 
		
			replace l_wst_int_cnflct = l_wst_int_cnflct * 100
			replace l_uk_int_cnflct = l_uk_int_cnflct * 100
			replace dtopic106 = dtopic106*100
	
		
		cap drop pms
		encode 	uk_hog_name, gen(pms)
	
		* Decade 
			cap drop decade
			egen decade = cut(year), at(1800(10)1920)
		
		
		* Sovereign era 
			cap drop era
			gen era = 0 if year < 1850
			replace era = 1 if year >= 1850 & year < 1885
			replace era = 2 if year >= 1885
			la def era_lbl 0 "Period 1" 1 "Period 2" 2 "Period 3", replace
			la val era era_lbl
		

*-------------------------------------------------------------------------------
* Table A1
*-------------------------------------------------------------------------------
				
				
	global REGRESSORS 	std_scientization  ///
						l*cnflct  ///
						l_fb_ag  ///
						l_uk_life ///
						programmatic 
						

				
	pwcorr std_dtopic106 $REGRESSORS, list
		

		
*-------------------------------------------------------------------------------
* Table 1 & 2
*-------------------------------------------------------------------------------
	preserve
	
		keep	dtopic106 $REGRESSORS
		
		outreg2 using 	"${VIZ}00_text/table2.doc" ///
						, replace ///
						sum(log) auto(3)
	restore
							
			
	global SCI	wst_census_ever ///
				wst_agency ///
				wst_yrbkpub ///
				stats_journals soc_journals ///
				fellows ///
				int_meetings ///
				committees /// 
				wst_n_unis ///
				all_societies
				
				
	preserve 
		replace wst_agency = wst_agency * 100
		replace wst_yrbkpub = wst_yrbkpub * 100
		replace wst_census_ever	= wst_census_ever * 100
		keep $SCI
		outreg2 using	"${VIZ}00_text/table1.doc" ///
						, replace ///
						sum(log) auto(3)
	restore
		
		
*-------------------------------------------------------------------------------
* Table 3
*-------------------------------------------------------------------------------
							
									
								
		global xls  "${VIZ}00_text/table3.xls"
		global txt	"${VIZ}00_text/table3.txt"
		cap erase 	"${xls}"
		cap erase	"${txt}"
		global model_opts  	fe  vce(robust)
		global outreg_opts		, excel ///
								stats(coef se) ///
								aster(coef) ///
								dec(3) 

		xtset pms
		global M1			xtreg std_dtopic106 std_scientization
									 
										
										
		global M2			$M1 ///
							l_uk_dmst_cnflct ///
							l_uk_int_cnflct ///
							l_wst_int_cnflct
										
							
		outreg2 using "${xls}" $outreg_opts : ///
								$M1 ///
								, $model_opts		
																							
		outreg2 using "${xls}" $outreg_opts append: ///
								$M2 ///
								 ///
								, $model_opts
								
		outreg2 using "${xls}" $outreg_opts append: ///
								$M2 ///
								l_fb_ag gr_fb_ag ///
								 ///
								, $model_opts
								
		outreg2 using "${xls}" $outreg_opts append: ///
								$M2 ///
								uk_lifeexp gr_uk_lifeexp ///
								, $model_opts

		outreg2 using "${xls}" $outreg_opts append: ///
								$M2 ///
								programmatic  gr_uk_el_pubgoods ///
								 ///
								, $model_opts								

								
								
*-------------------------------------------------------------------------------
* Table A2
*-------------------------------------------------------------------------------
							
									
								
		global xls  "${VIZ}01_appendix/table-a2.xls"
		global txt	"${VIZ}01_appendix/table-a2.txt"
		cap erase 	"${xls}"
		cap erase	"${txt}"
		global model_opts  	fe  vce(robust)
		global outreg_opts		, excel ///
								stats(coef se) ///
								aster(coef) ///
								dec(3) 

		xtset pms
		global M1			xtreg std_dtopic106 std_scientization
									 
										
										
		global M2			$M1 ///
							l_uk_dmst_cnflct ///
							l_uk_int_cnflct ///
							l_wst_int_cnflct ib1800.decade
										
							
		outreg2 using "${xls}" $outreg_opts : ///
								$M1 ///
								, $model_opts		
																							
		outreg2 using "${xls}" $outreg_opts append: ///
								$M2 ///
								 ///
								, $model_opts
								
		outreg2 using "${xls}" $outreg_opts append: ///
								$M2 ///
								l_fb_ag gr_fb_ag ///
								 ///
								, $model_opts
								
		outreg2 using "${xls}" $outreg_opts append: ///
								$M2 ///
								uk_lifeexp gr_uk_lifeexp ///
								, $model_opts

		outreg2 using "${xls}" $outreg_opts append: ///
								$M2 ///
								programmatic  gr_uk_el_pubgoods ///
								 ///
								, $model_opts
																
								
*-------------------------------------------------------------------------------
* Table A3
*-------------------------------------------------------------------------------
	
		global xls  "${VIZ}01_appendix/table-a3.xls"
		global txt	"${VIZ}01_appendix/table-a3.txt"
		cap erase 	"${xls}"
		cap erase	"${txt}"
		global model_opts  	fe  vce(robust)
		global outreg_opts		, excel ///
								stats(coef se) ///
								aster(coef) ///
								dec(3) 

		xtset pms
		global M1			xtreg std_dtopic106 std_scientization
									 
										
										
		global M2			$M1 ///
							l_uk_dmst_cnflct ///
							l_uk_int_cnflct ///
							l_wst_int_cnflct i.era
										
							
		outreg2 using "${xls}" $outreg_opts : ///
								$M1 ///
								, $model_opts		
																							
		outreg2 using "${xls}" $outreg_opts append: ///
								$M2 ///
								 ///
								, $model_opts
								
		outreg2 using "${xls}" $outreg_opts append: ///
								$M2 ///
								l_fb_ag gr_fb_ag ///
								 ///
								, $model_opts
								
		outreg2 using "${xls}" $outreg_opts append: ///
								$M2 ///
								uk_lifeexp gr_uk_lifeexp ///
								, $model_opts

		outreg2 using "${xls}" $outreg_opts append: ///
								$M2 ///
								programmatic  gr_uk_el_pubgoods ///
								 ///
								, $model_opts
								
								
*-------------------------------------------------------------------------------
* Draw figures
*-------------------------------------------------------------------------------
// 		do "${DO}01_viz_hm.do"
