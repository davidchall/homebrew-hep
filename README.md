[![#homebrew-hep](http://higgshunter.files.wordpress.com/2013/12/logo.png)](http://davidchall.github.io/homebrew-hep/)

## Introduction
Many high energy physics programs require special installation instructions for Mac OS X, and their issue trackers are often filled with unresolved Mac issues. Problems are also encountered when trying to link all these programs together.

Homebrew-hep is a Mac package manager for HEP programs, based on [Homebrew](http://brew.sh/), which tries to make life easier. In Homebrew language, it is a tap. From the end-user's perspective it is nice because it:

* keeps things organised in `/usr/local`
* automatically handles package dependencies
* is easy to update programs

## Quick start ##
1. Install [Homebrew](http://brew.sh/): `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
2. Tap homebrew-hep: `brew tap davidchall/hep`
3. Find out about package: `brew info <package>`
4. Install HEP packages: `brew install <package>` (e.g. `brew install fastjet`)

Remember to regularly `brew update`! More [detailed installation instructions](#detailed-installation-instructions) are found below.

## Available packages ##
All packages are tested on OS X 10.9 (Mavericks) on [Travis CI](https://travis-ci.org/) virtual machines. The build status of each package can be viewed [here](https://travis-ci.org/davidchall/homebrew-hep) - just click on an individual job to see a build log for that package.

Thanks to [**braumeister.org**](http://braumeister.org/repos/davidchall/homebrew-hep/browse/a), package metadata can now be browsed visually! Here is a quick list though:

* `applgrid`
* `fastjet`
* `fastnlo`
* `fjcontrib`
* `hepmc`
* `herwig`
* `hoppet`
* `jetvheto`
* `lhapdf`
* `madgraph5_amcatnlo`
* `mcfm`
* `mcgrid`
* `nlojet++`
* `openloops`
* `pythia`
* `qcdnum`
* `rivet`
* `sherpa`
* `thepeg`
* `topdrawer`
* `vbfnlo`
* `vincia`
* `whizard`
* `yoda`

Other useful Homebrew packages:

* `root` (`brew tap homebrew/science`)
* `python` (see [here](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Homebrew-and-Python.md) for why)
* `bash-completion` (enables tab-completion for some HEP packages)

If your favourite package is missing, please request it on the [issues page](https://github.com/davidchall/homebrew-hep/issues) or consider making a [contribution](#contributing).

## Guide to Homebrew ##
More documentation can be found through `brew help`, `man brew`, or the Homebrew [wiki](https://github.com/Homebrew/homebrew/tree/master/share/doc/homebrew#readme).

### General
* `brew list` List installed packages
* `brew update` Fetch the latest versions of the install scripts
* `brew outdated` Show packages that have an updated version available
* `brew upgrade` Upgrade all outdated packages
* `brew cleanup` Remove old versions of packages
* `brew doctor` Check your system for potential problems
* `brew search <string>` Substring search for package

### Packages
* `brew info <package>` Display package info (e.g. install options, dependencies)
* `brew home <package>` Open package website
* `brew install <package>` Install a specific package
* `brew upgrade <package>` Upgrade a specific package
* `brew uninstall <package>` Uninstall a specific package
* `brew test <package>` Perform a quick test on the package

## Detailed installation instructions ##
### Compilers
OS X doesn't provide compilers by default, so you must manually download these before starting. If you've already worked with C++ on your Mac then you probably have done this. There are two possible methods:

* [Xcode](http://itunes.apple.com/us/app/xcode/id497799835): Download the full IDE from the App Store and install the command line tools from the menu: Preferences->Downloads.
* [Command Line Tools for Xcode](https://developer.apple.com/downloads): Xcode is a big download, but you can download a package containing only the compilers. You will need to register with Apple Developers.

### Homebrew
Homebrew-hep is just an extension ("tap") of the [Homebrew](http://brew.sh/) package manager, so this must be installed. More detailed information on installing Homebrew is available on their [wiki](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Installation.md).

**Quick install:** Paste this into your terminal:
`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

Homebrew will keep all your packages organised within `/usr/local`. This is great because this is one of the locations automatically searched for programs, libraries, etc.

* Executables are stored in `/usr/local/bin`
* Libraries are stored in `/usr/local/lib`
* Headers are stored in `/usr/local/include`
* Other files are stored in `/usr/local/share`

### Homebrew-hep
A central part of Homebrew is its list of formulae. A formula gives Homebrew a set of instructions to follow to install a package. A tap is just an external list of formulae to be added to Homebrew's central list.

To add a list of HEP packages to Homebrew, type `brew tap davidchall/hep`.

_You are now ready to use Homebrew to install HEP programs!_

## Issues ##
* Physics problems should be reported to the package developers (please `brew home <package>`)
* Installation problems can be reported on the [issue tracker](https://github.com/davidchall/homebrew-hep/issues)

## Contributing ##
Any kind of contribution is welcome, but will require a [GitHub](https://github.com) account (GitHub _is_ pretty awesome though). If you're unfamiliar with git version control, I suggest you spend a few minutes with [this tutorial](http://try.github.com). The basic workflow is:

1. make contribution locally
   * `brew edit <package>` or
   * `brew create http://example.com/<package>-0.1.0.tar.gz`
2. test, e.g. `brew install <package>`, `brew test <package>`
3. conforms to style? `brew audit <package>`
4. [fork](https://help.github.com/articles/fork-a-repo) homebrew-hep
5. `cp /usr/local/Library/Formula/<package>.rb /path/to/your/repo`
6. `git commit <package>.rb && git push`
7. open [pull request](https://help.github.com/articles/using-pull-requests)

The Homebrew files which control the package installations are written in Ruby. I realise that this is a language unfamiliar to most high energy physicists, so I am willing to help people to add new packages. If you are struggling with a contribution or have a package request, please open an [issue](https://github.com/davidchall/homebrew-hep/issues) to discuss.

### Update a package version
This might be as simple as updating the `url` and `sha256` variables, but check the dependencies haven't changed and it still builds.

### Add new option to a package
You can add a new dependency with `depends_on`, and then usually pass the location to the `configure` script (see the [Herwig formula](https://github.com/davidchall/homebrew-hep/blob/master/herwig.rb) for an example). You can also add other options with `option`. Again, it's a good idea to browse existing formulae for ideas, and even search through the [main Homebrew repository](https://github.com/Homebrew/homebrew/tree/master/Library/Formula).

### Add a new package
* The `brew create http://example.com/foo-0.1.0.tar.gz` command will download the source tarball and create a template formula for you in the Homebrew repository: `/usr/local/Library/Formula/foo.rb`.
* You will need to edit the formula: `brew edit foo`. Homebrew maintains a [guide](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md) on writing formulae. It might also be a good idea to browse [other HEP formulae](https://github.com/davidchall/homebrew-hep) or the [main Homebrew repository](https://github.com/Homebrew/homebrew/tree/master/Library/Formula).
