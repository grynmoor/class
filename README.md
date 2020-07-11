A Lua module made for easy implementation of classes through just one function.

# Usage
To begin using the module, you will need to do:
```lua
require("class")
```
From there, a global function 'newclass' will be created which can be used to create classes. This global can be renamed by changing the **GLOBAL_NAME** variable in class.lua.
If the creation of a global is undesired, set the **GLOBAL** variable in classit.lua to false and instead do the following:
```lua
local newclass = require("class")
```
The module will return the same function used for creating classes.

## Creating a class
```lua
local Fruit = newclass()
```
## Creating a constructor
```lua
function Fruit:new(name, mass)
	if name ~= nil and type(name) ~= "string" then error() end
	if mass ~= nil and type(mass) ~= "number" then error() end
	self.name = name or "Fruit"
	self.mass = mass or 1
	self.peeled = false
end
```
## Creating a class instance
```lua
local newFruit = Fruit("New Fruit", 3)
print(newFruit.name) -- "New Fruit"
print(newFruit.mass) -- 3
print(newFruit.peeled) -- false
```
## Creating methods
```lua
function Fruit:bite(numTimes)
	if numTimes == nil then
		numTimes = 1
	elseif type(numTimes) ~= "number" then error() end
	local massLost = 0
	for i = 1, numTimes do
		if self.mass <= 0 then return massLost end
		massLost = math.floor(self.mass * 0.5)
		self.mass = self.mass - massLost
	end
	return massLost
end

function Fruit:peel()
	if self.peeled then return end
	self.peeled = true
end

-- Example usage
local newFruit = Fruit(nil, 5)
print(newFruit.peeled) -- false
newFruit:peel()
print(newFruit.peeled) -- true
print(newFruit.mass) -- 5
newFruit:bite(2)
print(newFruit.mass) -- 1
```
## Creating metamethods
```lua
function Fruit:__tostring()
	if self.mass > 0 then
		return ("A %s%s with a mass of %d"):format(self.peeled and "peeled " or "", self.name, self.mass)
	else 
		return "There's nothing left!"
	end
end

function Fruit:__call(...)
	return self:bite(...)
end

-- Example usage
local newFruit = Fruit("Banana")
print(newFruit) -- "A Banana with a mass of 1"
newFruit()
print(newFruit) -- "There's nothing left!"
```
## Creating a subclass
```lua
local Pineapple = classit(Fruit)

function Pineapple:new(mass, tanginess)
	Pineapple.super.new(self, "Pineapple", mass)
	if tanginess ~= nil and type(tanginess) ~= "number" then error() end
	self.tanginess = tanginess or 50
end
```
## Calling a method from a superclass
```lua
function Pineapple:bite(numTimes)
	if self.peeled then -- You wouldn't eat a pineapple that isn't peeled, would you?
		Pineapple.super.bite(self, numTimes)
	end
end
```
## Creating static variables
```lua
local Apple = newclass(Fruit)

Apple.keepsDoctorAway = true

function Apple:new(mass)
	Apple.super.new(self, "Apple", mass)
end

-- Example usage
local newApple = Apple()
print(newApple.keepsDoctorAway) -- true
```
## Checking object types
```lua
local newPineapple = Pineapple()
print(newPineapple:is(Apple)) -- false
print(newPineapple:is(Fruit)) -- true
print(newPineapple:is(Pineapple)) -- true
```
## Creating mix-ins
```lua
local StringUtil = newclass()

function StringUtil:weirdName()
	local name = self.name
	local tbl = {}
	for i = 1, #name do
		if i % 2 == 1 then
			table.insert(tbl, name:sub(i, i):upper())
		else
			table.insert(tbl, name:sub(i, i):lower())
		end
	end
	self.name = table.concat(tbl)
end

-- Example usage
local newPineapple = Pineapple()
newPineapple:mix(StringUtil)
newPineapple:weirdName()
print(newPineapple.name) -- PiNeApPlE
```
