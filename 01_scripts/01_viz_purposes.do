	global asize 	10-pt
	global lsize	8-pt

	global		axes ///
				ysc(lc(none) ) ///
				xsc(lc(none) ) ///
				xlab(, labc(gs10) tlc(gs10) tlw(medthick) labsize($asize )) ///
				ylab(, labc(gs10) tlc(gs10) tlw(medthick) nogrid labsize($asize )) ///
				note("") ///
				legend(size($lsize )) ///
				plotregion(lc(gs10) lw(medthick)) ///
				graphregion(margin(zero)) xti("")
				
				
				
	global		combine_opts ///
				imargin(zero) ///
				graphregion(margin(zero))
				
	
	graph set window fontface "Frutiger LT Condensed"

*-------------------------------------------------------------------------------
* Figure 1
*-------------------------------------------------------------------------------		

		
	* 1a
			
		tw 	(line wst_agency year if year < 1914 , lc(black) lw(medium)) ///
			(line wst_census year if year < 1914 , lc(black) lp("..-") lw(thick)) ///
			(line wst_yrbkpub year if year < 1914 , lc(black) lw(medthick) lp(dash)) ///
			, /// 
			$axes ///
			xlabel(1800(30)1920, angle(45) nogrid) ///
			ylab(, nogrid) ///
			xti("") ///
			yti() ///
			ti("A", place(w) span) ///
			legend(	order(	1 "Nat'l. statistics" "agency" ///
							2 "Nat'l. census" "ever conducted" ///
							3 "Concurrent nat'l."  ///
							"popul. statistics" "yearbook") ///
					pos(10) ring(0) bmargin(small) size(8-pt) ///
					region(lc(none) fcolor(none)) ///
					symxsize(small) keygap(*.5)) ///
			 aspect(1) graphregion(margin(zero)) xsize(3) ysize(3) 
					
					
		gr save "${VIZ}f1a.gph", replace
			
			
			
	* 1b
	
		tw	(connected committees year ///
					if year < 1914 & year > 1830 ///
					, msymbol(smx) msize(small) mlw(thin) lw(thin))  ///
			(line all_societies year ///
					if year < 1914, lw(medthick) lp(dash)) ///
			(line int_meetings year  ///
					if year < 1914 & year > 1830 ///
					, lc(black) lw(thick) lp("..-")) ///
			(line uk_n_unis year  ///
					if year < 1914 ///
					, lp(solid) lc(black)  lw(medium)) ///
			, ///
			$axes ///
			xlabel(1800(30)1920, angle(45) nogrid) ///
			ylab(0(25)100, nogrid ) ///
			xti("") ///
			yti("") ///
			ti("B", place(w) span) ///
			legend(	order(	4 "No. of UK universities" ///
							2 "Cum. No. of. statistics" ///
								"societies" ///
							1 "No. of active BAAS" ///
								"research committees" ///
							3 "Cum. No. of Int." ///
								"Statistics" "Congresses" ///
							) ///
					pos(10) ring(0) bmargin(small) ///
					region(color(none)) symxsize(medium) keygap(*.5)) ///
			aspect(1) xsize(3) ysize(3) 

					
		gr save "${VIZ}f1b.gph", replace
		
			
			
	* 1c
	
		tw	(connected fellows year ///
					if year < 1914  & year > 1833 ///
					, msymbol(smx) msize(small) mlw(thin) lw(thin)) ///
			(line soc_journals year /// 
					if year < 1914 , lc(black) lw(thick) lp("..-")) ///
			(line stats_journals year /// 
					if year < 1914 , lp(solid) lw(medium)) ///
			(line wst_n_unis year ///
					if year < 1914, lp(dash) lw(medthick)), ///
				$axes ///
				xlabel(1800(30)1920, angle(45) nogrid) ///
				ylab(, nogrid) ///
				xti("") ///
				yti("") ///
				ti("C", place(w) span) ///
				legend(	order(	3 "No. of statistics journals in" "circulation" ///
								4 "No. of universities in West" ///
								1 "No. of Fellows in the" "London (Royal) Statistical" "Society" ///
								2 "No. of social science" "journals in circulation") ///
						pos(10) ring(0) bmargin(small) ///
						region(color(none)) symxsize(medium) keygap(*.5)) ///
					aspect(1) xsize(3) ysize(3) 
			
			
		gr save "${VIZ}f1c.gph",  replace
		
			
			
	* Combine 
	
		gr combine 	"${VIZ}f1a.gph" ///
					"${VIZ}f1b.gph" ///
					"${VIZ}f1c.gph", col(3) ///
					$combine_opts   xsize(9) ysize(3.2) iscale(*1.5) xcommon
					
					
					
		gr export "${VIZ}00_text/fig1.pdf", replace


	
