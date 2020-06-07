local declared = {}
local function classit(name, super)
	assert(type(name) == "string" and not declared[name] and super == nil or type(super) == "string")

	local superClass, class, objectMt = super and assert(declared[super]) or nil, {}, {}
	local classMt = {
		__newindex = function(t, i, v)
			if i:sub(1, 2) == "__" then
				objectMt[i] = v
			else
				rawset(class, i, v)
			end;
		end;
		__call = function(t, ...)
			local obj = setmetatable({}, objectMt)
			obj:init(...)
			return obj
		end;
	}

	class.className = name
	class.objectMt = objectMt

	if superClass then 
		for i, v in pairs(superClass.objectMt) do
			if i:sub(1, 2) == "__" then
				objectMt[i] = v
			end
		end
		classMt.__index = superClass.objectMt.__index
		class.super = superClass
	else
		function class:init(...) return end
		function class:is(str)
			local obj = self
			while obj do
				if obj.className == str then return true end
				obj = obj.super
			end
			return false
		end
		function objectMt:__tostring() return self.className end		
	end
	objectMt.__index = class

	declared[name] = class
	return setmetatable(class, classMt)
end

return classit
