{smcl}
{* *! version 0.3.0 01oct2026}{...}
{title:statafun — Jokes, anagrams, and riddles for Stata}

{p 4 4 2}Requires Stata 16 or newer. All content is stored locally.

{title:Syntax}
{p 8 12 2}{cmd:statafun} [{cmd:,} {opt type(string)} {opt id(#)} {opt answer}
{opt source} {opt categories} {opt bank} {opt using(filename)}]

{title:Examples}
{p 8 8 2}{cmd:statafun}
{p 8 8 2}{cmd:statafun, type(joke)}
{p 8 8 2}{cmd:statafun, type(anagram)}
{p 8 8 2}{cmd:statafun, type(riddle)}
{p 8 8 2}{cmd:statafun, id(286) answer}
{p 8 8 2}{cmd:statafun, categories}

{title:Options}
{p 4 8 2}{opt type(string)} selects joke, anagram, riddle, or a custom type.
{p 4 8 2}{opt id(#)} selects a specific enabled entry.
{p 4 8 2}{opt answer} reveals an anagram or riddle answer.
{p 4 8 2}{opt source} displays the full source URL.
{p 4 8 2}{opt categories} lists enabled types and counts.
{p 4 8 2}{opt bank} displays the path to the active CSV bank.
{p 4 8 2}{opt using(filename)} reads a different CSV bank.

{title:Content}
{p 4 4 2}The bundled bank contains 200 jokes, 85 anagrams, and 100 riddles.
Riddle topics include general knowledge, statistics, and economics, but all use
the single type riddle.

{title:CSV bank}
{p 4 4 2}Columns are id, type, text, answer, source, source_url, and enabled.
Set enabled to 1 to include an entry or 0 to hide it. Answers are required for
enabled anagrams and riddles. The CSV is reloaded on every call.

{title:Stored results}
{p 4 4 2}r(id), r(N), r(text), r(answer), r(type), r(source), r(source_url),
and r(bank).

{title:Source}
{p 4 4 2}{browse "https://github.com/abdulbaaribakpa/statafun":statafun on GitHub}
