 //All UMcS clothing will now go here, to prevent unecessary .dm's. I mean, how much clothes do we need anyways... -Glloyd

 // Beautiful naval shit, Reference: http://www.teuse.net/personal/harrington/hh_bible.htm
 // http://www.trmn.org/portal/images/uniforms/rmn/rmn_officer_srv_dress_lrg.png

/obj/item/clothing/head/beret/centcom/officer
	urist_only = 1
	name = "officers beret"
	desc = "A black beret adorned with the shield—a silver kite shield with an engraved sword—of the NanoTrasen security forces, announcing to the world that the wearer is a defender of NanoTrasen."
	icon = 'icons/uristicons.dmi'
	icon_state = "centcomofficerberet"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/beret/centcom/captain
	urist_only = 1
	name = "captains beret"
	desc = "A white beret adorned with the shield—a cobalt kite shield with an engraved sword—of the NanoTrasen security forces, worn only by those captaining a vessel of the NanoTrasen Navy."
	icon = 'icons/uristicons.dmi'
	icon_state = "centcomcaptain"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/shoes/centcom
	urist_only = 1
	name = "dress shoes"
	desc = "They appear impeccably polished."
	icon = 'icons/uristicons.dmi'
	icon_state = "laceups"

/obj/item/clothing/under/rank/centcom/representative
	urist_only = 1
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Ensign\" and bears \"N.C.V. Fearless CV-286\" on the left shounder."
	name = "\improper NanoTrasen Navy Uniform"
	icon = 'icons/uristicons.dmi'
	icon_state = "officer"
	item_state = "g_suit"
	color = "officer"

/obj/item/clothing/under/rank/centcom/officer
	urist_only = 1
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Lieutenant Commander\" and bears \"N.C.V. Fearless CV-286\" on the left shounder."
	name = "\improper NanoTrasen Officers Uniform"
	icon = 'icons/uristicons.dmi'
	icon_state = "officer"
	item_state = "g_suit"
	color = "officer"

/obj/item/clothing/under/rank/centcom/captain
	urist_only = 1
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Captain\" and bears \"N.C.V. Fearless CV-286\" on the left shounder."
	name = "\improper NanoTrasen Captains Uniform"
	icon = 'icons/uristicons.dmi'
	icon_state = "centcom"
	item_state = "dg_suit"
	color = "centcom"

//swimsuits for women, because pool and sexism.

/obj/item/clothing/under/swimsuit/
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/black
	urist_only = 1
	name = "black swimsuit"
	desc = "An oldfashioned black swimsuit."
	icon = 'icons/uristicons.dmi'
	icon_state = "swim_black"
	color = "swim_black"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/blue
	urist_only = 1
	name = "blue swimsuit"
	desc = "An oldfashioned blue swimsuit."
	icon = 'icons/uristicons.dmi'
	icon_state = "swim_blue"
	color = "swim_blue"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/purple
	urist_only = 1
	name = "purple swimsuit"
	desc = "An oldfashioned purple swimsuit."
	icon = 'icons/uristicons.dmi'
	icon_state = "swim_purp"
	color = "swim_purp"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/green
	urist_only = 1
	name = "green swimsuit"
	desc = "An oldfashioned green swimsuit."
	icon = 'icons/uristicons.dmi'
	icon_state = "swim_green"
	color = "swim_green"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/red
	urist_only = 1
	name = "red swimsuit"
	desc = "An oldfashioned red swimsuit."
	icon = 'icons/uristicons.dmi'
	icon_state = "swim_red"
	color = "swim_red"
	siemens_coefficient = 1

//SciRIG. It's hip, it's happening and it protects against space and some other shit. You fuckers said you wanted more EVA.
//It's totally not just a reskin of the medrig...

/obj/item/clothing/head/helmet/space/rig/science
	name = "science hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Built with lightweight materials for extra comfort."
	icon_state = "rig0-medical"
	item_state = "medical_helm"
	color = "medical"
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 5, bomb = 60, bio = 100, rad = 30)

/obj/item/clothing/suit/space/rig/science
	urist_only = 1
	icon = 'icons/uristicons.dmi'
	icon_state = "Scirig"
	name = "science hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Built with lightweight materials for easier movement. Looks like it could hold up against an explosion."
	item_state = "Scirig"
	slowdown = 2
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/weapon/storage/box/monkeycubes,/obj/item/device/aicard,/obj/item/device/paicard,/obj/item/weapon/hand_tele)
	armor = list(melee = 10, bullet = 5, laser = 10,energy = 5, bomb = 60, bio = 100, rad = 30)

//Emergency Suit. It's really shitty, but better than a firesuit when it comes to space or biological hazards. Will need a special "emergency locker" for this.
//One of the lockers will go in each of the emergency storages, and have one of these fuckers in them. Prepare to feel the suck as it slowly kills you.

