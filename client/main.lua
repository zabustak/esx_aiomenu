local Vehicle = GetVehiclePedIsIn(ped, false)
local inVehicle = IsPedSittingInAnyVehicle(ped)
local lastCar = nil
local myIdentity = {}
local myIdentifiers = {}

ESX                           = nil

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while true do
		Wait(0)

		if IsControlJustPressed(1, 10) then
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'openGeneral'})
			local ped = GetPlayerPed(-1)
			if IsPedInAnyVehicle(ped, true) then 
				SendNUIMessage({type = 'showVehicleButton'})
			else 
				SendNUIMessage({type = 'hideVehicleButton'})
			end		
		end
		
		if IsControlJustPressed(1, 322) then
			SetNuiFocus(false, false)
			SendNUIMessage({type = 'close'})
		end
	end
end)

RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end)

RegisterNUICallback('NUIGenActions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openGeneral'})
end)

RegisterNUICallback('toggleid', function(data)
	TriggerServerEvent('menu:id', myIdentifiers, data)
end)

RegisterNUICallback('togglephone', function(data)
	TriggerServerEvent('menu:phone', myIdentifiers, data)
end)

RegisterNUICallback('toggleEngineOnOff', function()
	doToggleEngine()
end)

function doToggleEngine()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
        if IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
			SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
			ESX.ShowNotification('Engine Off')
		else
			SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
			ESX.ShowNotification('Engine On')
		end
    end
end

RegisterNUICallback('toggleVehicleLocks', function()
	car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        
	if car ~= 0 then
		lastCar = car
	end
		
	lockStatus = GetVehicleDoorLockStatus(lastCar)
	if lastCar ~= nil then
		if lockStatus == 0 or lockStatus == 1 then
			SetVehicleDoorsLocked(lastCar, 2)
			SetVehicleDoorsLockedForPlayer(lastCar, PlayerId(), false)
			TriggerEvent("chatMessage", "Info", {255, 255, 0}, "Door is now ^1locked^0.")
		elseif lockStatus == 2 then
			SetVehicleDoorsLocked(lastCar, 1)
			SetVehicleDoorsLockedForAllPlayers(vehicle, false)
			TriggerEvent("chatMessage", "Info", {255, 255, 0}, "Door is now ^2unlocked^0.")
		end
	else
		TriggerEvent("chatMessage", "Info", {255, 255, 0}, "You don't have a car.")
	end
end)


RegisterNUICallback('showCharacters', function(data)
	TriggerServerEvent('menu:characters', data)
	cb(data)
end)

--================================================================================================
--==                                  ESX Actions GUI                                           ==
--================================================================================================
RegisterNUICallback('NUIESXActions', function(data)
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openESX'})
	SendNUIMessage({type = 'showInventoryButton'})
	SendNUIMessage({type = 'showPhoneButton'})
	SendNUIMessage({type = 'showBillingButton'})
	SendNUIMessage({type = 'showAnimationsButton'})
end)

RegisterNUICallback('NUIopenInventory', function()
	exports['es_extended']:openInventory()
end)

RegisterNUICallback('NUIopenPhone', function()
	exports['esx_phone']:openPhone()
end)

RegisterNUICallback('NUIopenInvoices', function()
	exports['esx_billing']:openInvoices()
end)

RegisterNUICallback('NUIsetVoice', function()
	exports['esx_voice']:setVoice()
end)

RegisterNUICallback('NUIopenAnimations', function()
	exports['esx_animations']:openAnimations()
end)

RegisterNUICallback('NUIJobActions', function(data)
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openJobs'})
	local job = tostring(exports['esx_policejob']:getJob())
	if job == 'police' then
		SendNUIMessage({type = 'showPoliceButton'})
		SendNUIMessage({type = 'hideAmbulanceButton'})
		SendNUIMessage({type = 'hideTaxiButton'})
		SendNUIMessage({type = 'hideMechanicButton'})
		SendNUIMessage({type = 'hideFireButton'})
	elseif job == 'ambulance' then
		SendNUIMessage({type = 'showAmbulanceButton'})
		SendNUIMessage({type = 'hidePoliceButton'})
		SendNUIMessage({type = 'hideTaxiButton'})
		SendNUIMessage({type = 'hideMechanicButton'})
		SendNUIMessage({type = 'hideFireButton'})
	elseif job == 'taxi' then
		SendNUIMessage({type = 'showTaxiButton'})
		SendNUIMessage({type = 'hidePoliceButton'})
		SendNUIMessage({type = 'hideAmbulanceButton'})
		SendNUIMessage({type = 'hideMechanicButton'})
		SendNUIMessage({type = 'hideFireButton'})
	elseif job == 'mecano' then
		SendNUIMessage({type = 'showMechanicButton'})
		SendNUIMessage({type = 'hidePoliceButton'})
		SendNUIMessage({type = 'hideAmbulanceButton'})
		SendNUIMessage({type = 'hideTaxiButton'})
		SendNUIMessage({type = 'hideFireButton'})
	elseif job == 'fire' then
		SendNUIMessage({type = 'showFireButton'})  
		SendNUIMessage({type = 'hideMechanicButton'})
		SendNUIMessage({type = 'hidePoliceButton'})
		SendNUIMessage({type = 'hideAmbulanceButton'})
		SendNUIMessage({type = 'hideTaxiButton'})
	else
		SendNUIMessage({type = 'hidePoliceButton'})
		SendNUIMessage({type = 'hideAmbulanceButton'})
		SendNUIMessage({type = 'hideTaxiButton'})
		SendNUIMessage({type = 'hideMechanicButton'})
		SendNUIMessage({type = 'hideFireButton'})
	end
end)

