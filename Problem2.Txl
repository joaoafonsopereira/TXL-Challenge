include "Turing.Grm"

function main
    replace [program]
        P [program]
    by
        P [introduceElsifs]
end function

rule introduceElsifs
	replace [statement]
		if IfExpn [expn] then
            IfSScope [sub_scope]
        Elsifs [repeat elsif_clause]
        else
            if InnerIfExpn [expn] then
            	InnerIfSScope [sub_scope]
            ElseClause [opt else_clause]
            'end if
            % RestOfScope [statement*]
        'end if

    construct NewElsifClause [elsif_clause]
    	'elsif InnerIfExpn 'then
    		InnerIfSScope
	by
		if IfExpn then
            IfSScope
        Elsifs [. NewElsifClause]
    	ElseClause
    	'end if
end rule