demonUnits = {
		"tower_demonbuilder_imp",
		"tower_demonbuilder_imp2",
		"tower_demonbuilder_imp3",
		"tower_demonbuilder_imp4",
		"tower_demonbuilder_imp5",
		"tower_demonbuilder_imp6",
		"tower_demonbuilder_imp7",
		"tower_demonbuilder_imp8",
		"tower_demonbuilder_imp9",
		"tower_demonbuilder_imp10",
		"tower_demonbuilder_imp11",
		"tower_demonbuilder_imp12",
		"tower_demonbuilder_imp13",
		"tower_demonbuilder_imp14",
		"tower_demonbuilder_imp15",
		"tower_demonbuilder_imp16",
		"tower_demonbuilder_imp17",
		"tower_demonbuilder_imp18",
		"tower_demonbuilder_imp19",
		"tower_demonbuilder_imp20",
		"tower_demonbuilder_dog"
	}

function precache(keys)
	Timers:CreateTimer(25, function()
		print ("async precache of demon builder units")
		for _, unitName in pairs(demonUnits) do
			PrecacheUnitByNameAsync(unitName, function(...) end)
		end
	end)
end
