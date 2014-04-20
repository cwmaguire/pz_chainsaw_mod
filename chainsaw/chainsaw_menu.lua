-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

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
    print("ChainsawMenu.doChainsawMenu: No equipped chainsaw or inventory chainsaws")
    return
  end

  petrolCans = Chainsaw.getPetrolCansNotEmpty(player)

  if #petrolCans == 0 then
    print("ChainsawMenu.doChainsawMenu: No petrol cans in inventory")
    return
  end

  local fillText = "Fill " .. Chainsaw.chainsawName .. "..."
  local fillOption = context:addOption(fillText, worldObjects, nil)
  print("ChainsawMenu.doChainsawMenu: Created fill menu: " .. fillText)

  local chainsawMenu = ISContextMenu:getNew(context)
  context:addSubMenu(fillOption, chainsawMenu)

  if equippedChainsaw then
    local equipChainText = "(Eq) " .. equippedChainsaw:getName()
    local equipChainOption = chainsawMenu:addOption(equipChainText, worldObjects, nil)

    local equipFuelMenu = ISContextMenu:getNew(chainsawMenu)
    chainsawMenu:addSubMenu(equipChainOption, equipFuelMenu)

    ChainsawMenu.addPetrolCanMenus(equipFuelMenu, equippedChainsaw, petrolCans)
  end

  if #chainsaws > 0 then
    print("ChainsawMenu.doChainsawMenu: num chainsaws: " .. #chainsaws)
    for _, chainsaw in pairs(chainsaws) do
      if not chainsaw then
        print("ChainsawMenu.doChainsawMenu: chainsaw is nil; <sigh>")
        break
      end
      if chainsaw:getName() then
        print("ChainsawMenu.doChainsawMenu: creating menu item for chainsaw " ..
              chainsaw:getName())
      else
        print("ChainsawMenu.doChainsawMenu: chainsaw has no name?")
      end
      local chainOption = chainsawMenu:addOption(chainsaw:getName(), worldObjects, nil)

      local invChainFuelMenu = ISContextMenu:getNew(chainsawMenu)
      chainsawMenu:addSubMenu(chainOption, invChainFuelMenu)

      if not invChainFuelMenu then
        print("ChainsawMenu.doChainsawMenu: invChainFuelMenu nil")
      end

      if not player then
        print("ChainsawMenu.doChainsawMenu: player nil")
      end

      if not petrolCans then
        print("ChainsawMenu.doChainsawMenu: petrolCans nil")
      end

      ChainsawMenu.addPetrolCanMenus(invChainFuelMenu, player, chainsaw, petrolCans)
    end
  end
end

ChainsawMenu.addPetrolCanMenus = function(menuContext, player, chainsaw, petrolCans)
  for _, petrolCan in pairs(petrolCans) do
    local petrolCanText = petrolCan:getName()
    menuContext:addOption(petrolCanText, player, Chainsaw.fillChainsaw, chainsaw, petrolCan)
  end
end

Events.OnFillWorldObjectContextMenu.Add(ChainsawMenu.doChainsawMenu);
Events.OnFillInventoryObjectContextMenu.Add(ChainsawMenu.doChainsawMenu);
