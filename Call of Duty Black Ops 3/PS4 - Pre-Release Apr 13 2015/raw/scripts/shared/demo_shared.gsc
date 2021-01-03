#using scripts\codescripts\struct;

#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "fx", "destruct/fx_dest_k_rail" );
#precache( "fx", "destruct/fx_dest_k_rail_crumble01" );
#precache( "fx", "destruct/fx_dest_k_rail_crumble02" );
#precache( "fx", "destruct/fx_dest_k_rail_crumble03" );

// ============================================================================
//										 Utility 
// ============================================================================

function autoexec __init__sytem__() {     system::register("destructible_cover",&__init__,undefined,undefined);    }

function __init__()
{
	level thread precache_destructible_fx();

	cover_array = GetEntArray("dest_cover","targetname");
	level thread array::spread_all(cover_array, &destructible_cover_think); 
	
	// testing purposes only to proof out cover options before making a model.
	cover_array_geo = GetEntArray("dest_cover_geo","targetname");
	level thread array::spread_all( cover_array_geo, &destructible_cover_geo_think );
}

// ============================================================================
//krail_upper_01_jnt
//krail_mid_01_jnt
//krail_btm_01_jnt

function destructible_cover_think()
{
		//---  Default: Can be overwritted below -----------------
		self.break_fx = level._effect[ "k_rail_destruct" ];
		self.chunk_fx = level._effect[ "k_rail_destruct" ];
		self.break_sound = "dst_cover_concrete";
		self.chunk_sound = "dst_cover_concrete";	
	
		//disconnect paths around krails.
		self DisconnectPaths();
	
	if(isDefined(self.script_noteworthy) && self.script_noteworthy == "dest_krail")
	{

		//"krail_base_jnt" main body

		self.PartTags_upper = array("krail_upper_01_jnt", "krail_upper_02_jnt", "krail_upper_03_jnt", "krail_upper_04_jnt", "krail_upper_05_jnt", "krail_upper_06_jnt");
		self.PartTags_mid = array("krail_mid_01_jnt", "krail_mid_02_jnt", "krail_mid_03_jnt", "krail_mid_04_jnt", "krail_mid_05_jnt", "krail_mid_06_jnt");
		self.PartTags_btm = array("krail_btm_01_jnt", "krail_btm_02_jnt", "krail_btm_03_jnt", "krail_btm_04_jnt", "krail_btm_05_jnt", "krail_btm_06_jnt");
	
		self.PartTags = array("krail_upper_01_jnt", "krail_upper_02_jnt", "krail_upper_03_jnt", "krail_upper_04_jnt", "krail_upper_05_jnt", "krail_upper_06_jnt", 
		"krail_mid_01_jnt", "krail_mid_02_jnt", "krail_mid_03_jnt", "krail_mid_04_jnt", "krail_mid_05_jnt", "krail_mid_06_jnt",
		"krail_btm_01_jnt", "krail_btm_02_jnt", "krail_btm_03_jnt", "krail_btm_04_jnt", "krail_btm_05_jnt", "krail_btm_06_jnt"); 

		self.PartTags_dmg = array("krail_upper_01_jnt", "krail_upper_02_jnt", "krail_upper_03_jnt");

		self.PartTags_chips = [];
			
		self.health_data = [];
		foreach( tag in self.PartTags)
		{
			self.health_data[tag] = 100;
			self.health_full[tag] = 100;
		}
		foreach( tag in self.PartTags_chips)
		{
			self.health_data[tag] = 35;
			self.health_full[tag] = 35;
		}
			
		//--------------------------------------------------
		self.break_fx = level._effect[ "k_rail_destruct" ];
		self.chunk_fx = level._effect[ "k_rail_destruct" ];
		self.break_sound = "dst_cover_concrete";
		self.chunk_sound = "dst_cover_concrete";

		if(!IsDefined(self.angles))
			self.angles = (0, 0, 0);
		
		self.coll_model = spawn("script_model", self.origin);
		self.coll_model.angles = (self.angles);
		self.coll_model setmodel("fxdest_bc_krail_whole");
			
		self thread hide_cracked_parts(self.PartTags_dmg);
		//self thread hide_cracked_parts(self.PartTags);
	
		/*
		| 1 | 2 | 3 | 4 | 5 | 6 | upper
		| 1 | 2 | 3 | 4 | 5 | 6 | mid
		| 1 | 2 | 3 | 4 | 5 | 6 | btm
		*/		
		foreach( tag in self.PartTags)
		{	
			if( IsSubStr(tag, "krail_upper_"))
				self.part_links[tag] = [];
		
			if(tag == "krail_mid_01_jnt")
				self.part_links[tag] =  array("krail_upper_01_jnt");

			if(tag == "krail_mid_02_jnt")
				self.part_links[tag] = array("krail_upper_01_jnt", "krail_upper_02_jnt", "krail_mid_01_jnt");

			if(tag == "krail_mid_03_jnt")
				self.part_links[tag] = array("krail_upper_02_jnt", "krail_upper_03_jnt", "krail_upper_04_jnt");

			if(tag == "krail_mid_04_jnt")
				self.part_links[tag] = array("krail_upper_03_jnt", "krail_upper_04_jnt", "krail_upper_05_jnt");
				
			if(tag == "krail_mid_05_jnt")
				self.part_links[tag] = array("krail_upper_05_jnt", "krail_upper_06_jnt", "krail_mid_06_jnt");				

			if(tag == "krail_mid_06_jnt")
				self.part_links[tag] = array("krail_upper_06_jnt");
				
				
			if(tag == "krail_btm_01_jnt")
				self.part_links[tag] = array("krail_upper_01_jnt", "krail_mid_01_jnt");

			if(tag == "krail_btm_02_jnt")
				self.part_links[tag] = array("krail_upper_02_jnt", "krail_mid_02_jnt");

			if(tag == "krail_btm_03_jnt")
				self.part_links[tag] = array("krail_upper_03_jnt", "krail_mid_03_jnt");

			if(tag == "krail_btm_04_jnt")
				self.part_links[tag] = array("krail_upper_04_jnt", "krail_mid_04_jnt");
				
			if(tag == "krail_btm_05_jnt")
				self.part_links[tag] = array("krail_upper_05_jnt", "krail_mid_05_jnt");				

			if(tag == "krail_btm_06_jnt")
				self.part_links[tag] = array("krail_upper_06_jnt", "krail_mid_06_jnt");
		}

	}
	
	self thread dest_model_think();
		
}		

