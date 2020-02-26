//-- This sets up and watches all of the destruction that is done by the ship to the ship based off of the explosions and other fx

setup_merchant_ship_chain_destruction()
{
	//-- Example
	// blah thread damage_when_piece_breaks( notify, forward offset, right offset, up offset, radius, min damage, max damage, tag to offset from);
	
	
	//-- CONNING TOWER
	self thread damage_when_piece_breaks( "con_tower_level1_1", -139.5, -100, -85, 300, 2000, 3000, "contower01" );
	self thread damage_when_piece_breaks( "con_tower_level1_1", -139.5, -100, -85, 300, 2000, 3000, "contower01" );
	
	self thread damage_when_piece_breaks( "con_tower_level2_0", -1, -186, 0, 300, 2000, 3000, "contower02");
		
	self thread damage_when_piece_breaks( "con_tower_level2_1", 6, 0, 15, 300, 2000, 3000, "contower02", true);
	self thread damage_when_piece_breaks( "con_tower_level2_1", 6, 0, 0, 300, 2000, 3000, "contower02", true);
	
	self thread damage_when_piece_breaks( "con_tower_level3_1", 70, 0, 2.5, 300, 2000, 3000, "contower03", true);
	self thread damage_when_piece_breaks( "con_tower_level3_1", 70, 0, 2.5, 1000, 20, 30, "contower03", true);
	self thread damage_when_piece_breaks( "con_tower_level3_1", 50, 0, 0, 400, 500, 600, "contower03", true);
	self thread damage_when_piece_breaks( "con_tower_level3_1", 49, 280, -26.5, 150, 500, 600, "contower03", true);
	self thread damage_when_piece_breaks( "con_tower_level3_1", 49, 280, -159.5, 150, 500, 600, "contower03", true);
	self thread damage_when_piece_breaks( "con_tower_level3_1", 49, -280, -26.5, 150, 500, 600, "contower03", true);
	self thread damage_when_piece_breaks( "con_tower_level3_1", 49, -280, -159.5, 150, 500, 600, "contower03", true);
	self thread damage_when_piece_breaks( "con_tower_level3_1", 49, 118, 80, 300, 500, 600, "contower03", true);
	self thread damage_when_piece_breaks( "con_tower_level3_1", 49, -118, 80, 300, 500, 600, "contower03", true);
	
	self thread damage_when_piece_breaks( "con_tower_level4_0", -12.5, 0, -36.5, 80, 100, 200, "contower04");
	
	self thread damage_when_piece_breaks( "con_tower_level4_1", 0, 0, -30, 300, 2000, 3000, "contower04");
	self thread damage_when_piece_breaks( "con_tower_level4_1", -111, 0, 0, 100, 100, 200, "contower04");
	
	
	//-- FRONT DECK
	self thread damage_when_piece_breaks( "f_deck01_1", 24, -50, 75.5, 150, 100, 200, "f_deck01", true);
	
	self thread damage_when_piece_breaks( "f_deck02_1", -23, -32, 19, 115, 100, 200, "f_deck02", true);
	
	self thread damage_when_piece_breaks( "f_deck03_1", 0, -29, -237, 115, 500, 600, "f_deck03", true);
	self thread damage_when_piece_breaks( "f_deck03_1", 0, 3, -23, 115, 500, 600, "f_deck03", true);
	
	self thread damage_when_piece_breaks( "f_deck04_1", 19, 55, 122, 115, 500, 600, "f_deck04", true);
	self thread damage_when_piece_breaks( "f_deck04_1", 19, 64, -12, 115, 500, 600, "f_deck04", true);
	self thread damage_when_piece_breaks( "f_deck04_1", 10, -130, -237.5, 40, 500, 600, "f_deck04", true);
	
	self thread damage_when_piece_breaks( "f_deck05_1", -24, 37, 30, 115, 500, 600, "f_deck05", true);
	
	self thread damage_when_piece_breaks( "f_deck06_1", -40, -73, 32, 350, 1000, 2000, "f_deck06", true);
	
	self thread damage_when_piece_breaks( "f_deck07_1", -7, 26, 67, 115, 500, 600, "f_deck07", true);
	
	self thread damage_when_piece_breaks( "f_deck08_1", 0, -17, 47, 115, 500, 600, "f_deck08", true);
	
	self thread damage_when_piece_breaks( "f_deck09_1", 8, -34, -127, 350, 1000, 2000, "f_deck09", true);
	
	
	//-- REAR DECK
	self thread damage_when_piece_breaks( "r_deck01_1", 19, -68, -19, 115, 500, 600, "r_deck01", true);
	self thread damage_when_piece_breaks( "r_deck01_1", 19, -68, 121, 115, 500, 600, "r_deck01", true);
	
	self thread damage_when_piece_breaks( "r_deck02_1", -13, 63, 165, 115, 500, 600, "r_deck02", true);
	self thread damage_when_piece_breaks( "r_deck02_1", -13, 44, -63, 115, 500, 600, "r_deck02", true);
	
	self thread damage_when_piece_breaks( "r_deck03_1", -40, 0, 0, 450, 1000, 2000, "r_deck03", true);
	
	self thread damage_when_piece_breaks( "r_deck04_1", 0, -56, -55, 115, 500, 600, "r_deck04", true);
	
	self thread damage_when_piece_breaks( "r_deck05_1", 6, 67, -50, 115, 500, 600, "r_deck05", true);
	self thread damage_when_piece_breaks( "r_deck05_1", 2, 67, -150, 115, 500, 600, "r_deck05", true);
	
	self thread damage_when_piece_breaks( "r_deck06_1", -50, 51, 17, 350, 1000, 2000, "r_deck06", true);
	
	self thread damage_when_piece_breaks( "r_deck07_1", 8, -25, 94, 115, 500, 600, "r_deck07", true);
	self thread damage_when_piece_breaks( "r_deck07_1", 8, 10, 30, 115, 500, 600, "r_deck07", true);
	self thread damage_when_piece_breaks( "r_deck07_1", 13, -1, -40, 115, 500, 600, "r_deck07", true);
	
	self thread damage_when_piece_breaks( "r_deck08_1", 22, -43, 27, 115, 500, 600, "r_deck08", true);
	self thread damage_when_piece_breaks( "r_deck08_1", 22, 5, -47, 115, 500, 600, "r_deck08", true);
	self thread damage_when_piece_breaks( "r_deck08_1", 22, 38, -121, 115, 500, 600, "r_deck08", true);
	
	self thread damage_when_piece_breaks( "r_deck09_1", 13, 18, 30, 115, 500, 600, "r_deck09", true);
	self thread damage_when_piece_breaks( "r_deck09_1", 8, -34, -127, 115, 500, 600, "r_deck09", true);
	
}

