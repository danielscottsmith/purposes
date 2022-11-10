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
* Figures 1 & 2 
*-------------------------------------------------------------------------------

	cap frame drop thetas_lda
	frame create thetas_lda
	frame change thetas_lda
	import delimited "${DATA}00_dvs/lda200_thetas.csv", bindquote(strict)
	sort year 
	keep year topic106 length
	drop if year > 1914
	
	
	* --------
	* Figure 1 
	* --------


		cap drop yr_len
		egen yr_len = mean(length), by(year)
		
		
		cap drop yr_tag
		egen yr_tag = tag(year)

		
		tw	(hist	year if year < 1915 ///
					, $axes ///
					yscale(alt) ///
					freq ///
					discrete ///
					fc(gs13) ///
					lc(none) ///
					yti("{it:N} Speeches" ///
						"(histogram)" ///
						, orientation(horizontal) size(small)) ///
					ylab(	0 		"0" ///
							1.5e+04 "15K" ///
							3.0e+04 "30K" ///
							4.5e+04 "45K" ///
							6.0e+04 "60K" ///
							,	labc(gs10) labsize(medium))) ///
			(line 	yr_len year if year < 1915 & yr_tag == 1 ///
					, sort ///
					yaxis(2) ///
					lw(medium) ///
					lc(gs6) ///
					lp(solid) ///
					yscale(alt axis(2) lc(gs10)) ///
					ylab(0(60)240 ///
						, 	labc(gs10) ///
							tlc(gs10) ///
							tlw(medthick) ///
							axis(2) ///
							nogrid ///
							labsize(medium)) ///
					yti("Avg. No." ///
						"of Terms" ///
						"per speech" ///
						"(line)" ///
						, orientation(horizontal) ///
						axis(2) size(small)))  ///
			,  legend(off) ///
				xti("") ///
				xlabel(1800(30)1920 ///
					  , angle(45) labsize(medium)) ///
				xsize(3) ysize(3) aspect(1)
			
			
			
		gr export "${VIZ}00_text/fig1.pdf", replace 
	
	
	
	* --------
	* Figure 2
	* --------
	
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
* Figure 4
*-------------------------------------------------------------------------------		

		
	* 4a
			
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
					
					
		gr save "${VIZ}f4a.gph", replace
			
			
			
	* 4b
	
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

					
		gr save "${VIZ}f4b.gph", replace
		
			
			
	* 4c
	
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
			
			
		gr save "${VIZ}f4c.gph",  replace
		
			
			
	* Combine 
	
		gr combine 	"${VIZ}f4a.gph" ///
					"${VIZ}f4b.gph" ///
					"${VIZ}f4c.gph", col(3) ///
					$combine_opts   xsize(9) ysize(3.2) iscale(*1.5) xcommon
					
					
					
		gr export "${VIZ}00_text/fig4.pdf", replace





*-------------------------------------------------------------------------------
* Figure 8
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
* Figure 9
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
					
					
		gr export "${VIZ}00_text/fig9.pdf", replace

		
		
		
*-------------------------------------------------------------------------------
* Figure A1
*-------------------------------------------------------------------------------
	
	cap frame drop a1
	frame create a1
	frame change a1
	
	use "${DATA}01_ivs/theorists.dta"
	
	egen five = cut(year), at(1800(5)1920)
	drop if year > 1914

	tw	(lpoly smith five, lw(thick)) ///
		(lpoly pearson five, lw(thick)) ///
		(lpoly bentham five, lw(thick)) ///
		, $axes ///
		xti("") ///
		xlabel(1800(30)1920, angle(45)) ///
		xsize(3) ysize(3) aspect(1) ///
		legend(order(1 "Adam" "Smith" ///
					 2 "Carl" "Pearson" ///
					 3 "Jeremy" "Bentham") ///
					 region(lc(none) fcolor(none)) ///
				keygap(*.5) ///
				pos(12) ///
				ring(0) ///
				bmargin(small) ///
				size(8-pt) ///
				col(3))

	gr export "${VIZ}01_appendix/figa1.pdf", replace
	
	clear
	



