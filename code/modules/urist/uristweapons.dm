/*										*****New space to put all UristMcStation Weapons*****

Please keep it tidy, by which I mean put comments describing the item before the entry. -Glloyd */


//Welder machete, icons by ShoesandHats, object by Cozarctan

/obj/item/weapon/machete
	urist_only = 1
	name = "machete"
	desc = "a large blade beloved by sugar farmers and mass murderers"
	icon = 'icons/uristicons.dmi'
	icon_state = "machete"
	item_state = "machete"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	force = 20
	throwforce = 10
	w_class = 3
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("cleaved", "slashed", "sliced", "torn", "ripped", "diced", "cut")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return(BRUTELOSS)

/obj/item/weapon/machete/IsShield()
		return 1

//Energy pistol, It's like an energy gun it can be put in a pocket and has less shots

/obj/item/weapon/gun/energy/gun/small
	urist_only = 1
	name = "energy pistol"
	desc = "A small energy pistol fitted with a nice wooden handle that can be set to two mode, Kill and stun."
	icon = 'icons/uristguns.dmi'
	icon_state = "senergystun100"
	item_state = "gun"
	fire_sound = 'sound/weapons/Taser.ogg'
	w_class = 1
	charge_cost = 150 //How much energy is needed to fire.
	projectile_type = "/obj/item/projectile/energy/electrode"
	origin_tech = "combat=2;magnets=2"
	modifystate = "senergystun"

	mode = 0 //0 = stun, 1 = kill


	attack_self(mob/living/user as mob)
		switch(mode)
			if(0)
				mode = 1
				charge_cost = 150
				fire_sound = 'sound/weapons/Laser.ogg'
				user << "\red [src.name] is now set to kill."
				projectile_type = "/obj/item/projectile/beam"
				modifystate = "senergykill"
			if(1)
				mode = 0
				charge_cost = 150
				fire_sound = 'sound/weapons/Taser.ogg'
				user << "\red [src.name] is now set to stun."
				projectile_type = "/obj/item/projectile/energy/electrode"
				modifystate = "senergystun"
		update_icon()

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is unloading the [src.name] into their head!</b>"
		return(BRUTELOSS)