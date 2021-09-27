#include maps\_vehicle;
#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "subway", model, type, classname );
	build_destructible( "vehicle_subway_cart_destructible", "vehicle_subway_cart" );
	build_life( 9999 );
	build_localinit( ::init_local );
    
    //front left
    level.scr_anim[ "generic" ][ "london_train_shooter_guy1_opendoor_door_TAG_DOOR_1_LE" ]       = %london_train_shooter_guy1_opendoor_door_front_left;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy2_opendoor_door_TAG_DOOR_1_LE" ]       = %london_train_shooter_guy2_opendoor_door_front_left;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy3_opendoor_door_TAG_DOOR_1_LE" ]       = %london_train_shooter_guy3_opendoor_door_front_left;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy4_opendoor_door_TAG_DOOR_1_LE" ]       = %london_train_shooter_guy4_opendoor_door_front_left;
   	level.scr_anim[ "generic" ][ "london_train_shooter_guy_closedoor_door_TAG_DOOR_1_LE" ]       = %subway_cart_doors_close_front_left;
	
	//front right
    level.scr_anim[ "generic" ][ "london_train_shooter_guy1_opendoor_door_TAG_DOOR_1_RI" ]       = %london_train_shooter_guy1_opendoor_door_front_right;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy2_opendoor_door_TAG_DOOR_1_RI" ]       = %london_train_shooter_guy2_opendoor_door_front_right;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy3_opendoor_door_TAG_DOOR_1_RI" ]       = %london_train_shooter_guy3_opendoor_door_front_right;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy4_opendoor_door_TAG_DOOR_1_RI" ]       = %london_train_shooter_guy4_opendoor_door_front_right;
   	level.scr_anim[ "generic" ][ "london_train_shooter_guy_closedoor_door_TAG_DOOR_1_RI" ]       = %subway_cart_doors_close_front_right;

	//back left
    level.scr_anim[ "generic" ][ "london_train_shooter_guy1_opendoor_door_TAG_DOOR_2_LE" ]       = %london_train_shooter_guy1_opendoor_door_back_left;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy2_opendoor_door_TAG_DOOR_2_LE" ]       = %london_train_shooter_guy2_opendoor_door_back_left;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy3_opendoor_door_TAG_DOOR_2_LE" ]       = %london_train_shooter_guy3_opendoor_door_back_left;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy4_opendoor_door_TAG_DOOR_2_LE" ]       = %london_train_shooter_guy4_opendoor_door_back_left;
   	level.scr_anim[ "generic" ][ "london_train_shooter_guy_closedoor_door_TAG_DOOR_2_LE" ]       = %subway_cart_doors_close_back_left;
	
	//back right  
    level.scr_anim[ "generic" ][ "london_train_shooter_guy1_opendoor_door_TAG_DOOR_2_RI" ]       = %london_train_shooter_guy1_opendoor_door_back_right;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy2_opendoor_door_TAG_DOOR_2_RI" ]       = %london_train_shooter_guy2_opendoor_door_back_right;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy3_opendoor_door_TAG_DOOR_2_RI" ]       = %london_train_shooter_guy3_opendoor_door_back_right;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy4_opendoor_door_TAG_DOOR_2_RI" ]       = %london_train_shooter_guy4_opendoor_door_back_right;
   	level.scr_anim[ "generic" ][ "london_train_shooter_guy_closedoor_door_TAG_DOOR_2_RI" ]       = %subway_cart_doors_close_back_right;
    
    
    
    level.scr_anim[ "generic" ][ "london_train_shooter_doors_tree" ]       = %london_train_doors; //vehicles.atr animtree branch
    ai_anims();
}


