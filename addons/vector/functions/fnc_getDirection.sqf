// by commy2
#include "script_component.hpp"

/*
private "_dlgVector";

disableSerialization;
_dlgVector = GETUVAR(ACE_dlgVector, displayNull);

[
    round parseNumber ctrlText (_dlgVector displayCtrl 156),
    round parseNumber ctrlText (_dlgVector displayCtrl 182)
]
*/

private ["_position", "_direction", "_azimuth", "_inclination"];

_position = ATLToASL positionCameraToWorld [0,0,0];
_direction = ATLToASL positionCameraToWorld [0,0,1];

_azimuth = ((_direction select 0) - (_position select 0)) atan2 ((_direction select 1) - (_position select 1));
_inclination = asin ((_direction select 2) - (_position select 2));

if (_azimuth < 0) then {_azimuth = _azimuth + 360};

[_azimuth, _inclination]
