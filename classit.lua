local declared = {}
local function classit(name, super)
	assert(type(name) == "string" and super == nil or type(super) == "string")
	
	local superClass, newClass, prototype = super and assert(declared[super]) or nil, {}, {}
	local newClassMt = {
		__newindex = function(t, i, v)
			if i:find("__") == 1 then
				prototype[i] = v
			else
				rawset(newClass, i, v)
			end;
		end;
		__call = function(t, ...)
			local obj = setmetatable({}, prototype)
			obj:init(...)
			return obj
		end;
	}

	newClass.className = name
	newClass.prototype = prototype

	if superClass then 
		for i, v in pairs(superClass.prototype) do
			if i:find("__") == 1 then
				prototype[i] = v
			end
		end
		newClassMt.__index = superClass.prototype.__index
		newClass.super = superClass
	else
		function newClass:init(...) return end
		function newClass:is(str)
			local obj = self
			while obj do
				if obj.className == str then return true end
				obj = obj.super
			end
			return false
		end
		function prototype:__tostring() return self.className end		
	end
	prototype.__index = newClass

	declared[name] = newClass
	return setmetatable(newClass, newClassMt)
end

return classit
