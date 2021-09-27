#include maps\_utility;
#include common_scripts\utility;

#using_animtree( "generic_human" );
init()
{
	PrecacheModel( "prop_molotov_cocktail" );
	PrecacheItem( "molotov" );
	
	level._effect[ "molotov_trail_F" ]										 = loadfx( "fire/molotov_fire_grow_runner" );
	level._effect[ "molotov_throw" ]										 = loadfx( "fire/molotov_bottle_fire" );
	
	level.scr_anim[ "generic" ][ "molotov_throw" ] = %exposed_fast_grenade_B2;
}

throw_molotov( impact_point, create_trail )
{
	self endon( "death" );
	self thread maps\_anim::anim_generic( self, "molotov_throw" );
	self waittillmatch( "single anim", "grenade_right" );
	
	org = self getTagOrigin( "tag_inhand" );
	bottle = spawn( "script_model", org );
	bottle setModel( "prop_molotov_cocktail" );
	bottle linkTo( self, "tag_inhand" );
//	PlayFXOnTag( getfx( "molotov_throw" ), bottle, "tag_fx" );
	self waittillmatch( "single anim", "fire" );
	bottle delete();
	
	org = self getTagOrigin( "tag_inhand" );
	self childthread molotov_goes( org, impact_point, create_trail );
}

molotov_goes( source_org, impact_point, create_trail )
{
	
	grenade = MagicGrenade( "molotov", source_org, impact_point.origin, 5 );
	
	if ( !isdefined( grenade ) )
		return;
	
	grenade waittill( "death" );

	// create runner	
	if ( isdefined( impact_point.script_exploder ) )
	{
		exploder( impact_point.script_exploder );
	}
	
	if ( isdefined( create_trail ) )
	{
		trail_angle = VectorToAngles( impact_point.origin - source_org );
		
		orig = grenade.origin;
		trace = BulletTrace( orig, orig - (0,0,5000), false );
		orig = trace[ "position" ];
		ent = Spawn( "script_model", orig );
		ent setModel( "tag_origin" );
		ent.angles = (270, 180, 180);
		ent2 = Spawn( "script_model", orig );
		ent2 setModel( "tag_origin" );
		ent2.angles = (0, 0, 0);
		
		ent linkTo( ent2 );
		ent2.angles = (0,180,0) + ( 0, trail_angle[1], 0 );
		
		PlayFxOnTag( getfx( "molotov_trail_F" ), ent, "tag_origin" );
		
		for( i=0; i<20; i++ )
		{
			vec = AnglesToForward( trail_angle );
			orig2 = orig + (vec * ( i * 10 )) + ( 0, 0, 4 );
			RadiusDamage( orig2, 32, 100, 100 );
			wait( 0.05 );
		}
	}
}