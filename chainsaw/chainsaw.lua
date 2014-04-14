-- What do I want to do?
--
-- 1) Have the chainsaw idle
-- 2) Play an idle noise
-- 3) Have the chainsaw swing
-- 4) Have a swinging revving noise
-- 5) Have idling use fuel
-- 6) Have swining use fuel
-- 7) Add fuel
--

Chainsaw = {}
Chainsaw.tick = 0;

Chainsaw.addChainsaw = function(keyPressed)
  if keyPressed == Keyboard.KEY_INSERT then
    print("INSERT pressed: adding chainsaw")
    local player = getPlayer()
    local inv = player:getInventory()

    inv:AddItem("chainsaw.Chainsaw")
    inv:AddItem("Base.Axe")
  end
end

Chainsaw.isChainsawEquipped = function()
  local player = getPlayer()
  local item = player:getPrimaryHandItem()
  if item == nil then
    print("Chainsaw.isChainsawEquipped: Item is nil")
  elseif item:getDisplayName() == "Chainsaw" then
    print("Chainsaw.isChainsawEquipped: Item desc is \"Chainsaw\"")
  elseif item:getDisplayName() == nil then
    print("Chainsaw.isChainsawEquipped: Item desc is null")
  else
    print("Chainsaw.isChainsawEquipped: Item desc ~= \"Chainsaw\"")
    print("Chainsaw.isChainsawEquipped: Item desc == "..item:getDisplayName())
  end
  if item ~= nil and item:getDisplayName() == "Chainsaw" then
    print("Chainsaw.isChainsawEquipped: Item is not nil and desc = \"Chainsaw\"")
    return true
  else
    return false
  end
end

Chainsaw.onEquipPrimary = function()
  print("Chainsaw.onEquipPrimary")
  if Chainsaw.isChainsawEquipped() then
    print("Chainsaw.onEquipPrimary: chainsaw is equipped")
    Chainsaw.tick = 0
    Chainsaw.playIdleSound()
  else
    print("Chainsaw.onEquipPrimary: chainsaw is not equipped")
  end
end

Chainsaw.playIdleSound = function()
  print("Chainsaw.playIdleSound: playing idle sound")
  getSoundManager():PlaySound("chainsaw_idle", false, 1.0)
end

Chainsaw.onTick = function()
  Chainsaw.tick = Chainsaw.tick + 1
  if Chainsaw.tick % 120 == 0 and Chainsaw.isChainsawEquipped() then
    print("Chainsaw.onTick: chainsaw is equipped; playing idle sound")
    Chainsaw.playIdleSound()
  end
end

Events.OnKeyPressed.Add(Chainsaw.addChainsaw)
Events.OnEquipPrimary.Add(Chainsaw.onEquipPrimary)
Events.OnTick.Add(Chainsaw.onTick)
