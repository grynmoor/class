local function classit(superClass)
	local class, objectMt = {}, {}
	local classMt = {
		__newindex = function(t, i, v)
			if i:sub(1, 2) == "__" then
				objectMt[i] = v
			else
				rawset(class, i, v)
			end
		end;
		__call = function(t, ...)
			local obj = setmetatable({}, objectMt)
			obj:init(...)
			return obj
		end;	
	}

	if type(superClass) == "table" then 
		for i, v in pairs(superClass.objectMt) do
			if i:sub(1, 2) == "__" then
				objectMt[i] = v
			end
		end
		classMt.__index = superClass
		class.super = superClass
	else
		if superClass ~= nil then print(("superclass not set due to improper argument\n%s"):format(debug.traceback())) end
		function class:init(...) return end
		function class:is(tbl0)
			local tbl1 = getmetatable(self).class
			while tbl1 do
				if tbl0 == tbl1 then return true end
				tbl1 = tbl1.super
			end
			return false
		end	
	end

	class.objectMt = objectMt
	objectMt.__index = class
	objectMt.class = class
	return setmetatable(class, classMt)
end

return classit
