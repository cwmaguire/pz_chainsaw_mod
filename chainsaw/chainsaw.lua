-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

-- What do I want to do?

-- 1) Have the chainsaw idle -- done
-- 2) Play an idle noise -- done
-- 3) Have the chainsaw swing
-- 4) Have a swinging revving noise -- done
-- 5) Have idling use fuel -- done
-- 6) Have swining use fuel
-- 7) Add fuel -- in progress
-- 8) Figure out how to hook into the timed actions

require 'chainsaw/chainsaw_util.lua'

Chainsaw = {}
Chainsaw.tick = 0
Chainsaw.chainsawFillTime = 30
Chainsaw.chainsawName = "Chainsaw"
Chainsaw.petrolCanName = "Gas Can"

do
  local twentyMinutes = 20 * 60
  Chainsaw.chainsawFuelLimit = twentyMinutes

  local oneHour = 60 * 60
  Chainsaw.petrolCanFuel = oneHour
end

Chainsaw.onLoad = function()
  print("Chainsaw.onLoad")
  local player = getPlayer()
  Chainsaw.initInvItems(player)
end

Chainsaw.initInvItems = function(player)
  local equippedChainsaw
  local chainsaws
  local petrolCans

  if player then
    print("Chainsaw.initInvItems: player is loaded")
  else
    print("Chainsaw.initInvItems: player is nil")
    return
  end

  print("Chainsaw.initInvItems: calling Chainsaw.getChainsaws(player)")

  equippedChainsaw, chainsaws = Chainsaw.getChainsaws(player)

  print("Chainsaw.initInvItems: Chainsaw.getChainsaws(player) returned")

  if equippedChainsaw then
    print("Chainsaw.initInvItems: " .. equippedChainsaw:getName())
  else
    print("Chainsaw.initInvItems: no equipped chainsaw")
  end

  if chainsaws then
    print("Chainsaw.initInvItems: " .. #chainsaws .. " chainsaws found")
  else
    print("Chainsaw.initInvItems: no inventory chainsaws")
  end

  if equippedChainsaw then
    Chainsaw.initItem(equippedChainsaw)
  end

  if chainsaws and #chainsaws > 0 then
    for _, chainsaw in pairs(chainsaws) do
      Chainsaw.initItem(chainsaw)
    end
  end

  local petrolCans = Chainsaw.getPetrolCans(player)
  for _, petrolCan in pairs(petrolCans) do
    Chainsaw.initItem(petrolCan)
  end
end

Chainsaw.addChainsaw = function(keyPressed)
  if keyPressed == Keyboard.KEY_INSERT then
    print("INSERT pressed: adding inventory")
    local player = getPlayer()
    local inv = player:getInventory()

    local chainsaw = inv:AddItem("chainsaw.Chainsaw")
    local petrolCan = inv:AddItem("Base.PetrolCan")

    chainsaw:setAge(Chainsaw.chainsawFuelLimit - 100)

    print("Chainsaw.addChainsaw: added chainsaw and petrol can")

    Chainsaw.initItem(chainsaw, Chainsaw.chainsawFuelLimit)
    Chainsaw.initItem(petrolCan, Chainsaw.petrolCanFuel)

    print("Chainsaw.addChainsaw: init'd chainsaw and petrol can")
  elseif keyPressed == Keyboard.KEY_HOME then
    print("Chainsaw.addChainsaw: HOME key pressed")
    ChainsawUtil.printElements(Keyboard)
  else
    print("Chainsaw.addChainsaw: Key pressed = " .. keyPressed)
    print("Chainsaw.addChainsaw: type of Keyboard is " .. type(Keyboard))
    print("Chainsaw.addChainsaw: type of Keyboard.KEY_INSERT is " ..
          type(Keyboard.KEY_INSERT))
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
  print("Chainsaw.isChainsaw: looking for " .. Chainsaw.chainsawName ..
        " in " .. item:getName() ..
        " and getting: " .. index)
  return string.find(item:getName(), Chainsaw.chainsawName)
end

Chainsaw.isFull = function(chainsaw)
  if not chainsaw then
    print("Chainsaw.isFull: chainsaw is nil")
  end
  return chainsaw and chainsaw:getAge() >= Chainsaw.chainsawFuelLimit
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
  elseif Chainsaw.hasAgeName(item) then
    age = Chainsaw.getNameAge(item)
    print("Chainsaw.ensureAge: setting age of " ..
          item:getName() ..
          " to " .. age .. " based on age in name")
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
  elseif item:getAge() == 0 and not Chainsaw.hasAgeName(item) then
    print("Chainsaw.ensureAge: item has zero age but no age name; setting to max")
    item:setAge(Chainsaw.chainsawFuelLimit)
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

Chainsaw.getNameAge = function(item)
  return tonumber(string.match(item:getName(), "%[(%d+)%]"))
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

  if not player then
    print("Chainsaw.getChainsaws: player is nil")
    return
  else
    print("Chainsaw.getChainsaws: player is not nil")
  end

  if not playerInv then
    print("Chainsaw.getChainsaws: playerInv is nil")
    return
  else
    print("Chainsaw.getChainsaws: playerInv is not nil")
  end

  if not equippedItem then
    print("Chainsaw.getChainsaws: equippedItem is nil")
  else
    print("Chainsaw.getChainsaws: equippedItem is not nil")
  end

  if not chainsaws then
    print("Chainsaw.getChainsaws: chainsaws is nil")
  elseif #chainsaws == 0 then
    print("Chainsaw.getChainsaws: chainsaws is empty")
  else
    print("Chainsaw.getChainsaws: chainsaws has length: " .. #chainsaws)
  end

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
      table.insert(chainsaws, item)
    else
      print("Chainsaw.getChainsaws: Not using " .. item:getName() ..
            " with age " .. item:getAge())
    end
  end

  return equippedChainsaw, chainsaws
end

Chainsaw.getChainsawsNotFull = function(player)
  local equippedChainsaw
  local chainsaws
  local notFullChainsaws = {}

  equippedChainsaw, chainsaws = Chainsaw.getChainsaws(player)

  if equippedChainsaw and Chainsaw.isFull(equippedChainsaw) then
    print("Chainsaw.getChainsawsNotFull: " .. equippedChainsaw:getName() ..
          " is full")
    equippedChainsaw = nil
  elseif equippedChainsaw then
    print("Chainsaw.getChainsawsNotFull: " .. equippedChainsaw:getName() ..
          " is not full")
  else
    print("Chainsaw.getChainsawsNotFull: equipped chainsaw is nil")
  end

  if chainsaws then
    for _, chainsaw in pairs(chainsaws) do
      if not Chainsaw.isFull(chainsaw) then
        print("Chainsaw.getChainsawsNotFull: " .. chainsaw:getName() ..
              " is not full")
        table.insert(notFullChainsaws, chainsaw)
      elseif chainsaw then
        print("Chainsaw.getChainsawsNotFull: " .. chainsaw:getName() ..
              " is full")
      else
        print("Chainsaw.getChainsawsNotFull: chainsaw is nil")
        print("Chainsaw.getChainsawsNotFull: how would we even get here?")
        print("Chainsaw.getChainsawsNotFull: why would chainsaws have a nil element?")
      end
    end
  end

  return equippedChainsaw, notFullChainsaws
end

Chainsaw.isPetrolCan = function(item)
  return string.find(item:getName(), "Gas Can")
end

Chainsaw.isPetrolCanEmpty = function(petrolCan)
  return petrolCan:getAge() <= 0
end

Chainsaw.getPetrolCans = function(player)

  playerItems = player:getInventory():getItems()
  local petrolCans = {}

	for i = 0, playerItems:size() - 1 do
		local item = playerItems:get(i)

    if Chainsaw.isPetrolCan(item) then
      table.insert(petrolCans, item)
    end
  end

  return petrolCans
end

Chainsaw.getPetrolCansNotEmpty = function(player)
  if not player then
    print("Chainsaw.getPetrolCansNotEmpty: player nil ... weird")
  end

  local petrolCans = Chainsaw.getPetrolCans(player)
  local petrolCansNotEmpty = {}

  if not petrolCans then
    print("Chainsaw.getPetrolCansNotEmpty: petrolCans nil")
    print("Chainsaw.getPetrolCansNotEmpty: returning empty table")
    return petrolCansNotEmpty
  end

  if #petrolCans == 0 then
    print("Chainsaw.getPetrolCansNotEmpty: zero non-empty petrol cans")
  end

  for _, petrolCan in pairs(petrolCans) do
    if not Chainsaw.isPetrolCanEmpty(petrolCan) then
      table.insert(petrolCansNotEmpty, petrolCan)
    else
      print("Chainsaw.getPetrolCansNotEmpty: Not using " .. petrolCan:getName() ..
            " with age " .. petrolCan:getAge())
    end
  end

  return petrolCansNotEmpty
end

Chainsaw.fillChainsawTimedAction = function(player, chainsaw, petrolCan)
  if player then
    print("Chainsaw.fillChainsawTimedAction: player/character is not nil")
  end
  local action = FillChainsawAction:new(player, chainsaw, petrolCan, Chainsaw.chainsawFillTime)
  ISTimedActionQueue.add(action)
end

Chainsaw.fillChainsaw = function(player, chainsaw, petrolCan)
  if player and player:getInventory() then
    print("Chainsaw.fillChainsaw: got player with inventory")
  end

  if chainsaw and chainsaw:getName() then
    print("Chainsaw.fillChainsaw: got chainsaw: " .. chainsaw:getName())
  end

  if petrolCan and petrolCan:getName() then
    print("Chainsaw.fillChainsaw: got petrolCan: " .. petrolCan:getName())
  end

  local chainsawFuel = Chainsaw.getFuel(chainsaw)
  local petrolCanFuel = Chainsaw.getPetrolCanFuel(petrolCan)

  if not chainsawFuel or not petrolCanFuel then
    print("Chainsaw.fillChainsaw: no chainsaw fuel or petrol can fuel")
    return
  else
    if chainsawFuel then
      print("Chainsaw.fillChainsaw: chainsaw fuel: " .. chainsawFuel)
    end
    if petrolCanFuel then
      print("Chainsaw.fillChainsaw: petrolCanFuel fuel: " .. petrolCanFuel)
    end
  end

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

Chainsaw.getFuel = function(chainsaw)
  if chainsaw and Chainsaw.isChainsaw(chainsaw) then
    return chainsaw:getAge()
  else
    print("Chainsaw.getFuel: could not return chainsaw fuel: nil or not chainsaw")
    return nil
  end
end

Chainsaw.getPetrolCanFuel = function(petrolCan)
  if petrolCan and Chainsaw.isPetrolCan(petrolCan) then
    return petrolCan:getAge()
  else
    print("Chainsaw.getFuel: could not return petrol can fuel: nil or not petrol can")
    return nil
  end
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
  if item and Chainsaw.isChainsaw(item) then
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
    Chainsaw.playIdleSound()
  end
end

Chainsaw.playIdleSound = function()
  print("Chainsaw.playIdleSound: playing silly, fill-in idle sound")
  getSoundManager():PlaySound("chainsaw_idle", false, 0.5)
end

Chainsaw.use = function()
  local player
  local item
  if Chainsaw.isChainsawEquipped then
    player = getPlayer()
    chainsaw = player:getPrimaryHandItem()
    chainsaw:setAge(chainsaw:getAge() - 1.0)
    Chainsaw.setAgeName(chainsaw)
    print("Chainsaw.use: \"Using\" Chainsaw (lowering age)" .. chainsaw:getAge())
  end
end

Chainsaw.onTick = function()
  Chainsaw.tick = Chainsaw.tick + 1
  if Chainsaw.tick % 120 == 0 and Chainsaw.isChainsawEquipped then
    print("Chainsaw.onTick: chainsaw is equipped; playing idle sound")
    Chainsaw.playIdleSound()
  end
  if Chainsaw.tick % 30 == 0 then
    Chainsaw.use()
  end
end

Events.OnKeyPressed.Add(Chainsaw.addChainsaw)
Events.OnEquipPrimary.Add(Chainsaw.onEquipPrimary)
Events.OnTick.Add(Chainsaw.onTick)
Events.OnLoad.Add(Chainsaw.onLoad)
