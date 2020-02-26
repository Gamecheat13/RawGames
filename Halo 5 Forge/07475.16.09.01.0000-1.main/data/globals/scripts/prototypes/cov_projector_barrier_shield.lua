-- object cov_projector_barrier_shield

--## SERVER

global b_cov_projector_barrier:boolean = nil;
global var_cov_projector_barrier:number = 0;

function cov_projector_barrier_shield:init()
	print ("cov projector barrier shield");
	if(b_cov_projector_barrier)then																-- if you set this bool in your script, you can turn the shield on manually
		SleepUntil([| var_cov_projector_barrier >= 1], 2);										-- when you set this var
	end

	SleepUntil([| object_get_health(self) > 0], 2);

		object_set_function_variable (self, "shield_formed", 0.5, 1.0 );
		object_set_function_variable (self, "emit", 1.0, 1.0 );
		print ("shield formed");
	SleepUntil([| object_get_health(self) <= 0 or object_get_health(object_get_parent(self)) <= 0.2], 2);
		print (object_get_health(self));
		if object_get_health(object_get_parent(self)) <= 0.2 and object_get_health(self) > 0 then
			local time:number = 2.0;
			object_set_function_variable (self, "shield_formed", 1, time );
			object_set_function_variable (self, "emit", 0, 1.0 );
			print ("shield parent destroyed");
			sleep_s (time);
		elseif object_get_health(self) <= 0 then
			local time:number = 1.5;
			object_set_function_variable (self, "shield_destroyed", 1, time );
			print ("shield destroyed");
			sleep_s (time);
			
		end
		object_destroy (self);
		
		
end