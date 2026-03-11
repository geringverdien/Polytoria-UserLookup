#UserLookup
A library to convert UserID -> username, username -> UserID and retrieve player's store items (or specifically gamepasses)

### Usage
```lua
local g, e = UserLookup:GetGamepassesFromUserID(2)

if e then error(e) end

for _, p in pairs(g) do
    print("Name:", p.name, "\nPrice: ", p.price) -- https://api.polytoria.com/v1/users/{id}/store
end

print(UserLookup:GetUsernameFromUserID(1)) --> "Polytoria"
print(UserLookup:GetUserIDFromUsername("Polytoria")) --> 1
```
