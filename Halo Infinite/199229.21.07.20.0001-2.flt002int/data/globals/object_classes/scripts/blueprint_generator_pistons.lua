-- object blueprint_generator_pistons
-- Copyright (c) Microsoft. All rights reserved.
--## SERVER
--

hstructure blueprint_generator_pistons
	meta:table					-- required
	instance:luserdata			-- required (must be first slot after meta to prevent crash)
	components:userdata			-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")

	loopTime:number
	offsetTime:number
end

function blueprint_generator_pistons:init()
	self.loopTime = 45;
	self.offsetTime = 2;

	CreateKitThread(self, self.ToggleLoop, self)
	CreateKitThread(self, self.FXThread, self);
end

function blueprint_generator_pistons:ToggleLoop():void
	local flipPistons = false;

	device_set_position(self.components.unsc_custom_blueprint_electric_hydro_charger_machine_drum_a, 1);
	--SoundImpulseStartServer(TAG('sound\003_levels\003_lvl_positional\003_lvl_positional_mp_blueprint\003_lvl_positional_mp_blueprint_turbine_powercycle.sound'), self.components.unsc_custom_blueprint_electric_hydro_charger_machine_drum_a, 1);
	SleepSeconds(35);
	--SoundImpulseStartServer(TAG('sound\003_levels\003_lvl_positional\003_lvl_positional_mp_blueprint\003_lvl_positional_mp_blueprint_turbine_powercycle_end.sound'), self.components.unsc_custom_blueprint_electric_hydro_charger_machine_drum_a, 1);
	SleepSeconds(10);
	device_set_position_immediate(self.components.unsc_custom_blueprint_electric_hydro_charger_machine_drum_a, 0);

	repeat
	if flipPistons == false then

		
		--PISTONS
		device_set_position(self.components.unsc_prop_batterydock_a, 1);
		
		SleepSeconds(self.offsetTime);

		device_set_position(self.components.unsc_prop_batterydock_a03, 1);
		SleepUntil([|device_get_position(self.components.unsc_prop_batterydock_a03) == 1], 1);
		SleepSeconds(self.offsetTime);

		device_set_position(self.components.unsc_prop_batterydock_a01, 1);
		SleepSeconds(self.offsetTime);

		device_set_position(self.components.unsc_prop_batterydock_a02, 1);
		SleepSeconds(self.offsetTime);

		flipPistons = true;

	else
		
		
		--PISTONS
		device_set_position(self.components.unsc_prop_batterydock_a01, 0);
		SleepSeconds(self.offsetTime);

		device_set_position(self.components.unsc_prop_batterydock_a02, 0);
		SleepUntil([|device_get_position(self.components.unsc_prop_batterydock_a02) == 0], 1);
		SleepSeconds(self.offsetTime);

		device_set_position(self.components.unsc_prop_batterydock_a, 0);
		SleepSeconds(self.offsetTime);

		device_set_position(self.components.unsc_prop_batterydock_a03, 0);
		SleepSeconds(self.offsetTime);

		flipPistons = false;
	end

	device_set_position(self.components.unsc_custom_blueprint_electric_hydro_charger_machine_drum_a, 1);
	
	-- FX Turbine Electricity Start
	CreateEffectGroup(EFFECTS.fx_electricity_hero_machine);
	CreateEffectGroup(EFFECTS.fx_electricity_hero_machine_turbine_01);
	CreateEffectGroup(EFFECTS.fx_electricity_hero_machine_turbine_02);
	CreateEffectGroup(EFFECTS.fx_electricity_hero_machine_turbine_03);
	CreateEffectGroup(EFFECTS.fx_electricity_hero_machine_turbine_04);
	CreateEffectGroup(EFFECTS.fx_electricity_hero_machine_turbine_05);
	
	-- FX Battery 01 Sparks Start
	SleepSeconds(44);
	CreateEffectGroup(EFFECTS.fx_battery_01_sparks_front);
	CreateEffectGroup(EFFECTS.fx_battery_01_sparks_back);
	CreateEffectGroup(EFFECTS.fx_battery_01_electricity_front);
	CreateEffectGroup(EFFECTS.fx_battery_01_electricity_back);
	
	-- FX End	
	
	--SoundImpulseStartServer(TAG('sound\003_levels\003_lvl_positional\003_lvl_positional_mp_blueprint\003_lvl_positional_mp_blueprint_turbine_powercycle.sound'), self.components.unsc_custom_blueprint_electric_hydro_charger_machine_drum_a, 1);
	SleepSeconds(35);
	--SoundImpulseStartServer(TAG('sound\003_levels\003_lvl_positional\003_lvl_positional_mp_blueprint\003_lvl_positional_mp_blueprint_turbine_powercycle_end.sound'), self.components.unsc_custom_blueprint_electric_hydro_charger_machine_drum_a, 1);
	SleepSeconds(10);
	device_set_position_immediate(self.components.unsc_custom_blueprint_electric_hydro_charger_machine_drum_a, 0);

	until false;
end

function blueprint_generator_pistons:FXThread():void
	-- FX Turbine Electricity Start
	CreateEffectGroup(EFFECTS.fx_electricity_hero_machine);
	CreateEffectGroup(EFFECTS.fx_electricity_hero_machine_turbine_01);
	CreateEffectGroup(EFFECTS.fx_electricity_hero_machine_turbine_02);
	CreateEffectGroup(EFFECTS.fx_electricity_hero_machine_turbine_03);
	CreateEffectGroup(EFFECTS.fx_electricity_hero_machine_turbine_04);
	CreateEffectGroup(EFFECTS.fx_electricity_hero_machine_turbine_05);
	
	-- FX Battery 01 Sparks Start
	SleepSeconds(44);
	CreateEffectGroup(EFFECTS.fx_battery_01_sparks_front);
	CreateEffectGroup(EFFECTS.fx_battery_01_sparks_back);
	CreateEffectGroup(EFFECTS.fx_battery_01_electricity_front);
	CreateEffectGroup(EFFECTS.fx_battery_01_electricity_back);	
end