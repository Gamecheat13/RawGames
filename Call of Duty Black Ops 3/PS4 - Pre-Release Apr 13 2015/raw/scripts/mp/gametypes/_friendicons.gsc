#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "weapon/fx_hero_annhilatr_death_blood" );
#precache( "client_fx", "weapon/fx_hero_pineapple_death_blood" );

#namespace globallogic;


function autoexec __init__sytem__() {     system::register("globallogic",&__init__,undefined,undefined);    }


function __init__()
{
	//handles actor and  player corpse case
	RegisterClientField("actor", "annihilate_effect", 1, 1, "int", &annihilate_effect_cb, false);	
	RegisterClientField("actor", "pineapplegun_effect", 1, 1, "int", &pineapplegun_effect_cb, false);	

	level._effect[ "annihilate_explosion" ] = "weapon/fx_hero_annhilatr_death_blood";
	level._effect[ "pineapplegun_explosion" ] = "weapon/fx_hero_pineapple_death_blood";
}


function annihilate_effect_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		where = self GetTagOrigin( "J_SpineLower" );
		if (!isdefined(where))
			where = self.origin ;
		where = where + (0,0,-40);
		
		character_index = self GetCharacterBodyType();
		fields = GetHeroFields( character_index );
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

