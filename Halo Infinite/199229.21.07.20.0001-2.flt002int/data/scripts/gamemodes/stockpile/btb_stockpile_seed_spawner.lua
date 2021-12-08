-- object btb_stockpile_seed_spawner
-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

hstructure btb_stockpile_seed_spawner
	meta:table					-- required
	instance:luserdata			-- required (must be first slot after meta to prevent crash)
	components:userdata			-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")

    seedType:string	--$$ METADATA {"prettyName": "Power Seed Variant", "source": ["forerunner_capacitor", "banished_capacitor"], "tooltip": "Event that triggers the Equipment's spawn time", "groupName": " Spawn Properties" }	
end

function btb_stockpile_seed_spawner:init()

end