*-------------------------------------------------------------------------------
* Figure A2
*-------------------------------------------------------------------------------	

	frame create coherence
	frame change coherence
	
	use "${DATA}99_lda200/coherences.dta"
	
	
	* v 
	
		cap drop v_pos
		egen v_pos = mlabvpos(v k)
		sc v k ///
				, $axes recast(connected) ///
				mlab(k) mlabs(vsmall) m(dot) msize(vsmall) mfc(white) /// 
				mlc(black) mlabvposition(v_pos) yti("") ///
				text(.47 650 "v") ///
				aspect(1) xsize(3) ysize(3)  ///
				xlab(0(300)900, angle(45)) ylab(.425(.025).5)

		gr save "${VIZ}cohere_v.gph", replace

	
	* uci 
	
		cap drop uci_pos
		egen uci_pos = mlabvpos(uci k)
		sc uci k ///
				, $axes recast(connected) ///
				mlab(k) mlabs(vsmall) m(dot) msize(vsmall) mfc(white) /// 
				mlc(black) mlabvposition(uci_pos) yti("") ///
				text(.57 650 "uci") ///
				aspect(1) xsize(3) ysize(3) ///
				xlab(0(300)900, angle(45)) ylab(.5(.025).577)

		gr save "${VIZ}cohere_uci.gph", replace

	
	* npmi
	
		cap drop npmi_pos
		egen npmi_pos = mlabvpos(npmi k)
		sc npmi k ///
				, $axes recast(connected) ///
				mlab(k) mlabs(vsmall) m(dot) msize(vsmall) mfc(white) /// 
				mlc(black) mlabvposition(npmi_pos) yti("") ///
				text(.057 650 "npmi") ///
				aspect(1) xsize(3) ysize(3) ///
				xlab(0(300)900, angle(45)) ylab(.05(.004).062)

		gr save "${VIZ}cohere_npmi.gph", replace

	
	* umass 
	
		cap drop umass_pos
		egen umass_pos = mlabvpos(umass k)
		sc umass k ///
				, $axes recast(connected) ///
				mlab(k) mlabs(vsmall) m(dot) msize(vsmall) mfc(white) /// 
				mlc(black) mlabvposition(umass_pos) yti("") ///
				text(-1.98 650 "umass") ///
				aspect(1) xsize(3) ysize(3) ///
				xlab(0(300)900, angle(45)) ylab(-2.2(.1)-1.9)

		gr save "${VIZ}cohere_umass.gph", replace
	
	
	* Combine 
	
		gr combine 	"${VIZ}cohere_v.gph" ///
					"${VIZ}cohere_npmi.gph" ///
					"${VIZ}cohere_uci.gph" ///
					"${VIZ}cohere_umass.gph" ///
					, $combine_opts col(2)  xcommon xsize(3) ysize(3)
					
		gr export "${VIZ}01_appendix/figure_a1.tif", replace	width(3000)
	
	
	frame change default
	frame drop coherence


	
	
*-------------------------------------------------------------------------------
* Figure A3
*-------------------------------------------------------------------------------

	cap frame drop thetas_stm
	frame create thetas_stm
	frame change thetas_stm
	import delimited "${DATA}98_stm200/stm200_thetas_b.csv", bindquote(strict)
	sort year 
	keep year X9 
	
	replace x10 = x10 * 100
	
	drop if year > 1914

	
		tw lpoly	x10 year ///
					, $axes aspect(1) xsize(3) ysize(3) ///
					lw(thick) ///
					xlabel(1800(30)1920, angle(45) labsize(huge)) ///
					ylab(.25(.25) 1.25, labsize(huge)) ///
					xti("") ///
					yti("")  ///
					text(1 1845 	"Average loading of" ///
									"State Schooling" ///
									"(STM topic)", size(vlarge )) ///
					yline(.5, lp("--.") lw(vthin)) ///
					text(.465 1900 "equal chance", size(medium ))
					
		gr export "${VIZ}01_appendix/fig2_stm.pdf", replace

		
		
		
	clear 



		
*-------------------------------------------------------------------------------
* Clean up directory 
*-------------------------------------------------------------------------------
	
	local gphs : dir "${VIZ}"  files "*.gph"
	foreach gph in `gphs' {
		erase "${VIZ}`gph'"
	}
	

	
	
	
	

