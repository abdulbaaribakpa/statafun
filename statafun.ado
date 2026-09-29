*! version 0.1.1 29sep2026
program define statafun, rclass
    version 16.0
    syntax [, TYPE(string) ID(integer 0) SOURCE CATEGORIES BANK USING(string)]

    local __bank `"`using'"'
    if `"`__bank'"' == `""' {
        capture findfile statafun_jokes.csv
        if _rc {
            display as error "statafun: statafun_jokes.csv was not found on the adopath."
            exit 601
        }
        local __bank `"`r(fn)'"'
    }

    capture confirm file `"`__bank'"'
    if _rc {
        display as error "statafun: joke bank file not found: `__bank'"
        exit 601
    }

    if "`bank'" != "" {
        display as text _asis `"`macval(__bank)'"'
        return local bank `"`macval(__bank)'"'
        exit
    }

    tempname __frame
    frame create `__frame'
    local __opts bank(`"`macval(__bank)'"') id(`id')
    if `"`macval(type)'"' != `""' local __opts `__opts' type(`"`macval(type)'"')
    if "`source'" != "" local __opts `__opts' source
    if "`categories'" != "" local __opts `__opts' categories

    capture noisily frame `__frame': _statafun_helper, `__opts'
    local __rc = _rc
    if !`__rc' return add
    frame drop `__frame'
    if `__rc' exit `__rc'
end

program define _statafun_helper, rclass
    version 16.0
    syntax , BANK(string) ID(integer) [TYPE(string) SOURCE CATEGORIES]

    capture quietly import delimited using `"`macval(bank)'"', ///
        varnames(1) stringcols(_all) encoding(UTF-8) bindquote(strict) ///
        maxquotedrows(unlimited)
    if _rc {
        display as error "statafun: could not import the joke bank as UTF-8 CSV."
        exit 198
    }

    foreach __v in id type text source source_url enabled {
        capture confirm variable `__v'
        if _rc {
            display as error "statafun: schema error; required column `__v' is missing."
            exit 198
        }
    }

    quietly generate double __sf_id = real(trim(id))
    quietly generate byte __sf_enabled = real(trim(enabled))
    quietly generate strL __sf_type = lower(trim(type))
    quietly generate long __sf_row = _n

    quietly count if missing(__sf_id) | __sf_id <= 0 | __sf_id != floor(__sf_id)
    if r(N) {
        display as error "statafun: every id must be a positive integer."
        exit 198
    }
    quietly duplicates tag __sf_id, generate(__sf_dup)
    quietly count if __sf_dup
    if r(N) {
        display as error "statafun: id values must be unique, including disabled rows."
        exit 198
    }
    quietly count if trim(enabled) != "0" & trim(enabled) != "1"
    if r(N) {
        display as error "statafun: enabled must contain only 0 or 1."
        exit 198
    }
    quietly count if __sf_enabled == 1 & (trim(type) == "" | trim(text) == "")
    if r(N) {
        display as error "statafun: enabled rows must have nonempty type and text."
        exit 198
    }

    quietly count if __sf_enabled == 1
    local __enabled_n = r(N)
    if !`__enabled_n' {
        display as error "statafun: the joke bank has no enabled jokes."
        exit 2000
    }

    if "`categories'" != "" {
        quietly compress __sf_type
        gsort __sf_type -__sf_enabled __sf_id
        quietly generate byte __sf_tag = __sf_enabled == 1 & ///
            (_n == 1 | __sf_type != __sf_type[_n-1])
        quietly count if __sf_tag
        forvalues __i = 1/`=_N' {
            if __sf_tag[`__i'] {
                local __cat = __sf_type[`__i']
                quietly count if __sf_enabled == 1 & __sf_type == `"`macval(__cat)'"'
                local __n = r(N)
                display as text _asis `"`macval(__cat)'  `__n'"'
            }
        }
        return scalar N = `__enabled_n'
        return local bank `"`macval(bank)'"'
        exit
    }

    quietly generate byte __sf_match = __sf_enabled == 1
    if `"`macval(type)'"' != `""' {
        quietly replace __sf_match = 0 if __sf_type != lower(trim(`"`macval(type)'"'))
    }

    quietly count if __sf_match
    local __N = r(N)
    if `id' != 0 {
        quietly count if __sf_id == `id' & __sf_enabled == 1
        local __id_enabled = r(N)
        quietly count if __sf_id == `id' & __sf_match
        if !r(N) {
            if !`__id_enabled' {
                display as error "statafun: id `id' is missing or disabled."
            }
            else {
                display as error "statafun: id `id' is incompatible with the requested type."
            }
            exit 2000
        }
        quietly summarize __sf_row if __sf_match & __sf_id == `id', meanonly
        local __row = r(min)
    }
    else {
        if !`__N' {
            if `"`macval(type)'"' != `""' {
                display as error "statafun: no enabled jokes match type `type'."
            }
            else display as error "statafun: no enabled jokes are available."
            exit 2000
        }
        mata: st_local("__u", strofreal(_statafun_next(), "%21.0f"))
        local __k = floor(`__u' * `__N' / 2147483647) + 1
        quietly generate long __sf_ord = sum(__sf_match)
        quietly summarize __sf_row if __sf_match & __sf_ord == `__k', meanonly
        local __row = r(min)
    }

    local __id_out = __sf_id[`__row']
    local __type_out = type[`__row']
    local __text_out = text[`__row']
    local __source_out = source[`__row']
    local __url_out = source_url[`__row']

    display as text _asis `"`macval(__text_out)'"'
    local __credit `"Source: `macval(__source_out)'"'
    display as text _asis `"`macval(__credit)'"'
    if "`source'" != "" display as text _asis `"`macval(__url_out)'"'

    return scalar id = `__id_out'
    return scalar N = `__N'
    return local text `"`macval(__text_out)'"'
    return local type `"`macval(__type_out)'"'
    return local source `"`macval(__source_out)'"'
    return local source_url `"`macval(__url_out)'"'
    return local bank `"`macval(bank)'"'
    exit
end

mata:
// A private Mata external holds Park-Miller state. No Stata scalars or RNG
// settings are changed. Reloading Mata clears this separate sequence.
real scalar _statafun_next()
{
    real scalar m, s, t
    pointer(real scalar) scalar p
    m = 2147483647
    p = findexternal("_statafun_state")
    if (p == NULL) {
        p = crexternal("_statafun_state")
        t = clock(st_global("c(current_date)") + " " + st_global("c(current_time)"), "DMYhms")
        s = mod(t, m - 1) + 1
    }
    else s = *p
    s = mod(16807 * s, m)
    if (s <= 0) s = 1
    *p = s
    return(s)
}
end
