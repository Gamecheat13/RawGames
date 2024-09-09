#include common_scripts\_destructible;
#using_animtree( "destructibles" );

main()
{
	//---------------------------------------------------------------------
	// Red Generator
	//---------------------------------------------------------------------
	destructible_create( "toy_generator", "tag_bounce", 75, undefined, 32, "no_melee" );
		destructible_splash_damage_scaler( 15 );
				destructible_loopfx( "tag_fx2", "fx/smoke/generator_damage_whitesmoke", 0.4 );
			destructible_state( undefined, undefined, 75, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_fx2", "fx/smoke/generator_damage_blacksmoke", 0.4 );
			destructible_state( undefined, undefined, 250, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_fx2", "fx/smoke/generator_damage_blacksmoke", 0.4 );
				destructible_loopfx( "tag_fx4", "fx/explosions/generator_spark_runner", .9 );
				destructible_loopfx( "tag_fx3", "fx/explosions/generator_spark_runner", .6123 );
				destructible_loopsound( "generator_spark_loop" );
				destructible_healthdrain( 24, 0.2, 64, "allies" );
			destructible_state( undefined, undefined, 400, undefined, 5, "no_melee" );
				destructible_fx( "tag_fx", "fx/explosions/generator_explosion", true );
				destructible_fx( "tag_fx", "fx/fire/generator_des_fire",true );
				destructible_sound( "generator01_explode" );
				destructible_explode( 7000, 8000, 128, 128, 16, 50, undefined, 0 );	 // force_min, force_max, range, mindamage, maxdamage
				destructible_anim( %generator_explode, #animtree, "setanimknob", undefined, undefined, "generator_explode" );
			destructible_state( undefined, "machinery_generator_des", undefined, undefined, "no_melee" );
}
