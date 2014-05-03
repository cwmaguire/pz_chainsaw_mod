-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

require "TimedActions/ISBaseTimedAction"

FillChainsawAction = ISBaseTimedAction:derive("FillChainsawAction")

function FillChainsawAction:isValid()
	return true
end

function FillChainsawAction:update()
end

function FillChainsawAction:start()
end

function FillChainsawAction:stop()
    ISBaseTimedAction.stop(self)
end

function FillChainsawAction:perform()
  if self then
    print("ChainsawFillTimedAction.perform(self): self is not nil")
  else
    print("ChainsawFillTimedAction.perform(self): self is nil")
  end
	Chainsaw.fillChainsaw(self.player, self.chainsaw, self.petrolCan)
  FillChainsawAction.removeFromQueueStartNext(self)
end

FillChainsawAction.removeFromQueueStartNext = function(action)
  ISBaseTimedAction.perform(action)
end

function FillChainsawAction:new(character, chainsaw, petrolCan, time)
	local o = {}
	setmetatable(o, self)
  -- TODO See if we can do this on module load
  --      I'm not sure why we'd have to keep setting
  --      up the FillChainsawAction as a metatable over
  --      and over again
	self.__index = self
	o.character = character
  o.chainsaw = chainsaw
  o.petrolCan = petrolCan
	o.stopOnWalk = false
	o.stopOnRun = false
	o.maxTime = time
	return o
end
