local declared = {}
local function class(name, super)
	assert(type(name) == 'string' and super == nil or type(super) == 'string')
	
	local superclass = super and assert(declared[super]) or nil
	local newclass, mt = {}, {}

	newclass.classname = name
	newclass.mt = mt

	setmetatable(newclass, {
		__call = function(t, ...)
			local obj = setmetatable({}, mt)
			t:init(...)
			return obj
		end;
	})

	if superclass then 
		for i, v in pairs(superclass.mt) do
			if i:find('__') == 1 then
				mt[i] = v
			end
		end
		getmetatable(newclass).__index = superclass.mt.__index
		newclass.super = superclass
	else
		function newclass:init(...) return end
		function newclass:is(str)
			local obj = self
			while obj do
				if obj.classname == str then return true end
				obj = obj.super
			end
			return false
		end
		function mt:__tostring() return self.classname end		
	end
	mt.__index = newclass

	declared[name] = newclass
	return newclass
end

return class