#using_animtree( "generic_human" );
ai_anims()
{
    level.scr_anim[ "generic" ][ "london_train_shooter_guy1_opendoor" ]           = %london_train_shooter_guy1_opendoor;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy1_idle" ]               = %london_train_shooter_guy1_aim5;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy1_idle_right" ]         = %london_train_shooter_guy1_aim6;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy1_idle_left" ]          = %london_train_shooter_guy1_aim4;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy1_death" ]              = %london_train_shooter_guy1_death;

    level.scr_anim[ "generic" ][ "london_train_shooter_guy2_opendoor" ]           = %london_train_shooter_guy2_opendoor;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy2_idle" ]               = %london_train_shooter_guy2_aim5;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy2_idle_right" ]         = %london_train_shooter_guy2_aim6;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy2_idle_left" ]          = %london_train_shooter_guy2_aim4;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy2_death" ]              = %london_train_shooter_guy2_death;

    level.scr_anim[ "generic" ][ "london_train_shooter_guy3_opendoor" ]           = %london_train_shooter_guy3_opendoor;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy3_idle" ]               = %london_train_shooter_guy3_aim5;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy3_idle_right" ]         = %london_train_shooter_guy3_aim6;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy3_idle_left" ]          = %london_train_shooter_guy3_aim4;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy3_death" ]              = %london_train_shooter_guy3_death;

    level.scr_anim[ "generic" ][ "london_train_shooter_guy4_opendoor" ]           = %london_train_shooter_guy4_opendoor;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy4_idle" ]               = %london_train_shooter_guy4_aim5;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy4_idle_right" ]         = %london_train_shooter_guy4_aim6;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy4_idle_left" ]          = %london_train_shooter_guy4_aim4;
    level.scr_anim[ "generic" ][ "london_train_shooter_guy4_death" ]              = %london_train_shooter_guy4_death;
}

init_local()
{
}


/*QUAKED script_vehicle_subway_cart_destructible (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_subway::main( "vehicle_subway_cart_destructible", undefined, "script_vehicle_subway_cart_destructible" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,destructible_subway_cart
sound,vehicle_subway_cart,vehicle_standard,all_sp
sound,vehicle_car_exp,vehicle_standard,all_sp

defaultmdl="vehicle_subway_cart_destructible"
default:"vehicletype" "subway"
*/

/*QUAKED script_vehicle_subway_engine_destructible (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_subway::main( "vehicle_subway_cart_destructible", "subway_engine", "script_vehicle_subway_engine_destructible" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,destructible_subway_cart
sound,vehicle_subway_cart,vehicle_standard,all_sp
sound,vehicle_car_exp,vehicle_standard,all_sp

defaultmdl="vehicle_subway_cart_destructible"
default:"vehicletype" "subway_engine"
*/


door_guy_random()
{
    if ( !IsDefined( level.door_guy_random ) || level.door_guy_random.size == 0 )
        level.door_guy_random = [ 1,2,3,4 ];
    number = random( level.door_guy_random );
    level.door_guy_random = array_remove( level.door_guy_random, number );
    return number;
}


do_door_guy( tag, guy )
{
    guy_index = door_guy_random();
    door_info = spawnstruct();
    door_info.subway_cart = self;
    door_info.tag = tag;
    door_info.guy_index = guy_index;
    guy.door_info = door_info;
    
    subway_cart = self;
    
    guy.health = 1;
    
    subway_dooranim = getanim_generic( "london_train_shooter_guy" + guy_index + "_opendoor_door_" + tag );
    subway_dooranim_close = getanim_generic( "london_train_shooter_guy_closedoor_door_" + tag );
    
    thread do_door_guy_death( guy, subway_dooranim, subway_dooranim_close );
    
    subway_cart clearanim( subway_dooranim_close, 0.1 );
    subway_cart.mirror_destructible_model clearanim( subway_dooranim_close, 0.1 );
 
    subway_cart SetAnim( subway_dooranim, 1 );
    subway_cart.mirror_destructible_model SetAnim( subway_dooranim, 1 );

    guy LinkToBlendToTagImmediate( subway_cart, tag, false );
	guy AnimCustom( ::do_door_guy_think );
}

