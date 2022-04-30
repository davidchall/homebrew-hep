# Contributing

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
