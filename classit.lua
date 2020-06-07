local declared = {}
local function classit(name, super)
	assert(type(name) == "string" and super == nil or type(super) == "string")
	
	local superClass = super and assert(declared[super]) or nil
	local newClass, mt = {}, {}

	newClass.className = name
	newClass.mt = mt

	setmetatable(newClass, {
		__newindex = function(t, i, v)
			if i:find("__") == 1 then
				print(i)
				mt[i] = v
			else
				rawset(newClass, i, v)
			end;
		end;
		__call = function(t, ...)
			local obj = setmetatable({}, mt)
			obj:init(...)
			return obj
		end;
	})

	if superClass then 
		for i, v in pairs(superClass.mt) do
			if i:find("__") == 1 then
				mt[i] = v
			end
		end
		getmetatable(newClass).__index = superClass.mt.__index
		rawset(newClass, "super", superClass)
	else
		rawset(newClass, "init", function(self, ...) return end)
		rawset(newClass, "is", function(self, str)
			local obj = self
			while obj do
				if obj.className == str then return true end
				obj = obj.super
			end
			return false
		end)
		function mt:__tostring() return self.className end		
	end
	mt.__index = newClass

	declared[name] = newClass
	return newClass
end

return classit
