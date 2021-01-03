#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
   	    

function main()
{
	clientfield::register( "world", "freerun_state", 1, 2, "int", &freerunStateChanged, !true, !true );
	clientfield::register( "world", "freerun_retries", 1, 16, "int", &freerunRetriesUpdated, !true, !true );
	clientfield::register( "world", "freerun_faults", 1, 16, "int", &freerunFaultsUpdated, !true, !true );
	clientfield::register( "world", "freerun_startTime", 1, 31, "int", &freerunStartTimeUpdated, !true, !true );
	clientfield::register( "world", "freerun_finishTime", 1, 31, "int", &freerunFinishTimeUpdated, !true, !true );
	clientfield::register( "world", "freerun_bestTime", 1, 31, "int", &freerunBestTimeUpdated, !true, !true );
	clientfield::register( "world", "freerun_timeAdjustment", 1, 31, "int", &freerunTimeAdjustmentUpdated, !true, !true );
}

function freerunStateChanged( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	controllerModel = GetUIModelForController( localClientNum );
    stateModel = GetUIModel( controllerModel, "FreeRun.runState" );
    SetUIModelValue( stateModel, newVal );
}

function freerunRetriesUpdated( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	controllerModel = GetUIModelForController( localClientNum );
    retriesModel = GetUIModel( controllerModel, "FreeRun.freeRunInfo.retries" );
    SetUIModelValue( retriesModel, newVal );
}

function freerunFaultsUpdated( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	controllerModel = GetUIModelForController( localClientNum );
    faultsModel = GetUIModel( controllerModel, "FreeRun.freeRunInfo.faults" );
    SetUIModelValue( faultsModel, newVal );
}

function freerunStartTimeUpdated( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	controllerModel = GetUIModelForController( localClientNum );
    model = GetUIModel( controllerModel, "FreeRun.startTime" );
    SetUIModelValue( model, newVal );
}

function freerunFinishTimeUpdated( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	controllerModel = GetUIModelForController( localClientNum );
    model = GetUIModel( controllerModel, "FreeRun.finishTime" );
    SetUIModelValue( model, newVal );
}

function freerunBestTimeUpdated( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	controllerModel = GetUIModelForController( localClientNum );
    model = GetUIModel( controllerModel, "FreeRun.freeRunInfo.bestTime" );
    SetUIModelValue( model, newVal );
}

function freerunTimeAdjustmentUpdated( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	controllerModel = GetUIModelForController( localClientNum );
    model = GetUIModel( controllerModel, "FreeRun.timer.timeAdjustment" );
    SetUIModelValue( model, newVal );
}

function onPrecacheGameType()
{
}

function onStartGameType()
{	
}