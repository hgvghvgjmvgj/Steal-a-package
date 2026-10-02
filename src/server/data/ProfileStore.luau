-- Session leases protect against two servers overwriting one player's profile.
local shared = game:GetService("ReplicatedStorage").StealAPackage.Shared
local Schema = require(shared.Modules.ProfileSchema)
local Config = require(shared.Configs.GameConfig)
local Store = {}
Store.__index = Store
function Store.new(adapter, sessionId, clock)
    return setmetatable({Adapter = adapter, SessionId = sessionId, Clock = clock or os.time}, Store)
end
function Store:Acquire(key)
    local now = self.Clock()
    local result = self.Adapter:UpdateAsync(key, function(old)
        if type(old) == "table" and type(old.Session) == "table"
            and old.Session.Id ~= self.SessionId and (tonumber(old.Session.Expires) or 0) > now then
            return nil
        end
        return {Data = Schema.Normalize(if type(old) == "table" then old.Data else nil),
            Session = {Id = self.SessionId, Expires = now + Config.SessionLeaseSeconds}}
    end)
    if not result or not result.Session or result.Session.Id ~= self.SessionId then return nil, "Profile is active in another server" end
    return Schema.Normalize(result.Data)
end
function Store:Save(key, data, release)
    local now = self.Clock()
    local written = false
    self.Adapter:UpdateAsync(key, function(old)
        written = false
        if type(old) ~= "table" or type(old.Session) ~= "table" or old.Session.Id ~= self.SessionId then return nil end
        written = true
        return {Data = Schema.Normalize(data), Session = if release then nil else {Id = self.SessionId, Expires = now + Config.SessionLeaseSeconds}}
    end)
    return written
end
return Store
