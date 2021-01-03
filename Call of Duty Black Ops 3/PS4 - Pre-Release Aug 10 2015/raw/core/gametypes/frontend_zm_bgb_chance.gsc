#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\table_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace zm_frontend_zm_bgb_chance;



function zm_frontend_bgb_slots_logic()
{
	level thread bgb_slots_init();
	/#
	level thread zm_frontend_bgb_slots_devgui();
	#/
}

/#
function zm_frontend_bgb_slots_devgui()
{
	SetDvar( "bgb_token_spend_devgui", "" );

	bgb_devgui_base	= "devgui_cmd \"ZM/BGB/Token/";

	a_n_amounts = array( 1, 5, 10 );
	for( i = 0; i < a_n_amounts.size; i++ )
	{
		n_amount = a_n_amounts[ i ];
		AddDebugCommand( bgb_devgui_base + i + " - Add " + n_amount + "\" \"addBGBTokens " + n_amount + "\" \n");
	}

	a_n_amounts = array( 1, 2, 3 );
	for( i = 0; i < a_n_amounts.size; i++ )
	{
		n_amount = a_n_amounts[ i ];
		AddDebugCommand( bgb_devgui_base + ( i + 4 ) + " - Spend " + n_amount + "\" \"set " + "bgb_token_spend_devgui" + " " + n_amount + "\" \n");
	}

	level thread bgb_slots_devgui_think();
}

function bgb_slots_devgui_think()
{
	for( ;; )
	{
		n_bgb_token_spend_count = GetDvarString( "bgb_token_spend_devgui" );

		if ( n_bgb_token_spend_count != "" )
		{
			bgb_slots_roll( n_bgb_token_spend_count );
		}
		
		SetDvar( "bgb_token_spend_devgui", "" );
		
		wait( 0.5 );
	}
}
#/

function bgb_slots_init()
{
}

function bgb_slots_roll( n_bgb_token_spend_count )
{
	// roll each wheel
	for( n_wheel_index = 1; n_wheel_index < 4; n_wheel_index++ )
	{
	/#
		IPrintLn( "BGB SLOTS - ROLLING WHEEL " + n_wheel_index + "..." );
	#/
		bgb_slots_roll_wheel( n_wheel_index, n_bgb_token_spend_count );
	}
}

function bgb_slots_roll_wheel( n_wheel_index, n_bgb_token_spend_count )
{
	// TODO this is where we'll communicate with Demonware to get the bgb reward result; for now, here's a random result
	switch( n_wheel_index ) // descending probability across wheels
	{
		case 1:
			n_win_probability = 1.0;
			break;
		case 2:
			n_win_probability = 0.25;
			break;
		case 3:
			n_win_probability = 0.1;
			break;
	}
	
	n_win_probability += ( 0.1 * Float( n_bgb_token_spend_count ) ); // spend more tokens to win more bgbs
	
	// roll for success
	n_roll = RandomFloat( 1.0 );
	b_roll_succeeds = false;
	if( n_roll < n_win_probability )
	{
		b_roll_succeeds = true;
	}

	// award a random gumball for prototype
	if( b_roll_succeeds )
	{
		// random gumball
		statsTableName = "gamedata/stats/zm/zm_statstable.csv";
		n_bgb_index = RandomIntRange( 201, 235 );
		str_item_index = tableLookup( statsTableName, 0, n_bgb_index, 4 );
		
//		player AddDStat( "ItemStats", str_item_index, "itemStatsByGameTypeGroup", "ZCLASSIC", "stats", "bgbConsumablesGained", "statValue", 1 );
		
		str_output = "BGB SLOTS - WHEEL " + n_wheel_index + "... RECEIVED " + str_item_index + "!!!";
	}
	else
	{
		str_output = "BGB SLOTS - WHEEL " + n_wheel_index + "... nothing";
	}
	/#
		PrintTopRightln( str_output, ( 1, 1, 1 ) );
	#/
}
