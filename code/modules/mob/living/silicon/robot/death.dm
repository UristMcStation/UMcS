/mob/living/silicon/robot/gib(var/animation = 1)
	..()

/mob/living/silicon/robot/spawn_gibs()
	robogibs(loc, viruses)

/mob/living/silicon/robot/gib_animation(var/animate)
	..(animate, "gibbed-r")

/mob/living/silicon/robot/dust(var/animation = 1)
	if(mmi)
		del(mmi)
	..()

/mob/living/silicon/robot/spawn_dust()
	new /obj/effect/decal/remains/robot(loc)

/mob/living/silicon/robot/dust_animation(var/animate)
	..(animate, "dust-r")

/mob/living/silicon/robot/death(gibbed)
	if(stat == DEAD)	return
	if(!gibbed)
		emote("deathgasp")
	stat = DEAD
	update_canmove()
	if(camera)
		camera.status = 0

	uneq_all() // particularly to ensure sight modes are cleared

	if(blind)	blind.layer = 0
	sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO
	updateicon()
	update_fire()
	tod = worldtime2text() //weasellos time of death patch
	if(mind)	mind.store_memory("Time of death: [tod]", 0)

	sql_report_cyborg_death(src)

	return ..(gibbed)