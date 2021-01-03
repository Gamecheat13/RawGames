#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

 

#namespace chemicalgel;


function init_shared()
{	
	callback::on_connect( &monitorGel );
		
	level.chemicalgel_weapon = GetWeapon("hero_chemicalgelgun");
	level.chemicalgel_secondary_explosion_weapon = GetWeapon("chemicalgel_secondary_explosion");

	if ( !IsDefined( level.vsmgr_prio_overlay_gel_splat ) )
	{
		level.vsmgr_prio_overlay_gel_splat = 21;
	}					
	visionset_mgr::register_info( "overlay", "chemicalgelgun_splat", 1, level.vsmgr_prio_overlay_gel_splat, 7, true, &visionset_mgr::duration_lerp_thread_per_player, false );

	callback::add_weapon_damage( level.chemicalgel_weapon, &on_damage_chemicalgelgun );

}

function monitorGel_Internal( attacker )
{
		attacker endon("disconnect");
		self endon("disconnect");
		self endon("death");

		wait( 0.5 );
		
		damage = 50;
		radius = 40;
		radius_damage_max = 50;
		radius_damage_min = 1; 
		
		self DoDamage( damage, self.origin, attacker, attacker, "", "MOD_GRENADE_SPLASH", 0, level.chemicalgel_secondary_explosion_weapon );
		self RadiusDamage( self.origin, radius, radius_damage_max, radius_damage_min, attacker, "MOD_EXPLOSIVE", level.chemicalgel_secondary_explosion_weapon );
	
		//PlayFXOnTag( "_t6/explosions/fx_grenadeexp_default", self, "tag_fx" );
		PlayFX( level._supply_drop_explosion_fx, self.origin );
		PlaySoundAtPosition( "wpn_grenade_explode", self.origin );
}

function monitorGel()
{
	self endon("disconnect");
	self endon ("killGelMonitor");
	
	self.flashEndTime = 0;
	while(1)
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon, iDFlags );
		
		if ( !isalive( self ) )
		{
			continue;
		}
	
		if ( weapon != level.chemicalgel_weapon )
		{
			continue;
		}
		
		if ( type == "MOD_MELEE" || type == "MOD_MELEE_WEAPON_BUTT" )
		{
			continue;
		}
			
		self thread monitorGel_Internal( attacker );
	}
}

function start_damage_effects()
{
/#
	If ( IsGodMode( self ) )
	{
		return;
	}
#/

	visionset_mgr::activate( "overlay", "chemicalgelgun_splat", self, 0.5, 0.5 );

	//self clientfield::set( "damaged_by_chemicalgelgun", 1 );

	self thread end_damage_effects();
}

function end_damage_effects()
{
	self endon( "disconnect" );

	self waittill( "death" );

	visionset_mgr::deactivate( "overlay", "chemicalgelgun_splat", self );

	//self clientfield::set( "damaged_by_chemicalgelgun", 0 );
	}

function on_damage_chemicalgelgun( eAttacker, eInflictor, weapon, meansOfDeath, damage )
{
	if ( "MOD_GRENADE" != meansOfDeath && "MOD_GRENADE_SPLASH" != meansOfDeath )
	{
		return;
	}

	self thread start_damage_effects( );
}



