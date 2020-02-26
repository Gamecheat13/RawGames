
// CRYO ROOM


// Opening Cinematic - Cortana Orb
script static void fx_cortana_orb()
	print ("::: M10 - Cortana Orb - FX :::");
	effect_new( objects\characters\storm_cortana\fx\orb\cor_orb.effect, fx_cortana_orb );
end


// Opening Cinematic - Activate Cyro Tube Light
script static void fx_cryotube_light()
	print ("::: M10 - Cryotube Light - FX :::");
	effect_new( environments\solo\m10_crash\fx\lights\cry_tube_light.effect, fx_tube_light );

	// MC Cryo Tube LEDs
//	effect_new( environments\solo\m10_crash\fx\misc\cry_tube_led_01.effect, fx_tube_led_01 );
//	effect_new( environments\solo\m10_crash\fx\misc\cry_tube_led_02.effect, fx_tube_led_02 );
//	effect_new( environments\solo\m10_crash\fx\misc\cry_tube_led_03.effect, fx_tube_led_03 );
//	effect_new( environments\solo\m10_crash\fx\misc\cry_tube_led_04.effect, fx_tube_led_04 );
end


// Opening Cinematic - Activate Cryo Tube Steam (part 1)
script static void fx_cryotube_steam_01()
	print ("::: M10 - Cryotube Steam 01 - FX :::");
	effect_new( environments\solo\m10_crash\fx\atmosphere\cry_tube_low_fog.effect, fx_tube_floor_fog );
	effect_new( environments\solo\m10_crash\fx\atmosphere\cry_tube_vent_steam_01.effect, fx_tube_vent_01 );
	effect_new( environments\solo\m10_crash\fx\atmosphere\cry_tube_vent_steam_02.effect, fx_tube_vent_02 );
	effect_new( environments\solo\m10_crash\fx\atmosphere\cry_tube_vent_steam_02.effect, fx_tube_vent_03 );
end


// Opening Cinematic - Activate Cryo Tube Steam (part 2)
script static void fx_cryotube_steam_02()
	print ("::: M10 - Cryotube Steam 02 - FX :::");
	effect_new( environments\solo\m10_crash\fx\atmosphere\cry_tube_steam.effect, fx_tube_light );
	effect_new( environments\solo\m10_crash\fx\atmosphere\cry_tube_vent_steam_03.effect, fx_tube_vent_04 );
	effect_new( environments\solo\m10_crash\fx\atmosphere\cry_tube_vent_steam_03.effect, fx_tube_vent_05 );
end


// In-game Cryo Tube Light - Stay ON
script static void fx_cryotube_light_hold()
	print ("::: M10 - Cryotube Light Hold - FX :::");
	effect_new( environments\solo\m10_crash\fx\lights\cry_tube_light_hold.effect, fx_tube_light );
end


// In-game - Cryo Tube Lingering Fog
script static void fx_cryo_room_fog()
	print ("::: M10 - Cryo Room Lingering Fog - FX :::");
	effect_new( environments\solo\m10_crash\fx\atmosphere\cry_tube_low_fog_02.effect, fx_tube_floor_fog );
	effect_new( environments\solo\m10_crash\fx\atmosphere\cry_tube_room_steam_01.effect, fx_tube_vent_04 );
	effect_new( environments\solo\m10_crash\fx\atmosphere\cry_tube_room_steam_01.effect, fx_tube_vent_05 );
end


// Cryo Tube Door Open - Steam and Debris
script static void fx_cryotube_door_open()
	print ("::: M10 - Cryotube Door Open - FX :::");
	effect_new( environments\solo\m10_crash\fx\atmosphere\cry_steam_tube_door.effect, fx_tube_door );
end

/////// NOT USED ///
// Cortana Plinth - Activate
// script static void fx_cortana_plinth_activate()
// print ("::: M10 - Cortana Plinth Activate - FX :::");
// effect_new( objects\characters\storm_cortana\fx\plinth\cor_plinth_activate.effect, fx_cortana_plinth_cryo );
// end


///////////////////////////////////////
///   Cortana - Plinth Floor Glow   ///
///////////////////////////////////////

// Cortana Plinth Floor Glow
script static void fx_cortana_plinth_glow_cryo()
	print ("::: M10 - Cortana Plinth Floor Glow - FX :::");
	effect_new( objects\characters\storm_cortana\fx\plinth\cor_plinth_glow.effect, fx_cortana_plinth_cryo );
end


////////////////////////////
///   Cortana - Rez-in   ///
////////////////////////////

// Cortana Rez-in
script static void fx_cortana_rez_cryo()
	print ("::: M10 - Cortana Rez-in - FX :::");
	effect_new( objects\characters\storm_cortana\fx\rez\cor_rez_in.effect, fx_cortana_rez_cryo );
end


