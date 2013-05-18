/*
Envelopes are containers that can be sent through the disposal mail system once
Envelopes can be sealed and opened with a click
Sealed envelopes work like wrapped packages: they can be tagged with a destination scanner, written on, and delivered by disposal mail
Used envelopes function like small containers: they can't be tagged, and if sent through the delivery shoot they will go to disposals
New envelopes can be pretaagged with a destination, but they'll simply loop through the mail office until they've been sealed.
*/

/obj/item/weapon/storage/envelope
	name = "envelope"
	desc = "A small white envelope"
	icon_state = "envelope0"
	w_class = 1.0
	can_hold = list("/obj/item/weapon/paper")
	storage_slots = 4
	var/sealed = 0 //0 for a new envelope, 1 for a sealed envelope, 2 for a used envelope
	var/sortTag
	var/ident = "envelope"
	var/N = 0 //stores the envelope's destination until it's been sealed

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/device/destTagger))
			if(sealed != 2)
				var/obj/item/device/destTagger/O = W
				if(N != O.currTag)
					var/tag = uppertext(TAGGERLOCATIONS[O.currTag])
					user << "\blue *[tag]*"
					N = O.currTag
					if(sealed == 1)
						sortTag = N
					playsound(loc, 'sound/machines/twobeep.ogg', 100, 1)
			else
				user << "The [name] can't be sent; it's only good as garbage now."

		else if(istype(W, /obj/item/weapon/pen) && sealed == 1)
			var/str = copytext(sanitize(input(user,"Label text?","Set label","")),1,MAX_NAME_LEN)
			if(!str || !length(str))
				user << "<span class='notice'>Invalid text.</span>"
				return
			user.visible_message("<span class='notice'>[user] labels [src] as [str].</span>")
			name = "[name] ([str])"

		else
			..()

	attack_self(mob/user as mob)
		if(sealed == 0) //sealing the envelope
			sealed = 1
			sortTag = N
			icon_state = "[ident]1"
			user.visible_message("<span class='notice'>[user] licks the [name] and seal it shut.</span>")
		else if(sealed == 1) //opening the envelope
			sealed = 2
			sortTag = 0
			icon_state = "[ident]0"
			name = "used [name]"
			user.visible_message("<span class='notice'>[user] rips open the [name].</span>")
		else if(sealed == 2) //envelopes are one use only
			user << "The [name] can't be resealed."
		..()

	attack_hand(mob/user)
		if(sealed == 1 && src.loc == user)
			user << "The [name] is sealed. You need to open it first."
		else
			..()

/obj/item/weapon/storage/envelope/manilla
	name = "manilla envelope"
	desc = "A larger manilla envelope"
	icon_state = "manilla0"
	w_class = 2.0
	can_hold = list()
	max_w_class = 1
	max_combined_w_class = 4
	ident = "manilla"