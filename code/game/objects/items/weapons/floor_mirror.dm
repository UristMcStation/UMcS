//wip wip wup
/obj/structure/mirror/floor_mirror
	name = "floor mirror"
	desc = "A wooden floor mirror"
	icon = 'icons/obj/structures.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 0

/obj/structure/mirror/floor_mirror/attack_hand(mob/user as mob)
	if(shattered)	return

/obj/structure/mirror/floor_mirror/attack_hand(mob/user as mob)
	if(shattered)	return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		var/userloc = H.loc

		//see code/modules/mob/new_player/preferences.dm at approx line 545 for comments!
		//this is largely copypasted from there.

		//handle facial hair (if necessary)
		if(H.gender == MALE)
			var/new_style = input(user, "Select a facial hair style", "Grooming")  as null|anything in facial_hair_styles_list
			if(userloc != H.loc) return	//no tele-grooming
			if(new_style)
				H.f_style = new_style
		else
			H.f_style = "Shaved"

		//handle normal hair
		var/new_style = input(user, "Select a hair style", "Grooming")  as null|anything in hair_styles_list
		if(userloc != H.loc) return	//no tele-grooming
		if(new_style)
			H.h_style = new_style

		H.update_hair()

