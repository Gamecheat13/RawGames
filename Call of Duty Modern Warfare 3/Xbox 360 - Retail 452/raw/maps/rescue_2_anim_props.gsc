#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;

#using_animtree( "script_model" );
main()
{
	if ( !isdefined( level.scr_animtree ) )
		level.scr_animtree = [];
	if ( !isdefined( level.scr_anim ) )
		level.scr_anim = [];
	
	// models	
	PrecacheModel( "fxanim_gp_chain_arch_sm_mod" );
	PrecacheModel( "fxanim_gp_chain_short_mod" );
	PrecacheModel( "fxanim_gp_chain_arch_sm_mod" );
	PrecacheModel( "fxanim_gp_chain_short_mod" );
	PrecacheModel( "fxanim_gp_chain_med_hook_mod" );
	PrecacheModel( "fxanim_gp_chain_med_pulley_mod" );
	
	// anims
	level.scr_animtree[ "fxanim" ]											= #animtree;
	level.scr_anim[ "fxanim" ][ "fxanim_gp_chain_arch_sm_anim" ][0]			= %fxanim_gp_chain_arch_sm_anim;
	level.scr_anim[ "fxanim" ][ "fxanim_gp_chain_short_anim" ][0]			= %fxanim_gp_chain_short_anim;
	level.scr_anim[ "fxanim" ][ "fxanim_gp_chain_arch_sm_anim" ][0]			= %fxanim_gp_chain_arch_sm_anim;
	level.scr_anim[ "fxanim" ][ "fxanim_gp_chain_short_anim" ][0]			= %fxanim_gp_chain_short_anim;
	level.scr_anim[ "fxanim" ][ "fxanim_gp_chain_med_hook_anim" ][0]		= %fxanim_gp_chain_med_hook_anim;
	level.scr_anim[ "fxanim" ][ "fxanim_gp_chain_med_pulley_anim" ][0]		= %fxanim_gp_chain_med_pulley_anim;
	
	array_thread( getentarray( "spawn_animated_props", "targetname" ), ::spawn_animated_props_trigger );
	array_thread( getentarray( "level_cleanup", "targetname" ), ::level_cleanup_trigger );
}

spawn_animated_props_trigger()
{
	self waittill( "trigger" );
	nodes = getstructarray_delete( self.target, "targetname" );
	
	foreach ( n in nodes )
	{
		model = Spawn( "script_model", n.origin );
		model.angles = n.angles;
		model setModel( n.script_modelname );
		model.animname = "fxanim";
		model setAnimTree();
		model delaythread( RandomFloatRange( 0,3 ), ::anim_loop_solo, model, n.animation );
		model thread maps\_util_carlos::delete_on_notify( "level_cleanup" );
		n = undefined;
	}
}

level_cleanup_trigger()
{
	self waittill( "trigger" );
	level notify( "level_cleanup" );
	self delete();
}