//
// file: mp_nuked_fx.gsc
// description: clientside fx script for mp_nuked: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 


// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{
}


// --- ROB'S SECTION ---//
precache_createfx_fx()
{

	level._effect["fx_insects_butterfly_flutter"]								= loadfx("bio/insects/fx_insects_butterfly_flutter");
	level._effect["fx_insects_butterfly_flutter_radial"]				= loadfx("bio/insects/fx_insects_butterfly_flutter_radial");	

	level._effect["fx_mp_nuked_glint"]													= loadfx("maps/mp_maps/fx_mp_nuked_glint");	
	level._effect["fx_mp_nuked_glint_sm"]												= loadfx("maps/mp_maps/fx_mp_nuked_glint_sm");	
	level._effect["fx_mp_nuked_glint_lg"]												= loadfx("maps/mp_maps/fx_mp_nuked_glint_lg");	
	level._effect["fx_mp_nuked_double_rainbow"]									= loadfx("maps/mp_maps/fx_mp_nuked_double_rainbow");
	level._effect["fx_mp_nuked_double_rainbow_lg"]							= loadfx("maps/mp_maps/fx_mp_nuked_double_rainbow_lg");		

	level._effect["fx_mp_sand_blowing_xlg_distant"]							= loadfx("maps/mp_maps/fx_mp_sand_blowing_xlg_distant");
	level._effect["fx_mp_sand_windy_heavy_sm_slow"]							= loadfx("maps/mp_maps/fx_mp_sand_windy_heavy_sm_slow");
	
	level._effect["fx_cloud3d_cmls_lg1"]												= loadfx("env/weather/fx_cloud3d_cmls_lg1");	
	
	level._effect["fx_mp_nuked_sprinkler"]											= loadfx("maps/mp_maps/fx_mp_nuked_sprinkler");
	level._effect["fx_mp_nuked_hose_spray"]											= loadfx("maps/mp_maps/fx_mp_nuked_hose_spray");
	
	level._effect["fx_mp_nuked_glass_break"]										= loadfx( "maps/mp_maps/fx_mp_nuked_glass_break" );	
}


// fx prop anim effects
#using_animtree("fxanim_props");
precache_fx_prop_anims()
{
	level.nuked_fxanims = [];
	level.nuked_fxanims["fxanim_mp_dustdevil_anim"] = %fxanim_mp_dustdevil_anim;
	level.nuked_fx["fx_mp_sand_dust_devil"]			= loadfx( "maps/mp_maps/fx_mp_sand_dust_devil" );	
}

play_fx_prop_anims( localClientNum )
{
	fxanim_dustdevils = GetEntArray( localClientNum, "fxanim_mp_dustdevil", "targetname" );
	array_thread( fxanim_dustdevils, ::fxanim_think, localClientNum );
}

fxanim_think( localClientNum )
{
	self endon( "death" );
	self endon( "entityshutdown" );
	self endon( "delete" );

	wait( 3 );
	self UseAnimTree( #animtree );

	for ( ;; )
	{
		wait_time = RandomFloatRange( 15, 30 );
		wait( wait_time );

		self SetAnimRestart( level.nuked_fxanims["fxanim_mp_dustdevil_anim"], 1.0, 0.0, 1.0 );

		dust = PlayFxOnTag( localClientNum, level.nuked_fx["fx_mp_sand_dust_devil"], self, "dervish_jnt" );
		wait( 12 );
		
		StopFx( localClientNum, dust );
	}
}

main()
{
	clientscripts\mp\createfx\mp_nuked_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarint( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}

	precache_fx_prop_anims();
	
	waitforclient(0);

	players = level.localPlayers;

	for ( i = 0; i < players.size; i++ )
	{
		play_fx_prop_anims( i );
	}
}