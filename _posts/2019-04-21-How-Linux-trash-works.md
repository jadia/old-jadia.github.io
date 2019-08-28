---
layout: post
title: How Linux Trash works
excerpt_separator: <!--more-->
---
Notes:

- accidently delete files - trash can saviour
- for inexperienced user it's two step process
- earlier GNOME and KDE had their own trash mechanisms
- Trash storage uses unix file system tree approach

- Trash directory - a directory where trashed files and their info(original name/location, time of trashing,etc) are stored. 
- several trash dir possible on different mount locations
- a user home directory SHOULD have a trash directory.
- Home trash should be created for any new user.
- Different implementations:
  - some may accept deleted files from other partitions too(network, removable disks).
    - this is a 'failsafe' option - other than home no other place will be filled.
    - con: costly file copying between partitions, network and removable
  - But most OS choose not to support the above method of accepting deleted files from all over the system.
- On top directory (/ or /home) trashing can be done in two ways
  1. Create an $topdir/**.Trash** directory and permit all users who can trash file to write in it. Sticky bit permission must be set. While deleting from non-home partition check for $topdir/.Trash

#### Resources

1. [Ubuntu trash implementation](https://askubuntu.com/questions/27176/how-does-the-trash-can-work-and-where-can-i-find-official-documentation-refere)
2. [Trash specification](https://specifications.freedesktop.org/trash-spec/trashspec-latest.html)