// Test clientside script for karma_2
#include clientscripts\_utility;
#include clientscripts\_glasses;

#insert  raw\maps\karma.gsh;
#define ORGANS_INVISIBLE -1.17
#define ORGANS_VISIBLE 0
#define UNUSED 0

//*****************************************************************************
//*****************************************************************************

main()
{
	// This MUST be first for CreateFX!	
	clientscripts\karma_2_fx::main();
	
	// _load!
	clientscripts\_load::main();

	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\karma_2_amb::main();
	
	register_clientflag_callback( "actor", CLIENT_FLAG_ENEMY_HIGHLIGHT, ::set_id_shader );
	register_clientflag_callback( "scriptmover", CLIENT_FLAG_ORGAN_FADE, ::fade_karma_organs );

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	println("*** Client : karma_2 running...");

	//****************
	// EXTRA CAM SETUP
	//****************
	level thread fov_listener( "fov_zoom_e7_defalco_chase", 30);	// 18
	level thread fov_listener( "fov_zoom_e7_defalco_chase_out", 50);	// 18
	level thread fov_listener( "fov_zoom", 10 );
	level thread fov_listener( "fov_zoom_hi", 3 );
	level thread fov_listener( "fov_normal", 70 );
}


//
//	Do face swaps on a texture
face_swap( localClientNum, set, newEnt )
{
	self mapshaderconstant( localClientNum, 0, "ScriptVector0" ); 		
	self mapshaderconstant( localClientNum, 1, "ScriptVector1" ); 		

	// Call this to change the transparency ( 0 = Opaque, 1 = Transparent )
	layerA_Transparency = 0.0;
	layerB_Transparency = 0.0;
	
	if ( set )
	{
		layerC_Transparency = 1.0;
		layerD_Transparency = 0.0;
	}
	else
	{
		layerC_Transparency = 0.0;
		layerD_Transparency = 1.0;
	}
	layerE_Transparency = 0.0;
	layerF_Transparency = 0.0;
	self setshaderconstant( localClientNum, 0, layerA_Transparency, layerB_Transparency, layerC_Transparency, layerD_Transparency );
	self setshaderconstant( localClientNum, 1, layerE_Transparency, layerF_Transparency, 0, 0 );
}

//TODO needs a better fix because the .deathfunc can get overwritten (by things like balcony falls)
set_id_shader( localClientNum, set, newEnt )
{
	self mapshaderconstant( localClientNum, 2, "ScriptVector3" ); 
	
	if ( set )
	{
		self setshaderconstant( localClientNum, 2, 1, 0, 0, 0 );
	}
	else
	{
		//self setshaderconstant( localClientNum, 2, 0, 0, 0, 0 );
		decrement = 0;
		
		while(1)
		{
			self setshaderconstant( localClientNum, 2, 1 - decrement, 0, 0, 0 );
			decrement += 0.05;
			
			if(decrement >= 1)
			{
				self setshaderconstant( localClientNum, 2, 0, 0, 0, 0 );
				break;
			}
			wait(0.05);
		}
	}
}

// SetClientFlag will not run functions below if flag is already set; same with ClearClientFlag
// Note that default parameters on the organ models are set to show
fade_karma_organs( n_local_client, set, newEnt )  // self = script model (scriptmover)
{
	const n_shader_index = 3;
	self MapShaderConstant( n_local_client, n_shader_index, "ScriptVector7" );
	
	if ( set )  // fade to invisible from visible
	{
		_organs_fade_out( n_local_client, n_shader_index );
	}
	else 
	{
		_organs_fade_in( n_local_client, n_shader_index );
	}
}

_organs_fade_in( n_local_client, n_shader_index )
{
	const n_fade_time = 3.5;
	const n_update_time = 0.01;
	
	n_counter = 0;
	n_loops_total = Int( n_fade_time / n_update_time );
	
	n_increment = ( ( ORGANS_VISIBLE - ORGANS_INVISIBLE ) / n_loops_total );
	
	while ( n_counter <= n_loops_total )
	{
		n_value = ORGANS_INVISIBLE + ( n_increment * n_counter );
		self SetShaderConstant( n_local_client, n_shader_index, n_value, UNUSED, UNUSED, UNUSED );	
		
		n_counter++;
		wait n_update_time;
	}
}

_organs_fade_out( n_local_client, n_shader_index )
{
	println( "organs fade out" );
	
	self SetShaderConstant( n_local_client, n_shader_index, ORGANS_INVISIBLE, UNUSED, UNUSED, UNUSED );
}
