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
local function addChainsaw(keyPressed)
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

local function chainsawPlaySound(soundName)
  print("chainsawPlaySound called with SoundName: "..soundName)
  PlaySound(soundName, false, 0.0, 1.0)
  return true
end

Events.OnKeyPressed.Add(addChainsaw)
