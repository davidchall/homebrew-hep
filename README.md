# homebrew-hep
![homebrew-hep](http://higgshunter.files.wordpress.com/2013/12/logo.png)

[Click here](https://travis-ci.org/davidchall/homebrew-hep) for build status of individual packages.

## Introduction
Many high energy physics programs require special installation instructions for Mac OS X, and their issue trackers are often filled with unresolved Mac issues. Problems are also encountered when trying to link all these programs together.

Homebrew-hep is a Mac package manager for HEP programs, based on [Homebrew](http://brew.sh/). In Homebrew language, it is a tap. From the end-user's perspective it is nice because it:
* keeps things organised in `/usr/local` 
* automatically handles package dependencies
* is easy to update programs

## Instructions
1. Install [Homebrew](http://brew.sh/): `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"`
2. Tap homebrew-hep: `brew tap davidchall/hep`
3. Install HEP packages: `brew install <package>` (e.g. `brew install pythia8`)

Here are [more detailed installation instructions](https://github.com/davidchall/homebrew-hep/wiki/Detailed-installation-instructions) and a [list of available HEP packages](https://github.com/davidchall/homebrew-hep/wiki/List-of-packages).

***

### Help
* [Short guide to Homebrew commands](https://github.com/davidchall/homebrew-hep/wiki/Homebrew-guide)
* Problems with the packages themselves should be reported to the authors of the respective package (please `brew home <package>`)
* Problems with the Mac installation through Homebrew-hep can be reported on the [issue tracker](https://github.com/davidchall/homebrew-hep/issues)

### Can I contribute?
Of course! [Here](https://github.com/davidchall/homebrew-hep/wiki/How-to-contribute) is a guide to how. Some possible ways could be:
* add a new package
* add a new option to an existing package
* update a package to the latest version
