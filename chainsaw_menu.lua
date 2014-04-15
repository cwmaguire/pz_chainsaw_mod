require 'chainsaw/chainsaw.lua'

ChainsawMenu = {};

ChainsawMenu.doChainsawMenu = function(player, context, worldObjects)
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
    local equipChainText = "Equipped [" .. Chainsaw.getAge(equippedChainsaw) .. "] ..."
    local equipChainOption = chainsawMenu:addOption(equipChainText, worldObjects, nil)

    local equipFuelMenu = ISContextMenu:getNew(chainsawMenu)
    chainsawMenu:addSubMenu(equipChainOption, equipFuelMenu)

    Chainsaw.addPetrolCanMenus(equipFuelMenu, equippedChainsaw, petrolCans)
  end

  if #chainsaws > 0 then
    for _, chainsaw in pairs(chainsaws) do
      local chainText = "Chainsaw [" .. chainsaw:getAge() .. "] ...";
      local chainOption = chainsawMenu:addOption(chainText, worldObjects, nil)

      local invChainFuelMenu = ISContextMenu:getNew(chainsawMenu)
      chainsawMenu:addSubMenu(chainOption, invChainFuelMenu)

      Chainsaw.addPetrolCanMenus(invChainFuelMenu, player, chainsaw, petrolCans)
    end
  end
end

ChainsawMenu.addPetrolCanMenus = function(menuContext, player, chainsaw, petrolCans)
  for _, petrolCan in pairs(petrolCans) do
    local petrolCanText = "Fuel [" .. petrolCan:getAge() .. "]";
    menuContext:addOption(petrolCanText, player, Chainsaw.fillChainsaw, chainsaw, petrolCan)
  end
end
