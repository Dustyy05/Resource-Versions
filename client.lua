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
      if IsControlJustPressed(1, 244) then
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

RegisterNetEvent('Dusty:SETPEDS')
AddEventHandler('Dusty:SETPEDS', function(data)
  peds = data
  startLoop = true
end)

function open_menu()
  if(peds) then
    _MenuPool:Remove()
    _MenuPool = NativeUI.CreatePool()
    MainMenu = NativeUI.CreateMenu(Dusty.Options.Menu_Title, "Created by Dusty's Development - v1.0", "0")
    _MenuPool:Add(MainMenu)
    MainMenu:SetMenuWidthOffset(80)
    for i, v in pairs(peds) do
      local k = Dusty.Names[i]
      local menu = _MenuPool:AddSubMenu(MainMenu, k, k.. ' Ped Menu', true)
      MainMenu:AddItem(menu)
      for i2, v2 in ipairs(peds[i]) do
          local ped = NativeUI.CreateItem(v2.name, "Spawn the " .. v2.name)
          menu:AddItem(ped)
          ped.Activated = function(ParentMenu, SelectedItem)
            spawnped(v2.spawnCode, v2.name)
          end
      end
    end
  end
end

function spawnped(model, name)
  if IsModelInCdimage(model) then
    while not HasModelLoaded(model) do
      Wait(5)
      RequestModel(model)
    end
    SetPlayerModel(PlayerId(), model)
    notify('Successfully set your ped to '..name)
  else
    notify('Invalid ped!')
  end
end

function notify(text)
  SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(true, true)
end 
