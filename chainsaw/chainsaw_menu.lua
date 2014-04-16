require 'chainsaw/chainsaw.lua'

ChainsawMenu = {};

ChainsawMenu.doChainsawMenu = function(playerNum, context, worldObjects)
  print("Chainsaw menu")
  local player = getSpecificPlayer(playerNum)
  local playerInv = player:getInventory();
  local equippedChainsaw
  local chainsaws
  local petrolCans

  equippedChainsaw, chainsaws = Chainsaw.getChainsawsNotFull(player)

  if not equippedChainsaw and #chainsaws == 0 then
    print("No equipped chainsaw or inventory chainsaws")
    return
  end

  petrolCans = Chainsaw.getPetrolCansNotEmpty(player)

  if #petrolCans == 0 then
    print("No petrol cans in inventory")
    return
  end

  local fillText = "Fill " .. Chainsaw.chainsawName .. "..."
  local fillOption = context:addOption(fillText, worldObjects, nil)
  print("Created fill menu: " .. fillText)

  local chainsawMenu = ISContextMenu:getNew(context)
  context:addSubMenu(fillOption, chainsawMenu)

  if equippedChainsaw then
    local equipChainText = "Equipped [" .. Chainsaw.getAge(equippedChainsaw) .. "] ..."
    local equipChainOption = chainsawMenu:addOption(equipChainText, worldObjects, nil)

    local equipFuelMenu = ISContextMenu:getNew(chainsawMenu)
    chainsawMenu:addSubMenu(equipChainOption, equipFuelMenu)

    Chainsaw.addPetrolCanMenus(equipFuelMenu, equippedChainsaw, petrolCans)
  end

  if #chainsaws > 0 then
    for _, chainsaw in pairs(chainsaws) do
      local chainText = Chainsaw.chainsawName .. " [" .. chainsaw:getAge() .. "] ..."
      local chainOption = chainsawMenu:addOption(chainText, worldObjects, nil)

      local invChainFuelMenu = ISContextMenu:getNew(chainsawMenu)
      chainsawMenu:addSubMenu(chainOption, invChainFuelMenu)

      Chainsaw.addPetrolCanMenus(invChainFuelMenu, player, chainsaw, petrolCans)
    end
  end
end

ChainsawMenu.addPetrolCanMenus = function(menuContext, player, chainsaw, petrolCans)
  for _, petrolCan in pairs(petrolCans) do
    local petrolCanText = Chainsaw.petrolCanName .. " [" .. petrolCan:getAge() .. "]"
    menuContext:addOption(petrolCanText, player, Chainsaw.fillChainsaw, chainsaw, petrolCan)
  end
end

Events.OnFillWorldObjectContextMenu.Add(ChainsawMenu.doChainsawMenu);