do_door_guy_death( guy, subway_dooranim ,subway_dooranim_close )
{
	self endon ( "death" );
	tag = guy.door_info.tag;
	guy waittill ( "death" );
//	iprintlnbold( "clearanim door " );
	
	Assert( IsDefined( self.mirror_destructible_model ) );
	
	
	wait 1;
	cleartime = 0.2;
	self ClearAnim( subway_dooranim, cleartime );
	self.mirror_destructible_model ClearAnim( subway_dooranim, cleartime );
	
	self SetAnim( subway_dooranim_close);
	self.mirror_destructible_model SetAnim( subway_dooranim_close );
}



do_door_guy_think()
{
	self notify( "stop_door_guy_think" );
	self endon( "stop_door_guy_think" );

    animscripts\utility::initialize( "subway cart guy" );
    
    guy = self;
    door_info = guy.door_info;
    guy_index = door_info.guy_index;
    tag = door_info.tag;
    subway_cart = door_info.subway_cart;
    guy.animating_node = subway_cart;
    intro_anim = getanim_generic( "london_train_shooter_guy" + guy_index + "_opendoor" );
    anim_length = GetAnimLength( intro_anim );
    guy SetAnim( intro_anim, 1, 0, 1 );
    wait anim_length;

    if ( !IsAlive( guy ) )
        return;
    
    guy clearanim( intro_anim, 0.2 );

    idle_anim = getanim_generic( "london_train_shooter_guy" + guy_index + "_idle" );
    door_info.idle_anim = idle_anim;
    guy.riding_train = subway_cart;
    
    guy thread door_guy_shoots();
    guy clearanim( %root, 0.5 );
    guy SetAnim( idle_anim, 1, 0.2, 1 );
	subway_cart waittill ( "forever" );
}

LinkToBlendToTagImmediate(ent, tag, only_yaw, collision_physics )
{
    if ( !IsDefined( only_yaw ) )
        only_yaw = true;
    if( !IsDefined( collision_physics ) )
        collision_physics = false;
    self teleport_to_ent_tag( ent, tag );
    self LinkToBlendToTag( ent, tag, only_yaw, collision_physics );
}

door_guy_shoots()
{
	self endon( "stop_door_guy_think" );

    self.deathanim = getanim_generic( "london_train_shooter_guy" + self.door_info.guy_index + "_death" );
    self.animating_node endon ( "stop_door_loop" + self.door_info.tag );
    
    aim_right = getanim_generic( "london_train_shooter_guy" + self.door_info.guy_index + "_idle_right" );
    aim_left =  getanim_generic( "london_train_shooter_guy" + self.door_info.guy_index + "_idle_left" );
    aim_straight = self.door_info.idle_anim;
    direction = 0;
    self endon ( "death" );
    while( true )
    {
        barrel_angles = self GetTagAngles( "tag_flash" );
        barrel_origin = self GetTagOrigin( "tag_flash" );
        right_angle = vectortoangles( AnglesToRight( barrel_angles ) );
    
        dot = 0;
        if ( IsDefined( self.enemy ) )
        	dot = get_dot( barrel_origin, right_angle, self.enemy.origin );
    	
    	if( abs( dot ) < 0.1 )
    	    direction = direction;
    	if( dot > 0 )
            direction += -0.25;
        else 
            direction += 0.25;
            
        direction = clamp( direction, -1, 1 );
        strength = abs( direction );
        
        if( direction == 0 )
        {
            self ClearAnim( aim_left, 0.1 );
            self ClearAnim( aim_right, 0.1 );
            self SetAnim( aim_straight, 1 );
        }
        else if( direction < 0 )
        {
            self ClearAnim( aim_left, 0.1 );
            self SetAnim( aim_straight, 1 - strength );
            self SetAnim( aim_right, strength );
        }
        else
        {
            self ClearAnim( aim_right, 0.1 );
            self SetAnim( aim_straight, 1 - strength );
            self SetAnim( aim_left, strength );
        }
        if ( ! IsDefined( self.enemy ) )
        {
            wait 0.05;
            continue;
        }
        if( abs( dot ) < 0.45 )
            self shoot();
        wait 0.05;
    }
}
