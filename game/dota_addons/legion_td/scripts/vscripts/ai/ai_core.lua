STANDARD_THINK_TIME = 0.5

EXPORTS = {}

EXPORTS.Init = function( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandard
		self.Unstuck = Unstuck
		self.CheckIfHasAggro = CheckIfHasAggro
		self:SetContextThink( "ai_standard.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

function aiThinkStandard(self)
	if not self:IsAlive() and not self:HasModifier("modifier_invulnerable") then
		return
	end
	if self:HasModifier("modifier_stunned") or GameRules:IsGamePaused() then
		return STANDARD_THINK_TIME
	end
	if self:IsIdle() and not self:CheckIfHasAggro() then
		return self:Unstuck()
	end
	return STANDARD_THINK_TIME
end

function aiThinkStandardBuff(self)
	if not self:IsAlive() and not self:HasModifier("modifier_invulnerable") then
		return
	end
	if self:HasModifier("modifier_stunned") or GameRules:IsGamePaused() then
		return STANDARD_THINK_TIME
	end
	if self.ability:IsCooldownReady() then
		return self:Skill()
	end
	if self:IsIdle() and not self:CheckIfHasAggro() then
		return self:Unstuck()
	end
	return STANDARD_THINK_TIME
end

function aiThinkStandardSkill(self)
	if not self:IsAlive() and not self:HasModifier("modifier_invulnerable") then
		return
	end
	if self:HasModifier("modifier_stunned") or GameRules:IsGamePaused() then
		return STANDARD_THINK_TIME
	end
	if self:CheckIfHasAggro() and self.ability:IsCooldownReady() then
		return self:Skill()
	end
	if self:IsIdle() and not self:CheckIfHasAggro() then
		return self:Unstuck()
	end
	return STANDARD_THINK_TIME
end

function UseSkillNoTarget(self)
	self:CastAbilityNoTarget(self.ability, -1)
	return 1
end

function UseSkillOnTargetPosition(self)
	self:CastAbilityOnPosition(self:GetAggroTarget():GetAbsOrigin(), self.ability, -1)
	return 1
end

function UseSkillOnTarget(self)
	self:CastAbilityOnTarget(self:GetAggroTarget(), self.ability, -1)
	return 1
end

function UseSkillOnSelf(self)
	self:CastAbilityOnTarget(self, self.ability, -1)
	return 1
end

function Unstuck(self)
	if self.nextTarget then
		self:Stop()
		self:SetInitialGoalEntity(self.nextTarget)
	end
	return STANDARD_THINK_TIME
end

function CheckIfHasAggroInRange(self)
	if self:GetAggroTarget() ~= nil then
		if CalcDistanceBetweenEntityOBB(self, self:GetAggroTarget()) < self.skillUseRange then
			return true
		end
	end
	return false
end

function CheckIfHasAggro( self )
	return self:GetAggroTarget() ~= nil
end

return EXPORTS
