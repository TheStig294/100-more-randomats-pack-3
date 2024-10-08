# 100 More Randomats Pack 3
The randomat is a mechanic for TTT that triggers a random effect either when the "Randomat-4000" item is bought and used by a detective, or automatically at the start of every round.\
This mod adds many new "randomats" that could happen.\
This is the third of my 3 randomat packs. These randomats require other less known mods to work, many of which you might not already have installed, linked in the list of randomats below.

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

1. Let's play the 1812 Overture - Gives everyone an artillery cannon or PHD flopper
1. Minimap: Activated - Displays a minimap one everyone's screen
1. Megamind - Everyone changes to a Megamind playermodel
1. Sips sends his regards - Everyone gets one of these models: <https://steamcommunity.com/sharedfiles/filedetails/?id=2659543412>
1. Am I a jester or a traitor? - There is a jester, and a traitor with a maclunkey gun!
1. Random joke weapons for all!

# Randomats

__Randomats that don't have credit were completely made by me__

## AFK = Dead

Being AFK kills you\
\
_ttt_randomat_afk_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=572519224>

## Air Raid

Everyone gets a gravity changer
\
_ttt_randomat_afk_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=1618719637>

## Am I a jester or a traitor?

Makes someone a jester, and gives a traitor a "maclunkey" gun, which makes them deal no damage until they use it.
\
_ttt_randomat_maclunkey_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=1960689564>

## Bruh

Gives everyone a bruh bunker\
\
_ttt_randomat_bruh_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=1796374263>

## Careful where you look

Everyone gets an Amaterasu\
\
_ttt_randomat_amaterasu_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=3165277026>

## Combo

Triggers a random pair of randomats from a pre-made list.\
The possible pairs are listed below and and be individually turned on/off.\
If one of the randomats in the pair is turned off, then any pair using that randomat won't trigger.\
\
General idea and some combos suggested by u/venort_on Reddit.

### "Combo: Why aren't you dead?"

Infinite super shotguns + delayed damage!\
_ttt_randomat_cdelayshotguns_ - Default: 1 - Whether this randomat is enabled\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2055805086>\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2236037793>

### "Combo: KFC"

Everyone is a chicken + has an amaterasu!\
_ttt_randomat_cfirechicken_ - Default: 1 - Whether this randomat is enabled\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=1978094981>\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2428342861>

### "Combo: Sonic Potato!"

Pass on the hot potato or explode + while you have it you're super fast!\
_ttt_randomat_cpotato_ - Default: 1 - Whether this randomat is enabled\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2428342861>\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2377790970>

### "Combo: Snails vs. snails"

Everyone is a snail + has a snail following them!\
_ttt_randomat_csnails_ - Default: 1 - Whether this randomat is enabled\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2151761122>

### "Combo: Uh-oh"

Innocents freeze every 30 secs + RELEASE THE SNAILS!\
_ttt_randomat_csnailsfreeze_ - Default: 1 - Whether this randomat is enabled\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2055805086>\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2151761122>

### "Combo: Wibbly wobbly timey wimey"

Everyone gets a time manipulator + gravity changer!\
_ttt_randomat_ctimegravity_ - Default: 1 - Whether this randomat is enabled\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=1618719637>\
<https://steamcommunity.com/sharedfiles/filedetails/?id=1318271171>

### "Combo: Yogscast"

Yogs intro + everyone's a yogscast model!\
_ttt_randomat_cyogs_ - Default: 1 - Whether this randomat is enabled\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2055805086>\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2428342861>

## Death isn't the end

Everyone has a demonic possession\
\
_ttt_randomat_possession_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=1615324913>

## Fire Sale

Spawns "mystery boxes" around the map, which have a chance to contain powerful wonder weapons! (If installed)\
Else the boxes only contain weapons that can spawn on the floor\
Press 'E' to open a box if you find one, as many boxes as players spawn somewhere on the map to find\
\
_ttt_randomat_firesale_ - Default: 1 - Whether this randomat is enabled\
_randomat_firesale_music_ - Default: 1 - Whether music plays while event is active\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2554783208>
Optional "Wonder Weapons": <https://steamcommunity.com/sharedfiles/filedetails/?id=2252594978>

## Hack the planet

Gives everyone a command prompt\
\
_ttt_randomat_hack_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2181940209>

## Hot Potato

Gives someone a ‘Hot Potato’, a weapon that after 17 seconds makes the holder explode. It must be passed to another player to avoid exploding.\
\
_ttt_randomat_potato_ - Default: 1 - Whether this randomat is enabled\
\
Idea from u/Nuclearaxe979 on reddit.\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2377790970>

## Infinite Super Shotguns For All

Everyone can only use an infinite ammo super shotgun as their main weapon\
\
_ttt_randomat_supershotgun_ - Default: 1 - Whether this randomat is enabled\
_randomat_supershotgun_weaponid_ - Default: tfa_doom_ssg - Id of the weapon given\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2236037793>

## It's just a flesh wound

Everyone has a flesh wound\
\
_ttt_randomat_fleshwound_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2179764633>

## It's time to go third-person

Switches everyone to an over-the-shoulder thirdperson view\
\
_ttt_randomat_thirdperson_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2593095865>

## Jets vs. Wings

Gives someone a jetpack and everyone else a homing pigeon.\
\
_ttt_randomat_jetswings_ - Default: 1 - Whether this randomat is enabled\
\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=1735229517> \
<https://steamcommunity.com/sharedfiles/filedetails/?id=620936792>

