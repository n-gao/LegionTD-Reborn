-- From Dota 2 Spell Library https://github.com/Pizzalol/SpellLibrary

last_spike_attack = {}

function spiked_carapace_init( keys )
    keys.caster.carapaced_units = {}
end

function spiked_carapace_reflect( keys )
    local caster = keys.caster
    local attacker = keys.attacker
    local damageTaken = keys.DamageTaken
    local damageMultiplier = keys.ability:GetSpecialValueFor("damage_multiplier")

    if not caster.carapaced_units[ attacker:entindex() ] and not attacker:IsMagicImmune() then
        if (last_spike_attack.attacker == attacker and last_spike_attack.victim == caster) then 
            last_spike_attack = {}
            return
        end
        last_spike_attack = {
            attacker = self,
            victim = attacker
        }
        caster.carapaced_units[ attacker:entindex() ] = attacker
        ApplyDamage({victim = attacker, attacker = caster, damage = damageTaken*damageMultiplier, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_REFLECTION})
        if attacker:IsAlive() then
            keys.ability:ApplyDataDrivenModifier( caster, attacker, "modifier_assassinbuilder_spiked_carapace_stun", { } )
        end
        caster:SetHealth( caster:GetHealth() + damageTaken )
    end
end
