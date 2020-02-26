-- object slipspace_portal


--## SERVER

function slipspace_portal:init()

	print ("slipspace portal");
				
end

function slipspace_portal:OpenPortal()
	RunClientScript("Portal_OpenPortal",self);
end

function slipspace_portal:ClosePortal()
	RunClientScript("Portal_ClosePortal",self);
end


--## CLIENT

function remoteClient.Portal_OpenPortal(portal:object)

	print ("opening slipspace portal");
		object_set_function_variable(portal, "portal_open", 1, 1);
		object_set_function_variable(portal, "portal_active", 1, 1);
			sleep_s (4);
		object_set_function_variable(portal, "portal_open", 0, 1);

 end

function remoteClient.Portal_ClosePortal(portal:object)

	print ("closing slipspace portal");
		object_set_function_variable(portal, "portal_active", 0, 1);
			sleep_s (3.25);
		object_set_function_variable(portal, "portal_close", 1, 1);
			sleep_s (4);
		object_set_function_variable(portal, "portal_close", 0, 1);

 end

