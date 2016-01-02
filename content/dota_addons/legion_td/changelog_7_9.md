7.9

- Human Builder added!

- The game will now attempt to distribute sends evenly based on tango value rather than unit count. The player that recieves the biggest send will rotate every round (player in first position for first round, second position for 2nd round, etc.)
  
  Example: 4 players are going to be sent 15 20-tango kobolds and a single 600-tango roshan. Under the old system, Three players will recieve 4 kobolds each, and another player will recieve 3 kobolds and a roshan. Under the new system, three players will recieve 5 kobolds each, and another player recieves only the roshan.
	
- Fog of war covers the enemy team during build phases; only their king can be seen. Builders are prevented from moving across the river.

- It is now constantly day.

- Tango production penalty from leaked creeps is now repaired at the end of build phase rather than the start of it.

- Tango production penalty on is now a cumulative 10% penalty per level of leaked creep rather than a flat 100%. (time between ticks divided by .9^leaked_levels)

	This means regular creeps will increase time between ticks by roughly 11%/23%/37%/52%/69%/88%/109%/158% etc; leaking 7 creeps will now slightly halve tango production, and a full 15 units leaked in a wave will cause that players tango production to be cut to less than a quarter.
	
- "Boss" creeps (fatty, king, dragon) levels increased to 5/6/7 (all other wave creeps are level 1).

- Wave creeps now spawn in wider formations rather than clumped together.

- Wave creeps and player units will now walk to a point across from their spawn rather than all converging to a point on the other side.

- Tango production now starts at the beginning of the first wave rather than when the hero enters the world.

- Starting tangos from 30 to 40.

- Kings now have truestrike.

## Creep wave changes

- Fixed Assassin backstab; it previously would frequently trigger on face-stabs from one side only.

- Assassin spawn count from 10 to 12.

- Not Lifestealer now has vampiric aura instead of feast; attackrate from 1.2 to .8, health from 210 to 280.

- Hydra Splitshot additional attacks reduced from 3 to 2, base damage from 8.75-10 to 10-12.

- Kunkka spawn count from 15 to 12.

## Technical
- Humanbuilder units are cached on hero select rather than game init. In the future all units will be converted to this new system.

- Armor types changed from STRONG to SOFT and increased physical damage values by 125%.

	Previously, all attacks were doing 125% of their listed value due to armor type interaction. This change will make the UI better reflect actual behavior.