/obj/item/clothing/suit/emergencysuit
	urist_only = 1
	name = "emergency suit"
	desc = "A bulky suit meant to be used in emergencies only. It doesn't look too safe... Wait, is that blood?" //PREPARE FOR YOUR DOOM
	icon = 'icons/uristicons.dmi'
	icon_state = "emergency"
	item_state = "emergency"
	w_class = 4
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen)
	slowdown = 1.5
	armor = list(melee = 5, bullet = 0, laser = 5,energy = 0, bomb = 5, bio = 50, rad = 25)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL | STOPSPRESSUREDMAGE
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT

/obj/item/clothing/head/emergencyhood
	urist_only = 1
	name = "emergency hood"
	desc = "A bulky hood meant to be used in emergencies only. It doesn't look too safe, and has some strange gray stains inside..."
	icon = 'icons/uristicons.dmi'
	icon_state = "emergency_hood"
	item_state = "emergency_hood"
	armor = list(melee = 5, bullet = 0, laser = 0,energy = 0, bomb = 5, bio = 50, rad = 25)
	flags = FPRINT | TABLEPASS | STOPSPRESSUREDMAGE
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT

/obj/structure/closet/emsuits //Tossing the closet here, because why the fuck not.
	name = "emergency suit closet"
	desc = "It's a closet for storing emergency equipment and suits. A small  sign on the bottom reads 'use only in extreme emergencies'"
	icon = 'icons/uristicons.dmi'
	icon_state = "ecloset"
	icon_closed = "ecloset"
	icon_opened = "eclosetopen"

/obj/structure/closet/emsuits/New()
	..()

	new /obj/item/clothing/head/emergencyhood(src)
	new /obj/item/clothing/suit/emergencysuit(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/storage/toolbox/emergency(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)


//Sexy Captain's jacket

/obj/item/clothing/suit/captunic/capjacket
	urist_only = 1
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon = 'icons/uristicons.dmi'
	icon_state = "capjacket"
	item_state = "capjacket"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

//Armoured biosuit for sec

/obj/item/clothing/head/bio_hood/asec
	urist_only = 1
	name = "armoured bio hood"
	icon = 'icons/uristicons.dmi'
	icon_state = "Armouredbiohood"
	desc = "An armoured hood that protects the head and face from biological comtaminants and minor damage."
	permeability_coefficient = 0.01
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|HEADCOVERSMOUTH|BLOCKHAIR
	armor = list(melee = 20, bullet = 10, laser = 25, energy = 10, bomb = 25, bio = 100, rad = 20)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES

/obj/item/clothing/suit/bio_suit/asec
	urist_only = 1
	name = "armoured bio suit"
	desc = "An armoured suit that protects against biological contamination and minor damage."
	icon = 'icons/uristicons.dmi'
	icon_state = "Armouredbiosuit"
	item_state = "bio_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags = FPRINT | TABLEPASS
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 3.0 //disgusting slowdown to compensate.
	allowed = list(/obj/item/weapon/tank/emergency_oxygen,/obj/item/weapon/pen,/obj/item/device/flashlight/pen)
	armor = list(melee = 20, bullet = 10, laser = 25, energy = 10, bomb = 25, bio = 100, rad = 20)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/structure/closet/secure_closet/armoredbiosuit
	name = "armoured bio suit locker"
	req_access = list(access_armory)
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"

/obj/structure/closet/secure_closet/armoredbiosuit/New()
	..()

	new /obj/item/clothing/head/bio_hood/asec(src)
	new /obj/item/clothing/suit/bio_suit/asec(src)

//Welder apron done by Shoes and Hats and added by Cozarctan. Moved from welder. Welde machete goes into the new uristweapons.dm

/obj/item/clothing/suit/welderapron
	urist_only = 1
	name = "welder's apron"
	desc = "A leather work apron."
	icon = 'icons/uristicons.dmi'
	icon_state = "welderapron"
	item_state = "welderapron"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN

//Naval Space suit. Or something like that. I don't fucking know.

/obj/item/clothing/head/helmet/space/naval
	urist_only = 1
	name = "naval space helmet"
	desc = "A high quality space helmet used by the Nanotrasen Navy."
	icon = 'icons/uristicons.dmi'
	icon_state = "navyspacehelm"
	armor = list(melee = 60, bullet = 45, laser = 40,energy = 15, bomb = 30, bio = 40, rad = 30) //similar values to the syndi space suits.

/obj/item/clothing/suit/space/naval
	urist_only = 1
	name = "naval space suit"
	icon = 'icons/uristicons.dmi'
	icon_state = "navyspace"
	desc = "A high quality space suit used by the Nanotrasen Navy. Smells like oppression."
	w_class = 3
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)
	slowdown = 1
	armor = list(melee = 60, bullet = 45, laser = 40,energy = 15, bomb = 30, bio = 40, rad = 30)

//Alternate outfit for the HoP. Part of a little thing I want to do, which is add alternate clothing for all the heads.

/obj/item/clothing/under/rank/alt_heads/hop
	urist_only = 1
	desc = "It's a quite fancy looking jumpsuit worn by someone who works in the position of \"Head of Personnel\"."
	name = "head of personnel's stylish jumpsuit"
	icon = 'icons/uristicons.dmi'
	icon_state = "hopwhimsy"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

