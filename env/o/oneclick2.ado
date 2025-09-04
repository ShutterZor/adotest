*===================================================================================*
* Ado-file: OneClick Version 4.2 
* Author: Shutter Zor(左祥太)
* Affiliation: School of Accountancy, Wuhan Textile University
* E-mail: Shutter_Z@outlook.com 
* Date: 2022/10/30                                          
*===================================================================================*

capture program drop oneclick2
program define oneclick2
	version 16.0
	
	syntax varlist(min=3) [if] [in],			///
			Method(string)						///
			Pvalue(real)						///
			FIXvar(varlist fv ts)				///
			[									///
				Options(string)					///
				Zvalue							///
			]


	gettoken y ctrlvar : varlist
	gettoken x otherx : fixvar
	
	preserve
		qui gen subset = ""
		qui gen coef = .
		qui gen serr = .
		qui gen r2 = .
		
		* judge osb num
		tuples `ctrlvar'
		local n = _N
		if `ntuples' > `n' {
			qui set obs `ntuples'
		}
		if `ntuples' <= `n' {
			qui set obs `n'
		}
		
		local minutes = int(`ntuples'/60) + 1
		dis "This will probably take you up to `minutes' minutes"
		
		* select
		forvalues i = 1/`ntuples' {
			local percentcurrent = floor(`i' / `ntuples' * 100) 
			dis "`percentcurrent'% calculation has been completed"
			
			quietly {
			
				`method' `y' `fixvar' `tuple`i'', `options'
			
				replace subset = "`tuple`i''" in `i' 
				replace coef = _b[`x'] in `i'
				replace serr = _se[`x'] in `i'
				replace r2 = e(r2) in `i' 
			}
		}
		
		* drop 
		quietly {
			drop if subset == ""
			keep subset coef serr r2
			save Filter.dta, replace
		}
	restore
end


