-- object generic_ai
--## SERVER

hstructure generic_ai
	meta : table
	instance : luserdata
	anim_graph : tag
	ShockAnimation: string
	ShockedMagnitude : number
	ShockedMagnitudeThreshold : number
	CryoMagnitude: number
	CryoMagnitudeThreshold: number
	CryoCanFreeze: boolean
	CryoFreezeTime: number
	ElementalMagnitudeScalar: number
	DropHealthPack: boolean
	HealthPack: object
	DropHealthPackMarker: string
end

function generic_ai:init()
	self.ShockedMagnitude = 0;
	if (self.ShockedMagnitudeThreshold == nil) then
		self.ShockedMagnitudeThreshold = object_get_maximum_vitality(self, false)/2;
	end
	self.CryoMagnitude = 0;
	if (self.CryoMagnitudeThreshold == nil) then
		self.CryoMagnitudeThreshold = object_get_maximum_vitality(self, false)/2;
	end
	if (self.CryoCanFreeze == nil) then
		self.CryoCanFreeze = false;
	end
	if (self.CryoFreezeTime == nil) then
		self.CryoFreezeTime = 4;
	end
	if (self.ElementalMagnitudeScalar == nil) then
		self.ElementalMagnitudeScalar = 1;
	end
	if (self.DropHealthPack == nil) then
		self.DropHealthPack = false;
	end
	if (self.DropHealthPackMarker == nil) then
		self.DropHealthPackMarker = "equipment";
	end
	if (self.DropHealthPack == true) then
		self:attachHealthPackOnSpawn();
		RegisterEvent(g_eventTypes.deathEvent, generic_ai.onDeathCallback, self, self);
	end
end

function generic_ai:attachHealthPackOnSpawn()
	self.HealthPack = Object_CreateFromTag(TAG('objects\equipment\health_pack\olympus_health_pack_scripted_inert.crate'));
	objects_attach(self, self.DropHealthPackMarker, self.HealthPack, "");
end

function generic_ai:onDeathCallback(self:object):void
	generic_ai:dropHealthPackOnDeath(self);
    UnregisterEvent(g_eventTypes.deathEvent, generic_ai.onDeathCallback, self);
end

function generic_ai:dropHealthPackOnDeath(self:object)
	local healthPack:object = Object_CreateFromTag(TAG('objects\equipment\health_pack\health_pack_droppable.equipment'));
	object_teleport(healthPack, location(self.HealthPack, "light"));
	object_destroy(self.HealthPack);
end

function placement_script_shooting_dangerous()
	ai_register_stimulus(ai_current_actor, "shooting_dangerous")
end

function placement_script_loud_dungeon_group_a()
	ai_register_stimulus(ai_current_actor, "loud_dungeon");
	ai_set_clump(ai_current_actor, 1);
end

function placement_script_loud_dungeon_group_b()
	ai_register_stimulus(ai_current_actor, "loud_dungeon");
	ai_set_clump(ai_current_actor, 2);
end

function placement_script_loud_dungeon_group_c()
	ai_register_stimulus(ai_current_actor, "loud_dungeon");
	ai_set_clump(ai_current_actor, 3);
end

function placement_script_loud_dungeon_group_d()
	ai_register_stimulus(ai_current_actor, "loud_dungeon");
	ai_set_clump(ai_current_actor, 4);
end

function placement_script_loud_dungeon_group_e()
	ai_register_stimulus(ai_current_actor, "loud_dungeon");
	ai_set_clump(ai_current_actor, 5);
end

function placement_script_loud_dungeon_group_f()
	ai_register_stimulus(ai_current_actor, "loud_dungeon");
	ai_set_clump(ai_current_actor, 6);
end

function placement_script_loud_dungeon_group_g()
	ai_register_stimulus(ai_current_actor, "loud_dungeon");
	ai_set_clump(ai_current_actor, 7);
end

function placement_script_loud_dungeon_group_h()
	ai_register_stimulus(ai_current_actor, "loud_dungeon");
	ai_set_clump(ai_current_actor, 8);
end

function placement_script_shortened_perception_group_a()
	ai_register_stimulus(ai_current_actor, "shortened_perception");
	ai_set_clump(ai_current_actor, 1);
end

function placement_script_shortened_perception_group_b()
	ai_register_stimulus(ai_current_actor, "shortened_perception");
	ai_set_clump(ai_current_actor, 2);
end

function placement_script_shortened_perception_group_c()
	ai_register_stimulus(ai_current_actor, "shortened_perception");
	ai_set_clump(ai_current_actor, 3);
end

function placement_script_shortened_perception_group_d()
	ai_register_stimulus(ai_current_actor, "shortened_perception");
	ai_set_clump(ai_current_actor, 4);
end