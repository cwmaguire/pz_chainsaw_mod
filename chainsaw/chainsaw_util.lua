-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

ChainsawUtil = {};

ChainsawUtil.printElements = function(table)
  for k, v in pairs(table) do
    if type(k) == "string" then
      kString = k
    else
      kString = type(k)
    end
    if type(v) == "string" or type(v) == "number" then
      vString = v
    else
      vString = type(v)
    end
    print("ChainsawUtil.printElementTypes: Key: " ..
          kString ..
          ", Value: " .. vString)
  end
end

ChainsawUtil.checkPlayer = function()
  local player = getPlayer()

  if player then
    print("Chainsaw.checkPlayer: player is loaded")
  else
    print("Chainsaw.checkPlayer: player is nil")
    return
  end
end

ChainsawUtil.examineParams = function(a, b, c, d, e)
  if a then
    print("Chainsaw.examineParams: got param a of type: " .. type(a))
  else
    print("Chainsaw.examineParams: param a is nil (or false)")
  end

  if b then
    print("Chainsaw.examineParams: got param a of type: " .. type(b))
  else
    print("Chainsaw.examineParams: param b is nil (or false)")
  end

  if c then
    print("Chainsaw.examineParams: got param a of type: " .. type(c))
  else
    print("Chainsaw.examineParams: param c is nil (or false)")
  end

  if d then
    print("Chainsaw.examineParams: got param a of type: " .. type(d))
  else
    print("Chainsaw.examineParams: param d is nil (or false)")
  end

  if e then
    print("Chainsaw.examineParams: got param a of type: " .. type(e))
  else
    print("Chainsaw.examineParams: param e is nil (or false)")
  end
end

