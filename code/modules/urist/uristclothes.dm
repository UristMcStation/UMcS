 /*										*****New space to put all UristMcStation Clothing*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/uristclothes.dmi'
All UMcS clothing will now go here, to prevent unecessary .dm's. I mean, how much clothes do we need anyways... -Glloyd*/

 // Beautiful naval shit, Reference: http://www.teuse.net/personal/harrington/hh_bible.htm
 // http://www.trmn.org/portal/images/uniforms/rmn/rmn_officer_srv_dress_lrg.png

/obj/item/clothing/head/beret/centcom/officer
	urist_only = 1
	name = "officers beret"
	desc = "A black beret adorned with the shield—a silver kite shield with an engraved sword—of the NanoTrasen security forces, announcing to the world that the wearer is a defender of NanoTrasen."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "centcomofficerberet"

/obj/item/clothing/head/beret/centcom/captain
	urist_only = 1
	name = "captains beret"
	desc = "A white beret adorned with the shield—a cobalt kite shield with an engraved sword—of the NanoTrasen security forces, worn only by those captaining a vessel of the NanoTrasen Navy."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "centcomcaptain"

/obj/item/clothing/shoes/centcom
	urist_only = 1
	name = "dress shoes"
	desc = "They appear impeccably polished."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "laceups"

/obj/item/clothing/under/rank/centcom
	fitted = 0

/obj/item/clothing/under/rank/centcom/representative
	urist_only = 1
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Ensign\" and bears \"N.C.V. Fearless CV-286\" on the left shounder."
	name = "\improper NanoTrasen Navy Uniform"
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "officer"
	item_state = "g_suit"
	item_color = "officer"

/obj/item/clothing/under/rank/centcom/officer
	urist_only = 1
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Lieutenant Commander\" and bears \"N.C.V. Fearless CV-286\" on the left shounder."
	name = "\improper NanoTrasen Officers Uniform"
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "officer"
	item_state = "g_suit"
	item_color = "officer"

/obj/item/clothing/under/rank/centcom/captain
	urist_only = 1
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Captain\" and bears \"N.C.V. Fearless CV-286\" on the left shounder."
	name = "\improper NanoTrasen Captains Uniform"
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "centcom"
	item_state = "dg_suit"
	item_color = "centcom"

//swimsuits for women, because pool and sexism.

/obj/item/clothing/under/swimsuit/
	siemens_coefficient = 1
	fitted = 0

/obj/item/clothing/under/swimsuit/black
	urist_only = 1
	name = "black swimsuit"
	desc = "An oldfashioned black swimsuit."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "swim_black"
	item_color = "swim_black"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/blue
	urist_only = 1
	name = "blue swimsuit"
	desc = "An oldfashioned blue swimsuit."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "swim_blue"
	item_color = "swim_blue"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/purple
	urist_only = 1
	name = "purple swimsuit"
	desc = "An oldfashioned purple swimsuit."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "swim_purp"
	item_color = "swim_purp"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/green
	urist_only = 1
	name = "green swimsuit"
	desc = "An oldfashioned green swimsuit."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "swim_green"
	item_color = "swim_green"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/red
	urist_only = 1
	name = "red swimsuit"
	desc = "An oldfashioned red swimsuit."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "swim_red"
	item_color = "swim_red"
	siemens_coefficient = 1

//SciRIG. It's hip, it's happening and it protects against space and some other shit. You fuckers said you wanted more EVA.
//It's totally not just a reskin of the medrig...

/obj/item/clothing/head/helmet/space/rig/science
	name = "science hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Built with lightweight materials for extra comfort."
	icon_state = "rig0-medical"
	item_state = "medical_helm"
	item_color = "medical"
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 5, bomb = 60, bio = 100, rad = 30)

/obj/item/clothing/suit/space/rig/science
	urist_only = 1
	icon = 'icons/urist/uristclothes.dmi'
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
	icon = 'icons/urist/uristclothes.dmi'
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
	flags = STOPSPRESSUREDMAGE | THICKMATERIAL
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT

/obj/item/clothing/head/emergencyhood
	urist_only = 1
	name = "emergency hood"
	desc = "A bulky hood meant to be used in emergencies only. It doesn't look too safe, and has some strange gray stains inside..."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "emergency_hood"
	item_state = "emergency_hood"
	armor = list(melee = 5, bullet = 0, laser = 0,energy = 0, bomb = 5, bio = 50, rad = 25)
	flags = STOPSPRESSUREDMAGE | THICKMATERIAL
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT

//Sexy Captain's jacket

/obj/item/clothing/suit/captunic/capjacket
	urist_only = 1
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "capjacket"
	item_state = "capjacket"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