// ============================================================================
function hide_cracked_parts(tag_array)
{
	for ( i = 0; i < tag_array.size; i++ )
	{
		self HidePart(tag_array[i] + "_cracks"); 
	}
}	

// ============================================================================
//script_int: actual piece 1-18 3 rows of 6
function dest_model_think()
{
	self setcandamage(true);
	destroyed_pieces = [];

	while( 1 )
	{
		self.damaged = undefined;
		
		self waittill( "damage", amount, who, direction_vec, point, type, modelName, tagName, partName );

		self.damaged = true;

		if(!IsDefined(self.health_data[partName]))
				continue;
		
		// Did we hit a chunk piece directly?
		if(isSubStr(partName, ( "_chunk" ))) 
		{
			//chunk hit directly, damage only part.
			dmg = self.health_data[partName] - amount;
			if(dmg <= 0)
			{
				self thread destroy_chunks( partName );
			}
			part_hlth = self.health_full[partName];
			break;
		}
		else //hit a larger part.
		{	
			foreach( str in self.PartTags_chips)
			{
				if(isSubStr(str, (partName + "_chunk") && self.health_data[str] > 0))
				{
					self.health_data[str] = self.health_data[str] - amount;
					if(self.health_data[str] <= 0)
					{
						self thread destroy_chunks( str );
					}
					continue;
				}	
			}
			
			self.health_data[partName] = self.health_data[partName] - amount;
			part_hlth = self.health_data[partName];
				
		}

	
		if (part_hlth > 0) 
		{
			if(part_hlth < (self.health_full[partName] * 0.5) && part_hlth > 0 )
			{
				foreach( str in self.PartTags_dmg)
				{
					if(str == partName) //cracked overlay exists
					{
						self ShowPart( str + "_cracks" );
						break;
					}	
				}	
				
			}	
			continue;
		}
		
		// Check for linked parts to destroy first.
		if(IsDefined(self.part_links[partName]) && self.part_links[partName].size > 0 )
		{
			str = self.part_links[partName];
			for(i = 0; i < str.size; i ++)
			{
				if(self.health_data[str[i]] <= 0)
				{
					array::exclude(self.part_links[partName], str[i] );
				}
				else
				{	
					hlth_dmg = self.health_full[str[i]] * (randomfloatrange(0.1, 0.4));
					//self.health_data[str[i]] = self.health_data[str[i]] - hlth_dmg;
					
					self thread pass_on_damage(hlth_dmg, direction_vec, who, str[i], type);
				}
			}
			self.health_data[partName] = self.health_full[partName];
		}
		else
		{
			self thread destroy_piece(partName);
		}
	}		
}	

