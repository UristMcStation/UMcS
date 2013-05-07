
/obj/machinery/computer/cloning
	name = "Cloning Console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "dna"
	circuit = "/obj/item/weapon/circuitboard/cloning"
	req_access = list(access_heads) //Only used for record deletion right now.
	var/obj/machinery/dna_scannernew/scanner = null //Linked scanner. For scanning.
	var/obj/machinery/clonepod/pod1 = null //Linked cloning pod.
	var/temp = "Inactive"
	var/scantemp_ckey
	var/scantemp = "Ready to Scan"
	var/menu = 1 //Which menu screen to display
	var/list/records = list()
	var/datum/data/record/active_record = null
	var/obj/item/weapon/disk/data/diskette = null //Mostly so the geneticist can steal everything.
	var/loading = 0 // Nice loading text

/obj/machinery/computer/cloning/New()
	..()
	spawn(5)
		updatemodules()
		return
	return

/obj/machinery/computer/cloning/proc/updatemodules()
	src.scanner = findscanner()
	src.pod1 = findcloner()

	if (!isnull(src.pod1))
		src.pod1.connected = src // Some variable the pod needs

/obj/machinery/computer/cloning/proc/findscanner()
	var/obj/machinery/dna_scannernew/scannerf = null

	// Loop through every direction
	for(dir in list(NORTH,EAST,SOUTH,WEST))

		// Try to find a scanner in that direction
		scannerf = locate(/obj/machinery/dna_scannernew, get_step(src, dir))

		// If found, then we break, and return the scanner
		if (!isnull(scannerf))
			break

	// If no scanner was found, it will return null
	return scannerf

/obj/machinery/computer/cloning/proc/findcloner()
	var/obj/machinery/clonepod/podf = null

	for(dir in list(NORTH,EAST,SOUTH,WEST))

		podf = locate(/obj/machinery/clonepod, get_step(src, dir))

		if (!isnull(podf))
			break

	return podf

/obj/machinery/computer/cloning/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/disk/data)) //INSERT SOME DISKETTES
		if (!src.diskette)
			user.drop_item()
			W.loc = src
			src.diskette = W
			user << "You insert [W]."
			src.updateUsrDialog()
			return
	else
		..()
	return