//Armoured biosuit for sec

/obj/item/clothing/head/bio_hood/asec
	urist_only = 1
	name = "armoured bio hood"
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "Armouredbiohood"
	desc = "An armoured hood that protects the head and face from biological comtaminants and minor damage."
	permeability_coefficient = 0.01
	flags = HEADCOVERSEYES|HEADCOVERSMOUTH|BLOCKHAIR|THICKMATERIAL
	armor = list(melee = 20, bullet = 10, laser = 25, energy = 10, bomb = 25, bio = 100, rad = 20)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES

/obj/item/clothing/suit/bio_suit/asec
	urist_only = 1
	name = "armoured bio suit"
	desc = "An armoured suit that protects against biological contamination and minor damage."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "Armouredbiosuit"
	item_state = "bio_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 3.0 //disgusting slowdown to compensate.
	allowed = list(/obj/item/weapon/tank/emergency_oxygen,/obj/item/weapon/pen,/obj/item/device/flashlight/pen)
	armor = list(melee = 20, bullet = 10, laser = 25, energy = 10, bomb = 25, bio = 100, rad = 20)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

//Welder apron done by ShoesandHats and added by Cozarctan. Moved from welder. Welder machete goes into the new uristweapons.dm

/obj/item/clothing/suit/welderapron
	urist_only = 1
	name = "welder's apron"
	desc = "A leather work apron."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "welderapron"
	item_state = "welderapron"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN

//Naval Space suit. Or something like that. I don't fucking know.

/obj/item/clothing/head/helmet/space/naval
	urist_only = 1
	name = "naval space helmet"
	desc = "A high quality space helmet used by the Nanotrasen Navy."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "navyspacehelm"
	armor = list(melee = 55, bullet = 45, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)

/obj/item/clothing/suit/space/naval
	urist_only = 1
	name = "naval space suit"
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "navyspace"
	desc = "A high quality space suit used by the Nanotrasen Navy. Smells like oppression."
	w_class = 3
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen,/obj/item/device/flashlight)
	slowdown = 1
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)

//Alternate outfit for the HoP. Part of a little thing I want to do, which is add alternate clothing for all the heads. Let's try this again.

/obj/item/clothing/under/rank/head_of_personnel_whimsy
	urist_only = 1
	name = "head of personnel's suit"
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "hopwhimsy"
	item_state = "hopwhimsy"
	item_color = "hopwhimsy"
	desc = "A blue jacket and red tie, with matching red cuffs! Snazzy. Wearing this makes you feel more important than your job title does."
	fitted = 0

//Tactical Webbing. Icons are /tg/, there's just no def.
//Redone 26/01/2014 to make it a tie and such. Moves off of the fucked coat storage code. Also adds combat vests which, again, go under armour.

/obj/item/clothing/tie/storage
	urist_only = 1
	name = "load bearing equipment"
	desc = "Used to hold things when you don't have enough hands for that."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "webbing"
	item_color = "webbing"
	var/slots = 3
	var/obj/item/weapon/storage/pockets/hold

/obj/item/clothing/tie/storage/New()
	hold = new /obj/item/weapon/storage/pockets(src)
	hold.master_item = src
	hold.storage_slots = slots

/obj/item/clothing/tie/storage/attack_self(mob/user as mob)
	user << "<span class='notice'>You empty [src].</span>"
	var/turf/T = get_turf(src)
	hold.hide_from(usr)
	for(var/obj/item/I in hold.contents)
		hold.remove_from_storage(I, T)
	src.add_fingerprint(user)

/obj/item/clothing/tie/storage/attackby(obj/item/weapon/W as obj, mob/user as mob)
	hold.attackby(W,user)
	src.add_fingerprint(user)

/obj/item/weapon/storage/pockets
	name = "storage"
	var/master_item		//item it belongs to

/obj/item/weapon/storage/pockets/close(mob/user as mob)
	..()
	loc = master_item

/obj/item/clothing/tie/storage/webbing
	name = "webbing"
	desc = "Sturdy mess of synthcotton belts and buckles, ready to share your burden." //because nonsynth cotton is for chumps.
	icon_state = "webbing"
	item_color = "webbing"

/obj/item/clothing/tie/storage/black_vest
	name = "black webbing vest"
	desc = "Robust black synthcotton vest with lots of pockets to hold whatever you need, but cannot hold in hands."
	icon_state = "vest_black"
	item_color = "vest_black"
	slots = 5

