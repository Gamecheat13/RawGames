-- object kit_script_mvar_test
-- Copyright (C) Microsoft. All rights reserved.
--## SERVER
hstructure kit_script_mvar_test
	meta:table			-- required
	instance:luserdata	-- required (must be first slot after meta to prevent crash)
	components:userdata	-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")	
	myCustomString:string --$$ METADATA {"prettyName": "Custom String", "tooltip": "Put a custom string here", "groupName": "Base Properties" }
end

function kit_script_mvar_test:init()
	print("Test Kit Script Initialized!");
	print(self.myCustomString);
end

function kit_script_mvar_test:TestInstanceMethod()
	return true;
end