## Jingle Jam

Everyone gets a random Yogscast Christmas playermodel!\
\
_ttt_randomat_jinglejam_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=1220749653>

## Join the dark side

Gives every player a red lightsaber\
\
_ttt_randomat_darkside_ - Default: 1 - Whether this randomat is enabled\
\
Originally made by [ruiner189](https://steamcommunity.com/sharedfiles/filedetails/?id=1988901134)\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=635911320>

## Let's play the 1812 Overture

Gives everyone an artillery cannon (Upgraded if the Pack-a-Punch is installed) or PHD flopper\
\
Suggested by u/alpha1812 on Reddit.\
\
_ttt_randomat_cannons_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2087368173>\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2243578658>\
<https://steamcommunity.com/sharedfiles/filedetails/?id=3043605644>

## Megamind

Changes everyone to a Megamind playermodel\
\
_ttt_randomat_megamind_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=3020804282>

## Minimap: Activated

Adds a minimap to everyone's screen\
\
_ttt_randomat_minimap_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=3024317004>

## Muahahaha

Gives everyone a deal with the devil\
\
_ttt_randomat_devildeal_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2140473915>

## One Puuuuunch

Gives everyone One Punch fists!\
\
_ttt_randomat_onepunch_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2609859728>

## Random joke weapons for all

Gives everyone a random buyable joke weapon.\
\
_ttt_randomat_jokeweapons_ - Default: 1 - Whether this randomat is enabled\
\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2568344774>

## Pew! Bang! Pow

Strips everyone of their floor weapons, if they've picked up any, and gives either a pew gun or a finger gun.\
\
_ttt_randomat_pewbangpow_ - Default: 1 - Whether this randomat is enabled\
\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2236046949> \
<https://steamcommunity.com/sharedfiles/filedetails/?id=2329744756>

## RELEASE THE SNAILS

Spawns snails that follow players around, killing you if they reach you. Plays “threatening” music for a while.\
\
_ttt_randomat_snails_ - Default: 1 - Whether this randomat is enabled\
_randomat_snails_cap_ - Default: 12 - Maximum number of snails spawned\
_randomat_snails_delay_ - Default: 0.5 - Delay before snails are spawned\
_randomat_snails_music_ - Default: 1 - Music plays while randomat is active\
\
Changed name from "Don't. Blink.", modified to spawn killer snails in place of weeping angels\
Originally made by [Dem](https://steamcommunity.com/sharedfiles/filedetails/?id=1406495040)\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2151761122>

## Reach for the sky

Everyone gets a jetpack\
\
_ttt_randomat_jetpack_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=1735229517>

## RISE FROM YOUR... Dobbees?

When you die, you come back as a T-Posing "dobbee", from the "Dobby Grenade" weapon.\
\
_ttt_randomat_dobbees_ - Default: 1 - Whether this randomat is enabled\
\
Changed model set from the bee model to the dobbee model, check for dobby model being installed before triggering.\
Originally made by [Malivil](https://steamcommunity.com/sharedfiles/filedetails/?id=2055805086)\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2429414338>

## Secret Friday Update

Everyone gets a minecraft bow and minecraft block weapon. All other weapons are striped from players and the ground.\
\
_ttt_randomat_secretfriday_ - Default: 1 - Whether this randomat is enabled\
\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2311866661> \
<https://steamcommunity.com/sharedfiles/filedetails/?id=2311859098>

## Shh... It's a Secret

Runs another random Randomat event without notifying the players. Also silences all future Randomat events while this event is active.\
\
_ttt_randomat_secret_ - Default: 1 - Whether this event is enabled.

## Sips sends his regards

Everyone gets one of these models: <https://steamcommunity.com/sharedfiles/filedetails/?id=2659543412>\
\
_ttt_randomat_sips_ - Default: 1 - Whether this randomat is enabled\
\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2659543412>

## Snail Time

Transforms everyone into a snail\
\
_ttt_randomat_snailtime_ - Default: 1 - Whether this randomat is enabled\
_randomat_snailtime_health_ - Default: 1 - Player health as a snail\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2151761122>

## Snail Wars

Everyone gets a freeze gun and snail gun.\
\
_ttt_randomat_snailwars_ - Default: 1 - Whether this randomat is enabled\
\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2151761122> \
<https://steamcommunity.com/sharedfiles/filedetails/?id=1817717513>

## Spider Mod

When you look at someone, you see a health bar above them!\
\
_ttt_randomat_healthbar_ - Default: 1 - Whether this randomat is enabled\
\
Requires:\
<https://steamcommunity.com/sharedfiles/filedetails/?id=2372740052>

## Time Stop

All moving objects on the map freeze in place for 60 seconds, except for players.\
NOTE: This randomat is disabled by default as it can cause issues with players becoming stuck. If this randomat is enabled you may need to know how to teleport players out of places where they cannot get out.\
\
_ttt_randomat_timestop_ - Default: 0 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=1337349942>

## The Slow-mo Guys

Everyone gets a time manipulator
\
_ttt_randomat_timemanipulator_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=1318271171>

## War of Words

Everyone gets a death note!\
\
_ttt_randomat_deathnote_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2552417009>

## Woof Woof

Everyone gets a guard dog\
\
_ttt_randomat_woof_ - Default: 1 - Whether this randomat is enabled\
\
Requires: <https://steamcommunity.com/sharedfiles/filedetails/?id=2120419714>

## Steam Workshop Link
https://steamcommunity.com/sharedfiles/filedetails/?id=2428353239
