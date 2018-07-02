client

	New()
		setup_admin()
		GLOB.clients += src
		return ..()

	Del()
		GLOB.clients -= src
		return ..()