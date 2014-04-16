-- What do I want to do?
--
-- 1) Have the chainsaw idle -- done
-- 2) Play an idle noise -- done
-- 3) Have the chainsaw swing
-- 4) Have a swinging revving noise -- done
-- 5) Have idling use fuel
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
    print("INSERT pressed: adding chainsaw")
    local player = getPlayer()
    local inv = player:getInventory()

    inv:AddItem("chainsaw.Chainsaw")
    inv:AddItem("Base.Axe")
    inv:AddItem("Base.PetrolCan")
  end
end

Chainsaw.isChainsaw = function(item)
  return string.find(item:getName(), Chainsaw.chainsawName)
end

Chainsaw.isFull = function(chainsaw)
  local twentyMinutes = 20 * 60
  return chainsaw:getAge() < twentyMinutes
end

Chainsaw.getChainsawsNotFull = function(player)
  local equippedItem = player:getPrimaryHandItem()
  local equippedChainsaw
  local chainsaws = {}
  if Chainsaw.isChainsaw(equippedItem) and
    not Chainsaw.isFull(equippedItem) then
    equippedChainsaw = equippedItem
  end

  for item in player:getInventory():getItems() do
    if Chainsaw.isChainsaw(item) and not Chainsaw.isFull(item) then
      item:setName(Chainsaw.chainsawName .. " [" .. item:getAge() .."]")
      table.insert(chainsaws, equippedItem)
    end
  end

  return equippedChainsaw, chainsaws
end

Chainsaw.isPetrolCan = function(item)
  return string.find(item:getName(), "Gas Can")
end

Chainsaw.isPetrolCanEmpty = function(petrolCan)
  return petrolCan.getAge() > 0
end

Chainsaw.getPetrolCansNotEmpty = function(player)
  local petrolCans = {}
  for item in player:getInventory():getItems() do
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
  chainsaw:setName(Chainsaw.chainsawName .. " [" .. fuel .. "]")
end

Chainsaw.setPetrolCanFuel = function(petrolCan, fuel)
  petrolCan:setAge(fuel)
  petrolCan:setName(ChainSaw.petrolCanName .. "[" .. fuel .. "]")
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
    Chainsaw.ensureAge()
  end
end

Chainsaw.ensureAge = function()
  local item = getPlayer():getPrimaryHandItem()
  if item:getAge() <= 0 then
    item:setAge(100.0)
  end
end

Chainsaw.playIdleSound = function()
  print("Chainsaw.playIdleSound: playing idle sound")
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
