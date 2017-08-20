0.7.10

## General Changes

- Builder Passives added! (See Builder Changes below)

- Physical Damage Types added!

	There are 3 physical attack types: normal, pierce, and arcane; and 3 physical defense types: light, medium, and heavy. Front-line melee units are generally normal/heavy, archer-types and certain melee units are generally pierce/medium, and wizardly units are generally arcane/light. Not all units follow these common pairings however, and units can have any combination of attack and defense type.

	normal attacks deal:
	    80% to light defense
	    125% to medium defense
	    100% to heavy defense

	piercing attacks deal:
		125% to light defense
		100% to medium defense
		80% to heavy defense

    arcane attacks deal:
    	100% to light defense
    	80% to medium defense
    	125% to heavy defense

- All builder units, send units, and non-boss wave units have been given physical attack and defense types.

- New game option: Return to Sender. Tango units will be sent to the sender's team. ALL players must vote for this option to activate it. 

- Tango Limit is always on rather than being a vote option, and has been reworked: rather than being a constant absolute limit to tangos, each player's production time is multiplied by 5 while over the current maximum (cumulative with any leak penalties), and each player's tango count is reduced to the limit at the start of every wave spawn.

- Ranged defenders will now teleport to behind the king after clearing their wave, and defend a spot 200 units behind melee defenders.

- If more than 15 units are being sent to the same player, each additional set of 15 will be delayed by an additional 2 seconds (This should fix certain situations where send units will get stuck or even spawn off-map when a large number is sent at once, especially in playercount-imbalanced games).

- Attack Aquisition ranges on all non-king units increased from 500 to 850 (except humanbuilder sharpshooter which is still 950).

- Added abandon mechanic: if a player is disconnected for 3 wave spawns (or abandons directly), all their towers are sold for full value and their net worth (tower value, gold value, and tango/food upgrade value) is split among the remaining players on that team. That player's lane is then locked for the remainder of the game.

## Wave Changes

- Tango towers no longer produce tangos during duel rounds, including setup.

- Duel victory gold bounty reduced from 75/150/300 to 25/50/100.

- All player units now have a bounty equal to their food cost.

- All bosses (fatty, king, dragon) now have a +50% attack speed ability and their Base Attack Times increased: Fatty BAT from .8 to 1.2, King BAT from .4 to .9, Dragon BAT from .4 to .6

- Wave Bosses attack animation times have been fixed.

- Wave 15 (Enchantress) completion bounty from 37 to 67

- Wave 16 (Techies) unit bounty from 5 to 3

## Builder Changes

### Human Builder

- Human Builder gets 1.2 food per turn.

- Human Builder Gyrocopter Mk2 base damage decreased from 233 to 203.

- Human Builder Futuristic Gyrocopter base damage decreased from 350 to 300.

- Human Builder Icewrack Grandmaster has an additional pasive aura, Chilled Blood, which grants 10% additional HP to allies within a 900 unit radius.

- Human Builder Icewrack Grandmaster Freezing Field explosion interval decreased from every 1.0 seconds to every .7 seconds.

- Human Builder Soundmaster's Deafening Blast will now stun rather than disarm at the end of its duration, and should no longer cause units to get stuck up cliffs.

### Elemental Builder

- Elemental Builder gets stat bonuses and penalties on his entire legion depending on how much gold he's proportionally spent on each element. If he manages to get all elements within a threshhold of the average, he gets maximum stacks on all stats. Purchasing a God for an element (the most expensive upgrade for each element) will stabilize that element, making elemental harmony that much easier to achieve.

	Each 20% gold value above or below average value per element is worth a stack, either positive or negative. The stack bonuses/penalties are: Earth, .2/-.1 armor per stack; Fire, 2%/-1% base damage per stack; Thunder, 2%/-1% magic resist and outgoing magic amp; Water, +2/-1 attack speed per stack; Void, -1%/+.5% to all incoming damage. Elemental Harmony grants 9 positive stacks of each element.

### Nature Builder

- Nature Builder gets a final death knell on each of his units, healing a nearby ally for 10% of the dying unit's maximum health and dealing as much magic damage to a nearby foe. Maximum range on both effects is 300 units.

- New Nature Builder Unit: Treebeard. Upgrades from Treant, has Treant Protector's Overgrowth with a 2 second duration, and owning one will double the effectiveness of Nature Builder's passive.

## Technical / Bugfix

- Improved precaching of builder unit resources.

- Fixed a case where wave/send units would get "stuck" on the king, only playing their walk animation and not attacking.