RegisterNUICallback('NUIopenAmbulance', function()
	exports['esx_ambulancejob']:openAmbulance()
end)

RegisterNUICallback('NUIopenPolice', function()
	exports['esx_policejob']:openPolice()
end)

RegisterNUICallback('NUIopenMechanic', function()
	exports['esx_mecanojob']:openMechanic()
end)

RegisterNUICallback('NUIopenTaxi', function()
	exports['esx_taxijob']:openTaxi()
end)

RegisterNUICallback('NUIopenFire', function()
	exports['esx_firejob']:openFire()
end)

RegisterNUICallback('NUIVehicleActions', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openVehicles'})
end)

RegisterNUICallback('NUIDoorActions', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openDoorActions'})
end)

RegisterNUICallback('toggleFrontLeftDoor', function()
	local playerPed = GetPlayerPed(-1)
	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	if ( IsPedSittingInAnyVehicle( playerPed ) ) then
		if GetVehicleDoorAngleRatio(playerVeh, 0) > 0.0 then 
			SetVehicleDoorShut(playerVeh, 0, false)            
		else
			SetVehicleDoorOpen(playerVeh, 0, false)             
		end
	end
end)

RegisterNUICallback('toggleFrontRightDoor', function()
	local playerPed = GetPlayerPed(-1)
	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	if ( IsPedSittingInAnyVehicle( playerPed ) ) then
		if GetVehicleDoorAngleRatio(playerVeh, 1) > 0.0 then 
			SetVehicleDoorShut(playerVeh, 1, false)            
		else
			SetVehicleDoorOpen(playerVeh, 1, false)             
		end
	end
end)

RegisterNUICallback('toggleBackLeftDoor', function()
	local playerPed = GetPlayerPed(-1)
	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	if ( IsPedSittingInAnyVehicle( playerPed ) ) then
		if GetVehicleDoorAngleRatio(playerVeh, 2) > 0.0 then 
			SetVehicleDoorShut(playerVeh, 2, false)            
		else
			SetVehicleDoorOpen(playerVeh, 2, false)             
		end
	end
end)

RegisterNUICallback('toggleBackRightDoor', function()
	local playerPed = GetPlayerPed(-1)
	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	if ( IsPedSittingInAnyVehicle( playerPed ) ) then
		if GetVehicleDoorAngleRatio(playerVeh, 3) > 0.0 then 
			SetVehicleDoorShut(playerVeh, 3, false)            
		else
			SetVehicleDoorOpen(playerVeh, 3, false)             
		end
	end
end)

RegisterNUICallback('toggleHood', function()
	local playerPed = GetPlayerPed(-1)
	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	if ( IsPedSittingInAnyVehicle( playerPed ) ) then
		if GetVehicleDoorAngleRatio(playerVeh, 4) > 0.0 then 
			SetVehicleDoorShut(playerVeh, 4, false)            
		else
			SetVehicleDoorOpen(playerVeh, 4, false)             
		end
	end
end)

RegisterNUICallback('toggleTrunk', function()
	local playerPed = GetPlayerPed(-1)
	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	if ( IsPedSittingInAnyVehicle( playerPed ) ) then
		if GetVehicleDoorAngleRatio(playerVeh, 5) > 0.0 then 
			SetVehicleDoorShut(playerVeh, 5, false)            
		else
			SetVehicleDoorOpen(playerVeh, 5, false)             
		end
	end
end)

RegisterNUICallback('toggleWindowsUp', function()
	local playerPed = GetPlayerPed(-1)
	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	if ( IsPedSittingInAnyVehicle( playerPed ) ) then
		RollUpWindow(playerVeh, 0)
		RollUpWindow(playerVeh, 1)
		RollUpWindow(playerVeh, 2)
		RollUpWindow(playerVeh, 3)
   end
end)

