datum/computer/file/embedded_program
	var/list/memory = list()
	var/state
	var/obj/machinery/embedded_controller/master

	proc
		post_signal(datum/signal/signal, comm_line)
			if(master)
				master.post_signal(signal, comm_line)
			else
				del(signal)

		receive_user_command(command)

		receive_signal(datum/signal/signal, receive_method, receive_param)
			return null

		process()
			return 0

obj/machinery/embedded_controller
	var/datum/computer/file/embedded_program/program

	name = "embedded controller"
	density = 0
	anchored = 1

	var/on = 1

	interact(mob/user as mob)
		//user << browse(return_text(), "window=computer")
		//onclose(user, "computer")
		user.set_machine(src)
		var/datum/browser/popup = new(user, "computer", name) // Set up the popup browser window
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.set_content(return_text())
		popup.open()

	attack_hand(mob/user as mob)
		interact(user)

	update_icon()
	proc/return_text()

	proc/post_signal(datum/signal/signal, comm_line)
		return 0

	receive_signal(datum/signal/signal, receive_method, receive_param)
		if(!signal || signal.encryption) return

		if(program)
			program.receive_signal(signal, receive_method, receive_param)
			//spawn(5) program.process() //no, program.process sends some signals and machines respond and we here again and we lag -rastaf0

	Topic(href, href_list)
		if(..())
			return 0

		if(program)
			program.receive_user_command(href_list["command"])
			spawn(5) program.process()

		usr.set_machine(src)
		spawn(5) src.updateDialog()

	process()
		if(program)
			program.process()

		update_icon()
		src.updateDialog()

	radio
		var/frequency
		var/datum/radio_frequency/radio_connection

		initialize()
			set_frequency(frequency)

		post_signal(datum/signal/signal)
			signal.transmission_method = TRANSMISSION_RADIO
			if(radio_connection)
				return radio_connection.post_signal(src, signal)
			else
				signal = null

		proc
			set_frequency(new_frequency)
				radio_controller.remove_object(src, frequency)
				frequency = new_frequency
				radio_connection = radio_controller.add_object(src, frequency)