function pass_on_damage(damage, direction_vec, who, tag, type)
{
	while(IsDefined(self.damaged))
	{
		wait(0.1);
	}	
	
		pos = self GetTagOrigin( tag );
		self util::damage_notify_wrapper( damage, who, direction_vec, pos, type, "", "", tag );
}
// ============================================================================
function destroy_chunks( chunk )
{
		PlayFxOnTag(self.chunk_fx, self, chunk);
			
		self playsound( self.chunk_sound );
		
		self HidePart( chunk );
}	

// ============================================================================
function precache_destructible_fx()
{
	level._effect[ "k_rail_destruct" ]						= "destruct/fx_dest_k_rail";
	level._effect[ "k_rail_crumble01" ]						= "destruct/fx_dest_k_rail_crumble01";
	level._effect[ "k_rail_crumble02" ]						= "destruct/fx_dest_k_rail_crumble02";
	level._effect[ "k_rail_crumble03" ]						= "destruct/fx_dest_k_rail_crumble03";
}		

// ============================================================================
function destroy_piece(tag)
{

		PlayFxOnTag(self.break_fx, self, tag);
			
		self playsound(self.break_sound);				

		foreach( str in self.PartTags_dmg)
		{
			if(str == tag) //cracked overlay exists
			{
				self HidePart( str + "_cracks" );
				break;
			}	
		}			
		self HidePart(tag);
		self dest_collision_watcher(tag);
}	

// ============================================================================
function dest_collision_watcher(tag)
{

	if(IsSubStr(tag, "_upper_"))
	{
		array::exclude(self.PartTags_upper, tag );
	}
	else if(IsSubStr(tag, "_mid_"))
	{
		array::exclude(self.PartTags_mid, tag );
	}	
	else if(IsSubStr(tag, "_btm_"))
	{
		array::exclude(self.PartTags_btm, tag );
	}	

	if(self.PartTags_upper.size <= 0 && self.PartTags_mid.size > 0 )
	{
		self.coll_model setmodel("fxdest_bc_krail_med");
	}
	else if(self.PartTags_upper.size <= 0 && self.PartTags_mid.size <= 0 )
	{
		self.coll_model setmodel("fxdest_bc_krail_low");
	}
}	

