*===================================================================================*
* Ado-file: 	bdiffv Version 1
* Author: 		Shutter Zor(左祥太)
* Affiliation: 	Accounting Department, Xiamen University
* E-mail: 		Shutter_Z@outlook.com 
* Date: 		2025/8/8                                 
*===================================================================================*


capture program drop bdiffv
program define bdiffv, rclass
	dis as result "This is a network download package from GitHub."
end


*----------sub-programs----------

// NotSupported cmd cmd2  
*  see suest.ado Line.662
capture program drop NotSupported
program NotSupported
    
	local cmdlist cox xtgee ivreg ivregress areg xtreg sem xtmixed mixed
	local cmdlist `cmdlist' xtmepoisson mepoisson xtmelogit melogit meglm
	local cmdlist `cmdlist' gsem gmm
	local cmdYes : list 0 & cmdlist
	if `"`cmdYes'"' != "" {
		di as err "`:word 1 of `cmdYes'' is not supported by -groupdiff- with option -surtest-"
		exit 322
	}
	if "`e(cmd)'" == "regress" & "`e(model)'" == "iv" {
		di as err ///
		"regression models with instruments are not supported by -groupdiff- with option -surtest-"
		exit 322
	}
	if "`e(cmd)'" == "anova" {
		if 0`e(version)' < 2 {
			di as err ///
			  "anova run with version < 11 not supported by -groupdiff- with option -surtest-"
			exit 322
		}
	}

end	   






