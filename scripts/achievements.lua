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
    if me and statStoreTimer < 1 and love.system.getOS() ~= "Linux" then
        if me.legarmourID == 37 and me.chestarmourID == 35 and me.headarmourID == 36 then
            steam.userStats.setAchievement('leather_armour_achievement')
        elseif  me.legarmourID == 40 and me.chestarmourID == 39 and me.headarmourID == 38 then
            steam.userStats.setAchievement('iron_armour_achievement')
        elseif me.legarmourID == 49 and me.chestarmourID == 48 and me.headarmourID == 47 then
            steam.userStats.setAchievement('guardian_armour_achievement')
        elseif me.legarmourID == 74 and me.chestarmourID == 73 and me.headarmourID == 72 then
            steam.userStats.setAchievement('hero_armour_achievement')
        end

        if me.Prestige > 1 then
            steam.userStats.setAchievement('enchant_achievement')
        end

        if me.Prestige >= 10 then
            steam.userStats.setAchievement('prestige_achievement')
        end

        if worldLookup[me.x..","..me.y] and worldLookup[me.x..","..me.y].name == "Dominion of "..me.name then
            steam.userStats.setAchievement('build_achievement')
        end

        if me.mount.id == 64 then
            steam.userStats.setAchievement('pirate_achievement')
        end

        if me.mount.id == 61 then
            steam.userStats.setAchievement('boat_achievement')
        end

        if me.mount.name ~= "None" and me.mount.name ~= "Error" and me.mount.name ~= "" then
            steam.userStats.setAchievement('mount_achievement')
        end


        if me.buddy ~= "None" then
            steam.userStats.setAchievement('pet_achievement')
        end

        if me.lvl >= 2 then
            steam.userStats.setAchievement('level_1_achievement')
        end
        if me.lvl >= 10 then
            steam.userStats.setAchievement('level_10_achievement')
        end
        if me.lvl >= 25 then
            steam.userStats.setAchievement('level_25_achievement')
        end

        steam.userStats.storeStats()
        statStoreTimer = 60
    end
end