-- object fo_unsc_man_cannon

--## SERVER

function fo_unsc_man_cannon:init()

	RegisterManCannonLaunchedObjectEvent(UNSCManCannonLaunchedObject, self);

end

function UNSCManCannonLaunchedObject(manCannon:object, launchedObject:object)
	RunClientScript("UNSCManCannonLaunchedObjectClient",manCannon,launchedObject);
end

--## CLIENT

function remoteClient.UNSCManCannonLaunchedObjectClient(manCannon:object, launchedObject:object)

	effect_new_on_object_marker(TAG('objects\levels\forge\fo_unsc_man_cannon\fx\fo_unsc_man_cannon_launch.effect'), manCannon, "fx_rear" );
	effect_new_on_object_marker(TAG('objects\levels\forge\fo_unsc_man_cannon\fx\fo_unsc_man_cannon_launch_blur.effect'), launchedObject, "fx_shield_core" );

 end
 