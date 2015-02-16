# Instructions

1. Open up your terminal
2. Copy the following command and hit return:

```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/makersacademy/our-boxen/master/install)"

```

**This will take a while.** Be patient. Why not use this time to get to know your new peers?

Once this has finished, proceed to add your SSH key to Github.

## Add your SSH key to Github ##

In your terminal window, copy the following and hit return:

```sh
cat ~/.ssh/id_rsa.pub
```

In a browser (Chrome will have been installed in step 2 above), log in to Github and add the response from the previous command to your SSH Keys there.

**Congratulations, you're all set up!**

# What have we installed?

This installs the following software:

* Xcode command line tools
* Ruby 2.1.3
* Node v0.10
* Bundler
* Sublime Text 2
* iTerm2
* Chrome browser

The script will also generate an SSH public key to `~/.ssh/id_rsa.pub`.

## Boxen notes

This script is built on top of [Boxen](https://boxen.github.com/).

* Boxen __requires__ at least the Xcode Command Line Tools installed.
* Boxen __will not__ work with an existing rvm install.
* Boxen __may not__ play nice with a GitHub username that includes dash(-)
* Boxen __may not__ play nice with an existing rbenv install.
* Boxen __may not__ play nice with an existing chruby install.
* Boxen __may not__ play nice with an existing homebrew install.
* Boxen __may not__ play nice with an existing nvm install.
* Boxen __recommends__ installing the full Xcode.
