#include maps\_utility;
#include maps\westminster_tunnels;
#include maps\westminster_code;
main()
{
    describe_start( "train_start",                  ::start_train_start,      "Start Train Chase",                ::train_chase_intro  );
    describe_start( "train_start_ride",             ::start_train_start,      "Start Train Ride",                 ::train_chase  );
    
    //generated starts 
    describe_start( "train_start_first_bend",       ::start_train_mid,        "Start Ride - First bend",          ::train_chase  );
    describe_start( "train_start_civilian_fly_by",  ::start_train_mid,        "Train Ride - Fly by Civilians",    ::train_chase  );
    describe_start( "train_start_outside",          ::start_train_mid,        "Start Ride - Outside",         ::train_chase  );
    describe_start( "train_start_ghost_station",    ::start_train_mid,  "Start Ride - Ghost Stiation",         ::train_chase  );
    
//    describe_start( "train_crash_end",    ::start_train_end,  "Start Ride - Post Crash",         ::train_crash_exit  );

    /*  
	fake out run from launcher 

    add_start( "no_game_tunnel_start" );
    add_start( "no_game_ghost_station" );
    */
}


