#include maps\_utility;

	
	
	
	
	
	
	
main()
{
	
	global_FX( "barrel_fireFX_origin", "global_barrel_fire", "fire/firelp_barrel_pm", -15 );

	
	
	global_FX( "ch_streetlight_02_FX_origin", "ch_streetlight_02_FX", "misc/lighthaze", -15 );

	
	global_FX( "me_streetlight_01_FX_origin", "me_streetlight_01_FX", "misc/lighthaze_bog_a", -15 );

	
	global_FX( "ch_street_light_01_on", "lamp_glow_FX", "misc/light_glow_white", -15 );

	
	global_FX( "highway_lamp_post", "ch_streetlight_02_FX", "misc/lighthaze_villassault", -15 );
	
	
	global_FX( "cs_cargoship_spotlight_on_FX_origin", "cs_cargoship_spotlight_on_FX", "misc/lighthaze", -15 );

	
	global_FX( "me_dumpster_fire_FX_origin", "me_dumpster_fire_FX", "fire/firelp_med_pm", -15 );

	
	global_FX( "com_tires_burning01_FX_origin", "com_tires_burning01_FX", "fire/tire_fire_med", -15 );

}

global_FX( targetname, fxName, fxFile, delay )
{
	
	ents = getstructarray(targetname,"targetname");
	if ( !isdefined( ents ) )
		return;
	if ( ents.size <= 0 )
		return;
	
	for ( i = 0 ; i < ents.size ; i++ )
		ents[i] global_FX_create( fxName, fxFile, delay );
}

global_FX_create( fxName, fxFile, delay )
{
	if ( !isdefined( level._effect ) )
		level._effect = [];
	if ( !isdefined( level._effect[ fxName ] ) )
		level._effect[ fxName ]	= loadfx( fxFile );
	
	
	if ( !isdefined( self.angles ) )
		self.angles = ( 0, 0, 0 );
	
	ent = createOneshotEffect( fxName );
	ent.v[ "origin" ] = ( self.origin );
	ent.v[ "angles" ] = ( self.angles );
	ent.v[ "fxid" ] = fxName;
	ent.v[ "delay" ] = delay;
}