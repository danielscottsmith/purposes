********************************************************************************
* PRIMARY INVESIGATOR(S): 	Daniel Scott Smith
* VERSION: 					Stata 16.1 IC


*-------------------------------------------------------------------------------
* Set the critical parameters of the computing environment
*-------------------------------------------------------------------------------

	clear all
		
	set more off
	
	local	DIR			`"/Volumes/GoogleDrive-107745440581041782819/My Drive/00_Researching/00_scientization/-03_SSH/00_replication/"'
	local	DO			"`DIR'01_scripts/"
	local	VIZ			"`DIR'02_visuals/"
	local	DATA		"`DIR'00_data/"
	local	DVS			"`DATA'00_dvs/"
	local	IVS			"`DATA'01_ivs/"			
	local	BBS			"`DATA'02_bluebooks/"
	local	ACTS		"`DATA'03_acts/"
	
	

	
	
*-------------------------------------------------------------------------------
* BAAS committees data 
* --------------------
	/*
	Source:
 	MacLeod, R, and Peter Jeffrey Collins. 1981. The Parliament of Science : 
	The British Association for the Advancement of Science, 1831-1981. 
	Northwood: Science Reviews.
	*/
*-------------------------------------------------------------------------------
		import excel "`IVS'baas.xlsx", firstrow

		drop attendance 
		
		save "`DATA'baas.dta", replace

		clear all

		
		
		
*-------------------------------------------------------------------------------
* Fellows data 
* ------------
	/*
	Source:
	Rosenbaum, S. 1984. “The Growth of the Royal Statistical Society.” 
	Journal of the Royal Statistical Society. Series A (General) 147 (2). 
	[Royal Statistical Society, Wiley]: 375–88. doi:10.2307/2981692.
	*/
*-------------------------------------------------------------------------------
		import excel "`IVS'fellows.xlsx", sheet("Tabelle1") firstrow
		
		save "`DATA'fellows.dta", replace

		clear all
		
			
			
				
*-------------------------------------------------------------------------------
* Societies data 
* -------------
	/*
	Sources:
	Willcox, W. F. (1934). Note on the Chronology of Statistical Societies. 
	Journal of the American Statistical Association, 29(188). 
	https://doi.org/10.1080/01621459.1934.10503258
	
	Fitzpatrick, P. J. (1957). Statistical Societies in the United States 
	in the Nineteenth Century. The American Statistician, 11(5). 
	https://doi.org/10.1080/00031305.1957.10481745	
	*/
*-------------------------------------------------------------------------------
		import excel "`IVS'societies.xlsx", sheet("Sheet1") firstrow
		
		save "`DATA'societies.dta", replace
		
		clear all
		

		
		
*-------------------------------------------------------------------------------
* Colonies data 
* ------------
	/*
	Source:
	O’Neill, Aaron. 2020. “Number of Present-Day Countries That Held Part of 
	the British Empire, in Each Year from 1600 to 2000.” 
	https://www.statista.com/statistics/1070352/number-current-countries-in-british-empire/
	*/
*-------------------------------------------------------------------------------
		import excel "`IVS'colonies.xlsx", sheet("Tabelle1") firstrow
		destring year, replace

		
		
		
	* Merge BAAS, Fellows, and Journals Data 
	
		merge 1:1 year using "`DATA'baas.dta"
		drop _merge

		
		merge 1:1 year using "`DATA'fellows.dta"
		drop _merge
		
		
		merge 1:1 year using "`IVS'19c_journals.dta" 
		drop _merge
		
		merge 1:1 year using "`DATA'societies.dta" 
		drop _merge
		
		erase "`DATA'baas.dta"
		erase  "`DATA'societies.dta"
		erase "`DATA'fellows.dta"


		
		
*-------------------------------------------------------------------------------
* International Statistics Congress & Institute 

	/*
	Flora, Peter. 1975. “4. Historical Sources of Statistics.” 
	Current Sociology 23 (2). SAGE Publications Ltd: 113–39. 
	doi:10.1177/001139217502300205
	*/
