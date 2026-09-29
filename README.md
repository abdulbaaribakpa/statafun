# statafun

An offline Stata 16+ command with an editable bank of 200 jokes. No API key,
Python installation, or internet connection is needed to use the command.

## Start here

Install directly from the public GitHub repository:

```stata
net install statafun, from("https://raw.githubusercontent.com/abdulbaaribakpa/statafun/main")
statafun
```

Requires Stata 16 or newer. No GitHub account is needed. Share this command with
friends and ask them to report confusing jokes or errors in the repository's issues.

The quickest way to use this editable folder is to add it to Stata's search path:

```stata
adopath ++ "/absolute/path/to/statafun"
statafun
```

Alternatively, change Stata's working directory to this folder and run
`do start_here.do`. The path addition lasts for the current Stata session.
No changes to your Stata startup profile are made.

```stata
statafun                         // pick a joke
statafun, type(general)
statafun, type(programming)
statafun, type(pun)
statafun, type(research)
statafun, id(5) source            // exact joke, plus full source URL
statafun, categories              // available types and enabled counts
statafun, bank                    // locate the CSV being read
help statafun
```

The supplied categories contain 100 general, 40 programming, 30 pun, and 30
research-labelled jokes. These preserve the earlier review selection, including
its limitations: research is a broad provisional label, not an econometrics
collection; some programming jokes need specialist knowledge; near-duplicates
remain. You can change labels, edit text, and disable weak entries.

## Edit the bank

Open **editor.html** in a browser. Click **Open CSV**, choose
**statafun_jokes.csv**, then edit, add, remove, search, or disable jokes.
Click **Download edited CSV** and replace your working bank with the downloaded
file. Browsers usually save downloads in Downloads: the editor does not
automatically overwrite the original. Your edits stay in the browser page until
you download them; closing or refreshing it discards unsaved edits.

Alternatively, edit the CSV in Numbers, Excel, or a text editor. Spreadsheet users
must export as UTF-8 CSV (not XLSX or Numbers format). It has just six columns:

| Column | What to enter |
|---|---|
| id | Unique positive whole number; keep existing IDs stable |
| type | A short category, e.g. general, programming, pun, research, economics |
| text | The whole joke; quotes and commas are supported in correctly quoted CSV |
| source | Short display label, e.g. OJA |
| source_url | GitHub repository URL or another source URL |
| enabled | 1 to include, 0 to hide |

The command rereads the bank on every call. No rebuild is needed. Give a new joke
the next unused ID; custom categories work immediately. Do not add columns with
Stata code: all joke fields are treated as data.

For a personal bank stored separately, use:

```stata
statafun, using("/absolute/path/my_jokes.csv")
statafun, using("/absolute/path/my_jokes.csv") type(economics)
```

## Sources

`OJA` expands to the [Official Joke API repository](https://github.com/15Dkatz/official_joke_api).
Default output shows the short label. Add `source` to display the full URL;
`r(source_url)` also contains it. The upstream MIT notice is retained in
`statafun_UPSTREAM_LICENSE.txt`. See `statafun_SOURCES.md` for provenance.

## Conventional installation and GitHub

You can install from the local folder with:

```stata
net install statafun, from("/absolute/path/to/statafun")
```

This installs a separate copy in your ado directory. Use `statafun, bank` to find
that copy before editing, or use `using()` to keep your personal bank outside the
installation. Reinstalling with `replace` can overwrite the installed CSV.

The GitHub repository is public: https://github.com/abdulbaaribakpa/statafun.
Anyone can install with:

```stata
net install statafun, from("https://raw.githubusercontent.com/abdulbaaribakpa/statafun/main")
```

Keep `stata.toc`, `statafun.pkg`, and the files listed in the package at the same
location. This package has not been submitted to SSC.

## Results and state

After a joke, `return list` shows `r(id)`, `r(N)` (matching enabled candidates),
`r(text)`, `r(type)`, `r(source)`, `r(source_url)`, and `r(bank)`.
Like other r-class commands, statafun replaces previous r() results.
It uses a temporary frame and its own small random selector, preserving your
current data, active frame, estimates in e(), and Stata random-number state.
`set seed` does not control joke selection; use `id()` for repeatable output.
Repeated jokes are possible. It performs no background calls or tracking.

## Package files

- `statafun.ado`: editable Stata command source.
- `statafun.sthlp`: Stata help.
- `statafun_jokes.csv`: editable content used at runtime.
- `editor.html`: offline browser editor, with no external dependencies.
- `tests/test_statafun.do`: batch smoke and regression checks.

Package code is MIT-licensed; third-party joke text retains its source provenance.

## Verification

The Stata tests cover source display, type/ID selection, custom banks, disabled
entries, invalid schemas and IDs, literal quotes and multiline text, random
selection, and preservation of data, frame, estimates, and RNG state. Run from
this directory with `stata-mp -b do tests/test_statafun.do` (adjust executable to
your Stata edition). Check the log for `STATAFUN_ALL_TESTS_PASS`; Stata batch
exit codes alone do not reliably report do-file failures.

`node tests/test_editor.cjs` checks CSV parsing, 200-row roundtripping, editing,
and duplicate rejection without additional dependencies. The browser's local-file
preview was blocked by the tool's URL policy, so the visual editor layout and
download interaction have not been tested in a browser here.
