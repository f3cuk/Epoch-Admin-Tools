private["_players"];

// Do not modify this file unless you know what you are doing

AdminList = AdminList + SuperAdminList; // add SuperAdmin to Admin
AdminAndModList = AdminList + ModList; // Add all admin/mod into one list for easy call

tempList = []; // Initialize templist
helpQueue = []; // Initialize help queue

_players = entities "CAManBase";

/*
	Determines default on or off for admin tools menu
	Set this to false if you want the menu to be off by default.
	F11 turns the tool off, F10 turns it on.
	Leave this as True for now, it is under construction.
*/
if (isNil "toolsAreActive") then {toolsAreActive = false;};

// load server public variables
if(isDedicated) then {
	"usageLogger" addPublicVariableEventHandler {
		"EATadminLogger" callExtension (_this select 1);
	};
	"useBroadcaster" addPublicVariableEventHandler {
		EAT_toClient = (_this select 1);
		{
			if ((getPlayerUID _x ) in SuperAdminList) then {
				(owner _x) publicVariableClient "EAT_toClient";
			};
		} count _players;
	};
	"EAT_baseExporter" addPublicVariableEventHandler {
		"EATbaseExporter" callExtension (_this select 1);
	};
	"EAT_teleportFixServer" addPublicVariableEventHandler{
		_array = (_this select 1);
		_addRemove = (_array select 0);

		if(_addRemove == "add") then {
			_array = _array - ["add"];
			tempList = tempList + _array;
		} else {
			_array = _array - ["remove"];
			tempList = tempList - _array;
		};
		EAT_teleportFixClient = tempList;
		{(owner _x) publicVariableClient "EAT_teleportFixClient";} count _players;
	};
	"EAT_SetDateServer" addPublicVariableEventHandler {
		EAT_setDateClient = (_this select 1);
		setDate EAT_setDateClient;
		{(owner _x) publicVariableClient "EAT_setDateClient";} count _players;
	};
	"EAT_SetOvercastServer" addPublicVariableEventHandler {
		EAT_setOvercastClient = (_this select 1);
		5 setOvercast EAT_setOvercastClient;
		{(owner _x) publicVariableClient "EAT_setOvercastClient";} count _players;
	};
	"EAT_SetFogServer" addPublicVariableEventHandler {
		EAT_setFogClient = (_this select 1);
		5 setFog EAT_setFogClient;
		{(owner _x) publicVariableClient "EAT_setFogClient";} count _players;
	};
};

// Client public variables
if ((getPlayerUID player) in SuperAdminList) then {
	"EAT_toClient" addPublicVariableEventHandler {
		systemChat (_this select 1);
	};
};

"EAT_teleportFixClient" addPublicVariableEventHandler {
	tempList = (_this select 1);
};

"EAT_SetDateClient" addPublicVariableEventHandler {
	setDate (_this select 1);
};
"EAT_setOvercastClient" addPublicVariableEventHandler {
	drn_fnc_DynamicWeather_SetWeatherLocal = {};
	5 setOvercast (_this select 1);
};
"EAT_setFogClient" addPublicVariableEventHandler {
	drn_fnc_DynamicWeather_SetWeatherLocal = {};
	5 setFog (_this select 1);
};

// overwrite epoch public variables
"PVDZE_plr_SetDate" addPublicVariableEventHandler {};

// Show the admin list has loaded
adminListLoaded = true;
diag_log("Admin Tools: variables.sqf loaded");