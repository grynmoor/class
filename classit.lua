local function classit(superClass)
	local class, objectMt = {}, {}
	local classMt = {
		-- Any metamethods (or anything under an index starting with "__") set to 'class' will be moved over to 'objectMt'
		__newindex = function(t, i, v)
			if i:sub(1, 2) == "__" then
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
			if i:sub(1, 2) == "__" then
				objectMt[i] = v
			end
		end
		classMt.__index = superClass
		class.super = superClass
	else
		-- If not inheriting, warn user of possible improper argument (if valid) and implement base methods
		if superClass ~= nil then print(("superclass not set due to improper argument\n%s"):format(debug.traceback())) end
		-- Called immediately after initialization of a new object
		-- All :init(...) functions in inheriting classes must start with class.super.init(self, ...) for things to work as intended!
		function class:init(...) return end
		-- Type-check method for classes
		function class:is(tbl0)
			local tbl1 = self.class
			while tbl1 do
				if tbl0 == tbl1 then return true end
				tbl1 = tbl1.super
			end
			return false
		end	
		-- Minimal support for mixins
		function class:mixin(...)
		    for _, item in pairs({...}) do
		        for i, v in pairs(item) do
		            if self[i] == nil and type(v) == "function" then
		                self[i] = v
		            end
		        end
		    end
		end
	end
	-- Final touches to new class, add self-reference and object metatable, set '__index' for objectMt, and lastly set 'classMt' as a metatable for 'class'
	class.class = class
	class.objectMt = objectMt
	objectMt.__index = class
	return setmetatable(class, classMt)
end
return classit
