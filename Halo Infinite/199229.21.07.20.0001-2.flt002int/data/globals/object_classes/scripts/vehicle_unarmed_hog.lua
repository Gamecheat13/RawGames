-- object vehicle_unarmed_hog 

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('globals\object_classes\scripts\primitives\primitive_socket.lua')

hstructure vehicle_unarmed_hog
	meta : table
	instance : luserdata
	vehicle : object
end

global k_vehicleSmallCargoTags = table.makePermanent
{
	TAG('objects\primitives\carriable\primitive_carriable_bomb.weapon'),
	TAG('objects\multi\bts\bts_coin_primary\bts_coin_primary.weapon'),
	TAG('objects\primitives\carriable\primitive_carriable.weapon'),
	TAG('objects\primitives\fusion_coil\primitive_fusion_coil.weapon'),
	TAG('objects\primitives\carriable\primitive_carriable.weapon'),
	TAG('objects\weapons\multiplayer\ball\ball.weapon'),
	TAG('objects\weapons\multiplayer\skull\skull.weapon'),
}

global k_vehicleLargeCargoTags = table.makePermanent
{
	TAG('objects\weapons\melee\energy_sword\energy_sword.weapon'),
	TAG('objects\weapons\melee\gravity_hammer\gravity_hammer.weapon'),
	TAG('objects\weapons\multiplayer\proto_flag\proto_flag.weapon'),
	TAG('objects\weapons\proto\proto_skewer\proto_skewer.weapon'),
	TAG('objects\weapons\rifle\sniper_rifle\sniper_rifle.weapon'),
	TAG('objects\weapons\support_high\spnker_rocket_launcher_olympus\spnker_rocket_launcher_olympus.weapon'),
	TAG('objects\weapons\turret\gatling_mortar\gatling_mortar.weapon'),
	TAG('objects\vehicles\covenant\turrets\plasma_turret\weapon\plasma_turret_detached\storm_plasma_turret.weapon'),
	TAG('objects\vehicles\human\turrets\unsc_turret\weapons\unsc_chaingun\detached_chaingun\detached_chaingun.weapon'),
	TAG('objects\weapons\proto\proto_heatwave\proto_heatwave.weapon')
}


function vehicle_unarmed_hog:init():void
	self.vehicle = Object_GetParent(self);
	CreateObjectThread(self, self.CustomInitThread, self);
end

function vehicle_unarmed_hog:CustomInitThread():void
	local k_attachPointMarker = "unarmed_hog_attach";

	---=== Parcel Initialization And Object Creation ===---
	local smallCargo01:object = Object_GetObjectAtMarker(self.vehicle, "vehicle_small_cargo_01");
	local smallCargo02:object = Object_GetObjectAtMarker(self.vehicle, "vehicle_small_cargo_02");
	local largeCargo01:object = Object_GetObjectAtMarker(self.vehicle, "vehicle_large_cargo_01");
	if (smallCargo01 == nil or smallCargo02 == nil or largeCargo01 == nil) then
		dprint("vehicle_unarmed_hog failed to create necessary cargo parcels");
		return;
	end
	SleepUntil ([|smallCargo01.parcelInstance ~= nil and smallCargo02.parcelInstance ~= nil and largeCargo01 ~= nil], 1);

	---=== Parcel Config And Object Attachment ===---
	smallCargo01.parcelInstance.attachMarker = "small_cargo_attach";
	smallCargo02.parcelInstance.attachMarker = "small_cargo_attach";
	largeCargo01.parcelInstance.attachMarker = "large_cargo_attach";
	smallCargo01.parcelInstance.attachPointMarker = k_attachPointMarker;
	smallCargo02.parcelInstance.attachPointMarker = k_attachPointMarker;
	largeCargo01.parcelInstance.attachPointMarker = k_attachPointMarker;
	vehicle_unarmed_hog.AddRequiredTags(smallCargo01, k_vehicleSmallCargoTags);
	vehicle_unarmed_hog.AddRequiredTags(smallCargo02, k_vehicleSmallCargoTags);
	vehicle_unarmed_hog.AddRequiredTags(largeCargo01, k_vehicleLargeCargoTags);
	smallCargo01.parcelInstance:SetInteractObjectFromMarker("root");
	smallCargo02.parcelInstance:SetInteractObjectFromMarker("root");
	largeCargo01.parcelInstance:SetInteractObjectFromMarker("root");
end

function vehicle_unarmed_hog.AddRequiredTags(cargo:object, tagList:table):void
	for _, tagPath in ipairs(tagList) do
		cargo.parcelInstance:AddRequiredCarriableTag(tagPath);
	end
end