*-------------------------------------------------------------------------------
		
		
	* Enter congresses by hand (p. 126):
	
	
	* Generate indicator of congress meeting
	
		cap drop congress
		gen congress = 0

		replace congress = 1 if 	year == 1853 | ///
										year == 1855 | ///
										year == 1857 | ///
										year == 1860 | ///
										year == 1863 | ///
										year == 1867 | ///
										year == 1869 | ///
										year == 1872 | ///
										year == 1876

								
								
	* Compute running sums of congress meetings	
						
		cap drop congress_all
		gen 	congress_all = 0
		replace congress_all = 1	if 	year >= 1853 & year < 1855
		replace congress_all = 2	if 	year >= 1855 & year < 1857
		replace congress_all = 3	if 	year >= 1857 & year < 1860
		replace congress_all = 4	if 	year >= 1860 & year < 1863
		replace congress_all = 5	if 	year >= 1863 & year < 1867
		replace congress_all = 6	if 	year >= 1867 & year < 1869
		replace congress_all = 7	if 	year >= 1869 & year < 1872
		replace congress_all = 8	if 	year >= 1872 & year < 1876
		replace congress_all = 9	if 	year >= 1876 


		
	* Generate indicator of institute session
	
		cap drop session
		cap drop session_all
		gen	session	= 0 
		gen session_all = 0
		local j = 0

		
	* Generate running sums of institute sessions 
	
		forv i = 1887(2)1913 {
			local j = `j' + 1 
			replace session = 1 if year == `i'
			replace session_all = session_all + `j' if year >= `i' & year < `i' + 2
			}


			
	* Generate total sum 
	
		gen int_meetings = congress_all + session_all
		
		
		
		
	* save temp data
	
		save "`DATA'temp_iv.dta", replace
	
	
	
	
*-------------------------------------------------------------------------------
* Vdem data
*-------------------------------------------------------------------------------
	
	* Import raw vdem 10 data, pre-selected measures
	* These variables were selected using pandas on Python
	* see notebook cr_west_vdem10

		use	"`IVS'west_vdem10.dta"
		drop index		


	* Rename variables
	
		rename v2x_* *
		rename v2* *
		rename v3* *
		rename e_* *

		* ID info
		rename	regiongeo	un_region
		rename	exnamhog	hog_name
		rename 	extithog	hog_title
		rename	lpname		maj_party

		* political 
		rename	suffr 		el_suff
		rename	partipdem	el_part 
		rename	polyarchy	el_elect 
		rename	xel_frefair	el_fair
		rename	xnp_client	el_client
		rename	libdem		el_libdem
		rename  xeg_eqprotec	el_eqprot
		rename	partip		el_partip
		rename  dlencmps	el_pubgoods
		
		* education
		rename	peprisch	sch_enrll
		rename	canuni		n_unis 
		
		* social 
		rename	miurbani	urbnztn
		rename 	miurbpop	urbpop
		rename	pematmor	matmort
		rename	pelifeex	lifeexp
		rename	pefeliex	flifeexp
		rename	peinfmor	infmor 

		* nation state
		rename	stcitlaw	ctznshp 
		rename	stflag		flag
		rename	stnatant	anthem
		rename	stnatbank	bank
		rename	ststeecap 	econ_cap

		* scientization
		rename	stcensus	census
		rename	ststatag	agency
		rename	ststybcov	yrbkcov
		rename	ststybpub	yrbkpub

		* conflict
		rename	miinteco	int_cnflct
		rename	miinterc	dmst_cnflct
		
		

		
		
*-------------------------------------------------------------------------------
* Generate new census variable 			
*-------------------------------------------------------------------------------
			
	* Generate sum of all censuses ever taken

		cap drop census_all
		by country_name (year), sort: gen census_all = sum(census)
		
		
	* Generate indicator of first ever census

		cap drop census_ever
		by country_name (year), sort:	gen census_ever = census_all == 1 ///
										& census_all[_n - 1] != census_all
	
	* Generate indicator if there was ever a census conducted
										
		cap drop census_ever_all
		by country_name (year), sort: gen census_ever_all = sum(census_ever)

		
	* Drop & rename
	
		cap drop census_ever census
		rename census_ever_all census_ever


		
