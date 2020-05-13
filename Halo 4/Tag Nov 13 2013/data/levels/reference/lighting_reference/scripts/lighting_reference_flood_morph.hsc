(global short morph_wait_time 450)

(script static void begin_morph
    
    (sleep_until
        (begin
            (object_destroy marine)
            (object_destroy elite)
            (object_destroy brute)
            (object_destroy worker)
            
            (object_create marine)
            (object_create elite)
            (object_create brute)
            (object_create worker)
            
            (ai_place gr_pureforms)
                
            (sleep 30)
            
            (biped_morph marine)
            (biped_morph elite)
            (biped_morph brute)
            (biped_morph worker)
            
            (ai_morph sq_tank_to_ranged 0)
            (ai_morph sq_stalker_to_ranged 0)
            (ai_morph sq_ranged_to_tank 1)
            (ai_morph sq_stalker_to_tank 1)
            (ai_morph sq_ranged_to_stalker 2)
            (ai_morph sq_tank_to_stalker 2)            
            
            (sleep morph_wait_time)
            
            (ai_erase_all)
                        
            FALSE
        )
    )
    
    

)

(script static void begin_morph_marine
    
    (sleep_until
        (begin
            (object_destroy marine)
            
            (object_create marine)
            
                
            (sleep 30)
            
            (biped_morph marine)          
            
            (sleep morph_wait_time)
                                    
            FALSE
        )
    )

)

(script static void begin_morph_brute
    
    (sleep_until
        (begin
            (object_destroy brute)
            
            (object_create brute)
            
                
            (sleep 30)
            
            (biped_morph brute)          
            
            (sleep morph_wait_time)
                                    
            FALSE
        )
    )

)

(script static void begin_morph_elite
    
    (sleep_until
        (begin
            (object_destroy elite)
            
            (object_create elite)
            
                
            (sleep 30)
            
            (biped_morph elite)          
            
            (sleep morph_wait_time)
                                    
            FALSE
        )
    )

)

(script static void begin_morph_tank_to_ranged
    
    (sleep_until
        (begin
            
            (ai_place sq_tank_to_ranged)
                
            (sleep 30)
                        
            (ai_morph sq_tank_to_ranged 0)
            (ai_morph sq_stalker_to_ranged 0)
            (ai_morph sq_ranged_to_tank 1)
            (ai_morph sq_stalker_to_tank 1)
            (ai_morph sq_ranged_to_stalker 2)
            (ai_morph sq_tank_to_stalker 2)            
            
            (sleep morph_wait_time)
            
            (ai_erase_all)
                        
            FALSE
        )
    )
    
)

(script static void begin_morph_stalker_to_ranged
    
    (sleep_until
        (begin
            
            (ai_place sq_stalker_to_ranged)
                
            (sleep 30)
                        
            (ai_morph sq_stalker_to_ranged 0)        
            
            (sleep morph_wait_time)
            
            (ai_erase_all)
                        
            FALSE
        )
    )
    
)

(script static void begin_morph_ranged_to_tank
    
    (sleep_until
        (begin
            
            (ai_place sq_ranged_to_tank)
                
            (sleep 30)
                        
            (ai_morph sq_ranged_to_tank 1)         
            
            (sleep morph_wait_time)
            
            (ai_erase_all)
                        
            FALSE
        )
    )
    
)

(script static void begin_morph_stalker_to_tank
    
    (sleep_until
        (begin
            
            (ai_place sq_stalker_to_tank)
                
            (sleep 30)
                        
            (ai_morph sq_stalker_to_tank 1)          
            
            (sleep morph_wait_time)
            
            (ai_erase_all)
                        
            FALSE
        )
    )
    
)

(script static void begin_morph_ranged_to_stalker
    
    (sleep_until
        (begin
            
            (ai_place sq_ranged_to_stalker)
                
            (sleep 30)
                        
            (ai_morph sq_ranged_to_stalker 2)            
            
            (sleep morph_wait_time)
            
            (ai_erase_all)
                        
            FALSE
        )
    )
    
)

(script static void begin_morph_tank_to_stalker
    
    (sleep_until
        (begin
            
            (ai_place sq_tank_to_stalker)
                
            (sleep 30)
                        
            (ai_morph sq_tank_to_stalker 2)            
            
            (sleep morph_wait_time)
            
            (ai_erase_all)
                        
            FALSE
        )
    )
    
)

(script startup erase_bipeds
    (object_destroy marine)
    (object_destroy elite)
    (object_destroy brute)
    (object_destroy dead_marine_front)
    (object_destroy dead_elite_front)
    (object_destroy dead_brute_front)
    (object_destroy dead_marine_back)
    (object_destroy dead_elite_back)
    (object_destroy dead_brute_back)
)

(script static void (infect_biped (object_name abiped))

    (sleep_until
        (begin
            (object_destroy abiped)
            (object_create abiped)
            (sleep 10)
            (ai_place sq_infection)
            (sleep morph_wait_time)
            
            (ai_erase_all)
            
            FALSE
        )
    )

)

(script static void infect_all

    (sleep_until
        (begin
            (object_destroy dead_marine_front)
            (object_destroy dead_elite_front)
            (object_destroy dead_brute_front)
            (object_destroy dead_marine_back)
            (object_destroy dead_elite_back)
            (object_destroy dead_brute_back)
            (object_create dead_marine_front)
            (object_create dead_elite_front)
            (object_create dead_brute_front)
            (object_create dead_marine_back)
            (object_create dead_elite_back)
            (object_create dead_brute_back)
            
            (sleep 10)
            (ai_place sq_infection)
            (sleep (* morph_wait_time 2))
            
            (ai_erase_all)
            
            FALSE
        )
    )

)

(script static void tank_spew

    (object_destroy dead_marine_front)
    (object_destroy dead_elite_front)
    (object_destroy dead_brute_front)
    (object_destroy dead_marine_back)
    (object_destroy dead_elite_back)
    (object_destroy dead_brute_back)
    (object_destroy marine)
    (object_destroy elite)
    (object_destroy brute)
    
    (sleep 10)
    (ai_place sq_spew)
    
    
    (sleep_until
        (begin
            
            (unit_spew_action sq_spew)
            (sleep 30)
                        
            FALSE
        )
    )

)