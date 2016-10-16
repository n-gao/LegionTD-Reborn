-- From Dota 2 Spell Library https://github.com/Pizzalol/SpellLibrary

function spiked_carapace_init( keys )
    keys.caster.carapaced_units = {}
end

function spiked_carapace_reflect( keys )
    local caster = keys.caster
    local attacker = keys.attacker
    local damageTaken = keys.DamageTaken
    local damageMultiplier = keys:GetSpecialValueFor("damage_multiplier")
    
    if not caster.carapaced_units[ attacker:entindex() ] and not attacker:IsMagicImmune() then
        attacker:SetHealth( attacker:GetHealth() - (damageTaken*damageMultiplier) )
        keys.ability:ApplyDataDrivenModifier( caster, attacker, "modifier_spiked_carapaced_stun_datadriven", { } )
        caster:SetHealth( caster:GetHealth() + damageTaken )
        caster.carapaced_units[ attacker:entindex() ] = attacker
    end
end
