include "Turing.Grm"

% Grammar overrides borrowed from last problem's solution

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

redefine expn
		[primary]
	| 	[expn] [op] [expn]
end redefine


%%%%%% Transformation rules

function main
    replace [program]
        P [program]
    by
        P [introduceCaseStatements]
end function


rule introduceCaseStatements
	
	replace [statement]
		IfClause [if_clause]
		ElsifClauses [repeat elsif_clause]
		ElseClause [opt else_clause]
		'end if

	deconstruct IfClause
		'if E [expn] = V [expn] 'then
	    	IfSScope [sub_scope]

	where all
		E [isTestedForEqualityIn each ElsifClauses]

	construct CaseAlternatives [repeat case_alternative]
		_ [addCase each ElsifClauses]

	construct LastCaseAlternative [opt last_case_alternative]
		_ [addOptDefaultCase ElseClause]

	by
		'case E 'of
        	'label V:
        		IfSScope
            CaseAlternatives
            LastCaseAlternative
        'end 'case
       
end rule


function isTestedForEqualityIn ElsifClause [elsif_clause]

	deconstruct ElsifClause
		'elsif E [expn] = _ [expn] 'then
    		_ [sub_scope]
	match [expn]
		E

end function


function addCase ElsifClause [elsif_clause]
	
	replace [repeat case_alternative]
		OldCases [repeat case_alternative]

	deconstruct ElsifClause
		'elsif E [expn] = V [expn] 'then
	    	SScope [sub_scope]

	construct NewCase [case_alternative]
		'label V:
            SScope
    by
    	OldCases [. NewCase]

end function


function addOptDefaultCase ElseClause [opt else_clause]
	
	replace [opt last_case_alternative]
		_ [opt last_case_alternative]

	deconstruct ElseClause
		'else
            Sscope [sub_scope]
    by
    	'label :
            Sscope

end function