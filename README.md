[![#homebrew-hep](http://higgshunter.files.wordpress.com/2013/12/logo.png)](http://davidchall.github.io/homebrew-hep/)

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



## Contributing ##
Any kind of contribution is welcome, but will require a [GitHub](https://github.com) account (GitHub _is_ pretty awesome though). If you're unfamiliar with git version control, I suggest you spend a few minutes with [this tutorial](http://try.github.com). The basic workflow is:

1. [fork](https://help.github.com/articles/fork-a-repo) homebrew-hep
2. make contribution locally
   * `brew edit <package>` or
   * `brew create http://example.com/<package>-0.1.0.tar.gz`
3. `git commit <package>.rb && git push`
4. test contribution, e.g. `brew untap davidchall/hep && brew tap <username>/hep && brew install <package>`
5. open [pull request](https://help.github.com/articles/using-pull-requests)

The Homebrew files which control the package installations are written in Ruby. I realise that this is a language unfamiliar to most high energy physicists, so I am willing to help people to add new packages. If you are struggling with a contribution or have a package request, please open an [issue](https://github.com/davidchall/homebrew-hep/issues) to discuss.

### Update a package to the latest version
This might be as simple as updating the `url` and `sha1` variables, but check the dependencies haven't changed and it still builds.

### Add a new option to an existing package
You can add a new dependency with `depends_on`, and then usually pass the location to the `configure` script (see [`herwig`](https://github.com/davidchall/homebrew-hep/blob/master/herwig%2B%2B.rb) for an example). You can also add other options with `option`. Again, it's a good idea to browse exising formulae for ideas, and even search through the [main Homebrew repository](https://github.com/mxcl/homebrew/tree/master/Library/Formula).

### Add a new package
* The `brew create http://example.com/foo-0.1.0.tar.gz` command will download the source tarball and create a template formula for you in the Homebrew repository: `/usr/local/Library/Formula/foo.rb`.
* You will need to edit the formula: `brew edit foo`. Homebrew maintains a [guide](https://github.com/mxcl/homebrew/wiki/Formula-Cookbook) on writing formulae. It might also be a good idea to browse [other HEP formulae](https://github.com/davidchall/homebrew-hep) or the [main Homebrew repository](https://github.com/mxcl/homebrew/tree/master/Library/Formula).
* Once you are done making changes and testing, move the file from the Homebrew repository to your forked version of the `homebrew-hep` tap.
* You can now continue from step 3. of the basic workflow
