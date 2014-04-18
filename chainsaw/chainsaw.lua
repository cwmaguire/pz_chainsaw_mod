-- What do I want to do?
--
-- 1) Have the chainsaw idle -- done
-- 2) Play an idle noise -- done
-- 3) Have the chainsaw swing
-- 4) Have a swinging revving noise -- done
-- 5) Have idling use fuel -- done
-- 6) Have swining use fuel
-- 7) Add fuel -- in progress
-- 8) Figure out how to hook into the timed actions

Chainsaw = {}
Chainsaw.tick = 0;
Chainsaw.chainsawName = "Chainsaw"
Chainsaw.petrolCanName = "Gas Can"

do
  local twentyMinutes = 20 * 60
  Chainsaw.chainsawFuelLimit = twentyMinutes

  local oneHour = 60 * 60
  Chainsaw.petrolCanFuel = oneHour
end

Chainsaw.addChainsaw = function(keyPressed)
  if keyPressed == Keyboard.KEY_INSERT then
    print("INSERT pressed: adding inventory")
    local player = getPlayer()
    local inv = player:getInventory()

    inv:AddItem("chainsaw.Chainsaw")
    inv:AddItem("Base.PetrolCan")

    local equippedChainsaw
    local chainsaws
    equippedChainsaw, chainsaws = Chainsaw.getChainsaws(player)

    Chainsaw.initItem(equippedChainsaw)
    for _, chainsaw in pairs(chainsaws) do
      Chainsaw.initItem(chainsaw)
    end
  end

  if keyPressed == Keyboard.KEY_HOME then

  end
end

Chainsaw.isChainsaw = function(item)
  local result = string.find(item:getName(), Chainsaw.chainsawName)
  local index
  if not result then
    index = "nil"
  else
    index = result
  end
  print("Looking for " .. Chainsaw.chainsawName .. " in " ..
        item:getName() .. " and getting: " .. index)
  return string.find(item:getName(), Chainsaw.chainsawName)
end

Chainsaw.isFull = function(chainsaw)
  return chainsaw:getAge() >= Chainsaw.chainsawFuelLimit
end

Chainsaw.initItem = function(item, age)
    if not item then
      print("Chainsaw.initItem called with nil item")
      return
    end
    Chainsaw.ensureAge(item, age)
    Chainsaw.ensureName(item)
end

Chainsaw.ensureAge = function(item, age)
  if not item then
    print("Chainsaw.ensureAge called with nil item")
  end
  if age then
    print("Chainsaw.ensureAge called with age: " .. age)
    item:setAge(age)
  elseif not item:getAge() then
    print("Chainsaw.ensureAge: Item " .. item:getName() .. " does not have an age")
    if Chainsaw.isChainsaw(item) then
      print("Chainsaw.ensureAge: Setting chainsaw fuel to limit")
      item:setAge(Chainsaw.chainsawFuelLimit)
    elseif Chainsaw.isPetrolCan(item) then
      print("Chainsaw.ensureAge: Setting petrol can fuel to limit")
      item:setAge(Chainsaw.petrolCanFuel)
    end
  else
    print("Chainsaw.ensureAge: Item " .. item:getName() .. " has an age: " .. item:getAge())
  end
end

Chainsaw.ensureName = function(item)
  if not Chainsaw.hasAgeName(item) then
    print("Chainsaw.ensureName: Chainsaw doesn't have an age name")
    Chainsaw.setAgeName(item)
  else
    print("Chainsaw.ensureName: Chainsaw " .. item:getName() .. " already has age name")
  end
end

Chainsaw.hasAgeName = function(item)
  return string.find(item:getName(), "%[%d+%]")
end

Chainsaw.setAgeName = function(item)
  print("Chainsaw.setAgeName: Setting age name for " .. item:getName() .. " with age: " .. item:getAge())

  if Chainsaw.isChainsaw(item) then
    item:setName(Chainsaw.chainsawName .. " [" .. item:getAge() .."]")
    print("Chainsaw.setAgeName: Chainsaw name is now: " .. item:getName())
  elseif Chainsaw.isPetrolCan(item) then
    item:setName(Chainsaw.petrolCanName .. " [" .. item:getAge() .. "]")
    print("Chainsaw.setAgeName: Petrol can name is now: " .. item:getName())
  end

end