// ============================================================================
//									Obsolete geo functions: only for testing. 
// ============================================================================
function destructible_cover_geo_think()
{
		//---  Default: Can be overwritted below -----------------
		self.break_fx = level._effect[ "k_rail_destruct" ];
		self.chunk_fx = level._effect[ "k_rail_destruct" ];
		self.break_sound = "dst_cover_concrete";
		self.chunk_sound = "dst_cover_concrete";	
	
	pieces = GetEntArray(self.target, "targetname");

	If(!IsDefined( self.script_int ))
	{
		self.script_int = 6;
	}

	foreach( part in pieces)
	{
		if(IsDefined(part.script_float))
		{
			part.hlth = part.script_float;
		}
		else
		{
			part.hlth = 100;
		}		
		
		
		/*
		| 0 | 1 | 2 | 3 | 4 | 5 |
		| 6 | 7 | 8 | 9 | 10| 11|
		| 12| 13| 14| 15| 16| 17|
		*/			
		if( self.script_int == 6 )
		{
			if(part.script_int == 0 || part.script_int == 1 || part.script_int == 2 || part.script_int == 3 || part.script_int == 4 || part.script_int == 5) 
				part.links = [];	
				
			if(part.script_int == 6)
				part.links = array(pieces thread ents_from_script_int(0));

			if(part.script_int == 7)
				part.links = array(pieces thread ents_from_script_int(0), pieces thread ents_from_script_int(1),pieces thread ents_from_script_int(6));

			if(part.script_int == 8)
				part.links = array(pieces thread ents_from_script_int(1), pieces thread ents_from_script_int(2),pieces thread ents_from_script_int(3));

			if(part.script_int == 9)
				part.links = array(pieces thread ents_from_script_int(2), pieces thread ents_from_script_int(3),pieces thread ents_from_script_int(4));

			if(part.script_int == 10)
				part.links = array(pieces thread ents_from_script_int(3), pieces thread ents_from_script_int(4),pieces thread ents_from_script_int(5));
	
			if(part.script_int == 11)
				part.links = array(pieces thread ents_from_script_int(4), pieces thread ents_from_script_int(5));

			if(part.script_int == 12)
				part.links = array(pieces thread ents_from_script_int(6), pieces thread ents_from_script_int(0));
				
			if(part.script_int == 13)
				part.links = array(pieces thread ents_from_script_int(7), pieces thread ents_from_script_int(1));
				
			if(part.script_int == 14)
				part.links = array(pieces thread ents_from_script_int(8), pieces thread ents_from_script_int(2));

			if(part.script_int == 15)
				part.links = array(pieces thread ents_from_script_int(9), pieces thread ents_from_script_int(3));

			if(part.script_int == 16)
				part.links = array(pieces thread ents_from_script_int(4), pieces thread ents_from_script_int(10));

			if(part.script_int == 17)
				part.links = array(pieces thread ents_from_script_int(5), pieces thread ents_from_script_int(11));
		}
		
	/*
		| 0 | 1 | 2 | 3 |
		| 4 | 5 | 6 | 7 |
		| 8 | 9 | 10| 11|
		| 12| 13| 14| 15|
		| 16| 17| 18| 19|
	*/					
		else if( self.script_int == 4 )
		{
			if(part.script_int == 0 || part.script_int == 1 || part.script_int == 2 || part.script_int == 3) 
				part.links = [];

			if(part.script_int == 4)
				part.links = array(pieces thread ents_from_script_int(0));					

			if(part.script_int == 5)
				part.links = array(pieces thread ents_from_script_int(0), pieces thread ents_from_script_int(1),pieces thread ents_from_script_int(4));

			if(part.script_int == 6)
				part.links = array(pieces thread ents_from_script_int(2), pieces thread ents_from_script_int(3),pieces thread ents_from_script_int(7));

			if(part.script_int == 7)
				part.links = array(pieces thread ents_from_script_int(3));

			if(part.script_int == 8)
				part.links = array(pieces thread ents_from_script_int(0), pieces thread ents_from_script_int(4));

			if(part.script_int == 9)
				part.links = array(pieces thread ents_from_script_int(1), pieces thread ents_from_script_int(5));

			if(part.script_int == 10)
				part.links = array(pieces thread ents_from_script_int(2), pieces thread ents_from_script_int(6));
				
			if(part.script_int == 11)
				part.links = array(pieces thread ents_from_script_int(3), pieces thread ents_from_script_int(7));
				
			if(part.script_int == 12)
				part.links = array( pieces thread ents_from_script_int(0), pieces thread ents_from_script_int(4),pieces thread ents_from_script_int(8));
				
			if(part.script_int == 13)
				part.links = array(pieces thread ents_from_script_int(1), pieces thread ents_from_script_int(5), pieces thread ents_from_script_int(9));

			if(part.script_int == 14)
				part.links = array(pieces thread ents_from_script_int(2), pieces thread ents_from_script_int(6), pieces thread ents_from_script_int(10));
				
			if(part.script_int == 15)
				part.links = array(pieces thread ents_from_script_int(3), pieces thread ents_from_script_int(7), pieces thread ents_from_script_int(11));				

			if(part.script_int == 16)
				part.links = array(pieces thread ents_from_script_int(0), pieces thread ents_from_script_int(4), pieces thread ents_from_script_int(8), pieces thread ents_from_script_int(12));

			if(part.script_int == 17)
				part.links = array(pieces thread ents_from_script_int(1), pieces thread ents_from_script_int(5), pieces thread ents_from_script_int(9), pieces thread ents_from_script_int(13));
				
			if(part.script_int == 18)
				part.links = array(pieces thread ents_from_script_int(2), pieces thread ents_from_script_int(6), pieces thread ents_from_script_int(10), pieces thread ents_from_script_int(14));

			if(part.script_int == 19)
				part.links = array(pieces thread ents_from_script_int(3), pieces thread ents_from_script_int(7), pieces thread ents_from_script_int(11), pieces thread ents_from_script_int(15));				
		}	

		else if( self.script_int == 2 )
		{
				part.links = [];
		}

		part thread pieces_think(self);
	}
}		

