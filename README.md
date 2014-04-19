pz_chainsaw_mod
===============

Project Zomboid chainsaw item mod

I want to chop down trees with a chainsaw. I've currently got a working
chainsaw with silly sounds that can chop down trees and kill zombies.
I'm currently (as of this commit date) working on getting fuel amounts
and fuel filling menus working.

Warning:

BACK UP YOUR SAVE!

I've mangled a bunch of saves so please back up any saves before using
this.

Setup:

Note that I'm developing this on Linux.

I'm currently linking the pz_chainsaw_mod/chainsaw/ directory into the
media/lua/client/ directory in the steam PZ dir.
(~/.steam/steam/SteamApps/common/ProjectZomboid/projectzomboid/media/lua/client/)

I'm also linking scripts/chainsaw.txt into <steam dir>/media/scripts/

e.g.
ln -s ~/dev/pz_chainsaw_mod/chainsaw/
    ~/.steam/steam/SteamApps/common/ProjectZomboid/projectzomboid/media/lua/client/chainsaw/

ln -s ~/dev/pz_chainsaw_mod/scripts/chainsaw.txt
    ~/.steam/steam/SteamApps/common/ProjectZomboid/projectzomboid/media/scripts/chainsaw.txt

Mod Loader:

I've got a simple mod picture and info but the mod loader doesn't seem
to be working for me and I'm not super interested in distribution at
this point.

Ideas:
- chop logs on the ground into planks on the ground
- chainsaw will require gas
- chainsaw will be fairly loud, but not quite gunshot loud
- chainsaw will be a handy zombie weapon