RegisterNUICallback('toggleWindowsDown', function()
	local playerPed = GetPlayerPed(-1)
	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	if ( IsPedSittingInAnyVehicle( playerPed ) ) then
		RollDownWindow(playerVeh, 0)
		RollDownWindow(playerVeh, 1)
		RollDownWindow(playerVeh, 2)
		RollDownWindow(playerVeh, 3)
	end
end)

RegisterNUICallback('NUIWindowActions', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openWindows'})
end)

RegisterNUICallback('NUICharActions', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openCharacters'})
end)

RegisterNetEvent("menu:setCharacters")
AddEventHandler("menu:setCharacters", function(identity)
	myIdentity = identity
end)

RegisterNetEvent("menu:setIdentifier")
AddEventHandler("menu:setIdentifier", function(data)
	myIdentifiers = data
end)

RegisterNetEvent("menu:getSteamIdent")
AddEventHandler("menu:getSteamIdent", function(identity)
	if myIdentifiers.steamidentifier then
		TriggerEvent("chatMessage", "^1[IDENTITY]", {255, 255, 0}, "Your steam identifier is:" .. myIdentifiers.steamidentifier)
	else
		TriggerEvent("chatMessage", "^1[IDENTITY]", {255, 255, 0}, "Your steam identifier is nil. Please use /getID")
	end
end)


RegisterNUICallback('NUIlistCharacters', function(data)
	TriggerServerEvent('menu:setChars', myIdentifiers)
	Wait(1000)
	SetNuiFocus(true, true)
	local bt  = myIdentity.character1
	local bt2 = myIdentity.character2
	local bt3 = myIdentity.character3
  
	SendNUIMessage({
		type = "listCharacters",
		char1    = bt,
		char2    = bt2,
		char3    = bt3,
		backBtn  = "Back",
		exitBtn  = "Exit"
	}) 
end)

RegisterNUICallback('NUIchangeCharacters', function(data)
	TriggerServerEvent('menu:setChars', myIdentifiers)
	Wait(1000)
	SetNuiFocus(true, true)
	local bt  = myIdentity.character1
	local bt2 = myIdentity.character2
	local bt3 = myIdentity.character3
  
	SendNUIMessage({
		type = "changeCharacters",
		char1    = bt,
		char2    = bt2,
		char3    = bt3,
		backBtn  = "Back",
		exitBtn  = "Exit"
	}) 
end)

RegisterNUICallback('NUISelChar1', function(data)
	TriggerServerEvent('menu:selectChar1', myIdentifiers, data)
	cb(data)
end)

RegisterNUICallback('NUISelChar2', function(data)
	TriggerServerEvent('menu:selectChar2', myIdentifiers, data)
	cb(data)
end)

RegisterNUICallback('NUISelChar3', function(data)
	TriggerServerEvent('menu:selectChar3', myIdentifiers, data)
	cb(data)
end)

RegisterNUICallback('NUIdeleteCharacters', function(data)
	TriggerServerEvent('menu:setChars', myIdentifiers)
	Wait(1000)
	SetNuiFocus(true, true)
	local bt  = myIdentity.character1 --- Character 1 ---
	local bt2 = myIdentity.character2 --- character 2 ---
	local bt3 = myIdentity.character3 --- character 3 ---
  
	SendNUIMessage({
		type = "deleteCharacters",
		char1    = bt,
		char2    = bt2,
		char3    = bt3,
		backBtn  = "Back",
		exitBtn  = "Exit"
	}) 
end)

RegisterNUICallback('NUInewCharacter', function(data)
	if myIdentity.character3 == "No Character" then
		exports['esx_identity']:openRegistry()
	else
		TriggerEvent("chatMessage", "^1[IDENTITY]", {255, 255, 0}, "You can only have 3 characters!")
	end
end)

RegisterNUICallback('NUIDelChar1', function(data)
	TriggerServerEvent('menu:deleteChar1', myIdentifiers, data)
	cb(data)
end)

RegisterNUICallback('NUIDelChar2', function(data)
	TriggerServerEvent('menu:deleteChar2', myIdentifiers, data)
	cb(data)
end)

RegisterNUICallback('NUIDelChar3', function(data)
	TriggerServerEvent('menu:deleteChar3', myIdentifiers, data)
	cb(data)
end)

RegisterNetEvent('sendProximityMessageID')
AddEventHandler('sendProximityMessageID', function(id, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if pid == myId then
		TriggerEvent('chatMessage', "[ID]" .. "", {0, 153, 204}, "^7 " .. message)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "[ID]" .. "", {0, 153, 204}, "^7 " .. message)
	end
end)

RegisterNetEvent('sendProximityMessagePhone')
AddEventHandler('sendProximityMessagePhone', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if pid == myId then
		TriggerEvent('chatMessage', "[Phone]^3(" .. name .. ")", {0, 153, 204}, "^7 " .. message)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "[Phone]^3(" .. name .. ")", {0, 153, 204}, "^7 " .. message)
	end
end)