// ============================================================================
function ents_from_script_int(int)
{
	foreach( ent in self)
	{
		if(ent.script_int == int)
			return ent;
	}	
}

// ============================================================================
//script_float: health values for piece
function pieces_think(main_part)
{
	self setcandamage(true);
		
	while( 1 )
	{
		self waittill("damage",amount, who);
		
		self.hlth = self.hlth - amount;
		if (self.hlth > 0) 
		{
			if(self.hlth < (self.script_float * 0.5) && IsDefined(self.script_noteworthy))
			{
				foreach( str in main_part.PartTags_dmg)
				{
					if(str == self.script_noteworthy) //cracked overlay exists
					{
						main_part ShowPart( str + "_cracks" );
						continue;
					}	
				}	
				
			}	
			continue;
		}
		
		if(IsDefined(self.links) && self.links.size > 0 )
		{
			// hack to get through inability to remove ents from array.			
			destroyed = 0;
			foreach(ent in self.links)
			{
				if(( isdefined( ent.destroyed ) && ent.destroyed ))
				{
					destroyed++;
				}
				else
				{
					ent DoDamage(self.script_float * (randomfloatrange(0.1, 0.4)) , ent.origin + (0, 0, 10));
				}
			}
			
			if(destroyed >= self.links.size)
			{
				self thread destroy_geo_piece(main_part);
				self.links = [];
				return;
			}
			else
			{
				self.hlth = self.script_float;
			}							
		}
		else
		{	
			self thread destroy_geo_piece(main_part);
			return;
		}
	}		
}	

// ============================================================================
function destroy_geo_piece(main_part)
{
		self Hide();
		
		self.destroyed = true;

		PlayFx(main_part.break_fx, self.origin);
			
		self playsound(main_part.break_sound);				

		Self NotSolid();
}	
