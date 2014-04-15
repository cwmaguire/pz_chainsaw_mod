Events.OnFillWorldObjectContextMenu.Add(ISCampingMenu.doCampingMenu);

ChainsawMenu = {};

ChainsawMenu.doCampingMenu = function(player, context, worldObjects)
  local playerInv = getSpecificPlayer(player):getInventory();
  local equippedChainsaw
  local chainsaws
  local petrolCans

  equippedChainsaw, invChainsaws = Chainsaw.getChainsawsNotFull(player)

  if not equippedChainsaw and #chainsaws == 0 then
    return
  end

  petrolCans = Chainsaw.getPetrolCansNotEmpty(player)

  if #petrolCans == 0 then
    return
  end

  local fillOption = context:addOption("Fill Chainsaw ...", worldObjects, nil)

  local chainsawMenu = ISContextMenu:getNew(context)
  context:addSubMenu(fillOption, chainsawMenu)

  if equippedChainsaw then
    local equipChainText = "Equipped [" + Chainsaw.getAge(equippedChainsaw) + "] ..."
    local equipChainOption = chainsawMenu:addOption(equipChainText, worldObjects, nil)

    local equipFuelMenu = ISContextMenu:getNew(chainsawMenu)
    chainsawMenu:addSubMenu(equipChainOption, equipFuelMenu)

    Chainsaw.addPetrolCanMenus(equipFuelMenu, equippedChainsaw, petrolCans)
  end

  if #chainsaws > 0 then
    for _, chainsaw in chainsaws do
      local chainText = "Chainsaw [" + chainsaw:getAge() + "] ..."
      local chainOption = chainsawMenu:addOption(chainText, worldObjects, nil)

      local invChainFuelMenu = ISContextMenu:getNew(chainsawMenu)
      chainsawMenu:addSubMenu(chainOption, invChainFuelMenu)

      Chainsaw.addPetrolCanMenus(invChainFuelMenu, chainsaw, petrolCans)
    end
  end
end

Chainsaw.addPetrolCanMenus = function(menuContext, chainsaw, petrolCans)
    for _, petrolCan in petrolCans do
      local petrolCanText = "Fuel [" .. petrolCan:getAge() .. "]"
      menuContext:addOption(petrolCanText
                            player,
                            Chainsaw.fillChainsaw,
                            chainsaw,
                            petrolCan)
    end
end

    chainsawMenu:addOption(Chainsaw.getAge(equippedChainsaw),
                           player,
                           Chainsaw.onAddFuel,


  local fuelOption = context:addOption(campingText.addFuel, worldobjects, nil);
  local subMenuFuel = ISContextMenu:getNew(context);
    context:addSubMenu(fuelOption, subMenuFuel);
    for i,v in pairs(fuelList) do
      local label = v:getName()
      local count = itemCount[v:getName()]
      if count > 1 then
        label = label..' ('..count..')'
      end
      subMenuFuel:addOption(label, worldobjects, ISCampingMenu.onAddFuel, v, player, ISCampingMenu.campfire);
    end
  end


ISCampingMenu.onAddFuel = function(worldobjects, fuelType, player, campfire)
  local fuelAmt = campingFuelType[fuelType:getType()] or campingFuelCategory[fuelType:getCategory()]
  if not fuelAmt or fuelAmt < 0 then return end
  if luautils.walkAdj(camping.currentGridSquare) then
    ISTimedActionQueue.add(ISAddFuelAction:new(getSpecificPlayer(player), campfire, fuelType, fuelAmt * 60, 100));
  end
--  ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(player), fuelType, getSpecificPlayer(player):getInventory(), campfire.tile:getItemContainer()));
end

ISCampingMenu.onPlaceCampfire = function(worldobjects, player)
  local bo = campingCampfire:new()
  bo.player = player
  getCell():setDrag(bo, player)
end

ISCampingMenu.onRemoveCampfire = function(worldobjects, player, campfire)
  if luautils.walkAdj(camping.currentGridSquare) then
    ISTimedActionQueue.add(ISRemoveCampfireAction:new(getSpecificPlayer(player), campfire, 60));
  end
end

ISCampingMenu.onLightFromLiterature = function(worldobjects, player, literature, lighter, campfire)
  if luautils.walkAdj(camping.currentGridSquare) then
    ISTimedActionQueue.add(ISLightFromLiterature:new(getSpecificPlayer(player), literature, lighter, campfire, 100));
  end
end

ISCampingMenu.onLightFromKindle = function(worldobjects, player, campfire)
  if luautils.walkAdj(camping.currentGridSquare) then
    ISTimedActionQueue.add(ISLightFromKindle:new(getSpecificPlayer(player), campfire, 1500));
  end
end

ISCampingMenu.onAddPetrol = function(worldobjects, player, campfire)
  if luautils.walkAdj(camping.currentGridSquare) then
    local petrol = getSpecificPlayer(player):getInventory():FindAndReturn("PetrolCan")
    ISTimedActionQueue.add(ISAddPetrolAction:new(getSpecificPlayer(player), campfire, petrol, 10));
  end
end

ISCampingMenu.onLightFromPetrol = function(worldobjects, player, campfire)
  if luautils.walkAdj(camping.currentGridSquare) then
    local lighter = getSpecificPlayer(player):getInventory():FindAndReturn("Lighter")
    ISTimedActionQueue.add(ISLightFromPetrol:new(getSpecificPlayer(player), campfire, lighter, 20));
  end
end

ISCampingMenu.onAddTent = function(worldobjects, player)
  local bo = campingTent:new()
  bo.player = player
  getCell():setDrag(bo, player);
end

ISCampingMenu.onRemoveTent = function(worldobjects, player, tent)
  if luautils.walkAdj(camping.currentGridSquare) then
    ISTimedActionQueue.add(ISRemoveTentAction:new(getSpecificPlayer(player), tent, 60));
  end
end

ISCampingMenu.onSleep = function(worldobjects, tent)
  if luautils.walkAdj(camping.currentGridSquare) then
    ISWorldObjectContextMenu.onSleep();
  end
end

Events.OnFillWorldObjectContextMenu.Add(ISCampingMenu.doCampingMenu);

