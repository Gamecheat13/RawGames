-- object slipspace_portal_guardian


--## SERVER

function slipspace_portal_guardian:init()

	print ("guardian slipspace portal");
				
end

function slipspace_portal_guardian:OpenGuardianPortal()
	RunClientScript("Portal_OpenGuardianPortal",self);
end

function slipspace_portal_guardian:CloseGuardianPortal()
	RunClientScript("Portal_CloseGuardianPortal",self);
end


--## CLIENT

function remoteClient.Portal_OpenGuardianPortal(portal:object)

	print ("opening slipspace portal");
		object_set_function_variable(portal, "portal_open", 1, 1);
		object_set_function_variable(portal, "portal_active", 1, 1);
			sleep_s (4);
		object_set_function_variable(portal, "portal_open", 0, 1);

 end

function remoteClient.Portal_CloseGuardianPortal(portal:object)

	print ("closing slipspace portal");
		object_set_function_variable(portal, "portal_active", 0, 1);
			sleep_s (3.25);
		object_set_function_variable(portal, "portal_close", 1, 1);
			sleep_s (4);
		object_set_function_variable(portal, "portal_close", 0, 1);

 end

