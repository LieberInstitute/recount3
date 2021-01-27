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
