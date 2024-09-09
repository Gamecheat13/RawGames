#include common_scripts\_destructible;
#using_animtree( "destructibles" );

toy_tvs_flatscreen( version, mounting )
{
	//---------------------------------------------------------------------
	// Flatscreen TVs
	//---------------------------------------------------------------------
	destructible_create( "toy_tv_flatscreen_" + mounting + version, "tag_origin", 1, undefined, 32 );
		destructible_splash_damage_scaler( 1 );
			destructible_fx( "tag_fx", "fx/explosions/tv_flatscreen_explosion" );
			destructible_sound( "tv_shot_burst" );
			destructible_explode( 20, 2000, 10, 10, 3, 3, undefined, 15 );  // force_min, force_max, rangeSP, rangeMP, mindamage, maxdamage
		destructible_state( undefined, "ma_flatscreen_tv_" + mounting + "broken_" + version, 200, undefined, "no_melee" );
}

toy_tvs_flatscreen_sturdy( version, mounting )
{
	//---------------------------------------------------------------------
	// Flatscreen TVs that can take more damage
	//---------------------------------------------------------------------
	destructible_create( "toy_tv_flatscreen_" + mounting + version + "_sturdy", "tag_origin", 1, undefined, 1280 );
		destructible_splash_damage_scaler( 0.5 );
			destructible_fx( "tag_fx", "fx/explosions/tv_flatscreen_explosion_cheap" );
			destructible_sound( "tv_shot_burst" );
			destructible_explode( 20, 2000, 10, 10, 3, 3, undefined, 15 );  // force_min, force_max, rangeSP, rangeMP, mindamage, maxdamage
		destructible_state( undefined, "ma_flatscreen_tv_" + mounting + "broken_" + version, 200, undefined, "no_melee" );
}

toy_tvs_flatscreen_cinematic( modelName, destroyFn )
{
	//---------------------------------------------------------------------
	// Flatscreen TV that has a (optional) separate model that shows a cinematic on the screen
	//---------------------------------------------------------------------
	destructible_create( "toy_" + modelName, "tag_origin", 1, undefined, 32 );
		destructible_splash_damage_scaler( 1 );
			destructible_fx( "tag_fx", "fx/explosions/tv_flatscreen_explosion" );
			destructible_sound( "tv_shot_burst" );
			destructible_explode( 20, 2000, 10, 10, 3, 3, undefined, 15 );  // force_min, force_max, rangeSP, rangeMP, mindamage, maxdamage
			destructible_function( destroyFn );
		destructible_state( undefined, modelName + "_d", 200, undefined, "no_melee" );
}

// Finds and removes a targetted model.  Commonly used to remove the cinematic-playing screen on a TV when it's destroyed.
RemoveTargetted()
{
	tgtModels = GetEntArray( self.target, "targetname" );
	if ( isDefined( tgtModels ) )
	{
		foreach ( tgtModel in tgtModels )
		{
			tgtModel Delete();
		}
	}
}