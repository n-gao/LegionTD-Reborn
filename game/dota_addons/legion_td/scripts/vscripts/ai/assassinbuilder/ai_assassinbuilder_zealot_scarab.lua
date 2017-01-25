require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:FindAbilityByName("assassinbuilder_quill_spray")
		self.abilities[1].Skill = UseSkillNoTarget
		self.abilities[1].SkillTrigger = SkillTrigger
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_alpha_predator.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

function SkillTrigger( ability, entity )
	local smallRadius = ability:GetSpecialValueFor("radius")
	local smallUnits = FindUnitsInRadius(entity:GetTeamNumber(), entity:GetAbsOrigin(), nil, smallRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	if #smallUnits == 0 then return false end

	if entity:IsAttacking() then
		return true
	end

	local bigRadius = smallRadius+250
	local bigUnits = FindUnitsInRadius(entity:GetTeamNumber(), entity:GetAbsOrigin(), nil, bigRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	if #bigUnits > #smallUnits then return false end

	return true
end