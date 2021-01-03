// ----------------------------------------------------------------------------
// codescripts
// ----------------------------------------------------------------------------
#using scripts\codescripts\struct;

// ----------------------------------------------------------------------------
// shared
// ----------------------------------------------------------------------------
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\scene_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

// ----------------------------------------------------------------------------
// #define
// ----------------------------------------------------------------------------



// ----------------------------------------------------------------------------
// main
// ----------------------------------------------------------------------------
function main()
{
	init_clientfields();
}

// ----------------------------------------------------------------------------
// init_clientfields
// ----------------------------------------------------------------------------
function init_clientfields()
{
	// Callbacks for actors
	clientfield::register( "toplayer", "sim_out_of_bound", 1, 1, "counter", &callback_out_of_bound, !true, !true );
	
	clientfield::register( "world", "sim_lgt_tree_glow_01", 1, 1, "int", &callback_lgt_tree_glow_01, !true, !true );
	clientfield::register( "world", "sim_lgt_tree_glow_02", 1, 1, "int", &callback_lgt_tree_glow_02, !true, !true );
	clientfield::register( "world", "sim_lgt_tree_glow_03", 1, 1, "int", &callback_lgt_tree_glow_03, !true, !true );	
	clientfield::register( "world", "sim_lgt_tree_glow_04", 1, 1, "int", &callback_lgt_tree_glow_04, !true, !true );
	clientfield::register( "world", "sim_lgt_tree_glow_05", 1, 1, "int", &callback_lgt_tree_glow_05, !true, !true );
	
	clientfield::register( "world", "sim_lgt_tree_glow_all_off", 1, 1, "int", &callback_lgt_tree_glow_all_off, !true, !true );
	
	clientfield::register( "toplayer", "pstfx_frost_up", 		1, 1, "counter", 	&callback_pstfx_frost_up, 		!true, !true );
	clientfield::register( "toplayer", "pstfx_frost_down", 		1, 1, "counter", 	&callback_pstfx_frost_down, 	!true, !true );
	clientfield::register( "toplayer", "pstfx_frost_up_baby", 	1, 1, "counter", 	&callback_pstfx_frost_up_baby,	!true, !true );
	
	clientfield::register( "scriptmover", "infection_baby_shader", 1, 1, "int", 		&callback_baby_skin_shader, 	!true, !true);
	
	clientfield::register( "world", "toggle_sim_fog_banks", 1, 1, "int", &callback_toggle_sim_fog_banks, !true, !true );
	
	clientfield::register( "world", "break_baby", 			1, 1, "int", &callback_break_baby, !true, !true );
}

// ----------------------------------------------------------------------------
// callback_out_of_bound
// ----------------------------------------------------------------------------
function callback_out_of_bound( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	player = GetLocalPlayer( localClientNum );
	
	player postfx::StopPostfxBundle();
	player.pstfx_frost = 0;
}

// ----------------------------------------------------------------------------
// callback_lgt_tree_glow_01
// ----------------------------------------------------------------------------
function callback_lgt_tree_glow_01( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	exploder::exploder( "lgt_tree_glow_01" );
}

// ----------------------------------------------------------------------------
// callback_lgt_tree_glow_02
// ----------------------------------------------------------------------------
function callback_lgt_tree_glow_02( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	exploder::exploder( "lgt_tree_glow_02" );
}


// ----------------------------------------------------------------------------
// callback_lgt_tree_glow_03
// ----------------------------------------------------------------------------
function callback_lgt_tree_glow_03( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	exploder::exploder( "lgt_tree_glow_03" );
}

// ----------------------------------------------------------------------------
// callback_lgt_tree_glow_04
// ----------------------------------------------------------------------------
function callback_lgt_tree_glow_04( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	exploder::exploder( "lgt_tree_glow_04" );
}


// ----------------------------------------------------------------------------
// callback_lgt_tree_glow_05
// ----------------------------------------------------------------------------
function callback_lgt_tree_glow_05( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	exploder::exploder( "lgt_tree_glow_05" );
}

// ----------------------------------------------------------------------------
// callback_lgt_tree_glow_all_off
// ----------------------------------------------------------------------------
function callback_lgt_tree_glow_all_off( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	const n_exploders = 5;
	
	for ( i = 1; i <= n_exploders; i++ )
	{
		str_exploder_name = "lgt_tree_glow_0" + i;		
		exploder::stop_exploder( str_exploder_name );
	}
}

// ----------------------------------------------------------------------------
// callback_pstfx_frost_up
// ----------------------------------------------------------------------------
function callback_pstfx_frost_up( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	player = GetLocalPlayer( localClientNum );
	
	if ( !IsDefined( player.pstfx_frost ) )
	{
		player.pstfx_frost = 0;
	}
	
	if ( ( player.pstfx_frost == 0 ) && ( newVal == 1 ) )
	{
		playsound (0, "evt_freeze_start", (0,0,0));
		
		player.pstfx_frost = 1;
		player postfx::PlayPostfxBundle( "pstfx_frost_up" );
		player postfx::PlayPostfxBundle( "pstfx_frost_loop" );	
		
	}
}

