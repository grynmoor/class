
local metamethods = { --- Lookup table used for filtering metamethods
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


---@class Object
local Object = {} 				--- Base object class

Object.class = Object 			--- Class reference
Object.classname = "Object" 	--- Class string identifier
Object.super = nil 				--- Superclass reference
Object._metaclass = {}; 		--- Private table for metamethods which affect the class
Object._metainstance = {}; 		--- Private table for metamethods which affect class instances

setmetatable(Object, Object._metaclass)
Object._metainstance.__index = Object


--- Moves defined metamethods into the appropriate instance table
function Object._metaclass:__newindex(i, v)
    if metamethods[i] then self._metainstance[i] = v else rawset(self, i, v) end
end


--- Creates a new instance when this class is called like a method
function Object._metaclass:__call(...)
    return self:wrap({}, ...)
end


--- Returns the class string identifier when instances are cast to string
function Object:__tostring()
    return self.classname
end


--- Instance constructor. Behavior can be defined in extending classes
function Object:new(...)

end


--- Class method. Wraps the provided table into a class instance
function Object:wrap(t, ...)
    local c = self.class
    local s = self.super

    if s then s:wrap(t, ...) end

    setmetatable(t, c._metainstance)
    if rawget(c, "new") then c.new(t, ...) end
    return t
end


--- Class method. Returns true if this class is equal to or inherits from the provided class
function Object:is(class)
    local c = self.class

    while c do
        if c == class then return true end
        c = c.super
    end

    return false
end


--- Class method. Returns a new class that inherits behavior from this class
function Object:extend()
    local c = self.class

    local NewClass = {}

    NewClass.class = NewClass
    NewClass.super = c
    NewClass._metaclass = {}
    NewClass._metainstance = {}

    for i, v in pairs(c._metaclass) do NewClass._metaclass[i] = v end
    NewClass._metaclass.__index = c
    setmetatable(NewClass, NewClass._metaclass)

    for i, v in pairs(c._metainstance) do NewClass._metainstance[i] = v end
    NewClass._metainstance.__index = NewClass

    return NewClass
end


return Object
