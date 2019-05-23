# Foscam Archiver (for home NAS servers/appliances)
Automatically collect/backup from Foscam SD-card storage to most NAS setups

# The problem
To my knowledge, most (all?) modern Foscams have a built-in ftp-upload feature that one can use to point to an ftp server running on their home NAS... **but** this option has an unavoidable failing: uploaded videos have no audio!!  (Why!?!!?)

# The solution
As one example, the Foscam C1, has a quasi-secret built-in FTP **server** we can use. (Note this is entirely different from the ftp-upload *client* feature.) This feature is exposed when you "manage" your SD Card from the C1's webgui: [webgui:88] > Settings tab (on top) > Record tab (on left) > SD Card Management > "SD Card Management" button. This button silently starts the camera's FTP server, then opens a Windows Explorer FTP-browser URL to port 50021 of your camera.

Using this, we can automate the archiving process using some basic unix/linux tools.

# Tools involved

* the "Lftp" binary to manage the mirroring operation
* the "curl" binary to send the start-ftp command
* one or two scripts to config/run these binaries
* crontab (or your NAS's built in task scheduler) to regularly grab new files