*-------------------------------------------------------------------------------
* Figure 2a
*-------------------------------------------------------------------------------

	cap frame drop thetas_lda
	frame create thetas_lda
	frame change thetas_lda
	import delimited "${DATA}00_dvs/lda200_thetas.csv", bindquote(strict)
	sort year 
	keep year topic106 length
	drop if year > 1914
		
	
	
		cap drop topic106_pct
		gen topic106_pct = topic106 * 100
	
		tw lpoly	topic106_pct year ///
					, $axes aspect(1) xsize(3) ysize(3) ///
					lw(thick) ///
					xlabel(1800(30)1920, angle(45) labsize(huge)) ///
					ylab(.25(.25) 1, labsize(huge)) ///
					xti("") ///
					yti("")  ///
					text(.87 1845 	"Average loading of" ///
									"State Schooling" ///
									"(LDA topic)", size(vlarge )) ///
					yline(.5, lp("--.") lw(vthin)) ///
					text(.475 1900 "equal chance", size(medium ))
									
									
		gr export "${VIZ}00_text/fig2.pdf", replace									
	
	
	clear 
	frame change default 
	frame drop thetas_lda
		
	

*-------------------------------------------------------------------------------
* Figure 6
*-------------------------------------------------------------------------------



	* Schooling 
	
		tw	(sc std_etopic106 year, mc(gs6) msize(small))  ///
			(lfit std_etopic106 year, lw(thick)) ///
			(lpoly std_etopic106 year, lw(thick) lp(solid)) ///
				, $axes xlabel(1800(30)1920, angle(45) labsize(huge)) ///
				legend(off) xsize(3) ysize(3) aspect(1) ///
				 xti("") ///
				yti("") ylab(-2(1)3 , labsize(huge)) ///
				text(2 1830 "State" "Schooling", size(huge))
								
								
		gr export "${VIZ}00_text/fig8.pdf", replace
											

			tw	(lpolyci std_etopic102 year, clw(medthick) alw(none) acol(gs10%60)) ///
				(lfitci std_etopic102 year, clw(medthick) alw(none) acol(gs10%30)) ///
				(sc std_etopic102 year, m(oh) mc(gs6) msize(small))  ///
			 ///
				, $axes xlabel(1800(30)1920, angle(45) labsize(huge)) ///
				legend(off) xsize(3) ysize(3) aspect(1) ///
				 xti("") ///
				yti("") ylab(-2(1)3 , labsize(huge)) ///
				text(2 1830 "State" "Schooling", size(huge))										
											
											
											
											
