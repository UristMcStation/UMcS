/obj/item/datacube
	name ="Datacube"
	desc = "Research data in compressed form"
	icon = 'icons/uristmob/research2.dmi'
	icon_state = "cube"
	throwforce = 5
	w_class = 1.0
	throw_speed = 4
	throw_range = 10
	flags = FPRINT | TABLEPASS| CONDUCT
	origin_tech = "magnets=1"



/obj/machinery/computer/research_booster
	name = "Research Station"
	icon = 'icons/obj/computer.dmi'
	icon_state = "rdcomp"
	var/obj/subject = null
	var/working = 0
	var/tries = 5
	var/list/previous = list()
	var/code = "ABCDABCD"
	var/guess = "AAAAAAAA"

	var/const/CODE_LEN = 8
	var/const/MAX_TRIES = 5
	var/const/LAST_LETTER = "D"


/obj/machinery/computer/research_booster/attackby(obj/item/W as obj, mob/user as mob)

	if(working)
		user << "The [src.name] is already processing another technology."
		return
	if(subject!=null)
		user << "There is already something inside [src.name]."
		return
	if(!W.origin_tech)
		user << "\red This doesn't seem to have a tech origin!"
		return
	user.drop_item()
	W.loc = src
	subject = W
	user << "You insert [W]."
	src.updateUsrDialog()

/obj/machinery/computer/research_booster/proc/mastermind_new()
	var/result = ""
	var/list/letters = new
	for(var/i=text2ascii("A"),i<=text2ascii(LAST_LETTER),i++)
		letters.Add(ascii2text(i))
	for(var/i=0,i<CODE_LEN,i++)
		result+=pick(letters)

	return result

/obj/machinery/computer/research_booster/proc/mastermind_eval(guess,current)
	var/result = 0
	for(var/i=1,i<=CODE_LEN,i++)
		if(copytext(guess,i,i+1)==copytext(current,i,i+1))
			result++
	return result

/obj/machinery/computer/research_booster/proc/make_reward(var/obj/target)
	var/obj/item/datacube/result = new


	var/list/temp_list = params2list(target.origin_tech)
	for(var/O in temp_list)
		temp_list[O] = text2num(temp_list[O])+1

	result.origin_tech = list2params(temp_list)

	return result


/obj/machinery/computer/research_booster/attack_hand(mob/user as mob)
	user.set_machine(src)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	var/dat = ""
	dat += "<a href='byond://?src=\ref[src];refresh=1'>Refresh</a>"


	if(!isnull(subject))
		dat += "<h3>Research Subject: [subject.name] </h3>"
	else
		dat += "<h3>Research Subject: None </h3>"

	if(!working)
		dat += "<a href='byond://?src=\ref[src];start=1'>Start Research</a>"
	else
		for(var/a in previous)
			dat += "[a] : [src.mastermind_eval(src.code,a)]/[CODE_LEN] <br>"

		//Temp
		for(var/i=1,i<=CODE_LEN,i++)
			var/letter = copytext(guess,i,i+1)
			dat += "<a href='byond://?src=\ref[src];flip=[i]'>[letter]</a>"


		dat += "<a href='byond://?src=\ref[src];submit=1'>Decrypt</a>"

	var/datum/browser/popup = new(user, "research", "Research Console Interface")
	popup.set_content(dat)
	popup.open()
	return


/obj/machinery/computer/research_booster/Topic(href, href_list)
	if(..())
		return


	if ((href_list["start"]) && (!isnull(subject))) // New game
		tries = MAX_TRIES
		del(previous)
		previous = new/list
		working = 1
		code = mastermind_new()
	else if (href_list["submit"])
		tries--
		if(mastermind_eval(guess,code)==CODE_LEN)
			var/obj/item/datacube/reward = make_reward(subject)
			reward.loc = src.loc
			del(subject)
			working = 0
		else
			previous.Add(guess)
			if(tries==0)
				del(subject)
				working = 0
	else if (href_list["flip"])
		var/i = text2num(href_list["flip"])
		var/next_num = text2ascii(copytext(guess,i,i+1))+1
		var/next = next_num>text2ascii(LAST_LETTER)? "A" : ascii2text(next_num)
		var/n_guess = ""
		if(i>1)
			n_guess += copytext(guess,1,i)

		n_guess += next

		if(i<CODE_LEN)
			n_guess += copytext(guess,i+1)

		guess = n_guess

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return




