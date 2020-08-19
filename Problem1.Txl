% Turing Null Transform
% Jim Cordy
% Queen's University, October 1988

include "Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [replaceElsifs]
end function

rule replaceElsifs
	replace [statement]
		if IfExpn [expn] then
            IfSScope [sub_scope]
        elsif ElsifExpn [expn] then
        	ElsifSScope [sub_scope]
		RmningElsifs [repeat elsif_clause]
        ElseClause [opt else_clause]
        'end if
	by
		'if IfExpn then
            IfSScope
        'else
            'if ElsifExpn then
            	ElsifSScope			 
            RmningElsifs
            ElseClause
            'end 'if
        'end 'if 
end rule