* Run from the repository root: stata-mp -b do tests/test_statafun.do
version 16
set more off
adopath ++ "."
sysuse auto, clear
sort make
quietly regress price mpg
matrix coefficients_before = e(b)
quietly datasignature
local data_before `"`r(datasignature)'"'
local frame_before = c(frame)
set seed 12963
local rng_before = c(rngstate)

statafun, bank
confirm file `"`r(bank)'"'
statafun, id(5) source
assert r(id) == 5
assert r(N) == 200
assert `"`r(source)'"' == "OJA"
assert `"`r(source_url)'"' == "https://github.com/15Dkatz/official_joke_api"
statafun, type(PROGRAMMING)
assert r(N) == 40
assert `"`r(type)'"' == "programming"
statafun, type(pun)
assert r(N) == 30
statafun, categories
assert r(N) == 200

local first_id = 0
local different = 0
forvalues i = 1/30 {
    quietly statafun
    if `i' == 1 local first_id = r(id)
    if r(id) != `first_id' local different = 1
}
assert `different' == 1
assert c(rngstate) == "`rng_before'"

capture noisily statafun, id(999999)
assert _rc == 2000
capture noisily statafun, type(unknown_type)
assert _rc == 2000
capture noisily statafun, id(5) type(pun)
assert _rc == 2000
capture noisily statafun, using("tests/no_such_file.csv")
assert _rc == 601

* CSV edits are read afresh; quoted/multiline text must stay literal.
statafun, using("tests/fixtures/custom.csv") id(901) source
assert r(id) == 901
assert r(N) == 1
assert `"`r(source)'"' == "CUSTOM"
assert `"`r(source_url)'"' == "https://example.org/source"
mata: assert(strpos(st_global("r(text)"), char(36) + "STATAFUN_TEST_SENTINEL") > 0)
mata: assert(strpos(st_global("r(text)"), char(96) + "unexpanded" + char(39)) > 0)
mata: assert(strpos(st_global("r(text)"), char(10) + "Second line") > 0)
capture noisily statafun, using("tests/fixtures/custom.csv") id(902)
assert _rc == 2000
capture noisily statafun, using("tests/fixtures/duplicate.csv")
assert _rc == 198
capture noisily statafun, using("tests/fixtures/bad_schema.csv")
assert _rc == 198
capture noisily statafun, using("tests/fixtures/empty.csv")
assert _rc == 2000
capture noisily statafun, using("tests/fixtures/bad_enabled.csv")
assert _rc == 198

assert c(frame) == "`frame_before'"
assert c(rngstate) == "`rng_before'"
assert e(N) == 74
assert mreldif(e(b), coefficients_before) == 0
quietly datasignature
assert `"`r(datasignature)'"' == `"`data_before'"'
capture confirm scalar __statafun_draw
assert _rc != 0
capture confirm scalar __statafun_state
assert _rc != 0

* Working while the caller already has a preserve in effect.
preserve
statafun, id(1)
restore
display "STATAFUN_ALL_TESTS_PASS"
