pz_chainsaw_mod
===============

Project Zomboid chainsaw item mod

I want to chop down trees with a chainsaw. My main priority is to get
the functionality. I plan to consider sound and graphics after I can cut
down trees and perhaps carve logs into planks.

Setup:

    I'm currently linking the pz_chainsaw_mod/chainsaw/ directory into the
media/lua/client/ directory in the steam PZ dir.
(~/.steam/steam/SteamApps/common/ProjectZomboid/projectzomboid/media/lua/client/)

    I'm also linking scripts/chainsaw.txt into <steam
dir>/media/scripts/

e.g.
ln -s ~/dev/pz_chainsaw_mod/chainsaw/
~/.steam/steam/SteamApps/common/ProjectZomboid/projectzomboid/media/lua/client/chainsaw/

ln -s ~/dev/pz_chainsaw_mod/scripts/chainsaw.txt
~/.steam/steam/SteamApps/common/ProjectZomboid/projectzomboid/media/scripts/chainsaw.txt

Ideas:
- chop logs on the ground into planks on the ground
- chainsaw will require gas
- chainsaw will be fairly loud, but not quite gunshot loud
- chainsaw will be a handy zombie weapon