*-------------------------------------------------------------------------------			
* Take out UK data for later use
*-------------------------------------------------------------------------------

		preserve
			keep if country_name == "United Kingdom"
			drop country_name
			drop histname
			rename * uk_*
			rename uk_year year
			save "`DATA'uk_vdem10.dta", replace
		restore


		
*-------------------------------------------------------------------------------
* Compute west-wide institutional characteristics 
*-------------------------------------------------------------------------------
	
		drop if country_name == "United Kingdom" 

		global	world	el_suff el_part el_elect ///
						gdp ///
						sch_enrll ///
						ctznshp ///
						flag ///
						anthem ///
						bank ///
						census_ever ///
						agency ///
						yrbkcov ///
						yrbkpub ///
						int_cnflct ///
						dmst_cnflct ///
						econ_cap
		 
		 
		* Take annual averages / proportions
			
			foreach var in $world {
				cap drop world_`var'
				egen wst_`var' = mean(`var'), by(year)
				}
				
				
		* Count unis 
		
			egen wst_n_unis = sum(n_unis), by(year)
					

		* Count states
		
			cap drop wst_n_states
			egen wst_n_states = count(country_name), by(year)
					
					
					
		* Create year obs dataset 
		
			keep year wst* 
			egen year_tag = tag(year)
			keep if year_tag == 1
			drop year_tag

			
*-------------------------------------------------------------------------------
* Merge with uk vdem data
*-------------------------------------------------------------------------------

	merge 1:1 year using "`DATA'uk_vdem10.dta"
	drop _merge
	merge 1:1 year using "`DATA'temp_iv.dta"
	drop _merge
	
	
	
	
*-------------------------------------------------------------------------------
* Impute school enrollment vdem data
*-------------------------------------------------------------------------------
	
	
	* Impute values of enrollment rates, pre-1820
	* Assume the slope 1803–1819 == slope 1820-1830
	
	
		* Enrollment in UK

			cap drop imp_uk_sch_enrll
			gen imp_uk_sch_enrll = uk_sch_enrll

			reg uk_sch_enrll year if year > 1819 & year < 1830

			forv i = 1803(1)1819 {
				replace imp_uk_sch_enrll = `i' * _b[year] + _b[_cons] if year == `i'
			}

			
		* Enrollment across West
		
			cap drop imp_wst_sch_enrll
			gen imp_wst_sch_enrll = wst_sch_enrll

			reg wst_sch_enrll year if year > 1819 & year < 1830

			forv i = 1803(1)1819 {
				replace imp_wst_sch_enrll = `i' * _b[year] + _b[_cons] if year == `i'
			}
		
	
	
	
	
*-------------------------------------------------------------------------------
* Create measure of system-wide scientization
*-------------------------------------------------------------------------------
	
	
		
	* Create measure of system-wide scientization
	
		
		global scientization		wst_census_ever ///
									wst_agency ///
									wst_yrbkpub ///
									uk_yrbkpub ///
									uk_census_all ///
									stats_journals soc_journals ///
									fellows ///
									int_meetings ///
									uk_agency ///
									committees /// 
									wst_n_unis ///
									all_societies
				

				
		* Reliability analysis
		
			alpha $scientization, std item 
			factor $scientization , ipf
		
			cap drop scientization
			predict scientization 
		
		
		* Standardized & lagged index
		
// 			cap drop scientization		
// 			predict scientization  
			
// 			egen std_sci = std(scientization)
// 			drop scientization
// 			rename std_sci scientization		
			
			
			
			
			
*-------------------------------------------------------------------------------
* Clean up
*-------------------------------------------------------------------------------

		erase "`DATA'uk_vdem10.dta"
		erase "`DATA'temp_iv.dta"
