local gettingObject = false
local objData = {}

DrawEntityBoundingBox = function(entity, color)
    local model = GetEntityModel(entity)
    local min, max = GetModelDimensions(model)
    local rightVector, forwardVector, upVector, position = GetEntityMatrix(entity)

    -- Calculate size
    local dim =	{
		x = 0.5*(max.x - min.x),
		y = 0.5*(max.y - min.y),
		z = 0.5*(max.z - min.z)
	}

    local FUR = {
		x = position.x + dim.y*rightVector.x + dim.x*forwardVector.x + dim.z*upVector.x,
		y = position.y + dim.y*rightVector.y + dim.x*forwardVector.y + dim.z*upVector.y,
		z = 0
    }

    local _, FUR_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    FUR.z = FUR_z
    FUR.z = FUR.z + 2 * dim.z

    local BLL = {
        x = position.x - dim.y*rightVector.x - dim.x*forwardVector.x - dim.z*upVector.x,
        y = position.y - dim.y*rightVector.y - dim.x*forwardVector.y - dim.z*upVector.y,
        z = 0
    }
    local _, BLL_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    BLL.z = BLL_z

    -- DEBUG
    local edge1 = BLL
    local edge5 = FUR

    local edge2 = {
        x = edge1.x + 2 * dim.y*rightVector.x,
        y = edge1.y + 2 * dim.y*rightVector.y,
        z = edge1.z + 2 * dim.y*rightVector.z
    }

    local edge3 = {
        x = edge2.x + 2 * dim.z*upVector.x,
        y = edge2.y + 2 * dim.z*upVector.y,
        z = edge2.z + 2 * dim.z*upVector.z
    }

    local edge4 = {
        x = edge1.x + 2 * dim.z*upVector.x,
        y = edge1.y + 2 * dim.z*upVector.y,
        z = edge1.z + 2 * dim.z*upVector.z
    }

    local edge6 = {
        x = edge5.x - 2 * dim.y*rightVector.x,
        y = edge5.y - 2 * dim.y*rightVector.y,
        z = edge5.z - 2 * dim.y*rightVector.z
    }

    local edge7 = {
        x = edge6.x - 2 * dim.z*upVector.x,
        y = edge6.y - 2 * dim.z*upVector.y,
        z = edge6.z - 2 * dim.z*upVector.z
    }

    local edge8 = {
        x = edge5.x - 2 * dim.z*upVector.x,
        y = edge5.y - 2 * dim.z*upVector.y,
        z = edge5.z - 2 * dim.z*upVector.z
    }
    color = (color == nil and {r = 255, g = 255, b = 255, a = 255} or color)
    DrawLine(edge1.x, edge1.y, edge1.z, edge2.x, edge2.y, edge2.z, 3, 252, 190, 255)
    DrawLine(edge1.x, edge1.y, edge1.z, edge4.x, edge4.y, edge4.z, 3, 252, 190, 255)
    DrawLine(edge2.x, edge2.y, edge2.z, edge3.x, edge3.y, edge3.z, 3, 252, 190, 255)
    DrawLine(edge3.x, edge3.y, edge3.z, edge4.x, edge4.y, edge4.z, 3, 252, 190, 255)
    DrawLine(edge5.x, edge5.y, edge5.z, edge6.x, edge6.y, edge6.z, 3, 252, 190, 255)
    DrawLine(edge6.x, edge6.y, edge6.z, edge7.x, edge7.y, edge7.z, 3, 252, 190, 255)
    DrawLine(edge7.x, edge7.y, edge7.z, edge8.x, edge8.y, edge8.z, 3, 252, 190, 255)
    DrawLine(edge5.x, edge5.y, edge5.z, edge8.x, edge8.y, edge8.z, 3, 252, 190, 255)
    DrawLine(edge1.x, edge1.y, edge1.z, edge7.x, edge7.y, edge7.z, 3, 252, 190, 255)
    DrawLine(edge2.x, edge2.y, edge2.z, edge8.x, edge8.y, edge8.z, 3, 252, 190, 255)
    DrawLine(edge3.x, edge3.y, edge3.z, edge5.x, edge5.y, edge5.z, 3, 252, 190, 255)
    DrawLine(edge4.x, edge4.y, edge4.z, edge6.x, edge6.y, edge6.z, 3, 252, 190, 255)
end

local RotationToDirection = function(rotation)
	local adjustedRotation = {
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction = {
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local RayCastGamePlayCamera = function(distance)
    local player = PlayerPedId()
    local currentRenderingCam = false
    if not IsGameplayCamRendering() then
        currentRenderingCam = GetRenderingCam()
    end

    local cameraRotation = not currentRenderingCam and GetGameplayCamRot() or GetCamRot(currentRenderingCam, 2)
    local cameraCoord = not currentRenderingCam and GetGameplayCamCoord() or GetCamCoord(currentRenderingCam)
	local direction = RotationToDirection(cameraRotation)
	local destination =	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local _, b, c, _, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, player, 0))
	return b, c, e
end

function StartCreation()
    if not gettingObject then
        SendChatMessage('Press [ E ] to grab object')
        gettingObject = true
    else
        gettingObject = false
    end
    CreateThread(function ()
        while gettingObject do
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)
            local lineHit, coords, entity = RayCastGamePlayCamera(1000.0)
            
            if lineHit and IsEntityAnObject(entity) or IsEntityAVehicle(entity) or IsEntityAPed(entity) then
                FreeAimEntity = entity
                DrawEntityBoundingBox(entity)
                if IsControlJustReleased(0, 38) then
                    SendData(entity)
                end
            end
            DrawLine(playerPos.x, playerPos.y, playerPos.z, coords.x, coords.y, coords.z, 3, 252, 190, 255)
            Wait(0)
        end
    end)
end

function SendData(entity)
    local model = GetEntityModel(entity)
    local coords = GetEntityCoords(entity)
    local heading = GetEntityHeading(entity)
    data = nil
    objData = {
        name = Entities[model] or 'Missing Model',
        hash = GetHashKey(entity),
        netId = NetworkGetNetworkIdFromEntity(entity),
        heading = string.format('%.3f', heading),
        coords3 = string.format('vector3(%.3f, %.3f, %.3f)', coords.x, coords.y, coords.z),
        coords4 = string.format('vector4(%.3f, %.3f, %.3f, %.3f)', coords.x, coords.y, coords.z, heading)
    }
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'show',
        name = objData.name,
        hash = objData.hash,
        netId = objData.netId,
        heading = objData.heading,
        coords3 = objData.coords3,
        coords4 = objData.coords4,
    })
end


function SendChatMessage(message)
    TriggerEvent('chat:addMessage', {
        color = { 255, 255, 0 },
        multiline = true,
        args = { 'Client', message }
    })
end

RegisterCommand('viewobject', function ()
    StartCreation()
end)

RegisterKeyMapping('viewobject','View object grabber','keyboard', 'F2')

RegisterNUICallback('release', function (data, cb)
    cb({})
    SetNuiFocus(false, false)
end)

RegisterNUICallback('copy', function (data, cb)
    cb({})
    SendChatMessage('Text copied to clipboard.')
end)

RegisterNUICallback('saveobject', function (data, cb)
    cb({})
    TriggerServerEvent('kevin-objectgrabber:saveobject', objData)
end)