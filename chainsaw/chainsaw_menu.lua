-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.- What do I want to do?

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
      if not chainsaw then
        print("Chainsaw.doChainsawMenu: chainsaw is nil; <sigh>")
        break
      end
      local chainOption = chainsawMenu:addOption(chainsaw:getName(), worldObjects, nil)

      local invChainFuelMenu = ISContextMenu:getNew(chainsawMenu)
      chainsawMenu:addSubMenu(chainOption, invChainFuelMenu)

      -- TODO Check what is nil when we get here. Somethings breaking.

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
