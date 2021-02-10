# recount3 1.1.7

BUG FIXES

* `read_counts()` now reads the gene/exon counts for every sample as numeric
instead of integer in order to support count values that exceed the 32bit
integer threshold (such as `2447935369`). Previously, `read_counts()` would
report tiny fractions for such large numbers. This bug was reported by
Christopher Wilks.

# recount3 1.1.6

BUG FIXES

* Now `project_homes()` reads in a text file from
`recount3_url`/`organism`/homes_index which enables support for custom URLs such
as http://snaptron.cs.jhu.edu/data/temp/recount3test.

# recount3 1.1.4

BUG FIXES

* Fixed `project_homes()`, `available_projects()` and `available_samples()` to
support using non-standard `recount3_url`s where the user knows that are the
`project_homes()` for their organism of choice. This fix enables users to 
create their own custom recount3-like webservers and access their data using
the functions in this package. This fix introduces the argument
`available_homes` to both `available_projects()` and `available_samples()`. This
bug was reported by Christopher Wilks.

# recount3 1.1.3

NEW FEATURES

* Added `expand_sra_attributes()` that was contributed by Andrew E Jaffe. This
function expands the SRA attributes stored in a given SRA study, which makes it
easier to use that data. However, it makes it harder to merge studies and thus
should be used with caution.

# recount3 1.1.1

BUG FIXES

Fixed `locate_url()` for GTEx & TCGA BigWig files.

# recount3 0.99.0

NEW FEATURES

* Added a `NEWS.md` file to track changes to the package.
* Documentation website is now available at
http://LieberInstitute.github.io/recount3/. It gets updated with every commit on
the master branch (bioc-devel) using GitHub Actions and pkgdown.
