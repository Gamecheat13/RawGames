-- ========================================================================
-- 343 Industries - Shiva
-- Gamma Script: Scripted/MPAcademyNarrative
-- Export Date: 2/16/2021 7:42:23 PM -08:00
-- 
-- Confidential
-- ========================================================================


--## SERVER



--[========================================================================[
          Academy_PELICAN_intro_01


          We fade up in a pelican.

          Ahead of us is SPARTAN COMMANDER LAURETTE.

          The screen blurs.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_pelican_intro_01 = {
	name = "mpacademynarrative_academy_pelican_intro_01",
	tag = TAG('narrative\MPAcademyNarrative\Academy_PELICAN_intro_01.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_spartancommander_00200",
			-- character = nil, Line will play in 2D.
			moniker = "spartancommander", -- GAMMA_CHARACTER: SPARTANCOMMANDER
			-- text = "Hey, easy there. A lot's happened.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_SPARTANCOMMANDER_00200.sound'),
		},
		--           The screen blurs.
		[2] = {
			id = "mpacademynarrative_un_spartancommander_00300",
			-- character = nil, Line will play in 2D.
			moniker = "spartancommander", -- GAMMA_CHARACTER: SPARTANCOMMANDER
			-- text = "LACONIA changed everything. We needed to regroup. Rebuild.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_SPARTANCOMMANDER_00300.sound'),
		},
		--           FADE TO BLACK
		--           BEAT
		--           FADE UP
		--           The Commander is talking to someone over comms. Maybe in the
		--           front of the Pelican.
		[3] = {
			id = "mpacademynarrative_un_spartancommander_00400",
			-- character = nil, Line will play in 2D.
			moniker = "spartancommander", -- GAMMA_CHARACTER: SPARTANCOMMANDER
			-- text = "You're going to need to say that again?",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_SPARTANCOMMANDER_00400.sound'),
		},
		--           There's a pause.
		[4] = {
			id = "mpacademynarrative_un_spartancommander_00500",
			-- character = nil, Line will play in 2D.
			moniker = "spartancommander", -- GAMMA_CHARACTER: SPARTANCOMMANDER
			-- text = "They're missing? All of them?",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_SPARTANCOMMANDER_00500.sound'),
		},
		--           The door opens and she enters.
		[5] = {
			id = "mpacademynarrative_un_spartancommander_00600",
			-- character = nil, Line will play in 2D.
			moniker = "spartancommander", -- GAMMA_CHARACTER: SPARTANCOMMANDER
			-- text = "We just got word that the Infinity is missing. The Ring... gone. No one knows where.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_SPARTANCOMMANDER_00600.sound'),
		},
		--           There is a pause. She looks mournful. We see the effects of
		--           the war on her face. 
		--           BEEP BEEP. She snaps out of it.
		[6] = {
			id = "mpacademynarrative_un_marinemale01_02300",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale01", -- GAMMA_CHARACTER: MARINEMALE01 (V.O.)
			-- text = "We are coming up to the facility, Commander. No sign of trouble. ",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale01_02300.sound'),
		},
		[7] = {
			id = "mpacademynarrative_un_spartancommander_00700",
			-- character = nil, Line will play in 2D.
			moniker = "spartancommander", -- GAMMA_CHARACTER: SPARTANCOMMANDER
			-- text = "Take us in.\r\nWe built this facility off the grid. To train the next-generation of Spartans.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_SPARTANCOMMANDER_00700.sound'),
		},
		[8] = {
			id = "mpacademynarrative_un_marinemale01_02400",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale01", -- GAMMA_CHARACTER: MARINEMALE01 (V.O.)
			-- text = "On the ground in 3...",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale01_02400.sound'),
		},
		[9] = {
			id = "mpacademynarrative_un_spartancommander_00800",
			-- character = nil, Line will play in 2D.
			moniker = "spartancommander", -- GAMMA_CHARACTER: SPARTANCOMMANDER
			-- text = "You've got this.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_SPARTANCOMMANDER_00800.sound'),
		},
		[10] = {
			id = "mpacademynarrative_un_marinemale01_02500",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale01", -- GAMMA_CHARACTER: MARINEMALE01 (V.O.)
			-- text = "2...",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale01_02500.sound'),
		},
		[11] = {
			id = "mpacademynarrative_un_spartancommander_00900",
			-- character = nil, Line will play in 2D.
			moniker = "spartancommander", -- GAMMA_CHARACTER: SPARTANCOMMANDER
			-- text = "It's not gonna be easy.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_SPARTANCOMMANDER_00900.sound'),
		},
		[12] = {
			id = "mpacademynarrative_un_marinemale01_02600",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale01", -- GAMMA_CHARACTER: MARINEMALE01
			-- text = "1.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale01_02600.sound'),
		},
		--           The Pelican lurches as it touches down.
		[13] = {
			id = "mpacademynarrative_un_spartancommander_01000",
			-- character = nil, Line will play in 2D.
			moniker = "spartancommander", -- GAMMA_CHARACTER: SPARTANCOMMANDER
			-- text = "But I believe in you.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_SPARTANCOMMANDER_01000.sound'),
		},
		--           The rear door opens.
		[14] = {
			id = "mpacademynarrative_un_marinemale01_02700",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale01", -- GAMMA_CHARACTER: MARINEMALE01
			-- text = "Welcome to paradise. It's a beautiful day. Sunny skies. No sign of rain and just a small chance of being found and destroyed any second.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale01_02700.sound'),
		},
		--           The Spartan Commander steps out.
		[15] = {
			id = "mpacademynarrative_un_spartancommander_01100",
			-- character = nil, Line will play in 2D.
			moniker = "spartancommander", -- GAMMA_CHARACTER: SPARTANCOMMANDER
			-- text = "What did I tell you about being funny?",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_SPARTANCOMMANDER_01100.sound'),
		},
		[16] = {
			id = "mpacademynarrative_un_marinemale01_02800",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale01", -- GAMMA_CHARACTER: MARINEMALE01 (V.O.)
			-- text = "Keep doing it?",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale01_02800.sound'),
		},
		[17] = {
			id = "mpacademynarrative_un_spartancommander_01200",
			-- character = nil, Line will play in 2D.
			moniker = "spartancommander", -- GAMMA_CHARACTER: SPARTANCOMMANDER
			-- text = "Correct.\r\nYou gonna stand there all day? Or are you gonna come save humanity?",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_SPARTANCOMMANDER_01200.sound'),
		},
		--           FULL PLAYER CONTROL
		[18] = {
			id = "mpacademynarrative_un_spartancommander_01300",
			-- character = nil, Line will play in 2D.
			moniker = "spartancommander", -- GAMMA_CHARACTER: SPARTANCOMMANDER
			-- text = "Good.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_SPARTANCOMMANDER_01300.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_PELICAN_EXIT_LOOK_TUTORIAL
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_pelican_exit_look_tutorial = {
	name = "mpacademynarrative_academy_pelican_exit_look_tutorial",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_PELICAN_EXIT_LOOK_TUTORIAL.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_09400",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Look there. More Spartans joining the fight. ",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_09400.sound'),
		},
		--           Player is prompted to look up at the Pelicans overhead.
	},

	localVariables = {},
};



--[========================================================================[
          Academy_PELICAN_EXIT_2

          TUTORIAL MOVE

          Player gains movement control. Commander speaks to the rest
          of the Spartans, who are idling in the Pelican as the craft
          readies to take off.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_pelican_exit_2 = {
	name = "mpacademynarrative_academy_pelican_exit_2",
	tag = TAG('narrative\MPAcademyNarrative\Academy_PELICAN_EXIT_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_07000",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Your orders are to report to the training arena for drills and the live-fire exercise.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_07000.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          Academy_PELICAN_EXIT_3
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_pelican_exit_3 = {
	name = "mpacademynarrative_academy_pelican_exit_3",
	tag = TAG('narrative\MPAcademyNarrative\Academy_PELICAN_EXIT_3.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_08800",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "The waypoints on your HUD will point you in the right direction. Move out.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_08800.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          Academy_PELICAN_EXIT_PICKUP_1

          If the player lingers near the pelican.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_pelican_exit_pickup_1 = {
	name = "mpacademynarrative_academy_pelican_exit_pickup_1",
	tag = TAG('narrative\MPAcademyNarrative\Academy_PELICAN_EXIT_PICKUP_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_05700",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "I said \"move out\", Spartan. Now.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_05700.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          Academy_PELICAN_EXIT_PICKUP_2

          If the player continues to not move.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_pelican_exit_pickup_2 = {
	name = "mpacademynarrative_academy_pelican_exit_pickup_2",
	tag = TAG('narrative\MPAcademyNarrative\Academy_PELICAN_EXIT_PICKUP_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_marinemale01_02100",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale01", -- GAMMA_CHARACTER: MARINEMALE01
			-- text = "I'd listen to the Commander if I were you.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale01_02100.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          Academy_PELICAN_EXIT_PICKUP_3

          If the player lingers on the landing pad and doesn't enter
          the facility.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_pelican_exit_pickup_3 = {
	name = "mpacademynarrative_academy_pelican_exit_pickup_3",
	tag = TAG('narrative\MPAcademyNarrative\Academy_PELICAN_EXIT_PICKUP_3.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_marinemale01_02200",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale01", -- GAMMA_CHARACTER: MARINEMALE01
			-- text = "Just through those doors.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale01_02200.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_LOBBY_INTRO_1

          The player enters the lobby. 

          A Marine receptionist stands behind the desk ahead and to the
          left.

          When the player gets close (RADIO/OFFSCREEN):
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_lobby_intro_1 = {
	name = "mpacademynarrative_academy_lobby_intro_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_LOBBY_INTRO_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_marinemale01_00900",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale01", -- GAMMA_CHARACTER: Marinemale01 (V.O. RADIO)
			-- text = "Report to the A.I. Lab for calibration.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale01_00900.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          Academy_AI_INTRO_1

          The player enters the AI room. The AI plinth is directly
          ahead of them. Techs are milling around in the area.

          VIGNETTE AI Tech Start (just animations)

          One salutes when the player enters (RADIO/OFFSCREEN):
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_ai_intro_1 = {
	name = "mpacademynarrative_academy_ai_intro_1",
	tag = TAG('narrative\MPAcademyNarrative\Academy_AI_INTRO_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_marinemale01_01000",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale01", -- GAMMA_CHARACTER: Marinemale01 (V.O. RADIO)
			-- text = "Spartan on deck!",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale01_01000.sound'),
		},
		--           VIGNETTE AI Tech End
	},

	localVariables = {},
};



--[========================================================================[
          Academy_AI_Intro_2

          Player interacts with the plinth.

          NSEQ AI Acquisition Start

          Camera pulls out to a 3rd person shot of player and the
          plinth. A tech speaks to the player (via radio/offscreen).
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_ai_intro_2 = {
	name = "mpacademynarrative_academy_ai_intro_2",
	tag = TAG('narrative\MPAcademyNarrative\Academy_AI_Intro_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_marinemale02_00100",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale02", -- GAMMA_CHARACTER: Marinemale02 (V.O. RADIO)
			-- text = "Insert your A.I. chip to begin the calibration.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale02_00100.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          Academy_AI_Intro_4

          Spoken while the AI screen/menu is booting up.
          (RADIO/OFFSCREEN)
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_ai_intro_4 = {
	name = "mpacademynarrative_academy_ai_intro_4",
	tag = TAG('narrative\MPAcademyNarrative\Academy_AI_Intro_4.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_marinemale02_00300",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale02", -- GAMMA_CHARACTER: marinemale02 (V.O. RADIO)
			-- text = "Modularly designed for customization, these non-volitional AI have guaranteed stability and can be altered to suit your every need.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale02_00300.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_AI_INTRO_4_ALT


          Academy_AI_SELECT_1

          Player selects an AI in the AI selection menu.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_ai_intro_4_alt = {
	name = "mpacademynarrative_academy_ai_intro_4_alt",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_AI_INTRO_4_ALT.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_00100",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Greetings, Spartan. It would be my pleasure to serve at your side.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_00100.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          Academy_AI_SELECT_2

          Player confirms selection and configuration of their AI, and
          menu disperses, returning to the 3rd person shot. Player's AI
          is now on the plinth. It speaks and does a little greeting
          animation.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_ai_select_2 = {
	name = "mpacademynarrative_academy_ai_select_2",
	tag = TAG('narrative\MPAcademyNarrative\Academy_AI_SELECT_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_00200",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "I'm honored to work with you.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_00200.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_AI_SHIELDS_1

          Full HUD is activated
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_ai_shields_1 = {
	name = "mpacademynarrative_academy_ai_shields_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_AI_SHIELDS_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_00300",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Personal A.I. Designation Butler coming online.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_00300.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_AI_SHIELDS_2

          Optional AI line if animation pause is weird
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_ai_shields_2 = {
	name = "mpacademynarrative_academy_ai_shields_2",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_AI_SHIELDS_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_00400",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Calibrating armor baselines. ",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_00400.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_AI_SHIELDS_3

          Shield recharge
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_ai_shields_3 = {
	name = "mpacademynarrative_academy_ai_shields_3",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_AI_SHIELDS_3.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_00500",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Spartan shielding recharged.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_00500.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_AI_DOOR_HACK_1

          Player withdraws chip and inserts it into their helmet.
          Player returns to first person.

          NSEQ AI Acquisition Ends

          (RADIO/OFFSCREEN)
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_ai_door_hack_1 = {
	name = "mpacademynarrative_academy_ai_door_hack_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_AI_DOOR_HACK_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_marinemale02_00400",
			-- character = nil, Line will play in 2D.
			moniker = "marinemale02", -- GAMMA_CHARACTER: MARINEMALE02 (V.O. RADIO)
			-- text = "All armor systems reading green. Next your AI will complete additional motor diagnostics with you on the movement course.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MarineMale02_00400.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_AI_DOOR_HACK_2
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_ai_door_hack_2 = {
	name = "mpacademynarrative_academy_ai_door_hack_2",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_AI_DOOR_HACK_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_00600",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "If I may, I can provide the required access credentials to proceed.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_00600.sound'),
		},
		--           Player is prompted to deploy AI to open the door that leads
		--           to the movement course.
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_AI_DOOR_HACK_3

          Player interacts with door, line plays just before door opens
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_ai_door_hack_3 = {
	name = "mpacademynarrative_academy_ai_door_hack_3",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_AI_DOOR_HACK_3.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_00700",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Please, allow me.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_00700.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_OBSTACLE_TRAINING_INTRo_1

          Player enters the movement course for the first time. AI sets
          waypoints for them to follow.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_obstacle_training_intro_1 = {
	name = "mpacademynarrative_academy_obstacle_training_intro_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_OBSTACLE_TRAINING_INTRo_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_00800",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Projecting waypoints onto your HUD, Spartan. I shall continue calibrating as you progress through the course.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_00800.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_OBSTACLE_TRAINING_Intro_PICKUP_1

          If player delays in jumping over the first obstacle.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_obstacle_training_intro_pickup_1 = {
	name = "mpacademynarrative_academy_obstacle_training_intro_pickup_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_OBSTACLE_TRAINING_Intro_PICKUP_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_00900",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Use these points to find the route... at your leisure of course.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_00900.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_OBSTACLE_CROUCH_1

          If player doesn't Crouch when prompted
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_obstacle_crouch_1 = {
	name = "mpacademynarrative_academy_obstacle_crouch_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_OBSTACLE_CROUCH_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_01000",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Seems a tad cramped. Crouch to get through.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_01000.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_OBSTACLE_Melee_1

          Player destroys a target dummy with a melee strike.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_obstacle_melee_1 = {
	name = "mpacademynarrative_academy_obstacle_melee_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_OBSTACLE_Melee_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_01100",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Well struck.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_01100.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_OBSTACLE_Melee_PICKUP_1

          If the player passes through the first two dummy targets
          without striking them.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_obstacle_melee_pickup_1 = {
	name = "mpacademynarrative_academy_obstacle_melee_pickup_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_OBSTACLE_Melee_PICKUP_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_01200",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Now strike a target of your choice, so I may refine your suit's melee pneumatics.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_01200.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_OBSTACLE_WAIT

          Player waits around in the obstacle course
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_obstacle_wait = {
	name = "mpacademynarrative_academy_obstacle_wait",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_OBSTACLE_WAIT.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_01300",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Please feel free to fully avail yourself of all the movement course has to offer. We can go meet with the Commander when you're ready.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_01300.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_OBSTACLE_MOVEMENT_COURSE_TIMER_1

          A line in which the Butler acknowledges that the player is
          trying to improve their time on the course.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_obstacle_movement_course_timer_1 = {
	name = "mpacademynarrative_academy_obstacle_movement_course_timer_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_OBSTACLE_MOVEMENT_COURSE_TIMER_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_01400",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Going for a better time? Your dedication is admirable, Spartan.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_01400.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_OBSTACLE_OUTRO_1

          Player hits all waypoints and exits the obstacle course.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_obstacle_outro_1 = {
	name = "mpacademynarrative_academy_obstacle_outro_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_OBSTACLE_OUTRO_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_01500",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Motor diagnostics complete. Exceptional performance. Shall we rendezvous with the Commander at the weapon range?",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_01500.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_Facility_Access_Denied_1

          Player approaches or attempts to enter a door that is marked
          with red lighting/assorted "top secret" artistic treatments.
          We may open this door someday, we may not.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_facility_access_denied_1 = {
	name = "mpacademynarrative_academy_facility_access_denied_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_Facility_Access_Denied_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_01600",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Apologies, but we lack the required clearance to access this area of the facility.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_01600.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_armory_1

          Player enters the door leading to the armory.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_armory_1 = {
	name = "mpacademynarrative_academy_armory_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_armory_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_01700",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Ah, the Armory. Refined weapons for refined tastes. ",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_01700.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_armory_2

          Player nears the gun racks
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_armory_2 = {
	name = "mpacademynarrative_academy_armory_2",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_armory_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_01800",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Let's take this opportunity to arm ourselves.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_01800.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_armory_PICKUP_1

          Player picks up the weapon without being told to
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_armory_pickup_1 = {
	name = "mpacademynarrative_academy_armory_pickup_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_armory_PICKUP_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_01900",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "That will do nicely. Now: onward to the weapon range.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_01900.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_ARMORY_RETURN_1

          If the player returns to the armory and grabs a different
          weapon to try out at the range.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_armory_return_1 = {
	name = "mpacademynarrative_academy_armory_return_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_ARMORY_RETURN_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_02000",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Trying something different, eh?",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_02000.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_armory_IDLE_1

          If the player idles without picking up a weapon
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_armory_idle_1 = {
	name = "mpacademynarrative_academy_armory_idle_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_armory_IDLE_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_02100",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Perhaps this will serve as a suitable weapon. I shall mark its location on your HUD.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_02100.sound'),
		},
		--           Waypoint shows up on the HUD
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_armory_DOOR_NOGUN

          Player approaches the door to the weapons range without a gun
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_armory_door_nogun = {
	name = "mpacademynarrative_academy_armory_door_nogun",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_armory_DOOR_NOGUN.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_02200",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Wouldn't want to show up empty-handed. Check the storage lockers for a weapon.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_02200.sound'),
		},
		--           Waypoint shows up on the HUD
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_armory_PICKUP_2

          Player picks up the weapon after being told to either by
          DOOR_NOGUN or IDLE_1
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_armory_pickup_2 = {
	name = "mpacademynarrative_academy_armory_pickup_2",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_armory_PICKUP_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_02300",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Excellent. Now onward to the weapon range.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_02300.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_armory_ADMIRE

          Player lingers near the Covenant weapons
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_armory_admire = {
	name = "mpacademynarrative_academy_armory_admire",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_armory_ADMIRE.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_02400",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "This display boasts several exotic pieces. Latter-day Covenant and early Banished, if I'm not mistaken.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_02400.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_INTRO_1_ALT1

          NSEQ Weapon Range Start

          The Commander is talking to a Marine, her helmet on. She
          turns and sees the player Spartan.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_intro_1_alt1 = {
	name = "mpacademynarrative_academy_range_intro_1_alt1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_INTRO_1_ALT1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_01800",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: AcademyCommander
			-- text = "Ah, he tells me you've performed well so far. You're dismissed. Come.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_01800.sound'),
		},
		--           The Commander nods at the Marine and dismisses him.
		[2] = {
			id = "mpacademynarrative_un_academycommander_01900",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: AcademyCommander
			-- text = "Now let's see if your marksmanship is just as sharp.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_01900.sound'),
		},
		--           Commander walks to the range and activates it.
		[3] = {
			id = "mpacademynarrative_un_academycommander_02000",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "We'll set you up with live rounds.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_02000.sound'),
		},
		[4] = {
			id = "mpacademynarrative_un_academycommander_02100",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Take your time. Get a good feel for our new ordinance. ",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_02100.sound'),
		},
		--           The Commander begins to exit the weapon range.
		[5] = {
			id = "mpacademynarrative_un_academycommander_07900",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "I'll be watching from the observation deck.\r\nLet's begin.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_07900.sound'),
		},
		--           NSEQ Weapon Range Ends
		--           Player regains control once the Commander has exited the
		--           range.
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_AI_HIGHLIGHT_1

          TUTORIAL OUTLINES

          Target appears on the field. Spoken over Radio/Offscreen.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_ai_highlight_1 = {
	name = "mpacademynarrative_academy_range_ai_highlight_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_AI_HIGHLIGHT_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_02200",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER 
			-- text = "Your AI will outline all enemies for you.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_02200.sound'),
		},
		[2] = {
			id = "mpacademynarrative_un_mpsuitaibutler_02500",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "There we are. I hope that shade is appealing.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_02500.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_AI_HIGHLIGHT_2

          Red reticle (change color when the enemy is at optimal range)
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_ai_highlight_2 = {
	name = "mpacademynarrative_academy_range_ai_highlight_2",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_AI_HIGHLIGHT_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_02600",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "I shall update your crosshair color when your target is at optimal range for your weapon.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_02600.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_AI_HIGHLIGHT_3

          Gives command to fire. Radio/Offscreen
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_ai_highlight_3 = {
	name = "mpacademynarrative_academy_range_ai_highlight_3",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_AI_HIGHLIGHT_3.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_02400",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: AcademyCommander 
			-- text = "Now show me what you can do.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_02400.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_NEW_WEAPON_1

          Player kills target. Radio/Offscreen
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_new_weapon_1 = {
	name = "mpacademynarrative_academy_range_new_weapon_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_NEW_WEAPON_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_02500",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER 
			-- text = "Let's try a different weapon.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_02500.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_SCOPE_1

          Teach scope with new weapon. Radio/Offscreen
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_scope_1 = {
	name = "mpacademynarrative_academy_range_scope_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_SCOPE_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_02600",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER 
			-- text = "Zoom with your weapon for better visibility on long-range targets.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_02600.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_SCOPE_pickup_1

          If player kills a target without using scope.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_scope_pickup_1 = {
	name = "mpacademynarrative_academy_range_scope_pickup_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_SCOPE_pickup_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_02700",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Fine work. But can you do it through a scope?",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_02700.sound'),
		},
		--           If this line is not sufficient (maybe this second one can be
		--           a timeout:)
		[2] = {
			id = "mpacademynarrative_un_mpsuitaibutler_02800",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Switch to your scoped weapon and give it another try.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_02800.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_Shields_1

          Teaches Halo health model, shielding, headshots.
          Radio/Offscreen
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_shields_1 = {
	name = "mpacademynarrative_academy_range_shields_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_Shields_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_02900",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER 
			-- text = "Aim for the head when enemy shields are down.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_02900.sound'),
		},
		[2] = {
			id = "mpacademynarrative_un_academycommander_03000",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: AcademyCommander 
			-- text = "Shields recover quickly, so press your advantage while your enemy is vulnerable. ",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_03000.sound'),
		},
		--           Commander spawns in more targets. 
		--           Radio/Offscreen
		[3] = {
			id = "mpacademynarrative_un_academycommander_03100",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER 
			-- text = "Headshot these targets once you've dropped their shields.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_03100.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMy_RANGE_SHIELDS_HEADSHOT_1

          Player gets a successful headshot
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_shields_headshot_1 = {
	name = "mpacademynarrative_academy_range_shields_headshot_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMy_RANGE_SHIELDS_HEADSHOT_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_02900",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Excellent shot.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_02900.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_PICKUP_1

          If player waits to take down any targets that the Commander
          has spawned for them. Radio/Offscreen
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_pickup_1 = {
	name = "mpacademynarrative_academy_range_pickup_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_PICKUP_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_03400",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Take out those targets.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_03400.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_PICKUP_1_SINGULAR

          Requested alt in case we ever have a single target to
          destroy. (RADIO)
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_pickup_1_singular = {
	name = "mpacademynarrative_academy_range_pickup_1_singular",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_PICKUP_1_SINGULAR.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_08900",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER (V.O. RADIO)
			-- text = "Take out that target. ",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_08900.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_PICKUP_2

          Player kills targets. Radio/Offscreen.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_pickup_2 = {
	name = "mpacademynarrative_academy_range_pickup_2",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_PICKUP_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_03500",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER (V.O. RADIO)
			-- text = "Nice work.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_03500.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_GRENADES_PICKUP

          Radio/offscreen
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_grenades_pickup = {
	name = "mpacademynarrative_academy_range_grenades_pickup",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_GRENADES_PICKUP.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_09000",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER (V.O. RADIO)
			-- text = "Now for grenades. Grab some from that dispenser.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_09000.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_GRENADES_PICKUP_1
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_grenades_pickup_1 = {
	name = "mpacademynarrative_academy_range_grenades_pickup_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_GRENADES_PICKUP_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_09100",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Aim well and take out those targets.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_09100.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_GRENADES_PICKUP_2
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_grenades_pickup_2 = {
	name = "mpacademynarrative_academy_range_grenades_pickup_2",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_GRENADES_PICKUP_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_09200",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Well done.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_09200.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_OUTRO_1

          Radio/Offscreen
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_outro_1 = {
	name = "mpacademynarrative_academy_range_outro_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_OUTRO_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_03600",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: AcademyCommander 
			-- text = "Keep practicing and, when you're ready, meet us for the final exercise. ",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_03600.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_reminder_1

          Reminder if the player stays in the range after killing all
          enemies and doesn't spawn more.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_reminder_1 = {
	name = "mpacademynarrative_academy_range_reminder_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_reminder_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_03000",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "The Commander has been gracious enough to prepare a final exercise for us. Shall we indulge her?",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_03000.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_RANGE_Startover_1

          Player summons more enemies to the firing range
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_range_startover_1 = {
	name = "mpacademynarrative_academy_range_startover_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_RANGE_Startover_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_03100",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Perhaps a few more, for good measure.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_03100.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_Facility_INTRO_1

          Player enters the training facility (MP map - Interlock).
          Radio/Offscreen
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_intro_1 = {
	name = "mpacademynarrative_academy_training_facility_intro_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_Facility_INTRO_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_04100",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER 
			-- text = "Welcome to the Training Arena.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_04100.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_BOTS_INTRO_2

          Radio/Offscreen
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_bots_intro_2 = {
	name = "mpacademynarrative_academy_bots_intro_2",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_BOTS_INTRO_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_04300",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER 
			-- text = "Get to know the battlefield and meet me by the tower when you're ready to begin the exercise.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_04300.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_BOTS_INTRO_3

          Radio/Offscreen
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_bots_intro_3 = {
	name = "mpacademynarrative_academy_bots_intro_3",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_BOTS_INTRO_3.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_08500",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Get to know the battlefield and our equipment before we begin the exercise.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_08500.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_RADAR
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_radar = {
	name = "mpacademynarrative_academy_training_facility_radar",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_RADAR.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_03200",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Motion Tracker now online. Displaying enemy movements on your HUD.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_03200.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_PING
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_ping = {
	name = "mpacademynarrative_academy_training_facility_ping",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_PING.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_03300",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Using your HUD, I can mark important objects or objectives to your teammates using NAV markers.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_03300.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_GRENADES_1

          When the player first approaches a grenade pad.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_grenades_1 = {
	name = "mpacademynarrative_academy_training_facility_grenades_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_GRENADES_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_03400",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Let's try one of these grenades. ",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_03400.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_GRENADES_PICKUP_1

          If player does not throw the grenade when prompted.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_grenades_pickup_1 = {
	name = "mpacademynarrative_academy_training_facility_grenades_pickup_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_GRENADES_PICKUP_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_03500",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Give it a toss.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_03500.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_Equipment_1

          When the player first approaches an equipment pad.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_equipment_1 = {
	name = "mpacademynarrative_academy_training_facility_equipment_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_Equipment_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_03600",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "These contain specialized equipment that can give you the edge in combat.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_03600.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_equipment_PICKUP_1

          If player does not immediately deploy equipment.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_equipment_pickup_1 = {
	name = "mpacademynarrative_academy_training_facility_equipment_pickup_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_equipment_PICKUP_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_03700",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Try utilizing your equipment.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_03700.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_POWERUPS_1

          When the player first approaches a power up pad.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_powerups_1 = {
	name = "mpacademynarrative_academy_training_facility_powerups_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_POWERUPS_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_03800",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Ah! Now this device comes straight from ONI research. Quite potent indeed. ",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_03800.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_POWERUPS_PICKUP_1

          If player does not use a power up when prompted.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_powerups_pickup_1 = {
	name = "mpacademynarrative_academy_training_facility_powerups_pickup_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_POWERUPS_PICKUP_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_03900",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "I've read the reports, but I've never seen one in action. How about a demonstration?",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_03900.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_POWER_Weapons_1

          When the player first approaches a power weapon pad.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_power_weapons_1 = {
	name = "mpacademynarrative_academy_training_facility_power_weapons_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_POWER_Weapons_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_04000",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "These particular dispensers deploy powerful weapons, rather exclusively I might add.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_04000.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_POWER_WEAPONS_PICKUP_1

          If player does not pick up the power weapon when prompted.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_power_weapons_pickup_1 = {
	name = "mpacademynarrative_academy_training_facility_power_weapons_pickup_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_POWER_WEAPONS_PICKUP_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_04100",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Such firepower can often turn the tide of a battle.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_04100.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_weapon_container_1

          When the player first approaches a weapon container.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_weapon_container_1 = {
	name = "mpacademynarrative_academy_training_facility_weapon_container_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_weapon_container_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_04200",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "You can find new weapons inside these dispensers.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_04200.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_Commander_PICKUP_1

          If the player has explored the map but has not met the
          Commander. Radio/Offscreen
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_commander_pickup_1 = {
	name = "mpacademynarrative_academy_training_facility_commander_pickup_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_Commander_PICKUP_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_05800",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER 
			-- text = "Meet me by the tower when you're ready to begin.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_05800.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_Commander_PICKUP_1_ALT

          If the player has explored the map but has not met the
          Commander.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_commander_pickup_1_alt = {
	name = "mpacademynarrative_academy_training_facility_commander_pickup_1_alt",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_Commander_PICKUP_1_ALT.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_mpsuitaibutler_04300",
			-- character = nil, Line will play in 2D.
			moniker = "mpsuitaibutler", -- GAMMA_CHARACTER: MPSUITAIBUTLER
			-- text = "Congratulations. We have successfully surveyed all nearby points of interest. I suggest we find the Commander.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_MPSuitAIButler_04300.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_BOTS_WELCOME_1_ALT

          Commander and Spartans from earlier are idling in the yard.
          When the player gets near the Commander, but hasn't yet
          started the exercise.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_bots_welcome_1_alt = {
	name = "mpacademynarrative_academy_bots_welcome_1_alt",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_BOTS_WELCOME_1_ALT.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_07100",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Feeling oriented? Ready for something a little more real?",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_07100.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_BOTS_WELCOME_2

          The player interacts with the Commander to begin the bot
          match live fire exercise that concludes the tutorial
          experience.

          NSEQ Live Fire Exercise Starts

          The Commander is accompanied by two Spartans that were with
          the player in the pelican at the beginning of the level. They
          are preparing for combat.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_bots_welcome_2 = {
	name = "mpacademynarrative_academy_bots_welcome_2",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_BOTS_WELCOME_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_05900",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Now that we've got you calibrated, it's time for the real test: the live-fire exercise.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_05900.sound'),
		},
		[2] = {
			id = "mpacademynarrative_un_academycommander_09300",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Ready up, Spartan. It's time to fight.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_09300.sound'),
		},
		--           NSEQ Live Fire Exercise Ends
		--           Combat with bots begins.
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_TRAINING_FACILITY_Commander_PICKUP_2

          If player has explored the map and spoken to the Commander
          but does not initiate the combat exercise. Radio/Offscreen
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_training_facility_commander_pickup_2 = {
	name = "mpacademynarrative_academy_training_facility_commander_pickup_2",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_TRAINING_FACILITY_Commander_PICKUP_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_06100",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Speak with me when you want to start the combat exercise. ",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_06100.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_OUTRO

          @INFO Triggers as soon as combat finishes.

          @TYPE SEQ
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_outro = {
	name = "mpacademynarrative_academy_outro",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_OUTRO.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_08000",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: AcademyCommander
			-- text = "You did good.\r\nReally good in fact. I knew I picked well.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_08000.sound'),
		},
		--           She pauses and looks at you.
		[2] = {
			id = "mpacademynarrative_un_academycommander_08100",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "I need to go. ",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_08100.sound'),
		},
		[3] = {
			id = "mpacademynarrative_un_academycommander_08600",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "It's been confirmed that a portion of our forces are missing. Chief. The other Spartans. Gone.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_08600.sound'),
		},
		--           She pauses again and decides to offer some advice.
		[4] = {
			id = "mpacademynarrative_un_academycommander_08200",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "The state of this universe can shift at any moment. That's why we're needed: to endure. To ensure stability. To inspire hope.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_08200.sound'),
		},
		[5] = {
			id = "mpacademynarrative_un_academycommander_08700",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Hope when all is lost. What you began today is only the beginning.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_08700.sound'),
		},
		--           She grabs hold of the Pelican rail.
		[6] = {
			id = "mpacademynarrative_un_academycommander_08300",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: AcademyCommander
			-- text = "Keep training. When I get back... and believe me, I will be back, we're gonna be busy.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_08300.sound'),
		},
		--           The Pelican's engines roar to life and it starts to rise into
		--           the air.
		[7] = {
			id = "mpacademynarrative_un_academycommander_08400",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: AcademyCommander
			-- text = "Humanity won't save itself, Spartan!",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_08400.sound'),
		},
		--           The Pelican flies off toward the sunset. More join it. Music
		--           swells.
		--           CONGRATULATIONS: YOU COMPLETED THE ACADEMY SPARTAN
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_1
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_1 = {
	name = "mpacademynarrative_academy_support_1",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_1.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_05200",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Nice shot.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_05200.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_2

          Player gets an assist.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_2 = {
	name = "mpacademynarrative_academy_support_2",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_2.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_05300",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: AcademyCommander
			-- text = "Good support.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_05300.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_3

          Player shields are low.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_3 = {
	name = "mpacademynarrative_academy_support_3",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_3.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_05400",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: AcademyCommander
			-- text = "Watch your shields.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_05400.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_4

          Player is killed during combat exercise.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_4 = {
	name = "mpacademynarrative_academy_support_4",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_4.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_06200",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Pick yourself up, it's not over yet.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_06200.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_5

          Player is killed during combat exercise.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_5 = {
	name = "mpacademynarrative_academy_support_5",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_5.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_06300",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Get back in the fight.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_06300.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_6

          Player gets a headshot.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_6 = {
	name = "mpacademynarrative_academy_support_6",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_6.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_06400",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Excellent headshot.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_06400.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_7

          Player gets a melee kill.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_7 = {
	name = "mpacademynarrative_academy_support_7",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_7.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_06500",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Good form.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_06500.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_8

          Player does something noteworthy.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_8 = {
	name = "mpacademynarrative_academy_support_8",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_8.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_06600",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Good.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_06600.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_9

          The player's shields pop.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_9 = {
	name = "mpacademynarrative_academy_support_9",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_9.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_06700",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Take cover.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_06700.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_10

          If the player damages a friendly target.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_10 = {
	name = "mpacademynarrative_academy_support_10",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_10.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_06800",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Watch for allies.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_06800.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_11

          If the player damages a friendly target.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_11 = {
	name = "mpacademynarrative_academy_support_11",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_11.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_07500",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Looking good out there Spartan.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_07500.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_12

          If the player damages a friendly target.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_12 = {
	name = "mpacademynarrative_academy_support_12",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_12.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_07600",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Well done.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_07600.sound'),
		},
	},

	localVariables = {},
};



--[========================================================================[
          ACADEMY_SUPPORT_13

          If the player damages a friendly target.
--]========================================================================]

NarrativeInterface.loadedConversations.mpacademynarrative_academy_support_13 = {
	name = "mpacademynarrative_academy_support_13",
	tag = TAG('narrative\MPAcademyNarrative\ACADEMY_SUPPORT_13.Conversation'),

	Priority = CONVO_PRIORITY_FNC.CriticalPath,

	OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,

	lines = {
		[1] = {
			id = "mpacademynarrative_un_academycommander_07800",
			-- character = nil, Line will play in 2D.
			moniker = "academycommander", -- GAMMA_CHARACTER: ACADEMYCOMMANDER
			-- text = "Very nice.",
			tag = TAG('sound\001_vo\Scripted\Academy\001_vo_scr_mpacademynarrative\001_VO_SCR_MPAcademyNarrative_UN_AcademyCommander_07800.sound'),
		},
		--           NOTE:
		--           AI LINES WILL HAVE VARIATIONS FOR EACH OF THE (3) PLANNED
		--           PERSONALITIES. THE PERSONALITIES ARE TDB, CURRENTLY IN FLUX.
	},

	localVariables = {},
};
