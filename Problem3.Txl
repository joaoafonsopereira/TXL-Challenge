include "Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [replaceCaseStatements]
end function

rule replaceCaseStatements
	replace [statement]
		'case Expr [expn] 'of
            FirstAlt [case_alternative]
            RmningAlts [repeat case_alternative]
            DefaultAlt [opt last_case_alternative]
        'end case

    deconstruct FirstAlt 
    	'label Alt1 [expn] _ [repeat comma_expn] :
            SScope [sub_scope]

    construct Elsifs [repeat elsif_clause]
    	_ [AddElsif Expr each RmningAlts]
    	
    by 
		'if (Expr) = Alt1 'then
        	SScope
		Elsifs
		% Else
		'end if
end rule


function AddElsif Expn [expn] CaseAlt [case_alternative]
	replace [repeat elsif_clause]
		OldElsifs [repeat elsif_clause]

	deconstruct CaseAlt 
		'label Alt1 [expn] _ [repeat comma_expn] :
            SScope [sub_scope]

	construct NewElsif [elsif_clause]
		'elsif (Expn) = Alt1 'then
			SScope
	by
		OldElsifs [. NewElsif]
end function



    deconstruct DefaultAlt 
    	'label :
            DefaultSScope [sub_scope]
    construct Else [opt else_clause]
    	'else 
    		DefaultSScope