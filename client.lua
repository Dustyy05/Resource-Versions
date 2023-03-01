local startLoop = false
local cars = nil
local lastVec = nil
Citizen.CreateThread(function()
   if NetworkIsSessionStarted() then
     TriggerServerEvent('Dusty:REFRESHPERMS')
   end
end)

Citizen.CreateThread(function()
  _MenuPool = NativeUI.CreatePool()
  MainMenu = NativeUI.CreateMenu() 
  local menu_status = false
  while true do 
    Citizen.Wait(0)
    if(startLoop) then
      local pausemenu = IsPauseMenuActive()
      if(pausemenu) then
        menu_status = false
      end
      if IsControlJustPressed(1, 318) then
        if not menu_status then
          menu_status = true
          -- TriggerEvent('table', cars)
          open_menu()
          MainMenu:Visible(true)
        else 
          menu_status = false
        end
      elseif IsControlJustReleased(0, 177) and menu_status == true then
        menu_status = false
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    _MenuPool:ProcessMenus()	
    _MenuPool:ControlDisablingEnabled(false)
    _MenuPool:MouseControlsEnabled(false)
  end
end)

RegisterNetEvent('Dusty:SETVEHICLES')
AddEventHandler('Dusty:SETVEHICLES', function(data)
  cars = data
  startLoop = true
end)

function open_menu()
  if(cars) then
    _MenuPool:Remove()
    _MenuPool = NativeUI.CreatePool()
    MainMenu = NativeUI.CreateMenu(Dusty.Options.Menu_Title, "Created by Dusty's Development - v1.0", "0")
    --MainMenu = NativeUI.CreateMenu("Vehicle Menu", "Created by Dusty's Development - v1.0", "0")
    _MenuPool:Add(MainMenu)
    MainMenu:SetMenuWidthOffset(80)

    for i, v in pairs(cars) do
      local k = Dusty.Names[i]
      local menu = _MenuPool:AddSubMenu(MainMenu, k, k.. ' Vehicle Menu', true)
      MainMenu:AddItem(menu)
      for i2, v2 in ipairs(cars[i]) do
          local vehicle = NativeUI.CreateItem(v2.name, "Spawn the " .. v2.name)
          menu:AddItem(vehicle)
          vehicle.Activated = function(ParentMenu, SelectedItem)
          spawnvec(v2.spawnCode, v2.name)
        end
      end
    end
  end
end

function spawnvec(modal, name)
deleteOld()
  local ped = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey(modal)
  RequestModel(vehicle)
  Citizen.Wait(225)
	if not HasModelLoaded(vehicle) then
		notify("There was an ~r~error~w~ that occured whilst Loading the (" .. modal .. "). Contact Server Developer to fix the Config")
  else 
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0, 5.0, 0)
    local spawned_car = CreateVehicle(vehicle, coords, 64.55118,116.613,78.69622, true, false)
    SetVehicleOnGroundProperly(spawned_car)
    SetPedIntoVehicle(ped, spawned_car, - 1)
    SetModelAsNoLongerNeeded(vehicle)
    lastVec = spawned_car
    notify("~g~Successfully~w~ Spawned the: ~b~" .. name .. "")
    end
end 

function deleteOld()
if Dusty.Options.Delete_Last_Vehicle == "true" then
  if lastVec then
    DeleteEntity(lastVec)
   end
end
  return
end

function notify(text)
  SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(true, true)
end

RegisterNetEvent("Dusty:CarWipe")
AddEventHandler("Dusty:CarWipe", function ()
    for vehicle in EnumerateVehicles() do
        if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then 
            SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
            SetEntityAsMissionEntity(vehicle, false, false) 
            DeleteVehicle(vehicle)
            if (DoesEntityExist(vehicle)) then 
                DeleteVehicle(vehicle) 
            end
        end
    end
end)
