demonUnits = {
		"tower_demonbuilder_imp",
	"tower_demonbuilder_imp_leader",
	"tower_demonbuilder_imp_master",
	"tower_demonbuilder_imp_boss",
	"tower_demonbuilder_bone_archer",
	"tower_demonbuilder_flame_archer",
	"tower_demonbuilder_demonic_archer",
	"tower_demonbuilder_winged_nightmare",
	"tower_demonbuilder_dark_angel",
	"tower_demonbuilder_searing_pain",
	"tower_demonbuilder_golem",
	"tower_demonbuilder_flaming_golem",
	"tower_demonbuilder_tormentor",
	"tower_demonbuilder_pit_lord",
	"tower_demonbuilder_demon",
	"tower_demonbuilder_infernal",
	"tower_demonbuilder_arch_demon",
	"tower_demonbuilder_dark_lord"
	}

function precache(keys)
	Timers:CreateTimer(25, function()
		print ("async precache of demon builder units")
		for _, unitName in pairs(demonUnits) do
			PrecacheUnitByNameAsync(unitName, function(...) end)
		end
	end)
end
