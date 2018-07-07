## Welcome Screen
A simple welcome screen mod for minetest.
 
#### Overview
The mod displays a welcome window with (rules, information, anything you like) to new players and asks them to accept (or decline) it.  
Players who decline it are not granted interact privilege.

#### Installation
* Navigate to the mod folder, copy and rename "rules.conf_example" file to "rules.conf" file so your changes would persist at updates.
* Adjust rules.conf file to your liking.
* Adjust default_privs variable in your minetest server config, remove default "interact" privilege. (example: default_privs = shout)

#### Usage
Any players who are missing an "interact" privilege will be prompted with a rules window upon login.  
Accepting the rules will grant them with the privilege. Declining it will allow them to roam the server without interacting.  
The window can be summoned again at any time with "/rules" command. Players who already have an "interact" privilege can  
use this command too.

#### Credit
* Licensed under WTFPL.
* Thanks to Lowenkrieger for fixing my terrible grammar in rules.conf_example.
 
