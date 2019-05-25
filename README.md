# Foscam Archiver (for home NAS servers/appliances)
Automatically collect/backup from Foscam SD-card storage to most NAS setups

# The problem
To my knowledge, most (all?) modern Foscams have a built-in ftp-upload feature that one can use to point to an ftp server running on their home NAS... **but** this option has an unavoidable failing: uploaded videos have no audio!!  (Why!?!!?)

# The motivation
If, instead, your camera is configured to save media to a removeable SD-card, these files *do* have audio. Physically removing the SD-card is an unacceptable pain, but it IS possible to access its contents over your home network! (well, probably. I can't speak for all camera models.)

As one example, the Foscam C1, has a quasi-secret built-in FTP **server** we can use. (Note this is entirely different from the ftp-upload *client* feature.) This feature is exposed when you "manage" your SD Card from the C1's webgui: `[webgui:88] > Settings tab (on top) > Record tab (on left) > SD Card Management > "SD Card Management" button`. This button silently starts the camera's FTP server, then opens a Windows Explorer FTP-browser URL to port 50021 of your camera.

Using this, we can automate the archiving process using some basic unix/linux tools.

# Tools involved

* your NAS for the archive storage
* the "Lftp" binary to manage the mirroring operation
* the "curl" binary to send the start-ftp command
* one or two scripts to config/run these binaries
* crontab (or your NAS's built in task scheduler) to regularly grab new files

## Installing these tools on FreeNAS / in a FreeNAS jail

I prefer to install non-server-essential junk outside the main OS, in a jail, but you don't have to. Doing so with a jail will definitely require you install some things manually so it's a better instructional starting point:

* Open a jail console (if using a jail) or SSH shell
  * use `sudo` prefixing if you aren't root
  * `pkg update` to update the FreeBSD repository catalogue
  * `pkg install curl` to install curl (used to start an unstarted FTP server on the foscam)
  * `pkg install lftp` to install lftp (which will manage all mirroring)
* choose/prepare your script(s)
* schedule a task
  * use crontab inside a jail, or
  * use FreeNAS's scheduler if you didn't use a jail, or
  * use FreeNAS's scheduler to send an SSH command to the jail (requires your jail also have SSH access conf'd)
