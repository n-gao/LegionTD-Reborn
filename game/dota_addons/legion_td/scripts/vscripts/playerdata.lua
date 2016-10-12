PlayerData = PlayerData or class({})
PlayerData.datas = {}

function PlayerData.CreateToPlayer(player, callback)
  local result = PlayerData.Get(player:GetSteamID())
  if result ~= nil then  return result end
  local result = PlayerData.new(nil, player)
  Game.storage:SavePlayerData(result.steamID, result:GetToStoredData(), function() end)
  callback(result, true)
  return result
end

function PlayerData.Get(steamID)
  return PlayerData.datas[steamID] or PlayerData.new(nil, nil, steamID)
end

function PlayerData.AddOrUpdate(storedData, player, steamID)
  local self = PlayerData.Get(steamID or player:GetSteamID())
  if self then 
    self:OverrideStoredData(storedData)
    self:OverridePlayer(player)
    return self
  end
  return PlayerData.new(storedData, player, steamID)
end

function PlayerData.new(storedData, player, steamID)
  local self = PlayerData()
  self.storedData = storedData or {}
  self.steamID = steamID or self.player:GetSteamID()
  self.player = player or Game:FindPlayerWithSteamID(self.steamID) or Player.newPlaceHolder()
  PlayerData.datas[self.steamID] = self
  return self
end

function PlayerData:OverrideStoredData(storedData)
  self.storedData = storedData or {}
end

function PlayerData:OverridePlayer(player)
  self.player = player or Player.newPlaceHolder()
end

function PlayerData:GetToStoredData()
  local result = {
    experience = self:GetTotalExpierence(),
    kills = self:GetTotalKills(),
    leaks = self:GetTotalLeaks(),
    earned_tangos = self:GetTotalEarnedTangos(),
    won_duels = self:GetTotalWonDuels(),
    won_games = self:GetTotalWonGames(),
    lost_games = self:GetTotalLostGames(),
  }
  local fractionKills = self:GetTotalFractionKills()
  for key, value in pairs(fractionKills) do
    result[key] = value
  end
  local playedBuilders = self:GetTotalPlayedBuilder()
  for builder, count in pairs(playedBuilders) do
    result[builder] = count
  end
  return result
end

function PlayerData:SaveGetStoredAttribute(attribute)
    if self.storedData[attribute] == nil then return 0 end
    return self.storedData[attribute]
end

function PlayerData:GetTotalPlayedBuilder()
  local result = {}
  local builders = Game:GetAllBuilders()
  for builder, hero in pairs(builders) do
    local count = 0
    if (self.player.hero ~= nil and hero == self.player.hero:GetUnitName()) then
      count = count + 1
    end
    local key = "played_"..builder
    count = count + self:SaveGetStoredAttribute(key)
    result["played_"..builder] = count
  end
  return result
end

function PlayerData:GetTotalFractionKills()
  local result = {}
  local fractions = Game:GetAllFractions()
  for fraction,_ in pairs(fractions) do
    local kills = self.player:GetKillsOfFraction(fraction)
    local key = "kills_"..fraction;
    kills = kills + self:SaveGetStoredAttribute(key)
    result[key] = kills
  end
  return result
end

function PlayerData:GetTotalWonDuels()
  local result = self.player:GetWonDuels()
  result = result + self:SaveGetStoredAttribute("won_duels")
  return result
end

function PlayerData:GetTotalWonGames()
  local result = 0
  if (self.player.wonGame) then result = result + 1 end
  result = result + self:SaveGetStoredAttribute("won_games")
  return result
end

function PlayerData:GetTotalLostGames()
  local result = 0
  if (self.player.lostGame) then result = result + 1 end
  result = result + self:SaveGetStoredAttribute("lost_games")
  return result
end

function PlayerData:GetTotalExpierence()
  local result = self.player:GetExperience()
  result = result + self:SaveGetStoredAttribute("experience")
  return result
end

function PlayerData:GetTotalKills()
  local result = self.player:GetKills()
  result = result + self:SaveGetStoredAttribute("kills")
  return result
end

function PlayerData:GetTotalLeaks()
  local result = self.player:GetLeaks()
  result = result + self:SaveGetStoredAttribute("leaks")
  return result
end

function PlayerData:GetTotalEarnedTangos()
  local result = self.player:GetEarnedTangos()
  result = result + self:SaveGetStoredAttribute("earned_tangos")
  return result
end
