//Special thinks to Rob for getting the code to work.

/obj/structure/stool/bed/chair/bike
	name = "bike"
	icon = 'icons/obj/uristvehicles.dmi'
	icon_state = "bike"
	anchored = 0
	density = 1
	var/callme = "bike"	//how do people refer to it?


/obj/structure/stool/bed/chair/bike/New()
	handle_rotation()


/obj/structure/stool/bed/chair/bike/examine()
	set src in usr
	usr << "A Nanotrasen bike."

/obj/structure/stool/bed/chair/bike/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle()

	if(iscarbon(user)) //Nothing else is likely to be riding the bike - RR

		var/mob/living/carbon/C = user
		var/Current_Location = get_turf(C)

		if(istype(Current_Location, /turf/space)) //Wheels don't spin against nothing, no friction = no movement, Physics'd - RR
			C << "<span clas='danger'>You peddle as fast as you can but there's no ground for the wheel to push against!</span>"
			return

	step(src, direction)
	update_mob()
	handle_rotation()

/obj/structure/stool/bed/chair/bike/Move()
	..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = loc


/obj/structure/stool/bed/chair/bike/buckle_mob(mob/M, mob/user)
	if(M != user || !ismob(M) || get_dist(src, user) > 1 || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon))
		return

	unbuckle()

	M.visible_message(\
		"<span class='notice'>[M] climbs onto the [callme]!</span>",\
		"<span class='notice'>You climb onto the [callme]!</span>")
	M.buckled = src
	M.loc = loc
	M.dir = dir
	M.update_canmove()
	buckled_mob = M
	update_mob()
	add_fingerprint(user)


/obj/structure/stool/bed/chair/bike/unbuckle()
	if(buckled_mob)
		buckled_mob.pixel_x = 0
		buckled_mob.pixel_y = 0
	..()


/obj/structure/stool/bed/chair/bike/handle_rotation()
	if(dir == SOUTH)
		layer = FLY_LAYER
	else
		layer = OBJ_LAYER

	if(buckled_mob)
		if(buckled_mob.loc != loc)
			buckled_mob.buckled = null //Temporary, so Move() succeeds.
			buckled_mob.buckled = src //Restoring

	update_mob()

/obj/structure/stool/bed/chair/bike/proc/update_mob()
	if(buckled_mob)
		buckled_mob.dir = dir


/obj/structure/stool/bed/chair/bike/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob)
		buckled_mob.bullet_act(Proj) //Cause the rider to use their normal Bullet_act - RR
