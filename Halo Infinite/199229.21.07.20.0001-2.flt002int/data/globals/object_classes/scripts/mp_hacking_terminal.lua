-- object mp_hacking_terminal 
-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('scripts\ParcelLibrary\parcel_hackable_object.lua');


hstructure mp_hacking_terminal
	meta : table
	instance : luserdata

	initialPower:boolean;					--$$ METADATA {"prettyName": "Initially Powered On", "groupName": "Hacking Terminal", "tooltip": "Check to have Hacking Terminal to be intially Powered"}

	actionStringID:string;					--$$ METADATA {"prettyName": "Action String ID", "groupName": "Hacking Terminal", "tooltip": "An optional override to define the action string for the switch."}
	secondaryActionStringID:string;			--$$ METADATA {"prettyName": "Secondary Action String ID", "groupName": "Hacking Terminal", "tooltip": "An optional override to define the secondary action string for the switch."}
	useNavpoint:boolean;					--$$ METADATA {"prettyName": "Use Initial Navpoint", "groupName": "Hacking Terminal", "tooltip": "Use Navpoint on Hacking Terminal before hacking sequence?"}
	hackingNavpointString:string;			--$$ METADATA {"prettyName": "Navpoint String", "groupName": "Hacking Terminal", "tooltip": "Override String ID for Navpoint String"}
	hackTimer:number						--$$ METADATA {"prettyName": "Hacking Timer", "min": 1.0, "max": 120.0, "groupName": "Hacking Terminal", "tooltip": "Override String ID for Navpoint String"}
	decayRate:number;						--$$ METADATA {"prettyName": "Decay Rate", "groupName": "Hacking Terminal", "tooltip": "Rate at which hacking progress decays. 1 is same rate as timer counting up."}
	useOnce:boolean;						--$$ METADATA {"prettyName": "Hack Only Once", "groupName": "Hacking Terminal", "tooltip": "Can the hacking terminal only be hacked once?"}
	useCooldown:boolean;					--$$ METADATA {"prettyName": "Cooldown", "groupName": "Hacking Terminal", "tooltip": "Set if the hacking terminal should disable for a bit before becoming active again."}
	cooldownLength:number;					--$$ METADATA {"prettyName": "Cooldown Length", "groupName": "Hacking Terminal", "tooltip": "Set how long the Hacking Terminal is inactive between uses."}

	initialTeam:string;						--$$ METADATA {"prettyName": "Initial Team", "groupName": "Team Info", "source": ["None", "Red", "Blue", "Green", "Yellow", "Purple", "Orange", "Brown", "Grey"], "tooltip": "What is the Initial Team that owns the terminal?"}
	initialCanInteract:boolean;				--$$ METADATA {"prettyName": "Initial Team Can Interact", "groupName": "Team Info", "tooltip": "If there is an Initial Team, can they interact with object?"}

	tetherDistance:number					--$$ METADATA {"prettyName": "Personal AI Tether Distance", "groupName": "Personal AI", "tooltip": "Set how far away the player can go before the hack connection breaks. -1 is infinite"}

	alwaysPowerOn:boolean					--$$ METADATA {"prettyName": "Always Power On", "groupName": "Broadcast Channels", "tooltip": "Always have power channel Power something on."}
	powerMessage:string						--$$ METADATA {"prettyName": "Send Power Broadcast", "groupName": "Broadcast Channels", "tooltip": "Set Power Channel that will Broadcast on Hacking Complete"}
	controlMessage:string					--$$ METADATA {"prettyName": "Send Control Broadcast", "groupName": "Broadcast Channels", "tooltip": "Set Control Channel that will Broadcast on Hacking Complete"}
	incomingPowerMessage:string				--$$ METADATA {"prettyName": "Receive Power Broadcast", "groupName": "Broadcast Channels", "tooltip": "Set Power Channel for receiving info to turn on/off the Hacking Terminal"}



	owningTeam: mp_team
	hackingTerminalParcel:table
end

function mp_hacking_terminal:init()
	local powerState:number = 1;

	if self.initialPower then
		powerState = 1;
	else
		powerState = 0;
	end

	object_set_function_variable(self, "ispowered", powerState, 0.2);
	object_set_function_variable(self, "isenabled", powerState, 0.2);
	object_set_function_variable(self, "isactive_ban_hacking_terminal", powerState, 0.2);

	if self.initialTeam == "None" then
        self.owningTeam = nil
    elseif self.initialTeam == "Red" then
        self.owningTeam = MP_TEAM.mp_team_red
    elseif self.initialTeam == "Blue" then
        self.owningTeam = MP_TEAM.mp_team_blue
    elseif self.initialTeam == "Green" then
        self.owningTeam = MP_TEAM.mp_team_green
    elseif self.initialTeam == "Yellow" then
        self.owningTeam = MP_TEAM.mp_team_yellow
    elseif self.initialTeam == "Purple" then
        self.owningTeam = MP_TEAM.mp_team_purple
    elseif self.initialTeam == "Orange" then
        self.owningTeam = MP_TEAM.mp_team_orange
    elseif self.initialTeam == "Brown" then
        self.owningTeam = MP_TEAM.mp_team_brown
    elseif self.initialTeam == "Grey" then
        self.owningTeam = MP_TEAM.mp_team_grey
    end

	self.hackingTerminalParcel = HackableObject:New(
	hmake HackableObjectInitArgs
	{
		instanceName = tostring(self) .. "HackingObject",
		hackableObject = self,
		interactString = self.actionStringID,
		secondaryString = self.secondaryActionStringID,
		overrideInteractString = true,
		initialTeam = self.owningTeam,
	});


	self.hackingTerminalParcel.CONFIG.initialNavpointOn = self.useNavpoint;
	self.hackingTerminalParcel.CONFIG.neutral = self.hackingNavpointString;
	self.hackingTerminalParcel.CONFIG.hackingTimeDuration = self.hackTimer;
	self.hackingTerminalParcel.CONFIG.useCooldown = self.useCooldown or false;
	self.hackingTerminalParcel.CONFIG.triggerOnce = self.useOnce or false;
	self.hackingTerminalParcel.CONFIG.decayRate = self.decayRate;
	self.hackingTerminalParcel.CONFIG.tetherDistance = self.tetherDistance;
	self.hackingTerminalParcel.CONFIG.cooldownTimeInSeconds = self.cooldownLength;
	self.hackingTerminalParcel.CONFIG.initialTeamCanInteract = self.initialCanInteract;

	-- Parcel sets it to 1 by default.
	if self.initialPower ~= nil and not self.initialPower then
		self.hackingTerminalParcel.CONFIG.intialPower = 0;
	end

	self.hackingTerminalParcel.CONFIG.alwaysPower = self.alwaysPowerOn;
	self.hackingTerminalParcel.CONFIG.powerChannel = self.powerMessage;
	self.hackingTerminalParcel.CONFIG.controlChannel = self.controlMessage;
	self.hackingTerminalParcel.CONFIG.incomingPowerChannel = self.incomingPowerMessage;
	

	ParcelAddAndStart(self.hackingTerminalParcel, self.hackingTerminalParcel.instanceName);
end

function mp_hacking_terminal:quit()
	if self.hackingTerminalParcel ~= nil then
		ParcelEnd(self.hackingTerminalParcel);
		self.hackingTerminalParcel = nil;
	end
end
-------------------------------------------------------------------------------------------------------------------------