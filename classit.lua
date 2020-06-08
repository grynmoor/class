--[[
	MIT License

	Copyright (c) 2020 grynmoor

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

-- Dictionary for metamethods
local metamethods = {
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

-- Base methods that all classes will have
-- :new(...) is used for constructing classes, being called immediately after the initialization of a new object
-- All :new(...) methods in inheriting classes must start with class.super.new(self, ...) for things to work as intended!
local function new(self, ...) return end
-- Type-check method for classes
local function is(self, a)
	local b = self.class
	while b do
		if a == b then return true end
		b = b.super
	end
	return false
end	
-- Minimal support for mixins
local function mix(self, ...)
    for _, item in pairs({...}) do
        for i, v in pairs(item) do
            if self[i] == nil and type(v) == "function" then
                self[i] = v
            end
        end
    end
end	

-- Used to create new classes
-- Is returned by module
local function classit(superClass)
	local class, objectMt = {}, {}
	local classMt = {
		-- Any metamethods (or anything under an index starting with "__") set to 'class' will be moved over to 'objectMt'
		__newindex = function(t, i, v)
			if metamethods[i] then
				objectMt[i] = v
			else
				rawset(class, i, v)
			end
		end;
		-- Used to instantiate objects
		__call = function(t, ...)
			local obj = setmetatable({}, objectMt)
			obj:init(...)
			return obj
		end;	
	}
	if type(superClass) == "table" then 
		-- If inheriting, carry over object metamethods from superclass to new class and begin to reference superclass in lookups
		for i, v in pairs(superClass.objectMt) do
			if metamethods[i] then
				objectMt[i] = v
			end
		end
		classMt.__index = superClass
		class.super = superClass
	else
		-- If not inheriting, warn user of possible improper argument (if valid) and implement base methods
		if superClass ~= nil then print(("superclass not set due to improper argument\n%s"):format(debug.traceback())) end
		class.new = new
		class.is = is 
		class.mix = mix
	end
	-- Final touches to new class, add self-reference and object metatable, set '__index' for objectMt, and lastly set 'classMt' as a metatable for 'class'
	class.class = class
	class.objectMt = objectMt
	objectMt.__index = class
	return setmetatable(class, classMt)
end

return classit
