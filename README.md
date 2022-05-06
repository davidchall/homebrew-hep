# Website for homebrew-hep

The homebrew-hep website is found [here](https://davidchall.github.io/homebrew-hep/).

It is based on [formulae.brew.sh](https://formulae.brew.sh), whose source is found [here](https://github.com/Homebrew/formulae.brew.sh).
The main changes needed were:

1. Edit [formulae.html](./_includes/formulae.html) template to handle external dependencies (not found in tap).
2. Add [formula_external.html](./_includes/formula_external.html) template to output useful information about an external formula.
3. Edit [formula.html](./_layouts/formula.html) template to remove unsupported features (e.g., casks, API, analytics data).
4. Edit [base.html](./_layouts/base.html) template (source from [brew.sh](https://github.com/Homebrew/brew.sh)) to remove Homebrew-specific services (e.g., Google Analytics, Algolia search).

The website is built by a GitHub Actions workflow found [here](https://github.com/davidchall/homebrew-hep/blob/HEAD/.github/workflows/website.yml).
