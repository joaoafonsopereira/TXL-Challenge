include "Turing.Grm"

% Grammar overrides to allow construction of if clauses (to increase readability)

define if_clause
	    'if [expn] 'then          [NL][IN]
	    	[sub_scope]           [EX]
end define

redefine if_statement
        [if_clause]
        [repeat elsif_clause]
        [opt else_clause]
        'end 'if
end redefine



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
    	'label Alt1 [expn] Alts1 [repeat comma_expn] :
            SScope [sub_scope]

    construct IfCond [expn]
    	(Expr) = Alt1

    construct If [if_clause]
    	'if IfCond[addOrs Expr each Alts1] 'then
        	SScope

    construct Elsifs [repeat elsif_clause]
    	_[addElsif Expr each RmningAlts]

	construct Else [opt else_clause]
    	_[addOptElse DefaultAlt]

    by 
		If
		Elsifs
		Else
		'end 'if
end rule


function addElsif Expn [expn] CaseAlt [case_alternative]
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


function addOptElse DefaultAlt [opt last_case_alternative]
	replace [opt else_clause]
		_ [opt else_clause]

	deconstruct DefaultAlt 
		'label :
	        DefaultSScope [sub_scope]
    by
    	'else 
    		DefaultSScope
end function


function addOrs Expn [expn] Alt [comma_expn]
	replace [expn]
		OldExpn [expn]

	deconstruct Alt
		', AltExpn [expn]
	by
		(OldExpn) 'or ((Expn) = AltExpn)
end function