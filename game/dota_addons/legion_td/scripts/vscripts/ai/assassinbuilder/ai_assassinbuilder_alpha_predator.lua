require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:FindAbilityByName("assassinbuilder_spiked_carapace")
		self.abilities[1].Skill = UseSkillNoTarget
		self.abilities[1].SkillTrigger = SkillTrigger1
		self.abilities[2] = self:FindAbilityByName("assassinbuilder_snot_spray")
		self.abilities[2].Skill = UseSkillTargetOptimalRadius
		self.abilities[2].SkillTrigger = CheckAbilityRange
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_alpha_predator.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

function SkillTrigger1( ability, entity )
	local Radius = 1000
	local Units = FindUnitsInRadius(entity:GetTeamNumber(), entity:GetAbsOrigin(), nil, Radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for i,v in pairs(Units) do
		if CalcDistanceBetweenEntityOBB(entity, v) < v:GetAttackRange() then
			return true
		end
	end
	return false
end
