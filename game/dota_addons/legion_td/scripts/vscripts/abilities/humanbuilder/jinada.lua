function Jinada( keys )
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local modifierName = keys.modifiername

	ability:StartCooldown(cooldown)

	caster:RemoveModifierByName(modifierName) 

	Timers:CreateTimer(cooldown, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
	end)	
end
