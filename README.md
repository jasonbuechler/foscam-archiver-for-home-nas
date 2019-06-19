# Foscam Archiver (for home NAS servers/appliances, or Windows)
Automatically collect/backup from Foscam SD-card storage to most NAS setups

## The problem
To my knowledge, most (all?) modern Foscams have a built-in ftp-upload feature that one can use to point to an ftp server running on their home NAS... **but** this option has an unavoidable failing: uploaded videos have no audio!!  (Why!?!!?)

## The motivation
If, instead, your camera is configured to save media to a removeable SD-card, these files *do* have audio. Physically removing the SD-card is an unacceptable pain, but it IS possible to access its contents over your home network! (well, probably. I can't speak for all camera models.)

As one example, the Foscam C1, has a quasi-secret built-in FTP **server** we can use. (Note this is entirely different from the ftp-upload *client* feature.) This feature is exposed when you "manage" your SD Card from the C1's webgui: `[webgui:88] > Settings tab (on top) > Record tab (on left) > SD Card Management > "SD Card Management" button`. This button silently starts the camera's FTP server, then opens a Windows Explorer FTP-browser URL to port 50021 of your camera.

Using this, we can automate the archiving process using some basic unix/linux tools. Thus, I'm choosing to call this whole thing a (quasi-) "service", for simplicity. And this being said, this project is more of a how-to with guided examples than anything else.

## Tools involved

* your NAS/computer to store the media and run the "service"
* the "Chocolatey" package manager, IF running *the service* on a Windows box
* the "Lftp" binary to manage the mirroring operation
* the "curl" binary to send the start-ftp command
* one or two scripts to config/run these binaries
* crontab (or your NAS's built in task scheduler) to regularly grab new files


# Installation

## Installing these tools on FreeNAS / in a FreeNAS jail

I prefer to install non-server-essential junk outside the main OS, in a jail, but you don't have to. Doing so with a jail will definitely require you install some things manually so it's a better instructional starting point:

* Open a jail console (if using a jail) or SSH shell
  * use `sudo` prefixing if you aren't root
  * `pkg update` to update the FreeBSD repository catalogue
  * `pkg install curl` to install curl (used to start an unstarted FTP server on the foscam)
  * `pkg install lftp` to install lftp (which will manage all mirroring)
* choose/prepare your script(s)
  * you can use a shell script that includes an LFTP command, or...
  * use just an LFTP script 
  
## Installing the tools on Windows

There's other ways to run Lftp on Windows, but I prefer using Chocolatey to sort of emulate the pkg/apt-get package managers since it's quick and easy. Chocolatey runs a quasi-hidden Cygwin environment in the background and installs .exe "shims" that communicate with the hidden environment. 

* open an **administrator** command shell (aka run-as-administrator on cmd.exe)
* install Chocolatey via copy/paste/execute of the install command (https://chocolatey.org/install)
  * Currently: 
  
        @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
        
  * You should see progress text, but not errors.
  * If you see no text at all, try restarting your computer -- .net might have crashed
* install curl and Lftp using chocolatey (in that same administrator shell)
  * `choco install curl` to install curl (used to start an unstarted FTP server on the foscam)
  * `choco install lftp` to install lftp (which will manage all mirroring)
* choose/prepare your script(s)
  * you can use a shell script that includes an LFTP command, or...
  * use just an LFTP script   
  
  
# Usage/Scheduling


## Scheduling automatic runs on FreeNAS / in a FreeNAS jail

* schedule a task trigger
  * use crontab inside a jail, or...
  * use FreeNAS's scheduler if you didn't use a jail, or...
  * use FreeNAS's scheduler to send an SSH command to the jail (requires your jail also have SSH access conf'd)
* set your task action
  * point it directly at *(an executable)* shell script: e.g.: `/PATH/TO/sync_foscams_simple.sh`, or...
  * point it at the Lftp binary and use the `-f` flag: e.g. `/PATH/TO/lftp -f /PATH/TO/sync_foscams_noshell.lftp`

## Scheduling automatic runs on Windows

* schedule a task trigger
  * find the "Task Scheduler" app by searching via the Start menu
  * choose "Create Basic Task" from the Actions section on the right side of the window
  * give it a name and choose the date/time frequency for triggering it
* set your task action
  * choose to "Start a program"
  * point the "Program/script" box at the Lftp binary: e.g. `lftp.exe` or `C:\PATH\TO\lftp.exe`
  * set the "Add arguments" box to `-f /cygdrive/C/PATH/TO/sync_foscams_noshell.lftp`
  * NOTE: in the arguments box, the standard windows "c:\whatever" syntax is replaced by "/cygdrive/c/whatever" with slashes reversed to make the Cygwin environment happy
