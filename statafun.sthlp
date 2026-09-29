{smcl}
{* *! version 0.1.0 29sep2026}{...}
{title:statafun — Offline jokes from an editable CSV bank}

{p 4 4 2}Requires Stata 16 or newer. No network access or extra packages required.

{title:Syntax}
{p 8 12 2}{cmd:statafun} [{cmd:,} {opt type(string)} {opt id(#)} {opt source}
{opt categories} {opt bank} {opt using(filename)}]

{title:Examples}
{p 8 8 2}{cmd:statafun}
{p 8 8 2}{cmd:statafun, type(programming)}
{p 8 8 2}{cmd:statafun, type(pun)}
{p 8 8 2}{cmd:statafun, id(5) source}
{p 8 8 2}{cmd:statafun, categories}
{p 8 8 2}{cmd:statafun, bank}
{p 8 8 2}{cmd:statafun, using("/path/to/my_jokes.csv")}

{title:Options}
{p 4 8 2}{opt type(string)} selects an enabled category, ignoring case. The supplied
bank uses general, programming, pun, and research. New categories work without code changes.
{p 4 8 2}{opt id(#)} displays a particular positive ID. With type(), it must also
belong to that category. Disabled IDs cannot be selected.
{p 4 8 2}{opt source} displays the full source URL. The short source label is
shown by default. OJA means Official Joke API.
{p 4 8 2}{opt categories} lists enabled categories and counts.
{p 4 8 2}{opt bank} displays and returns the path to the CSV used by the command.
{p 4 8 2}{opt using(filename)} reads a personal CSV instead of the bundled bank.

{title:Editing}
{p 4 4 2}Use {cmd:statafun, bank} to find the current file. Edit it in a spreadsheet
or text editor and save as UTF-8 CSV. The development folder also includes an offline
browser editor, editor.html. Its Download button saves an edited CSV; replace the
working bank with that download. The command reloads the CSV on every call.

{p 4 4 2}Required columns: {bf:id}, {bf:type}, {bf:text}, {bf:source},
{bf:source_url}, {bf:enabled}. IDs must be unique positive integers. Set enabled to
1 to include or 0 to hide. Give new jokes unused IDs and keep existing IDs stable.
Save a backup of personal edits before reinstalling the package with replace.

{title:Stored results}
{p 4 4 2}After displaying a joke: r(id), r(N) (matching enabled candidates), r(text),
r(type), r(source), r(source_url), and r(bank). Existing r() results are replaced.

{title:Research session state}
{p 4 4 2}The active frame, its data, e() estimation results, and Stata's random-number
state are preserved. Selection uses a separate lightweight random generator.
{cmd:set seed} does not control jokes. Use id() for reproducible selection.
Repeated jokes are possible.

{title:Source and content}
{p 4 4 2}{browse "https://github.com/15Dkatz/official_joke_api":Official Joke API on GitHub}.
Upstream MIT notice is included in statafun_UPSTREAM_LICENSE.txt; provenance is in
statafun_SOURCES.md. The 200 jokes preserve the previous review selection. Research
is a provisional broad label, not a specialized econometrics collection. Some
programming jokes require technical background. Edit or disable items to suit your audience.
