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
        else
            if x = m then
                put "hi"
                k := 3
            else
                if m > n then
                    if m = 5 then
                        x := m * n
                    else
                        if y = z then
                            x := 4
                        'end if
                    'end if
                    put x
                else
                    put "that's it"
                'end if
            'end if
        'end if
	by
		if x = y then
            z :=1
        elsif x = m then
            put "hi"
            k := 3
        elsif m > n then
            if m = 5 then
                x := m * n
            elsif y = z then
                x := 4
            'end if
            put x
        else
            put "that's it"
        'end if
end rule
