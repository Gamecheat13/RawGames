-- object light_fixture

--## SERVER

hstructure light_fixture
    meta : table;
    instance : luserdata;
    components : userdata;
	
	intensity:number;				--$$ METADATA {"visible": true}		
	lightColor:color_rgba;			--$$ METADATA {"visible": true}
	targetColor:color_rgba;		--$$ METADATA {"visible": true}
	emissiveMultiplier:number; --$$ METADATA {"visible": true}
	coneIntensity:number; 		--$$ METADATA {"visible": true}
	
	initializationInProgress:boolean;
	hasInitialized:boolean;
	--fixtureObject:object
	fixtureObjects:table;
	lights:table
	cones:table
	flares:table;
end

function light_fixture:init()	
	if self.hasInitialized ~= true then
		self:Initialize();
	end
end

function light_fixture:Initialize():void
	--Initialize the parameters
	if self.initializationInProgress ~= true then
		self.initializationInProgress = true;
		self.hasInitialized = false;
		CreateKitThread(self, self.FinishInitialization, self);
	end
end

function light_fixture:FinishInitialization():void
	self.intensity = self.intensity or 0;
	self.lightColor = self.lightColor or color_rgba(1,1,1,0);
	self.targetColor = self.targetColor or color_rgba(1,0,0,0);
	self.emissiveMultiplier = self.emissiveMultiplier or 0;
	self.coneIntensity = self.coneIntensity or 0;	
	
	self.fixtureObjects = Kits_GetComponentsOfType(self, "object");	
	
	-- Avoid spikes by throttling initialization.
	Sleep(1);

	--Set all the lights in the fixture to their default value
	self.lights = Kits_GetComponentsOfType(self, "light");
	for _, light in ipairs(self.lights) do
		Lights_SetIntensity(light, self.intensity);
		Lights_SetColor(light, self.lightColor.r,self.lightColor.g,self.lightColor.b);
		Lights_SetColorChangeTargetColor(light, self.targetColor.r, self.targetColor.g, self.targetColor.b);
	end
	
	-- Avoid spikes by throttling initialization.
	Sleep(1);

	self.cones = Kits_GetComponentsOfType(self, "light_cone");
	for _, cone in ipairs(self.cones) do
		Fixture_SetLightConeIntensityByIndex(cone, self.coneIntensity);
		Fixture_SetLightConeColorByIndex(cone, self.lightColor.r, self.lightColor.g, self.lightColor.b);
		--print(_ , Fixture_GetLightConeColorByIndex(cone));
	end

	self.flares = Kits_GetComponentsOfType(self, "effect_placement");
	for _, flare in ipairs(self.flares) do
		Fixture_SetEffectScaleByIndex(flare, 1);		
	end

	
	--CreateThread(self.set_emissive, self, 1);
	--CreateThread(self.set_emissive_color, self, self.lightColor);
	--CreateThread(self.set_emissive_multiplier, self, self.emissiveMultiplier);

	self:set_emissive(1);
	self:set_emissive_color(self.lightColor);
	self:set_emissive_multiplier(self.emissiveMultiplier);
	
	--Allows any parent interpolator kits to initialize after this fixture has finished
	self.hasInitialized = true;
	self.initializationInProgress = false;
end

function light_fixture:set_master_dimmer(value:number, time:number)
	time = time or 0;
	for _, obj in ipairs(self.fixtureObjects) do
		object_set_function_variable(obj, "master_dimmer", value, time);
	end
end

function light_fixture:get_master_dimmer():number
	return object_get_function_value(self.fixtureObjects[1], "master_dimmer");
end

function light_fixture:set_emissive(eIntensity:number, time:number)
	time = time or 0;
	for _, obj in ipairs(self.fixtureObjects) do
		object_set_function_variable(obj, "e_amount", eIntensity, time);
	end
end

function light_fixture:get_emissive():number
	return object_get_function_value(self.fixtureObjects[1], "e_amount");
end

function light_fixture:set_emissive_multiplier(multiplier:number, time:number)
	time = time or 0;
	local finalValue = multiplier / 100;
	for _, obj in ipairs(self.fixtureObjects) do
		object_set_function_variable(obj, "e_multiplier", finalValue, time);
	end
end

function light_fixture:set_emissive_color(c:color_rgba)
	for _, obj in ipairs(self.fixtureObjects) do
		Fixture_SetEmissiveColor(obj, c.r, c.g, c.b);
	end
end

function light_fixture:set_light_color(c:color_rgba)	
	for _, obj in ipairs(self.fixtureObjects) do
		Fixture_SetColor(self.lights, obj, c.r, c.g, c.b);
	end		
	
	for _, cone in ipairs(self.cones) do
		Fixture_SetLightConeColorByIndex(cone, c.r, c.g, c.b);		
	end
end

function light_fixture:set_light_dimmer(value:number):void
	SetLightsDimmerValue(self.lights, value);
end

function light_fixture:get_emissive_color():number	
	return self.lightColor;
end

function light_fixture:set_cone_dimmer(dimmer:number)
	for _c, cone in ipairs(self.cones) do
		Fixture_SetLightConeIntensityByIndex(cone, self.coneIntensity * dimmer);		
	end	
end

function light_fixture:set_flare_dimmer(dimmer:number)
	for _, flare in ipairs(self.flares) do
		Fixture_SetEffectScaleByIndex(flare, dimmer);
	end
end
