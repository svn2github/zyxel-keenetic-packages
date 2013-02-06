-- Prosody Example Configuration File
-- 
-- Information on configuring Prosody can be found on our
-- website at http://prosody.im/doc/configure
-- 
-- Tip: You can check that the syntax of this file is correct
-- when you have finished by running: luac -p prosody.cfg.lua
-- If there are any errors, it will let you know what and where
-- they are, otherwise it will keep quiet.
--
-- The only thing left to do is rename this file to remove the .dist ending, and fill in the
-- blanks. Good luck, and happy Jabbering!

run_as_root = true

---------- Server-wide settings ----------
-- Settings in this section apply to the whole server and are the default settings
-- for any virtual hosts

-- This is a (by default, empty) list of accounts that are admins
-- for the server. Note that you must create the accounts separately
-- (see http://prosody.im/doc/creating_accounts for info)
-- Example: admins = { "user1@example.com", "user2@example.net" }
admins = { }

-- This is the list of modules Prosody will load on startup.
-- It looks for mod_modulename.lua in the plugins folder, so make sure that exists too.
modules_enabled = {

	-- Generally required
		"roster"; -- Allow users to have a roster. Recommended ;)
		"saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
		"tls"; -- Add support for secure TLS on c2s/s2s connections
		"dialback"; -- s2s dialback support
		"disco"; -- Service discovery
	
	-- Not essential, but recommended
		"private"; -- Private XML storage (for room bookmarks, etc.)
		"vcard"; -- Allow users to set vCards
	
	-- Nice to have
		"legacyauth"; -- Legacy authentication. Only used by some old clients and bots.
		"version"; -- Replies to server version requests
		"uptime"; -- Report how long server has been running
		"time"; -- Let others know the time here on this server
		"ping"; -- Replies to XMPP pings with pongs
		"pep"; -- Enables users to publish their mood, activity, playing music and more
		"register"; -- Allow users to register on this server using a client and change passwords
	
	-- Other specific functionality
		--"posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
		--"console"; -- Opens admin telnet interface on localhost port 5582
		--"bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
		--"httpserver"; -- Serve static files from a directory over HTTP
};

-- These modules are auto-loaded, should you
-- for (for some mad reason) want to disable
-- them then uncomment them below
modules_disabled = {
	-- "presence";
	-- "message";
	-- "iq";
};

-- Disable account creation by default, for security
-- For more information see http://prosody.im/doc/creating_accounts
allow_registration = false;

-- File to write pid in
pidfile = "/media/DISK_A1/system/var/run/prosody/prosody.pid";

-- These are the SSL/TLS-related settings. If you don't want
-- to use SSL/TLS, you may comment or remove this
ssl = {
	key = "/media/DISK_A1/system/etc/prosody/certs/localhost.key";
	certificate = "/media/DISK_A1/system/etc/prosody/certs/localhost.cert";
}

-- Errors to syslog
-- All to /var/log/prosody/
log = {
	{ levels = { "error" }; to = "syslog";  };
	{ levels = { "error" }; to = "file"; filename = "/meida/DISK_A1/system/var/log/prosody/prosody.err";  };
	-- Change "info" to "debug" for more verbose logging
	{ levels = { min = "info" }; to = "file"; filename = "/media/DISK_A1/system/var/log/prosody/prosody.log";  };
}

----------- Virtual hosts -----------
-- You need to add a VirtualHost entry for each domain you wish Prosody to serve.
-- Settings under each VirtualHost entry apply *only* to that host.

VirtualHost "localhost"

VirtualHost "example.com"
	enabled = false -- Remove this line to enable this host

	-- Assign this host a certificate for TLS, otherwise it would use the one
	-- set in the global section (if any).
	-- Note that old-style SSL on port 5223 only supports one certificate, and will always
	-- use the global one.
	ssl = { 
		key = "/etc/prosody/certs/example.com.key";
		certificate = "/etc/prosody/certs/example.com.crt";
		}

------ Components ------
-- You can specify components to add hosts that provide special services,
-- like multi-user conferences, and transports.
-- For more information on components, see http://prosody.im/doc/components

---Set up a MUC (multi-user chat) room server on conference.example.com:
--Component "conference.example.com" "muc"

---Set up an external component (default component port is 5347)
--Component "gateway.example.com"
--	component_secret = "password"
