 /*										*****New space to put all Misc. UristMcStation Items*****

Please keep it tidy, by which I mean put comments describing the item before the entry.I may or may not move couches and flora here. -Glloyd*/


//GPS, for all your finding needs.

/obj/item/device/gps
	name = "relay positioning device"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	item_state = "locator"
	w_class = 2

/obj/item/device/gps/attack_self(var/mob/user as mob)
	var/turf/T = get_turf(src)
	user << "\blue \icon[src] [src] flashes <i>[T.x].[rand(0,9)]:[T.y].[rand(0,9)]:[T.z].[rand(0,9)]</i>."

