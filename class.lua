--[[
	MIT License

	Copyright (c) 2020 grynmoor

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the 'Software'), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

local base = { -- Base data that all classes will have.
	class = nil;
	super = nil;
 	new = function(self, ...) end; -- Used as a constructor when instantiating new instances
	is = function(self, other) -- Type-check method for classes
		local class = self.class
		while class do
			if class == other then return true end
			class = class.super
		end
		return false
	end;
}
local meta = { -- Used to filter metamethods
	__index = true;
	__newindex = true;
	__call = true;
	__concat = true;
	__unm = true;
	__add = true;
	__sub = true;
	__mul = true;
	__div = true;
	__mod = true;
	__pow = true;
	__tostring = true;
	__metatable = true;
	__eq = true;
	__lt = true;
	__le = true;
	__mode = true;
}

local function newclass(super) -- Used to create new classes, is returned by module
	local class, classMt, instanceMt = {}, {}, {}

	class.class = class
	class.instanceMt = instanceMt

	classMt.__newindex = function(t, i, v) -- Any metamethods set to 'class' will be moved over to 'instanceMt'
		if meta[i] then
			instanceMt[i] = v
		else
			rawset(t, i, v)
		end
	end
	classMt.__call = function(t, ...) -- Used to instantiate new instances
		local instance = setmetatable({}, instanceMt)
		instance:new(...)
		return instance
	end

	if super then -- If inheriting, carry over instance metamethods from super to new class
		class.super = super
		classMt.__index = super 
		for i, v in pairs(super.instanceMt) do instanceMt[i] = v end
	else -- If not inheriting, implement base data
		for i, v in pairs(base) do class[i] = v end
	end
	instanceMt.__index = class

	return setmetatable(class, classMt)
end

return newclass
