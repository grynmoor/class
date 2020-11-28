-- lookup table used for filtering metamethods
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
	__gc = true;
	__len = true;
}

-- base object class
local Object = {
	mtClass = {
		__newindex = function(self, i, v)
			if metamethods[i] then self.mtInstance[i] = v else rawset(self, i, v) end
		end;
		__call = function(self, i, v)
			return self:wrap({}, ...)
		end;
	};
	mtInstance = {};
}
setmetatable(Object, Object.mtClass)

function Object:init(...)

end

function Object:wrap(t, ...)
	setmetatable(t, self.mtInstance)
	t:init(...)
	return t
end

function Object:unwrap()
	setmetatable(self, nil)
	for i in pairs(self) do self[i] = nil end
	return self
end

function Object:isA(class)
	c = self.class
	while c do
		if c == class then return true end
		c = c.super
	end
	return false
end

-- constructor
return function(super)
	if not super then super = Object end

	local class = {super = super}
	class.class = class

	local mtClass = {__index = super}
	for i, v in pairs(super.mtClass) do mtClass[i] = v end
	class.mtClass = mtClass

	local mtInstance = {__index = class}
	for i, v in pairs(super.mtInstance) do mtInstance[i] = v end
	class.mtInstance = mtInstance

	return setmetatable(class, mtClass)
end
