items = {}


function initItems()
    print("getting items...")
    items = json:decode(apiGETThreadless("/item"))
    print(items)
end

function getItemFromID(id)
    for i, v in ipairs(items) do
        if v.ID == id then
            return v
        end
    end
    return nil
end

function isItemEnchanted(item)
    if item and item.Name and item.Name ~= "None" and item.Enchantment == nil or item.Enchantment == "" or item.Enchantment == "None" then
        return false
    else
        return true
    end
end
