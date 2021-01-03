#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_hive_gun;
#using scripts\shared\weapons\_weaponobjects;

        

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "weapon/fx_hero_annhilatr_death_blood" );
#precache( "client_fx", "weapon/fx_hero_pineapple_death_blood" );

#namespace globallogic;


function autoexec __init__sytem__() {     system::register("globallogic",&__init__,undefined,"visionset_mgr");    }


function __init__()
{
	visionset_mgr::register_visionset_info( "mpintro", 1, 31, undefined, "mpintro" );

	//handles actor and  player corpse case
	clientfield::register( "world", "game_ended", 1, 1, "int", &game_ended, true, true );
	RegisterClientField("playercorpse", "firefly_effect", 1, 2, "int", &firefly_effect_cb, false);	
	RegisterClientField("playercorpse", "annihilate_effect", 1, 1, "int", &annihilate_effect_cb, false);	
	RegisterClientField("playercorpse", "pineapplegun_effect", 1, 1, "int", &pineapplegun_effect_cb, false);	
	RegisterClientField("actor", "annihilate_effect", 1, 1, "int", &annihilate_effect_cb, false);	
	RegisterClientField("actor", "pineapplegun_effect", 1, 1, "int", &pineapplegun_effect_cb, false);	

	level._effect[ "annihilate_explosion" ] = "weapon/fx_hero_annhilatr_death_blood";
	level._effect[ "pineapplegun_explosion" ] = "weapon/fx_hero_pineapple_death_blood";
	
	level.gameEnded = false;
}


function game_ended(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal && !level.gameEnded )
	{
		level notify("game_ended");
		level.gameEnded = true;
	}
}


function firefly_effect_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( bNewEnt && newVal)
	{
		self thread hive_gun::gib_corpse( localClientNum, newVal );
	}
}


function annihilate_effect_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( !util::is_mature() || util::is_gib_restricted_build() )
		return;

	if(newVal)
	{
		where = self GetTagOrigin( "J_SpineLower" );
		if (!isdefined(where))
			where = self.origin ;
		where = where + (0,0,-40);
		
		character_index = self GetCharacterBodyType();
		fields = GetCharacterFields( character_index, CurrentSessionMode() );
		if ( fields.fullbodyexplosion != "" )
		{
			Playfx( localClientNum, fields.fullbodyexplosion, where );
		}
	}
}


function pineapplegun_effect_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
       if(newVal)
       {
	       where = self GetTagOrigin( "J_SpineLower" );
	       if (!isdefined(where))
	              where = self.origin;
	
	       if ( IsDefined( level._effect[ "pineapplegun_explosion" ] ) )
	       {
	              Playfx( localClientNum, level._effect["pineapplegun_explosion"], where );
	       }
	       
       }
}

