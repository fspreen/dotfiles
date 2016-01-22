# Git Submodule Quickref #

Submodules are a way to include another project in a subdirectory.  They are
somewhat tricky to work with.  I can never remember the commands, so this is
a handy reference since I'm using them for Vim plugins in my dotfiles.

## Clone a Project with Submodules ##
The shortcut:

    $ git clone --recursive $URL

The long way:

    $ git clone $URL
    $ git submodule init
    $ git submodule update

## Add a Submodule ##
Move to the directory and execute:

``$ git submodule add $URL``

Remember to commit the .gitmodules file which stores the URL.

## Update a Submodule ##
### Making a Change to Push ###
Move to the submodule directory and execute:

    $ git fetch
    $ git merge origin/master

Alternatively:

    $ git submodule update --remote $MODULE_NAME

All submodules that need updating:

    $ git submodule update --remote

### Retrieving a Change with Pull ###
The typical ``git pull`` or fetch+merge action will update the master branch
for each submodule.

If you try ``git submodule update`` after a ``git pull`` you will wind up with
detached heads!  Do this instead:

    $ git submodule update --merge

This is equivalent to a ``git pull`` within the submodule (i.e. fetch+merge)
which should be okay as long as there haven't been any local changes in there.

Note that the above command won't work if the heads have already been detached.
Fix detached heads with:

    $ git submodule foreach git checkout master

Then follow this up with the merging submodule update as above.

## Change a Submodule URL ##
Edit the .gitmodules file to update the new URL.  (This file was created when
the submodule was added.)  Then synchronize the change with the Git
configuration:

``$ git submodule sync``

By default, this updates all submodules; consult the official Git
documentation for information on limiting this.

It also appears to update the appropriate remotes in the local copy of the
submodule's repository.  (That is, if you move to the submodule's directory
and execute ``git remote -v`` it will show the new URL.)

Remember to commit the change to .gitmodules when things are satisfactory.