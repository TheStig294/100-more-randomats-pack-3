_This is the third of my 4 randomat packs. These randomats will automatically turn on as you install the mods they need. So, if you install, or already have at least one of the mods listed below, this mod will add a randomat for it! (Or a few!)_
# Settings/Options
_Words in italics_ are console commands.\
Press ` or ~ in a game of TTT to open the console and type in _the words in italics_ (plus a space and a number) to change this mod’s settings. \
\
Alternatively, add the italic text to your __server.cfg__ (for dedicated servers)\
or __listenserver.cfg__ (for peer-to-peer servers)\
\
For example, to turn off randomats triggering at the start of a round of TTT, type in:\
_ttt_randomat_auto 0_\
(1 = on, 0 = off)\
\
_ttt_randomat_auto_ - Default: 0 - Whether the Randomat should automatically trigger on round start.\
_ttt_randomat_auto_chance_ - Default: 1 - Chance of the auto-Randomat triggering.\
_ttt_randomat_auto_silent_ - Default: 0 - Whether the auto-started event should be silent.\
_ttt_randomat_chooseevent_ - Default: 0 - Allows you to choose out of a selection of events.\
_ttt_randomat_rebuyable_ - Default: 0 - Whether you can buy more than one Randomat.\
_ttt_randomat_event_weight_ - Default: 1 - The default selection weight each event should use.\
_ttt_randomat_event_hint_ - Default: 1 - Whether the Randomat should print what each event does when they start.\
_ttt_randomat_event_hint_chat_ - Default: 1 - Whether hints should also be put in chat.\
_ttt_randomat_event_history_ - Default: 10 - How many events should be kept in history. Events in history will are ignored when searching for a random event to start.

# Newly added randomats
1. One Puuuuunch! - Gives everyone the one punch fists!
1. Hot Potato! - Gives someone a hot potato they have to pass on or explode!
1. O Rubber Tree... - Periodically gives everyone baby donconnans

# Randomats
**Randomats that don't have credit were completely made by me**

## 100% Detective Winrate
Whoever has the highest detective winrate is turned into a detective! (According to the TTT stats mod)\
\
_ttt_randomat_detectivewinrate_ - Default: 1 - Whether this randomat is enabled

## AFK = Dead
Being AFK kills you\
\
_ttt_randomat_afk_ - Default: 1 - Whether this randomat is enabled

## Bruh...
Gives everyone a bruh bunker\
\
_ttt_randomat_bruh_ - Default: 1 - Whether this randomat is enabled

## Careful where you look...
Everyone gets an amaterasu\
\
_ttt_randomat_amaterasu_ - Default: 1 - Whether this randomat is enabled

## Death isn't the end...
Everyone has a demonic possession\
\
_ttt_randomat_possession_ - Default: 1 - Whether this randomat is enabled

## Drink up!
Everyone gets a random zombies perk\
\
_ttt_randomat_drinkup_ - Default: 1 - Whether this randomat is enabled

## Everyone has their favourites
Gives everyone their most bought detective and traitor item, according to the TTT stats mod.\
If the two items take the same slot, only the most bought of the two is given.\
\
_ttt_randomat_favourites_ - Default: 1 - Whether this randomat is enabled
## Gotta buy 'em all!
Gives everyone a detective and traitor weapon they haven't bought before, according to the TTT stats mod. If the two weapons take the same slot, only the traitor weapon is given. \
\
If a player has bought all detective AND traitor items at least once, they get to choose a randomat at the start of every round for the rest of the map!\
If multiple players have bought all items, they take turns in choosing randomats.\
\
A list of all detective and traitor weapons you are yet to buy is displayed in the chat.\
\
_ttt_randomat_buyemall_ - Default: 1 - Whether this randomat is enabled

## Hack the planet!
Gives everyone a command prompt\
\
_ttt_randomat_hack_ - Default: 1 - Whether this randomat is enabled

## Home Run!
Everyone is continually given home run bats!\
\
_ttt_randomat_homerun_ - Default: 1 - Whether this randomat is enabled\
_randomat_homerun_strip_ - Default: 1 - The event strips your other weapons\
_randomat_homerun_weaponid_ - Default: weapon_ttt_homebat - Id of the weapon given\
\
Changed name from "Batter Up!"\
Originally made by [nanz](https://steamcommunity.com/sharedfiles/filedetails/?id=2194776699)

## Hot Potato!
Gives someone a ‘Hot Potato’, a weapon that after 17 seconds makes the holder explode. It must be passed to another player to avoid exploding.\
\
_ttt_randomat_potato_ - Default: 1 - Whether this randomat is enabled\
\
Idea from u/Nuclearaxe979 on reddit.

## Infinite Super Shotguns For All!
Everyone can only use an infinite ammo super shotgun as their main weapon\
\
_ttt_randomat_supershotgun_ - Default: 1 - Whether this randomat is enabled
_randomat_supershotgun_weaponid_ - Default: tfa_doom_ssg - Id of the weapon given

## It's just a flesh wound.
Everyone has a flesh wound\
\
_ttt_randomat_fleshwound_ - Default: 1 - Whether this randomat is enabled

## It's time to go third-person!
Switches everyone to an over-the-shoulder thirdperson view\
\
_ttt_randomat_thirdperson_ - Default: 1 - Whether this randomat is enabled

## Jets vs. Wings
Gives someone a jetpack and everyone else a homing pigeon.\
\
_ttt_randomat_jetswings_ - Default: 1 - Whether this randomat is enabled

## Jingle Jam
Everyone gets a random Yogscast Christmas playermodel!\
\
_ttt_randomat_jinglejam_ - Default: 1 - Whether this randomat is enabled

## Join the dark side!
Gives every player a red lightsaber\
\
_ttt_randomat_darkside_ - Default: 1 - Whether this randomat is enabled\
\
Originally made by [ruiner189](https://steamcommunity.com/sharedfiles/filedetails/?id=1988901134)

## Meow
Everyone gets an infinite ammo cat gun\
\
_ttt_randomat_meow_ - Default: 1 - Whether this randomat is enabled

## Muahahaha!
Gives everyone a deal with the devil\
\
_ttt_randomat_devildeal_ - Default: 1 - Whether this randomat is enabled

## Mystery box
Everyone gets a random COD Zombies wonder weapon!\
\
_ttt_randomat_mysterybox_ - Default: 1 - Whether this randomat is enabled

## Now, you're thinking with portals.
Everyone gets a portal gun!\
\
_ttt_randomat_portal_ - Default: 1 - Whether this randomat is enabled\
\
Changed name from "Aperture Science!", now uses a different portal gun weapon\
Originally made by [nanz](https://steamcommunity.com/sharedfiles/filedetails/?id=2194776699)

## O Rubber Tree...
Continually gives donconnans to everyone\
\
_ttt_randomat_donconnons_ - Default: 1 - Whether this randomat is enabled\
_randomat_donconnons_timer_ - Default: 5 - Time between being given donconnons\
_randomat_donconnons_strip_ - Default: 0 - The event strips your other weapons\
_randomat_donconnons_weaponid_ - Default: weapon_ttt_donconnon_randomat - Id of the weapon given\
_randomat_donconnons_damage_ - Default: 1000 - Donconnon Damage\
_randomat_donconnons_speed_ - Default: 350 - Donconnon Speed\
_randomat_donconnons_range_ - Default: 2000 - Donconnon Range\
_randomat_donconnons_scale_ - Default: 0.1 - Donconnon Size\
_randomat_donconnons_turn_ - Default: 0 - Donconnon Homing turn speed, set to 0 to disable homing\
_randomat_donconnons_lockondecaytime_ - Default: 15 - Seconds until homing stop\
\
Changed name from "O Rubber Tree", added description, made doncon projectiles much smaller, faster and one-shot, added convars to change donconnon stats, no longer strips all weapons by default, fixed donconnons eventually stopping being given out\
Originally made by [Fate](https://steamcommunity.com/sharedfiles/filedetails/?id=2122924789)

## One Puuuuunch!
Gives everyone One Punch fists!\
\
_ttt_randomat_onepunch_ - Default: 1 - Whether this randomat is enabled

## Pew! Bang! Pow!
Strips everyone of their floor weapons, if they've picked up any, and gives either a pew gun or a finger gun.\
\
_ttt_randomat_pewbangpow_ - Default: 1 - Whether this randomat is enabled

## RELEASE THE SNAILS!
Spawns snails that follow players around, killing you if they reach you. Plays “threatening” music for a while.\
\
_ttt_randomat_snails_ - Default: 1 - Whether this randomat is enabled\
_randomat_snails_cap_ - Default: 12 - Maximum number of snails spawned\
_randomat_snails_delay_ - Default: 0.5 - Delay before snails are spawned\
_randomat_snails_music_ - Default: 1 - Music plays while randomat is active

Changed name from "Don't. Blink.", modified to spawn killer snails in place of weeping angels\
Originally made by [Dem](https://steamcommunity.com/sharedfiles/filedetails/?id=1406495040)
## Random Deathmatch
Gives everyone an infinite ammo free kill gun, strips all other weapons on the ground and on players. Transforms the jester or swapper into an innocent if there is one.\
\
_ttt_randomat_rdm_ - Default: 1 - Whether this randomat is enabled

## Reach for the sky
Everyone gets a jetpack\
\
_ttt_randomat_jetpack_ - Default: 1 - Whether this randomat is enabled

## Redemption Time
Puts someone with their worst traitor partner, according to the TTT stats mod. Doesn't trigger if there aren't at least two living traitors already in the round.\
\
_ttt_randomat_redemption_ - Default: 1 - Whether this randomat is enabled

## Secret Friday Update
Everyone gets a minecraft bow and minecraft block weapon. All other weapons are striped from players and the ground.\
\
_ttt_randomat_secretfriday_ - Default: 1 - Whether this randomat is enabled

## Sharky and Palp!
Puts someone with their best traitor partner, according to the TTT stats mod. Doesn't trigger if there aren't at least two living traitors already in the round.\
\
_ttt_randomat_sharky_ - Default: 1 - Whether this randomat is enabled

## Snail Time!
Transforms everyone into a snail\
\
_ttt_randomat_snailtime_ - Default: 1 - Whether this randomat is enabled\
_randomat_snailtime_health_ - Default: 1 - Player health as a snail

## Snail Wars
Everyone gets a freeze gun and snail gun.\
\
_ttt_randomat_snailwars_ - Default: 1 - Whether this randomat is enabled

## Time Stop
All moving objects on the map freeze in place for 60 seconds, except for players.\
NOTE: This randomat is disabled by default as it can cause issues with players becoming stuck. If this randomat is enabled you may need to know how to teleport players out of places where they cannot get out.\
\
_ttt_randomat_timestop_ - Default: 0 - Whether this randomat is enabled

## UNLIMITED POWEEERRRRRR!
Everyone gets a stungun with unlimited ammo!\
\
_ttt_randomat_stungun_ - Default: 1 - Whether this randomat is enabled\
\
Originally made by [nanz](https://steamcommunity.com/sharedfiles/filedetails/?id=2194776699)

## What it's like to be ...
Gives everyone someone's playermodel and favourite traitor and detective weapon, according to the TTT stats mod.\
If the two weapons take the same slot, only the most bought of the two is given.\
\
_ttt_randomat_whatitslike_ - Default: 1 - Whether this randomat is enabled\
_randomat_whatitslike_disguise_ - Default: 0 - Hide each player’s name

## Woof Woof!
Everyone gets a guard dog\
\
_ttt_randomat_woof_ - Default: 1 - Whether this randomat is enabled

## You just triggered my trap card!
Everyone gets an uno reverse card that reflects all damage and lasts for a set amount of time\
\
_ttt_randomat_uno_ - Default: 1 - Whether this randomat is enabled\
_randomat_uno_time_ - Default: 3 - How long the uno reverse card lasts