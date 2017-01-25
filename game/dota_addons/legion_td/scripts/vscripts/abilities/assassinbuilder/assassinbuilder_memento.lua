function AutoActivate( event )
	local caster = event.caster
	local ability = event.ability
	local threshold = ability:GetSpecialValueFor( "auto_activate_threshold" )

	if caster:GetHealth() < threshold then
		caster:CastAbilityNoTarget(ability, -1)
	end
end

function Suicide( keys )
	local caster = keys.caster
	local ability = keys.ability

	caster:ForceKill(false)
end