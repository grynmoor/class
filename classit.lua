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
local pairs, type, rawset, setmetatable = pairs, type, rawset, setmetatable -- micro-optimize for the lulz
local GLOBAL = true -- If true, create global variable for classit
local GLOBAL_NAME = "classit" -- Name of global variable
local META = { -- Hash table for metamethods
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
local BASE = { -- Base data that all classes will have
	new = function(self, ...) end; -- :new(...) is used for constructing classes, being called immediately after the initialization of a new object
	is = function(self, other) -- Type-check method for classes
		local class = self.class 
		while class do
			if other == class then return true end
			class = class.super
		end
		return false
	end;	
	mix = function(self, ...) -- Minimal support for mixins
	    for _, item in pairs({...}) do
	        for i, v in pairs(item) do
	            if self[i] == nil and type(v) == "function" then
	                self[i] = v
	            end
	        end
	    end
	end;
}
local function classit(super) -- Used to create new classes, is returned by module
	super = (super == nil or type(super) == "table") and super or nil
	local class, classMt, objectMt = {}, {}, {}
	class.class, class.super, class.objectMt = class, super, objectMt
	classMt.__index = super 
	classMt.__newindex = function(t, i, v) -- Any metamethods set to 'class' will be moved over to 'objectMt'
		if META[i] then
			objectMt[i] = v
		else
			rawset(t, i, v)
		end
	end
	classMt.__call = function(t, ...) -- Used to instantiate objects
		local obj = setmetatable({}, objectMt)
		obj:new(...)
		return obj
	end
	if super then -- If inheriting, carry over object metamethods from super to new class
		for i, v in pairs(super.objectMt) do
			if META[i] then objectMt[i] = v end
		end
	else -- If not inheriting, implement base data
		for i, v in pairs(BASE) do class[i] = v end
	end
	objectMt.__index = class
	return setmetatable(class, classMt)
end
if GLOBAL then rawset(_G, GLOBAL_NAME, classit) end
return classit
