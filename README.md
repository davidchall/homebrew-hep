# homebrew-hep
This repository is a place to store [Homebrew](http://brew.sh/) formulae relating to high energy physics. 
Homebrew is a package manager for OS X, keeping things nicely organised in `/usr/local`.

## Instructions
1. First install Homebrew: `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"`
2. Tell it about this repository: `brew tap davidchall/hep`
3. Install HEP packages: `brew install <formula>` (e.g. `brew install pythia8`)

If a formula conflicts with an existing formula in the master repository, use `brew install davidchall/hep/<formula>`.

For a list of available HEP packages, please see [here](https://github.com/davidchall/homebrew-hep).

## Can I contribute?
By all means, yes! I will update this document with instructions in the near future.
But in the meantime, please consult Homebrew's [wiki page](https://github.com/mxcl/homebrew/wiki/Formula-Cookbook) on how to add a new formula.
