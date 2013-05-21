
# About

GitX is a gitk-like clone written specifically for OS X.  This means that it
has a native interface and tries to integrate with the operating system as good
as possible.


# Features

  * History browsing of your repository
  * Nicely formatted diff of any revision
  * Search based on author or revision subject
  * Show the complete tree of any revision

# License

GitX is licensed under the GPL version 2.  For more information, see the
included LICENSE.txt file.

# Usage

GitX itself is fairly simple.  Most of its power is in the 'gitx' binary, which
you should install through the menu.  the 'gitx' binary supports most of git
rev-list's arguments.  For example, you can run `gitx --all' to display all
branches in the repository, or `gitx -- Documentation' to only show commits
relating to the 'Documentation' subdirectory.  With `gitx -Shaha', gitx will
only show commits that contain the word 'haha'.  Similarly, with 'gitx
v0.2.1..', you will get a list of all commits since version 0.2.1.