damage_when_piece_breaks( break_notify, forward, right, up, rad, min_damage, max_damage, tag_offset, flame )
{
	level endon("stop merchant ship damage");
	
	for( ; ; )
	{
		self waittill( "broken", recieved_notify );
		
		if( recieved_notify == break_notify )
		{
			if(rad >= 115)
			{
				level notify("large explosion comment");
			}
			
			if(!isDefined(tag_offset))
			{
				dmg_origin = self.origin;
			}
			else
			{
				dmg_origin = self GetTagOrigin(tag_offset);
			}
			
			//offset the dmg_origin according to the FX
			dmg_origin = dmg_origin + (AnglesToForward(self.angles) * forward);
			dmg_origin = dmg_origin + (AnglesToRight(self.angles) * right);
			dmg_origin = dmg_origin + (AnglesToUp(self.angles) * up);
			
			if(IsDefined(flame))
			{
				setup_drones_for_burn(dmg_origin, rad);
			}
			//do amazing things
			wait_float = RandomFloatRange(0.1, 0.3);
			wait(wait_float);
			RadiusDamage(dmg_origin, rad, max_damage, min_damage);
			return;
		}
		
		//-- added notifies to help manage the triple 25s
		//if( recieved_notify == "r_deck03_0" || recieved_notify == "r_deck03_1")
		if(recieved_notify == "r_deck03_1")
		{
			//notify deck gun
			self.deck_gun_destroyed = true;
			self notify("deck_gun_destroyed");
		}
		
		//if( recieved_notify == "con_tower_level4_0" || recieved_notify == "con_tower_level4_1" )
		if(recieved_notify == "con_tower_level4_1")
		{
			//-- notify tower gun
			self.tower_gun_destroyed = true;
			self notify("tower_gun_destroyed");
		}
		
		if(recieved_notify == "bow_light_pitch" || recieved_notify == "aft_light_pitch")
		{
			level notify("suggest good kill");
		}
		
		wait(0.05); //Wait A Frame
	}
}

setup_drones_for_burn(dmg_origin, dmg_radius)
{
	drones = [];
	drones = GetEntArray("drone", "targetname");
	random_num = 0;
	
	for( i=0; i < drones.size; i++)
	{
		if(DistanceSquared(dmg_origin, drones[i].origin) < (dmg_radius * dmg_radius) * 0.75)
		{
			random_num = RandomIntRange(0,10);
			if(random_num < 4)
			{
				drones[i].combust = true;
			}
		}
	}
}