/obj/machinery/computer/cloning/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/cloning/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/cloning/attack_hand(mob/user as mob)
	user.set_machine(src)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	updatemodules()

	var/dat = ""
	dat += "<a href='byond://?src=\ref[src];refresh=1'>Refresh</a>"

	dat += "<h3>Cloning Pod Status</h3>"
	dat += "<div class='statusDisplay'>[temp]&nbsp;</div>"

	switch(src.menu)
		if(1)
			// Modules
			if (isnull(src.scanner) || isnull(src.pod1))
				dat += "<h3>Modules</h3>"
				//dat += "<a href='byond://?src=\ref[src];relmodules=1'>Reload Modules</a>"
				if (isnull(src.scanner))
					dat += "<font class='bad'>ERROR: No Scanner detected!</font><br>"
				if (isnull(src.pod1))
					dat += "<font class='bad'>ERROR: No Pod detected</font><br>"

			// Scanner
			if (!isnull(src.scanner))

				dat += "<h3>Scanner Functions</h3>"

				dat += "<div class='statusDisplay'>"
				if (!src.scanner.occupant)
					dat += "Scanner Unoccupied"
				else if(loading)
					dat += "[src.scanner.occupant] => Scanning..."
				else
					if (src.scanner.occupant.ckey != scantemp_ckey)
						scantemp = "Ready to Scan"
						scantemp_ckey = src.scanner.occupant.ckey
					dat += "[src.scanner.occupant] => [scantemp]"
				dat += "</div>"

				if (src.scanner.occupant)
					dat += "<a href='byond://?src=\ref[src];scan=1'>Start Scan</a>"
					dat += "<br><a href='byond://?src=\ref[src];lock=1'>[src.scanner.locked ? "Unlock Scanner" : "Lock Scanner"]</a>"
				else
					dat += "<span class='linkOff'>Start Scan</span>"

			// Database
			dat += "<h3>Database Functions</h3>"
			if (src.records.len && src.records.len > 0)
				dat += "<a href='byond://?src=\ref[src];menu=2'>View Records ([src.records.len])</a><br>"
			else
				dat += "<span class='linkOff'>View Records (0)</span><br>"
			if (src.diskette)
				dat += "<a href='byond://?src=\ref[src];disk=eject'>Eject Disk</a><br>"



		if(2)
			dat += "<h3>Current records</h3>"
			dat += "<a href='byond://?src=\ref[src];menu=1'><< Back</a><br><br>"
			for(var/datum/data/record/R in src.records)
				dat += "<h4>[R.fields["name"]]</h4>Scan ID [R.fields["id"]] <a href='byond://?src=\ref[src];view_rec=\ref[R]'>View Record</a>"
		if(3)
			dat += "<h3>Selected Record</h3>"
			dat += "<a href='byond://?src=\ref[src];menu=2'><< Back</a><br>"

			if (!src.active_record)
				dat += "<font class='bad'>Record not found.</font>"
			else
				dat += "<h4>[src.active_record.fields["name"]]</h4>"
				dat += "Scan ID [src.active_record.fields["id"]] <a href='byond://?src=\ref[src];clone=\ref[src.active_record]'>Clone</a><br>"

				var/obj/item/weapon/implant/health/H = locate(src.active_record.fields["imp"])

				if ((H) && (istype(H)))
					dat += "<b>Health Implant Data:</b><br />[H.sensehealth()]<br><br />"
				else
					dat += "<font class='bad'>Unable to locate Health Implant.</font><br /><br />"

				dat += "<b>Unique Identifier:</b><br /><span class='highlight'>[src.active_record.fields["UI"]]</span><br>"
				dat += "<b>Structural Enzymes:</b><br /><span class='highlight'>[src.active_record.fields["SE"]]</span><br>"

				if(diskette && diskette.fields)
					dat += "<div class='block'>"
					dat += "<h4>Inserted Disk</h4>"
					dat += "<b>Contents:</b> "
					var/list/L = list()
					if(diskette.fields["UI"])
						L += "Unique Identifier"
					if(diskette.fields["UE"] && diskette.fields["name"] && diskette.fields["b_type"])
						L += "Unique Enzymes"
					if(diskette.fields["SE"])
						L += "Structural Enzymes"
					dat += english_list(L, "Empty", " + ", " + ")
					dat += "<br /><a href='byond://?src=\ref[src];disk=load'>Load from Disk</a>"

					dat += "<br /><a href='byond://?src=\ref[src];disk=save'>Save to Disk</a>"
					dat += "</div>"

				dat += "<font size=1><a href='byond://?src=\ref[src];del_rec=1'>Delete Record</a></font>"

		if(4)
			if (!src.active_record)
				src.menu = 2
			dat = "[src.temp]<br>"
			dat += "<h3>Confirm Record Deletion</h3>"

			dat += "<b><a href='byond://?src=\ref[src];del_rec=1'>Scan card to confirm.</a></b><br>"
			dat += "<b><a href='byond://?src=\ref[src];menu=3'>Cancel</a></b>"


	//user << browse(dat, "window=cloning")
	//onclose(user, "cloning")
	var/datum/browser/popup = new(user, "cloning", "Cloning System Control")
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/machinery/computer/cloning/Topic(href, href_list)
	if(..())
		return

	if(loading)
		return

	if ((href_list["scan"]) && (!isnull(src.scanner)))
		scantemp = ""

		loading = 1
		src.updateUsrDialog()

		spawn(20)
			src.scan_mob(src.scanner.occupant)

			loading = 0
			src.updateUsrDialog()


		//No locking an open scanner.
	else if ((href_list["lock"]) && (!isnull(src.scanner)))
		if ((!src.scanner.locked) && (src.scanner.occupant))
			src.scanner.locked = 1
		else
			src.scanner.locked = 0

	else if (href_list["view_rec"])
		src.active_record = locate(href_list["view_rec"])
		if(istype(src.active_record,/datum/data/record))
			if (!active_record.fields["ckey"])
				del(src.active_record)
				src.temp = "<font class='bad'>Record Corrupt</font>"
			else
				src.menu = 3
		else
			src.active_record = null
			src.temp = "Record missing."

	else if (href_list["del_rec"])
		if ((!src.active_record) || (src.menu < 3))
			return
		if (src.menu == 3) //If we are viewing a record, confirm deletion
			src.temp = "Delete record?"
			src.menu = 4

		else if (src.menu == 4)
			var/obj/item/weapon/card/id/C = usr.get_active_hand()
			if (istype(C)||istype(C, /obj/item/device/pda))
				if(src.check_access(C))
					src.temp = "[src.active_record.fields["name"]] => Record deleted."
					src.records.Remove(src.active_record)
					del(src.active_record)
					src.menu = 2
				else
					src.temp = "<font class='bad'>Access Denied.</font>"

	else if (href_list["disk"]) //Load or eject.
		switch(href_list["disk"])
			if("load")
				if (!diskette || !istype(diskette.fields) || !diskette.fields["name"] || !diskette.fields)
					src.temp = "<font class='bad'>Load error.</font>"
					src.updateUsrDialog()
					return
				if (!src.active_record)
					src.temp = "<font class='bad'>Record error.</font>"
					src.menu = 1
					src.updateUsrDialog()
					return
				
				src.active_record.fields = diskette.fields.Copy()
				src.temp = "Load successful."
			
			if("eject")
				if(src.diskette)
					src.diskette.loc = src.loc
					src.diskette = null
			if("save")
				if(!diskette || diskette.read_only || !active_record || !active_record.fields)
					src.temp = "<font class='bad'>Save error.</font>"
					src.updateUsrDialog()
					return	
				
				diskette.fields = active_record.fields.Copy()
				diskette.name = "data disk - '[src.diskette.fields["name"]]'"
				src.temp = "Save successful."

	else if (href_list["refresh"])
		src.updateUsrDialog()

	else if (href_list["clone"])
		var/datum/data/record/C = locate(href_list["clone"])
		//Look for that player! They better be dead!
		if(istype(C))
			//Can't clone without someone to clone.  Or a pod.  Or if the pod is busy. Or full of gibs.
			if(!pod1)
				temp = "<font class='bad'>No Clonepod detected.</font>"
			else if(pod1.occupant)
				temp = "<font class='bad'>Clonepod is currently occupied.</font>"
			else if(pod1.mess)
				temp = "<font class='bad'>Clonepod malfunction.</font>"
			else if(!config.revival_cloning)
				temp = "<font class='bad'>Unable to initiate cloning cycle.</font>"
			else if(pod1.growclone(C.fields["ckey"], C.fields["name"], C.fields["UI"], C.fields["SE"], C.fields["mind"], C.fields["mrace"]))
				temp = "[C.fields["name"]] => <font class='good'>Cloning cycle in progress...</font>"
				records.Remove(C)
				del(C)
				menu = 1
			else
				temp = "[C.fields["name"]] => <font class='bad'>Initialisation failure.</font>"

		else
			temp = "<font class='bad'>Data corruption.</font>"

	else if (href_list["menu"])
		src.menu = text2num(href_list["menu"])

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/machinery/computer/cloning/proc/scan_mob(mob/living/carbon/human/subject as mob)
	if (!check_dna_integrity(subject) || !istype(subject))
		scantemp = "<font class='bad'>Unable to locate valid genetic data.</font>"
		return
	if (!getbrain(subject))
		scantemp = "<font class='bad'>No signs of intelligence detected.</font>"
		return
	if (subject.suiciding == 1)
		scantemp = "<font class='bad'>Subject's brain is not responding to scanning stimuli.</font>"
		return
	if ((!subject.ckey) || (!subject.client))
		scantemp = "<font class='bad'>Mental interface failure.</font>"
		return
	if (NOCLONE in subject.mutations)
		scantemp = "<font class='bad'>Mental interface failure.</font>"
		return
	if (!isnull(find_record(subject.ckey)))
		scantemp = "<font class='average'>Subject already in database.</font>"
		return

	var/datum/data/record/R = new /datum/data/record()
	if(subject.dna)
		R.fields["mrace"] = subject.dna.mutantrace
	else
		R.fields["mrace"] = null
	R.fields["ckey"] = subject.ckey
	R.fields["name"] = subject.real_name
	R.fields["id"] = copytext(md5(subject.real_name), 2, 6)
	R.fields["UE"] = subject.dna.unique_enzymes
	R.fields["UI"] = subject.dna.uni_identity
	R.fields["SE"] = subject.dna.struc_enzymes

	//Add an implant if needed
	var/obj/item/weapon/implant/health/imp = locate(/obj/item/weapon/implant/health, subject)
	if (isnull(imp))
		imp = new /obj/item/weapon/implant/health(subject)
		imp.implanted = subject
		R.fields["imp"] = "\ref[imp]"
	//Update it if needed
	else
		R.fields["imp"] = "\ref[imp]"

	if (!isnull(subject.mind)) //Save that mind so traitors can continue traitoring after cloning.
		R.fields["mind"] = "\ref[subject.mind]"

	src.records += R
	scantemp = "Subject successfully scanned."

//Find a specific record by key.
/obj/machinery/computer/cloning/proc/find_record(var/find_key)
	var/selected_record = null
	for(var/datum/data/record/R in src.records)
		if (R.fields["ckey"] == find_key)
			selected_record = R
			break
	return selected_record

/obj/machinery/computer/cloning/update_icon()

	if(stat & BROKEN)
		icon_state = "commb"
	else
		if(stat & NOPOWER)
			src.icon_state = "c_unpowered"
			stat |= NOPOWER
		else
			icon_state = initial(icon_state)
			stat &= ~NOPOWER