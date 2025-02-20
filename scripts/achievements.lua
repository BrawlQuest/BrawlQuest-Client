--[[
    This is an easier way of checking achievements that might be set by player stats.
    It's called every time the server sends an update
]]

statStoreTimer = 60

stats = {
    kills = 0,
    level = 0
}

function checkAchievementUnlocks()
    statStoreTimer = statStoreTimer - 1
    if me and statStoreTimer < 1 then
        if me.LegArmourID == 37 and me.ChestArmourID == 35 and me.HeadArmourID == 36 then
            steam.userStats.setAchievement('leather_armour_achievement')
        elseif  me.LegArmourID == 40 and me.ChestArmourID == 39 and me.HeadArmourID == 38 then
            steam.userStats.setAchievement('iron_armour_achievement')
        elseif me.LegArmourID == 49 and me.ChestArmourID == 48 and me.HeadArmourID == 47 then
            steam.userStats.setAchievement('guardian_armour_achievement')
        elseif me.LegArmourID == 74 and me.ChestArmourID == 73 and me.HeadArmourID == 72 then
            steam.userStats.setAchievement('hero_armour_achievement')
        end

        if me.Prestige > 1 then
            steam.userStats.setAchievement('enchant_achievement')
        end

        if me.Prestige >= 10 then
            steam.userStats.setAchievement('prestige_achievement')
        end

        if worldLookup[me.X..","..me.Y] and worldLookup[me.X..","..me.Y].Name == "Dominion of "..me.Name then
            steam.userStats.setAchievement('build_achievement')
        end

        if me.Mount.ID == 64 then
            steam.userStats.setAchievement('pirate_achievement')
        end

        if me.Mount.ID == 61 then
            steam.userStats.setAchievement('boat_achievement')
        end

        if me.Mount.Name ~= "None" and me.Mount.Name ~= "Error" and me.Mount.Name ~= "" then
            steam.userStats.setAchievement('mount_achievement')
        end


        if me.Buddy ~= "None" then
            steam.userStats.setAchievement('pet_achievement')
        end

        if me.LVL >= 2 then
            steam.userStats.setAchievement('level_1_achievement')
        end
        if me.LVL >= 10 then
            steam.userStats.setAchievement('level_10_achievement')
        end
        if me.LVL >= 25 then
            steam.userStats.setAchievement('level_25_achievement')
        end

        steam.userStats.storeStats()
        statStoreTimer = 60
    end
end