Inspired by rxi's classic module. classit is a Lua module made for easy implementation of classes through just one function!
```lua
local classit = require("classit")

--------------------------
-- Example fruit object --

local fruit = classit()

function fruit:new(mass, name)
	assert(type(mass) == "number" and name == nil or type(name) == "string")
	self.mass = mass
	self.name = name or "Fruit"
end

function fruit:bite()
	self.mass = math.floor(self.mass / 2)
end

function fruit:__tostring()
	return ("A very tasty %s that has a mass of %d gram%s."):format(self.name, self.mass, self.mass == 1 and "" or "s")
end

function fruit:__call()
	self:bite()
end

--------------------------
-- Example apple object --

local apple = classit(fruit) --> class apple inherits from class fruit

apple.keepsDoctorAway = true -- static variable

function apple:new(mass, appleType)
	apple.super.init(self, mass, "Apple")
	assert(type(appleType) == "string")
	self.mass = mass
	self.appleType = appleType
end

function apple:__tostring()
	return ("A very tasty %s %s that has a mass of %d gram%s."):format(self.appleType, self.name, self.mass, self.mass == 1 and "" or "s")
end

------------------------------
-- Example stringutil mixin --

local stringutil = classit()

function stringutil:weirdCase(str)
    local tbl = {}
    for i = 1, #str do
        if i % 2 == 1 then
            table.insert(tbl, str:sub(i, i):upper())
        else
           table.insert(tbl, str:sub(i, i):lower())
        end
    end
    return table.concat(tbl)
end

-------------------------
-- Fruit demonstration --

local tastyFruit = fruit(4) --> Creates fruit object with a mass of 4 and the name "Fruit"
print(tastyFruit) --> "A very tasty Fruit that has a mass of 4 grams."
print(tastyFruit:is(fruit)) --> true
print(tastyFruit:is(apple)) --> false
tastyFruit:bite() --> Halves then rounds down the mass of the fruit object
print(tastyFruit) --> "A very tasty Fruit that has a mass of 2 grams."
tastyFruit() --> Calls tastyFruit:bite()
print(tastyFruit) --> "A very tasty Fruit that has a mass of 1 gram."

-------------------------
-- Apple demonstration --

local redApple = apple(10, "Red") --> Creates apple object with a mass of 10, the name "Apple", and apple type "Red"
print(redApple) --> "A very tasty Red Apple that has a mass of 10 grams."
print(redApple:is(fruit)) --> true
print(redApple:is(apple)) --> true
redApple:bite() --> Halves then rounds down the mass of the fruit object
print(redApple) --> "A very tasty Red Apple that has a mass of 5 grams."
redApple() --> Calls redApple:bite()
print(redApple) --> A very tasty Red Apple that has a mass of 2 grams.
print(redApple.keepsDoctorAway) --> true

-------------------------
-- Mixin demonstration --

redApple:mix(stringutil)
print(redApple:weirdCase(redApple.name)) --> "ApPlE"
```
