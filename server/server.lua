function SendDoorData(data)
    local resourcePath = GetCurrentResourceName()
    local file = io.open(resourcePath..'.txt', 'a')
    file:write('\n' .. data)
    file:close()
end

RegisterNetEvent('kevin-objectgrabber:saveobject', function (data)
    local fileData = '[\''..data.name..'\']'..'  =  {'..
    '\n    Object Name = `'..data.name..'`,'..
    '\n    Object Hash = `'..data.hash..'`,'..
    '\n    NetId = '..data.netId..','..
    '\n    Heading = '..data.heading..','..
    '\n    Coords3 = '..data.coords3..','..
    '\n    Coords4 = '..data.coords4..','..
    '\n},'
    SendDoorData(fileData)
end)