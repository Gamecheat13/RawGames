-- object monitor_light

--## SERVER

hstructure monitor_light
    meta : table;
    instance : luserdata;
    components : userdata;	
	
	lights:table;
	monitor:object;
end

function monitor_light:init()			
	self.lights = Kits_GetComponentsOfType(self, "light");
	self.monitor = Kits_GetComponentsOfType(self, "object")[1];
	--print(self.monitor);
    --print ("monitor is", self.components.unsc_prop_monitor_a__cr)	
	self:RegisterEventOnceOnSelf(g_eventTypes.deathEvent, self.turn_off, self.components.unsc_prop_monitor_g__cr)
end

function monitor_light:turn_off()
	for _, light in ipairs(self.lights) do
		Lights_SetDimmerValue(light, 0)
	end
end