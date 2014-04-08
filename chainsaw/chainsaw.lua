local function addChainsaw(keyPressed)
  print(keyPressed)
  print(Keyboard.KEY_INSERT:toString())

  if keyPressed == Keyboard.KEY_INSERT then
    print(""..keyPressed.." is equal to "..Keyboard.KEY_INSERT)
    local player = getPlayer()
    local inv = player:getInventory()

	  chainsaw = InventoryItemFactory.CreateItem("chainsaw.Chainsaw")
    player:sendObjectChange('addItem', {item = chainsaw})
    inv:AddItem("chainsaw.Chainsaw")
    inv:AddItem("Base.Axe")
  end
end

local function sayKey(keyPressed)
  print("Key is "..keyPressed)
  print("Insert key is "..Keyboard.KEY_INSERT)
  --local player = getPlayer():Say("Key is"..toString(keyPressed))
end

local function swingBatter()
  print("****************************** swing batter")
  getPlayer():Say("Swing batter!")
  --getSpecifiedPlayer(0):Say("Swing batter! (specified player)")
end

local function saySomething()
  print("********************************** saySomething() ****************************")
end

chainsawObject = {}
chainsawObject.saySomething = function()
  print("********************************* chainsawObject.saySomething() ************************")
end

Events.OnKeyPressed.Add(addChainsaw)
Events.OnKeyPressed.Add(sayKey)
Events.OnWeaponSwing.Add(swingBatter)
Events.OnGameBoot.Add(saySomething)
Events.OnGameBoot.Add(chainsawObject.saySomething)
