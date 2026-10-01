# statafun

`statafun` adds short jokes, anagrams, and riddles to Stata. Everything is stored
locally in an editable CSV file, so the command works without an API key or an
internet connection.

## Install

```stata
net install statafun, from("https://raw.githubusercontent.com/abdulbaaribakpa/statafun/main")
```

Stata 16 or newer is required.

## Use

```stata
statafun                       // any entry
statafun, type(joke)           // a joke or pun
statafun, type(anagram)        // an anagram with a hidden answer
statafun, type(riddle)         // a riddle with a hidden answer
statafun, categories           // list available types and counts
```

Anagrams and riddles display the command needed to reveal their answer. For
example:

```stata
statafun, id(286) answer
```

Use `id()` to select a specific entry, `source` to show its full source URL, and
`bank` to locate the CSV file currently in use.

## Content

The bundled bank contains:

- 200 jokes and puns
- 85 anagrams
- 100 riddles: 34 general, 33 statistics, and 33 economics

The public interface has only three types: `joke`, `anagram`, and `riddle`.
Riddle topics are intentionally not separate categories.

The riddles and anagrams were written for this package with AI assistance and
quality-checked before inclusion. The sourced jokes retain their short source
label and full source URL in the CSV. Detailed provenance is recorded in
`statafun_SOURCES.md`.

## Edit the bank

`statafun_jokes.csv` is read each time the command runs. Changes therefore take
effect immediately. The file can be edited as UTF-8 CSV or through the included
offline `editor.html` page.

The columns are:

| Column | Purpose |
|---|---|
| `id` | Stable positive integer |
| `type` | `joke`, `anagram`, or `riddle` |
| `text` | Joke text, anagram prompt, or riddle question |
| `answer` | Answer for anagrams and riddles |
| `source` | Short source label |
| `source_url` | Full source or provenance URL |
| `enabled` | `1` to include the entry, `0` to hide it |

A separate bank can be supplied without changing the installed file:

```stata
statafun, using("/absolute/path/my_bank.csv")
```

## License and source

The package code is MIT-licensed. Third-party joke text retains its recorded
provenance and upstream notice. See `statafun_LICENSE.txt`,
`statafun_UPSTREAM_LICENSE.txt`, and `statafun_SOURCES.md`.

The source repository is
[github.com/abdulbaaribakpa/statafun](https://github.com/abdulbaaribakpa/statafun).
