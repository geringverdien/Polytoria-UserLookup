local UserLookup = {}

local function getStorePage(userID, page)
    local jsonResponse
    ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
    Http:Get("https://api.polytoria.com/v1/users/" .. userID .. "/store?page=" .. page .. "&limit=100", function(data, err, errmsg)
        if err then
            print("Error fetching user creations:", errmsg)
            jsonResponse = false
        else
            jsonResponse = json.parse(data)
        end
    end)

    repeat wait(0) until jsonResponse ~= nil

    if not jsonResponse then return nil, "Failed to fetch user creations" end

    return jsonResponse
end

function UserLookup:GetUsernameFromUserID(userID)
    local jsonResponse
    ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
    Http:Get("https://api.polytoria.com/v1/users/"..userID, function(data, err, errmsg)
        if err then
            print("Error fetching user data:", errmsg)
            jsonResponse = false
        else
            jsonResponse = json.parse(data)
        end
    end)

    repeat wait(0) until jsonResponse ~= nil

    if not jsonResponse then return nil, "Failed to fetch user data" end

    return jsonResponse.username
end

function UserLookup:GetUserIDFromUsername(username)
    local jsonResponse
    ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
    Http:Get("https://api.polytoria.com/v1/users/find?username="..username, function(data, err, errmsg)
        if err then
            print("Error fetching user data:", errmsg)
            jsonResponse = false
        else
            jsonResponse = json.parse(data)
        end
    end)

    repeat wait(0) until jsonResponse ~= nil

    if not jsonResponse then return nil, "Failed to fetch user data" end

    return jsonResponse.id
end


function UserLookup:GetCreationsFromUserID(userID)
    local firstPageResults, err = getStorePage(userID, 1)
    if not firstPageResults then return nil, err end

    local allAssets = {}
    local assets = firstPageResults.assets
    local pageAmount = firstPageResults.pages

    for _, asset in pairs(assets) do
        table.insert(allAssets, asset)
    end

    if pageAmount > 1 then
        for page = 2, pageAmount do
            local pageResults, err = getStorePage(userID, page)
            if not pageResults then return nil, err end

            for _, asset in pairs(pageResults.assets) do
                table.insert(allAssets, asset)
            end
        end
    end

    return allAssets
end

function UserLookup:GetGamepassesFromUserID(userID)
    local creations, err = self:GetCreationsFromUserID(userID)
    if not creations then return nil, err end

    local gamepasses = {}
    for _, asset in pairs(creations) do
        if asset.type == "gamePass" then
            table.insert(gamepasses, asset)
        end
    end

    return gamepasses
end


return UserLookup
