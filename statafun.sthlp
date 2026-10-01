{smcl}
{* *! version 0.3.1 01oct2026}{...}
{title:statafun — Jokes, anagrams, and riddles for Stata}

{title:Syntax}

{cmd:statafun} [{cmd:,} {opt type(string)} {opt id(#)} {opt answer} {opt source} {opt categories}]

{title:Examples}

{cmd:statafun}{break}
{cmd:statafun, type(joke)}{break}
{cmd:statafun, type(anagram)}{break}
{cmd:statafun, type(riddle)}{break}
{cmd:statafun, id(286) answer}{break}
{cmd:statafun, categories}

{title:Options}

{opt type(string)} selects joke, anagram, riddle, or a custom type.{break}
{opt id(#)} selects a specific entry.{break}
{opt answer} reveals an anagram or riddle answer.{break}
{opt source} displays the full source URL.{break}
{opt categories} lists the available types and counts.
