--Doyle3694
print("Commands.lua")
CommandEngine = {}
CommandEngine.Commands = {}
CommandEngine.Variables = {}
function CommandEngine:CheckCommand( keys )
	if not CommandEngine.initialized then CommandEngine.init() end
	if string.sub(keys.text, 1, #CommandEngine.prefix) then

		local submessage = string.sub(keys.text, #CommandEngine.prefix+1)
		local div = select(2, string.find(submessage, " "))
		if div then div = div-1 else div = #submessage end
		local command = submessage:sub(1, div):lower()
		submessage = submessage:sub(div+2)

		if CommandEngine.Commands[command] then
			CommandEngine.Commands[command](self,  submessage, keys)
			print("PlayerID: " .. keys.playerid .. " ran command " .. keys.text)
		end
	end
end

function CommandEngine.init()
	CommandEngine.prefix = "-"
	CommandEngine.initialized = true

	if GameRules:IsCheatMode() then
		CommandEngine.Commands.start = GameRules.GameMode.game.StartNextRoundCommand
		CommandEngine.Commands.skip = CommandEngine.Commands.start
	end
end

if GameRules:IsCheatMode() then
	function CommandEngine.Commands.tango(instance, submessage, keys)
		instance.vPlayers[keys.playerid+1].player:AddTangos(tonumber(submessage) or 0)
	end
end

function CommandEngine.Commands.settings(instance, submessage, keys)
	if not CommandEngine.Variables.settingsCooldown then
		Say(nil, "Current settings:", false)
		for i,v in pairs(voteOptions) do
			Say(nil, i .. " : " .. tostring(v), false)
		end
		CommandEngine.Variables.settingsCooldown = true
		resettimer = Timers:CreateTimer(30, function() CommandEngine.Variables.settingsCooldown = false end)
	end
end
CommandEngine.Commands.gamemode = CommandEngine.Commands.settings
