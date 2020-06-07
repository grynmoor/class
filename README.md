class is a single-function module that allows for the implementation of classes in Lua.

```lua
local class = require("class")

--------------------------
-- Example fruit object --

local fruit = class("fruit")

function fruit:init(mass, name)
	assert(type(mass) == "number" and name == nil or type(name) == "string")
	self.mass = mass
	self.name = name or "Fruit"
end

function fruit:bite()
	self.mass = self.mass / 2
end

function fruit.mt:__tostring()
	return ("A very tasty %s that has a mass of %d grams."):format(self.name, self.mass)
end

--------------------------
-- Example apple object --

local apple = class("apple", "fruit") --> class apple inherits from class fruit

apple.keepsDoctorAway = true -- static variable

function apple:init(mass, appleType)
	apple.super.init(self, mass, "Apple")
	assert(type(appleType) == "string")
	self.mass = mass
	self.appleType = appleType
end

function apple.mt:__tostring()
	return ("A very tasty %s %s that has a mass of %d grams."):format(self.appleType, self.name, self.mass)
end

-------------------------
-- Fruit demonstration --

local tastyFruit = fruit(4) --> Creates fruit object with a mass of 4 and the name "Fruit"
print(tastyFruit) --> "A very tasty Fruit that has a mass of 4 grams."
print(tastyFruit:is("fruit")) --> true
print(tastyFruit:is("apple")) --> false
tastyFruit:bite() --> Halves the mass of the fruit object
print(tastyFruit) --> "A very tasty Fruit that has a mass of 2 grams."

-------------------------
-- Apple demonstration --

local redApple = apple(10, "Red") --> Creates apple object with a mass of 10, the name "Apple", and apple type "Red"
print(redApple) --> "A very tasty Red Apple that has a mass of 10 grams."
print(redApple:is("apple")) --> true
print(redApple:is("fruit")) --> true
redApple:bite()
print(redApple) --> "A very tasty Red Apple that has a mass of 5 grams."
print(apple.keepsDoctorAway) --> true
```
