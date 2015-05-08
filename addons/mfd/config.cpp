#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"ace_common"};
        author[] = {"jaynus"};
        authorUrl = "http://www.ace3mod.com/";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "OverlayDialog.hpp"