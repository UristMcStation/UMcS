//Necromorphs. Meant to do this a while ago, icons by nien.

/mob/living/simple_animal/hostile/necromorph
	name = "necromorph"
	desc = "Reanimated corpses of the dead, reshaped into horrific new forms by a recombinant extraterrestrial infection."
	speak_emote = list("screeches")
	icon = 'icons/uristicons.dmi'
	icon_state = "necro_s"
	icon_living = "necro_s"
	icon_dead = "necro_d"
	health = 40
	maxHealth = 40
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "slashes"
	attack_sound = 'sound/weapons/slash.ogg'
	faction = "creature"

/mob/living/simple_animal/hostile/necromorph/baby
	name = "baby necromorph"
	ranged = 1
	icon = 'icons/uristicons.dmi'
	icon_state = "baby_necro"
	icon_dead = "b_necro_l"
	health = 20
	maxHealth = 20
	projectilesound = 'sound/weapons/Gunshot_smg.ogg'
	projectiletype = /obj/item/projectile/bullet/weakbullet
