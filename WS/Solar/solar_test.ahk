#include solar_functions.ahk

winActivate, ahk_id %solar_id%
listSelect(solar_id, group_list, 3)
listSelectByAttribute(solar_id, plan_list, 5, "Active")