// ----------------------------------------------------------------------------
// callback_pstfx_frost_down
// ----------------------------------------------------------------------------
function callback_pstfx_frost_down( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	player = GetLocalPlayer( localClientNum );
	
	if ( !IsDefined( player.pstfx_frost ) )
	{
		player.pstfx_frost = 0;
	}
	
	if ( ( player.pstfx_frost == 1 ) && ( newVal == 1 ) )
	{
		playsound (0, "evt_freeze_end", (0,0,0));
		player.pstfx_frost = 0;
		player postfx::PlayPostfxBundle( "pstfx_frost_down" );
	
	}
}

// ----------------------------------------------------------------------------
// callback_pstfx_frost_up_baby
// ----------------------------------------------------------------------------
function callback_pstfx_frost_up_baby( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	player = GetLocalPlayer( localClientNum );
	
	player.pstfx_frost = -1;
	player postfx::PlayPostfxBundle( "pstfx_baby_frost_up" );
	player postfx::PlayPostfxBundle( "pstfx_baby_frost_loop" );
	
	playsound (0, "evt_freeze_start", (0,0,0));	
}

// ----------------------------------------------------------------------------
// callback_toggle_sim_fog_banks
// ----------------------------------------------------------------------------
function callback_toggle_sim_fog_banks( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	n_bank = 0;
	
	if ( newVal == 1 )
	{
		n_bank = 2;
	}
	else
	{
		n_bank = 0;
	}		
		
	SetWorldFogActiveBank( localClientNum, n_bank );
}

// ----------------------------------------------------------------------------
// callback_break_baby
// ----------------------------------------------------------------------------
function callback_break_baby( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		level thread scene::play( "p7_fxanim_cp_infection_baby_bundle" );
		exploder::exploder( "inf_boa_crying" );
	}
}

// ----------------------------------------------------------------------------
// callback_baby_skin_shader
// ----------------------------------------------------------------------------
function callback_baby_skin_shader( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
//#if 0
//	n_wait_per_cycle = 1 / N_CHANGE_PER_SECOND;
//	
//	n_desaturation_increment = 1 / ( N_CHANGE_PER_SECOND * N_BABY_SKIN_CHANGE_LENGTH );
//	n_desaturation = 0;
//	
//	n_vein_increment = 1 / ( N_CHANGE_PER_SECOND * N_BABY_SKIN_CHANGE_LENGTH );
//	n_vein = 0;
//	
//	n_eyeball_increment = 1 / ( N_CHANGE_PER_SECOND * N_BABY_SKIN_CHANGE_LENGTH );
//	n_eyeball = 0;
//#endif

	start_time = GetTime();
	anim_time = 15;

	vien_start_time = 2;
	eyeball_start_time = 3;
	
	updating = 1;
	while( updating )
	{
		time = gettime();
		time_in_seconds = ( time - start_time ) / 1000;

		// Check for the shader complete time
		if( time_in_seconds >= anim_time )
		{
			time_in_seconds = anim_time;
			updating = 0;
		}
		
		// Set the desaturation value, time starts at 0, finishes at 10
		n_desaturation = time_in_seconds / 15.0;

		// Set the vien value, time starts at 2, finishes at 10
		if( time_in_seconds < vien_start_time )
		{
			n_vein = 0;
		}
		else
		{
			n_vein = 1 - ( ( 15 - time_in_seconds ) / (anim_time - vien_start_time) );
		}

		// Set the eyeball value
		if( time_in_seconds < eyeball_start_time )
		{
			n_eyeball = 0;
		}
		else
		{
			n_eyeball = 1 - ( ( 15 - time_in_seconds ) / (anim_time - eyeball_start_time) );
		}

		// Map the shader values
		self MapShaderConstant( 0, 0, "scriptVector1", n_desaturation, n_vein, 0, 0 );
		self MapShaderConstant( 0, 0, "scriptVector0", n_eyeball, 0, 0 );
		
		wait( 0.01 );
	}
		

//#if 0
//	for ( i = 0; i <= N_BABY_SKIN_CHANGE_LENGTH; i = i + n_wait_per_cycle )
//	{
//		// Set the desaturation value
//		//  - Time starts at 0, finishes at 10
//		ndesaturation = 
//		
//		// Set the vien value
//		// - Time starts at 2, finishes at 10
//
//
//		self MapShaderConstant( 0, 0, "scriptVector1", n_desaturation, n_vein, 0, 0 );
//
//
//		self MapShaderConstant( 0, 0, "scriptVector0", n_eyeball, 0, 0 );
//			
//		n_desaturation += n_desaturation_increment;
//		n_vein += n_vein_increment;
//		n_eyeball += n_eyeball_increment;
//			
//		wait n_wait_per_cycle;
//	}
//#endif


}

