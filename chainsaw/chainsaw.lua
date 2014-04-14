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

local function isChainsawEquipped()
  local player = getPlayer()
  local item = player:getPrimaryHandItem()
end

Chainsaw.chainsawPlayCheckSound = function()
  print("chainsawPlayCheckSound called with SoundName: check")
  getSoundManager():PlaySound("check", false, 1.0)
end

Chainsaw.onTick = function()
  Chainsaw.tick = Chainsaw.tick + 1
  if Chainsaw.tick % 60 == 0 then
    print("chainsawPlayCheckSound called with SoundName: check")
    getSoundManager():PlaySound("check", false, 1.0)
  end
end

Events.OnKeyPressed.Add(Chainsaw.addChainsaw)
Events.OnEquipPrimary.Add(Chainsaw.chainsawPlayCheckSound)
Events.OnTick.Add(Chainsaw.onTick)
