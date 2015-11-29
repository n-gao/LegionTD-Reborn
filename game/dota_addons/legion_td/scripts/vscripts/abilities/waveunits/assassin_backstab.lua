function BackstabHit( event )
  local caster = event.caster
  local target = event.target
  local maxAngle = event.ability:GetSpecialValueFor("angle")
  local test = AngleDiff(target:EyeAngles().y, caster:EyeAngles().y)
  if test <= maxAngle and not target:IsBuilding() then
    local mult = event.ability:GetSpecialValueFor("extra_damage")
    local damageTable = {
    	victim = target,
    	attacker = caster,
    	damage = caster:GetAttackDamage() * mult,
    	damage_type = DAMAGE_TYPE_PHYSICAL,
    }
    print("test")
    EmitSoundOn("Hero_Riki.Backstab", target)
    CreateEffect({
      entitiy = target,
      effect = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
    })
    ApplyDamage(damageTable)
  end
end
