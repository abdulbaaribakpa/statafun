# Joke sources

## OJA

GitHub: https://github.com/15Dkatz/official_joke_api

Source data: https://github.com/15Dkatz/official_joke_api/blob/master/jokes/index.json

Upstream notice: https://github.com/15Dkatz/official_joke_api/blob/master/LICENCE

200 rows were selected in the earlier review CSV from a 451-row download on
2026-09-29. The upstream JSON did not contain item IDs. Package IDs identify
our selected rows; they are not claimed to be upstream IDs. Joke wording is
unchanged from the review file, which joined setup and punchline with an em dash
and normalized whitespace. All 200 rows use the type `joke`.

The repository carries an MIT license, reproduced in full in
statafun_UPSTREAM_LICENSE.txt. The repository says jokes were contributed by
community members; individual authorship and rights have not been independently
verified. The earlier candidate-review status remains applicable. Retaining a
GitHub link records provenance; it is not by itself a separate permission grant.

## Original anagrams

Eighty-five anagrams were created for this package with AI assistance on
2026-09-30. They were selected from 150 candidates using three rules: the letters
must match exactly after ignoring capitalization, spaces, and punctuation; the
resulting phrase must be recognizable; and the transformation must have enough
surprise or wordplay to work as a quiz. Sixty-five weaker or uninformative pairs
were excluded.

These rows use the single type `anagram`; no statistics/economics subcategory is
stored. The CSV `text` field contains the scrambled phrase and `answer` contains
the original technical term. Their short source label is `Original` and their
source URL points to this repository.

The 200 sourced humour rows use the single type `joke`. Earlier labels such as
general, programming, pun, and research were merged to keep the public interface
simple; the entry text, stable ID, source label, and source URL were not changed.

## Original riddles

One hundred riddles were written for this package with AI assistance on
2026-10-01 and reviewed for clarity, a definite answer, and relevance. The set
contains 34 general riddles, 33 statistics riddles, and 33 economics riddles.

All rows use the single type `riddle`; topic labels are not stored as categories.
The CSV `text` field contains the question and `answer` contains the solution.
Their short source label is `Original` and their source URL points to this
repository.
