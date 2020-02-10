RegisterNUICallback('createvehicle', function(data)
    CreateThread(function() 
        vehicle = data.vehicle
        hash = GetHashKey(vehicle)
        p5 = tostring(data.p5)
        p6 = tostring(data.p6)
        p7 = tostring(data.p7)
        p8 = tostring(data.p8)
        p9 = tostring(data.p9)
        if ((p5 == "true") or (p5 == "false")) then p5 = tostring(p5) else p5 = tonumber(p5) end
        if ((p6 == "true") or (p6 == "false")) then p6 = tostring(p6) else p6 = tonumber(p6) end
        if ((p7 == "true") or (p7 == "false")) then p7 = tostring(p7) else p7 = tonumber(p7) end
        if ((p8 == "true") or (p8 == "false")) then p8 = tostring(p8) else p8 = tonumber(p8) end
        if ((p9 == "true") or (p9 == "false")) then p9 = tostring(p9) else p9 = tonumber(p9) end
        if IsModelValid(hash) then
            local ped = PlayerPedId()
            if IsPedSittingInAnyVehicle(ped) then 
                local currentvehicle = GetVehiclePedIsIn(ped,false)
                SetEntityAsMissionEntity(currentvehicle,true,true)
                DeleteVehicle(currentvehicle)
            end
            RequestModel(hash,0)
            while not HasModelLoaded(hash) do
                RequestModel(hash,0)
                Wait(0)
            end
            if not IsThisModelABoat(hash) then
                RequestCollisionForModel(hash)
                while not HasCollisionForModelLoaded(hash) do
                    RequestCollisionForModel(hash)
                    Wait(0)
                end
            end
            if HasModelLoaded(hash) then
                local x,y,z = table.unpack(GetEntityCoords(ped))
                local pedheading = GetEntityHeading(ped)
                if data.createtype == "1" then
                    vehcreated = CreateVehicle(hash,x,y,z,pedheading,p5,p6,p7,p8)
                elseif data.createtype == "2" then
                    vehcreated = CreateVehicle_2(hash,x,y,z,pedheading,p5,p6,p7,p8,p9)
                end
                SetEntityAsMissionEntity(vehcreated,true,true)
                while not DoesEntityExist(vehcreated) do
                    Wait(0)
                end
                SetVehicleOnGroundProperly(vehcreated,0)
                SetVehicleAsNoLongerNeeded(vehcreated)
                TaskWarpPedIntoVehicle(ped,vehcreated,-1)
                SetEntityVisible(vehcreated,true)
                SetModelAsNoLongerNeeded(hash)
            end
        end
    end)
end)

RegisterNUICallback('close', function()
	SendNUIMessage({showmenu = false})
	SetNuiFocus(false)	
end)

RegisterCommand('rcpvehicles', function() 
	SendNUIMessage({showmenu = true})
	SetNuiFocus(true,true)
end, false)