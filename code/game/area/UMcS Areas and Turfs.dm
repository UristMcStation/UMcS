/*Urist McStation Areas, turf and maybe some other random shit to save on .dm's.

Basically, if you need to add areas or turfs for UMcS, use this file -Glloyd */


//UMcS unique Areas

/area/tcommsat/pirate
	name = "\improper Pirate Server Room"
	icon_state = "tcomsatcham"

/area/shuttle/pirate1/centcom
	icon_state = "shuttle"
	name = "\improper Pirate Ship Centcom" //WIP

/area/shuttle/pirate1/station
	icon_state = "shuttle"
	name = "\improper Pirate Ship"

/area/shuttle/naval1/centcom
	icon_state = "shuttle"
	name = "\improper Navy Ship Centcom" //WIP

/area/shuttle/naval1/station
	icon_state = "shuttle"
	name = "\improper Navy Ship"

/area/crew_quarters/pool
	name = "\improper Pool"
	icon_state = "bluenew"

/area/lounge
	name = "\improper Lounge"
	icon_state = "lounge"

/area/bridge/meeting_hall
	name = "\improper Meeting Hall"
	icon_state = "bridge"
	music = null

/area/crew_quarters/heads_dorms //Noble's Quarters, hehehe.
	name = "\improper Heads of Staff Dorms"
	icon_state = "head_quarters"

/area/storage/emergency3
	name = "Escape Emergency Storage" //Because yolo
	icon_state = "emergencystorage"


//TURFS
//I SWEAR, IF ANYONE FUCKS WITH THIS, I WILL KILL YOU. WE ONLY NEED THE ONE TURF DEF FOR STATION TURFS. USE GENERATE ICONS FROM ICON STATES -Glloyd

/turf/simulated/floor/uristturf
	name = "floor"
	icon = 'icons/turf/uristturf.dmi'
	icon_state = "yellowdiag02"
	floor_tile = new/obj/item/stack/tile/plasteel

//>Says we only need one turf def
//>Adds another. Holy fuck. Anyways, this is pool turf, so we don't fuck up /tg/ .dmi's. ALOSO, if there ARE turfs to add, add them above this.

/turf/simulated/floor/uristturf/pool
	name = "Pool"
	icon = 'icons/turf/uristturf.dmi'
	icon_state = "water4"

turf/simulated/floor/uristturf/pool/New()
	..()
	overlays += image("icon"='icons/turf/uristturf.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)