/obj/item/clothing/tie/storage/brown_vest
	name = "brown webbing vest"
	desc = "Worn brownish synthcotton vest with lots of pockets to unload your hands."
	icon_state = "vest_brown"
	item_color = "vest_brown"
	slots = 5

//Naval Commando Helmet and Suit

/obj/item/clothing/head/helmet/space/rig/commando
	urist_only = 1
	name = "naval commando helmet"
	desc = "An extremely intimidating helmet worn by the Nanotrasen Naval Commandos"
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "rig0-commando"
	item_color = "commando"
	armor = list(melee = 65, bullet = 55, laser = 35,energy = 20, bomb = 30, bio = 30, rad = 30)


/obj/item/clothing/suit/space/rig/commando
	urist_only = 1
	name = "naval commando suit"
	desc = "A heavily armored suit that protects against moderate damage. Worn by the Nanotrasen Naval Commandos. It reeks of oppression."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "commando"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen,/obj/item/weapon/melee/energy/sword)
	slowdown = 1
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 30, rad = 30)

//Meido outfit, Pretty much Japanese for Maid outfit. I will most likely be doing more costumes. -Nien

/obj/item/clothing/suit/meido
	urist_only = 1
	name = "meido costume"
	desc = "A black maid costume."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "meido"
	item_state = "meido"
	body_parts_covered = CHEST|GROIN|ARMS

//Alternate detective gear from BS12, Noire as fuck.

/obj/item/clothing/under/det/black
	urist_only = 1
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "detalt"
	item_state = "detalt"
	item_color = "detalt"
	fitted = 0

/obj/item/clothing/under/det/slob
	urist_only = 1
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "polsuit"
	item_state = "polsuit"
	item_color = "polsuit"
	fitted = 0

/obj/item/clothing/under/det/slob/verb/rollup()
	set name = "Roll suit sleeves"
	set category = "Object"
	set src in usr
	item_color = item_color == "polsuit" ? "polsuit_rolled" : "polsuit"
	if (ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_w_uniform(1)

/obj/item/clothing/suit/storage/det_suit/black
	urist_only = 1
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "detective"

/obj/item/clothing/head/det_hat/black
	urist_only = 1
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "dethat"

//psychologist clothing

/obj/item/clothing/under/rank/psychologist
	urist_only = 1
	name = "psychologist's suit"
	desc = "A slightly weathered suit worn by the station's psychologist. Are those Cheesy Honker stains?" //you fukken slob
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "psychologist"
	item_state = "psychologist"
	item_color = "psychologist"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	fitted = 0

/obj/item/clothing/suit/psychologist
	urist_only = 1
	name = "tweed jacket"
	desc = "A tweed jacket worn by the station's psychologist. It looks a tad worn at the elbows."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "tweedjacket"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|GROIN|ARMS
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper)

	verb/toggle()
		set name = "Toggle Coat Buttons"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		switch(icon_state)
			if("tweedjacket_open")
				src.icon_state = "tweedjacket"
				usr << "You button up the jacket."
			if("tweedjacket")
				src.icon_state = "tweedjacket_open"
				usr << "You unbutton the jacket."
			else
				usr << "You attempt to button-up the velcro on your [src], before promptly realising how retarded you are."
				return
		usr.update_inv_wear_suit()	//so our overlays update

//More love for the detective. A shoulder holster

/obj/item/clothing/tie/holster
	urist_only = 1
	name = "shoulder holster"
	desc = "A handgun holster."
	icon = 'icons/urist/uristclothes.dmi'
	icon_state = "holster"
	item_color = "holster"
	var/obj/item/weapon/gun/holstered = null

//Terran Confederacy Trader outfit

/obj/item/clothing/under/terran
	urist_only = 1
	icon = 'icons/urist/uristclothes.dmi'

/obj/item/clothing/suit/terran
	urist_only = 1
	icon = 'icons/urist/uristclothes.dmi'

/obj/item/clothing/head/terran
	urist_only = 1
	icon = 'icons/urist/uristclothes.dmi'

/obj/item/clothing/under/terran/trader
	name = "Terran Confederacy trader's outfit"
	desc = "An opulant outfit worn by a Terran Confederacy trader"
	icon_state = "TCToutfit"
	item_state = "TCToutfit"
	item_color = "TCToutfit"

/obj/item/clothing/suit/terran/trader
	name = "Terran Confederacy trader's cloak"
	desc = "An opulant cloak worn by a Terran Confederacy trader"
	icon_state = "TCTRobes"
	item_state = "TCTRobes"
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/head/terran/trader
	name = "Terran Confederacy trader's hat"
	desc = "An opulant hat worn by a Terran Confederacy trader"
	icon_state = "TCTHat"
	item_state = "TCTHat"