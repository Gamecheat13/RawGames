-- object primitive_carriable

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure primitive_carriable
	meta : table
	instance : luserdata
end

function primitive_carriable:init()
	Object_SetHasPickupPriority(self, true);
end
