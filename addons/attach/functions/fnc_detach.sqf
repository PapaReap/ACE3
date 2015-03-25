/*
 * Author: eRazeri and esteldunedain
 * Detach an item from a unit
 *
 * Arguments:
 * 0: unit doing the attaching (player) <STRING>
 * 1: vehicle that it will be detached from (player or vehicle) <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * Nothing
 *
 * Public: No
 */
#include "script_component.hpp"

PARAMS_2(_unit,_attachToVehicle);

private ["_attachedObjects", "_attachedItems"];

_attachedObjects = _attachToVehicle getVariable [QGVAR(Objects), []];
_attachedItems = _attachToVehicle getVariable [QGVAR(ItemNames), []];

private ["_attachedObject", "_attachedIndex", "_itemName", "_minDistance", "_unitPos", "_objectPos"];

_attachedObject = objNull;
_attachedIndex = -1;
_itemName = "";

//Find closest attached object
_minDistance = 1000;
_unitPos = getPos _unit;
_unitPos set [2,0];
{
    _objectPos = getPos _x;
    _objectPos set [2, 0];
    if (_objectPos distance _unitPos < _minDistance) then {
        _minDistance = _objectPos distance _unitPos;
        _attachedObject = _x;
        _itemName = _attachedItems select _forEachIndex;
        _attachedIndex = _forEachIndex;
    };
} forEach _attachedObjects;

// Check if unit has an attached item
if (isNull _attachedObject || {_itemName == ""}) exitWith {ERROR("Could not find attached object")};

// Exit if can't add the item
if !(_unit canAdd _itemName) exitWith {
    [localize "STR_ACE_Attach_Inventory_Full"] call EFUNC(common,displayTextStructured);
};

// Add item to inventory
_unit addItem _itemName;

if (toLower _itemName in ["b_ir_grenade", "o_ir_grenade", "i_ir_grenade"]) then {
    // Hack for dealing with X_IR_Grenade effect not dissapearing on deleteVehicle
    detach _attachedObject;
    _attachedObject setPos ((getPos _unit) vectorAdd [0, 0, -1000]);
    // Delete attached item after 0.5 seconds
    [{deleteVehicle (_this select 0)}, [_attachedObject], 0.5, 0] call EFUNC(common,waitAndExecute);
} else {
    // Delete attached item
    deleteVehicle _attachedObject;
};

// Reset unit variables
_attachedObjects deleteAt _attachedIndex;
_attachedItems deleteAt _attachedIndex;
_attachToVehicle setVariable [QGVAR(Objects), _attachedObjects, true];
_attachToVehicle setVariable [QGVAR(ItemNames), _attachedItems, true];

// Display message
switch (true) do {
    case (_itemName == "ACE_IR_Strobe_Item") : {
        [localize "STR_ACE_Attach_IrStrobe_Detached"] call EFUNC(common,displayTextStructured);
    };
    case (toLower _itemName in ["b_ir_grenade", "o_ir_grenade", "i_ir_grenade"]) : {
        [localize "STR_ACE_Attach_IrGrenade_Detached"] call EFUNC(common,displayTextStructured);
    };
    case (toLower _itemName in ["chemlight_blue", "chemlight_green", "chemlight_red", "chemlight_yellow"]) : {
        [localize "STR_ACE_Attach_Chemlight_Detached"] call EFUNC(common,displayTextStructured);
    };
};