Chainsaw.getChainsaws = function(player)
  local playerInv = player:getInventory()
  local playerItems = playerInv:getItems()
  local equippedItem = player:getPrimaryHandItem()
  local equippedChainsaw
  local chainsaws = {}
  local item

  if equippedItem and Chainsaw.isChainsaw(equippedItem) then
    equippedChainsaw = equippedItem
  end

	for i = 0, playerItems:size() - 1 do
		item = playerItems:get(i)

    if item then
      print("Chainsaw.getChainsaws: item is not nil")
    else
      print("Chainsaw.getChainsaws: Item in playerItems is nil")
    end

    if Chainsaw.isChainsaw(item) then
      Chainsaw.initItem(item)
      table.insert(chainsaws, item)
    else
      print("Not using " .. item:getName() .. " with age " .. item:getAge())
    end
  end

end

Chainsaw.getChainsawsNotFull = function(player)
  local equippedChainsaw
  local chainsaws
  local fullChainsaws = {}

  chainsaws, equippedChainsaw = Chainsaw.getChainsaws(player)

  if equippedChainsaw and Chainsaw.isFull(equippedChainsaw) then
    equippedChainsaw = nil
  end

  if chainsaws then
    for _, chainsaw in pairs(chainsaws) do
      if not Chainsaw.isFull(chainsaw) then
        table.insert(fullChainsaws, item)
      end
    end
  end

  return equippedChainsaw, fullChainsaws
end

Chainsaw.isPetrolCan = function(item)
  return string.find(item:getName(), "Gas Can")
end

Chainsaw.isPetrolCanEmpty = function(petrolCan)
  return petrolCan:getAge() <= 0
end

Chainsaw.getPetrolCansNotEmpty = function(player)
  playerItems = player:getInventory():getItems()
  local petrolCans = {}

	for i = 0, playerItems:size() - 1 do
		local item = playerItems:get(i);

    if Chainsaw.isPetrolCan(item) and
      not Chainsaw.isPetrolCanEmpty(item) then
      item:setName("Gas Can [".. item:getAge() .."]")
      table.insert(petrolCans, equippedItem)
    end
  end

  return petrolCans
end

Chainsaw.fillChainsaw = function(player, chainsaw, petrolCan)
  local chainsawFuel = Chainsaw.getFuel(chainsaw)
  local petrolCanFuel = Chainsaw.getPetrolCanFuel(petrolCan)

  local fuelNeeded = Chainsaw.chainsawFuelLimit - chainsawFuel
  local petrolLeft
  if fuelNeeded <= petrolCanFuel then
    fuelLeft = petrolCanFuel - fuelNeeded
    chainsawFuel = Chainsaw.chainsawFuelLimit
  else
    fuelLeft = 0
    chainsawFuel = chainsawFuel + petrolCanFuel
  end
  Chainsaw.setFuel(chainsaw, chainsawFuel)
  Chainsaw.setPetrolCanFuel(petrolCan, fuelLeft)
end

Chainsaw.setFuel = function(chainsaw, fuel)
  chainsaw:setAge(fuel)
  Chainsaw.setAgeName(chainsaw)
end

Chainsaw.setPetrolCanFuel = function(petrolCan, fuel)
  petrolCan:setAge(fuel)
  Chainsaw.setAgeName(petrolCan)
end

Chainsaw.setIsChainsawEquipped = function()
  local player = getPlayer()
  local item = player:getPrimaryHandItem()
  if item ~= nil and Chainsaw.isChainsaw(item) then
    Chainsaw.isChainsawEquipped = true
  else
    Chainsaw.isChainsawEquipped = false
  end
end

Chainsaw.onEquipPrimary = function()
  local item = nil
  Chainsaw.setIsChainsawEquipped()
  if Chainsaw.isChainsawEquipped then
    Chainsaw.tick = 0
    Chainsaw.isChainsawEquipped = true
    Chainsaw.playIdleSound()
  end
end

Chainsaw.playIdleSound = function()
  print("Chainsaw.playIdleSound: playing silly, fill-in idle sound")
  getSoundManager():PlaySound("chainsaw_idle", false, 0.5)
end

Chainsaw.use = function()
  local player = getPlayer()
  local item = player:getPrimaryHandItem()
  item:setAge(item:getAge() - 1.0)
  print("\"Using\" Chainsaw (lowering age)" .. item:getAge())
end

Chainsaw.onTick = function()
  Chainsaw.tick = Chainsaw.tick + 1
  if Chainsaw.tick % 120 == 0 and Chainsaw.isChainsawEquipped then
    print("Chainsaw.onTick: chainsaw is equipped; playing idle sound")
    Chainsaw.playIdleSound()
  end
  if Chainsaw.tick % 30 == 0 and Chainsaw.isChainsawEquipped then
    Chainsaw.use()
  end
end

Events.OnKeyPressed.Add(Chainsaw.addChainsaw)
Events.OnEquipPrimary.Add(Chainsaw.onEquipPrimary)
Events.OnTick.Add(Chainsaw.onTick)
