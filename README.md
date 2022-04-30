[![#homebrew-hep](https://raw.githubusercontent.com/davidchall/homebrew-hep/master/.github/homebrew-hep-logo.png)](https://github.com/davidchall/homebrew-hep)

## Introduction

Many high energy physics programs require special installation instructions for macOS, and their issue trackers are often filled with unresolved Mac issues. Problems are also encountered when trying to link all these programs together.

Homebrew-hep is a macOS package manager for HEP programs, based on [Homebrew](https://brew.sh/), which tries to make life easier. In Homebrew terminology, it is a tap. From the user's perspective it is nice because it:

* Keeps things organised in a dedicated directory
* Automatically handles package dependencies
* Makes it easy to update programs

## Quick start

1. Install [Homebrew](https://brew.sh/)
2. Tap homebrew-hep: `brew tap davidchall/hep`
3. Learn about a package: `brew info <package>`
4. Install a package: `brew install <package>`

## Available packages

A list of HEP packages provided by homebrew-hep can be found [here](https://github.com/davidchall/homebrew-hep/tree/master/Formula).

Other Homebrew packages useful for high energy physics:

* `root` ([see details](https://formulae.brew.sh/formula/root))
* `bash-completion` (enables tab-completion for some HEP packages)

If your favourite HEP package is missing, please request it on the [issues page](https://github.com/davidchall/homebrew-hep/issues) or consider making a [contribution](./CONTRIBUTING.md).

## Issues
* Report physics problems to the package developers (`brew home <package>`)
* Report installation problems on the [issue tracker](https://github.com/davidchall/homebrew-hep/issues)