*-------------------------------------------------------------------------------
* Figure 7
*-------------------------------------------------------------------------------

	* Crown 
	
			
		tw	(lpolyci std_etopic45 year, clw(medthick) alw(none) acol(gs10%60)) ///
			(lfitci std_etopic45 year, clw(medthick) alw(none) acol(gs10%30)) ///
			(sc std_etopic45 year if std_etopic45 < 3, m(oh) mc(gs6) msize(small))  ///
			 ///
				, $axes xlabel(1800(30)1920, angle(45) labsize(vlarge)) ///
				legend(off) xsize(3) ysize(3) aspect(1) ///
				 xti("") ///
				yti("") ylab(-2(1)3 , labsize(vlarge)) ///
				text(2 1885 "Crown")	
				
		gr save "${VIZ}crown_cent", replace
		
		
		
	* Nationalism 
	
			
		tw	(lpolyci std_etopic57 year, clw(medthick) alw(none) acol(gs10%60)) ///
			(lfitci std_etopic57 year, clw(medthick) alw(none) acol(gs10%30)) ///
			(sc std_etopic57 year, m(oh) mc(gs6) msize(small))  ///
			 ///
				, $axes xlabel(1800(30)1920, angle(45) labsize(vlarge)) ///
				legend(off) xsize(3) ysize(3) aspect(1) ///
				 xti("") ///
				yti("") ylab(-2(1)3 , labsize(vlarge)) ///
				text(2 1885 "English" "Nationalism")	
				
		gr save "${VIZ}nationalism_cent", replace

		
		
	* Christian Values
		
				
		tw	(lpolyci std_etopic184 year, clw(medthick) alw(none) acol(gs10%60)) ///
			(lfitci std_etopic184 year, clw(medthick) alw(none) acol(gs10%30)) ///
			(sc std_etopic184 year if std_etopic184 < 3, m(oh) mc(gs6) msize(small))  ///
			 ///
				, $axes xlabel(1800(30)1920, angle(45) labsize(vlarge)) ///
				legend(off) xsize(3) ysize(3) aspect(1) ///
				 xti("") ///
				yti("") ylab(-2(1)3 , labsize(vlarge)) ///
				text(2 1885 "Christian Faith" "& Character")	
				
		gr save "${VIZ}christian_cent", replace
		
		
		
		
	* Development 
	
	
		tw	(lpolyci std_etopic102 year, clw(medthick) alw(none) acol(gs10%60)) ///
			(lfitci std_etopic102 year, clw(medthick) alw(none) acol(gs10%30)) ///
			(sc std_etopic102 year, m(oh) mc(gs6) msize(small))  ///
			 ///
				, $axes xlabel(1800(30)1920, angle(45) labsize(vlarge)) ///
				legend(off) xsize(3) ysize(3) aspect(1) ///
				 xti("") ///
				yti("") ylab(-2(1)3 , labsize(vlarge)) ///
				text(-1.7 1885 "Industrial" "Development")	

				
		gr save "${VIZ}develop_cent", replace


	* & Health 
	
					
		tw	(lpolyci std_etopic42 year, clw(medthick) alw(none) acol(gs10%60)) ///
			(lfitci std_etopic42 year, clw(medthick) alw(none) acol(gs10%30)) ///
			(sc std_etopic42 year, m(oh) mc(gs6) msize(small))  ///
			 ///
				, $axes xlabel(1800(30)1920, angle(45) labsize(vlarge)) ///
				legend(off) xsize(3) ysize(3) aspect(1) ///
				 xti("") ///
				yti("") ylab(-2(1)3 , labsize(vlarge)) ///
				text(-1.7 1885 "Public Health")	

					
		gr save "${VIZ}health_cent", replace
		
		
	
	
	* Quantification 
	
		tw	(lpolyci std_etopic122 year, clw(medthick) alw(none) acol(gs10%60)) ///
			(lfitci std_etopic122 year, clw(medthick) alw(none) acol(gs10%30)) ///
			(sc std_etopic122 year, m(oh) mc(gs6) msize(small))  ///
			 ///
				, $axes xlabel(1800(30)1920, angle(45) labsize(vlarge)) ///
				legend(off) xsize(3) ysize(3) aspect(1) ///
				 xti("") ///
				yti("") ylab(-2(1)3 , labsize(vlarge)) ///
				text(-1.7 1885 "Social" "Quantification")	

					
		gr save "${VIZ}quant_cent", replace
		

	
	
	
	
	* Combine 
	
		gr combine "${VIZ}crown_cent" "${VIZ}nationalism_cent" "${VIZ}christian_cent" ///
					, col(3) xsize(3) ysize(3) $combine_opts
		
		gr save "${VIZ}crown_nat_chrish", replace
		
		
		gr combine "${VIZ}quant_cent" "${VIZ}develop_cent" "${VIZ}health_cent" ///
					, col(3) xsize(3) ysize(3) $combine_opts
		
		gr save "${VIZ}qtn_dev_health", replace
	
		gr combine   "${VIZ}qtn_dev_health" "${VIZ}crown_nat_chrish" ///
					, row(2) xsize(4.5) ysize(3)  iscale(*1.25) ///
					$combine_opts
					
					
		gr export "${VIZ}00_text/fig7.pdf", replace

		
		
*-------------------------------------------------------------------------------
* Clean up directory 
*-------------------------------------------------------------------------------
	
	local gphs : dir "${VIZ}"  files "*.gph"
	foreach gph in `gphs' {
		erase "${VIZ}`gph'"
	}
	
