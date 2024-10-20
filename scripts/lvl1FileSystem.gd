extends Node


var file_system = {
	"Root": {  # Changed "Root" to "root"
		"Files": [],  # Keep it as an empty list for files
		"Subdirectories": {  # Changed "Subdirectories" to "subdirectories"
			"missileLab": {  # Changed "Directory 1" to "directory 1"
				"Files": [],  # Changed "File A" and "File B" to lowercase
				"Subdirectories": {
					"ww2missiles": {  # Changed "Subdirectory 1" to "subdirectory 1"
						"Files": [{
						"name": "enzian.mis", 
						"content": "Old ww2 missile. Doesn't Work.", 
						"permissions": {"read": true, "write": true, "execute": true}, 
						"specialFunction": "old"
						},{
						"name": "Rheintochter.mis", 
						"content": "Old ww2 missile. Doesn't Work", 
						"permissions": {"read": true, "write": false, "execute": true}, 
						"specialFunction": "old"
						},{
						"name": "fritz.mis", 
						"content": "Old ww2 missile. Doesn't Work", 
						"permissions": {"read": true, "write": true, "execute": true}, 
						"specialFunction": "old"
						},
						],
							
						"Subdirectories": {},
						"parent": "missileLab",  # Reference to the parent directory
						"textInfo" : "I wonder if old missles are effective. WW2 was 257 years ago though."  # Reference to the parent directory
					},
					"emptyRoom": {  # Changed "Subdirectory 1" to "subdirectory 1"
						"Files": [{
						"name": "note.txt", 
						"content": "What did you expect. Just turn around", 
						"permissions": {"read": true, "write": true, "execute": true}, 
						"specialFunction": ""
						}
						],
							
						"Subdirectories": {},
						"parent": "missileLab",  # Reference to the parent directory
						"textInfo" : "Lots of cobwebs here"  # Reference to the parent directory
					},
					"expirementLab": {  # Changed "Subdirectory 1" to "subdirectory 1"
						"Files": [{
						"name": "lisp.mis", 
						"content": "Experimental Missile. Only for Dr. Curry's Use.", 
						"permissions": {"read": true, "write": true, "execute": true}, 
						"specialFunction": "trap"
						},{
						"name": "lua.mis", 
						"content": "Looks like lisp does good work. I wonder what Dr. Curry was up to.", 
						"permissions": {"read": true, "write": false, "execute": true}, 
						"specialFunction": "old"
						},{
						"name": "python.mis", 
						"content": "That lisp missle sure is powerful. I bet it could do a lot of damage, but there is a rumor it is trapped.", 
						"permissions": {"read": true, "write": true, "execute": true}, 
						"specialFunction": "old"
						},
						],
							
						"Subdirectories": {},
						"parent": "missileLab",  # Reference to the parent directory
						"textInfo" : "Lots of servers. Hopefully no processes get in my way. After all I am one too and I would hate to be killed. We should check the Ps"  # Reference to the parent directory
					}
				},
				"parent": "Root",  # Reference to the parent directory
				"textInfo" : "Seems like a lot of ways to attack king slime are here, but we need to go deeper"  # Reference to the parent directory
			},
			"haskellLab": {  # Changed "Directory 2" to "directory 2"
				"Files": [{
					"name": "beamBlaster.exe", 
					"content": "This is an Attack File", 
					"permissions": {"read": false, "write": true, "execute": false}, 
					"specialFunction": "shoot"
					},{
					"name": "slimeNote.txt", 
					"content": "You need 3 different attacks from 3 different beamBlaster files. Go find them and save the computer \n-Doctor Haskell Curry", 
					"permissions": {"read": true, "write": true, "execute": false}, 
					"specialFunction": ""}
					],  # Changed "File C" to lowercase
				"Subdirectories": {
					"haskellInfo": {  # Changed "Subdirectory 2" to "subdirectory 2"
						"Files": [{
						"name": "password.txt", 
						"content": "So like I might even do it eventually (look at the first letters this may be useful)", 
						"permissions": {"read": true, "write": true, "execute": false}, 
						"specialFunction": ""
						},{
						"name": "topSecret.txt", 
						"content": "Yes, I did. My admin password is:\n bashyboy", 
						"permissions": {"read": true, "write": false, "execute": false}, 
						"specialFunction": ""
						},{
						"name": "curryNotes.txt", 
						"content": "No one would store their sudo password in a plain text file.", 
						"permissions": {"read": true, "write": true, "execute": false}, 
						"specialFunction": ""
						},
						],  # Changed "File CC" to lowercase
						"Subdirectories": {},
						"parent": "haskellLab",  # Reference to the parent directory
						"textInfo" : "These files seem useful, but we can't view them. I bet a *meow* command could help. I wonder what ls -l would show."  # Reference to the parent directory
					}
				},
				
				"parent": "Root",  # Reference to the parent directory
				"textInfo" : "Seems like we need to CHange the MODe of these files. If only we had a sudo user password."  # Reference to the parent directory
			},
			"gitMissles": {  # Changed "Directory 3" to "directory 3"
				"Files": [{
						"name": "README.md", 
						"content": "Now we are learning git. Let's look into our repository. I bet git help would be useful.", 
						"permissions": {"read": true, "write": true, "execute": false}, 
						"specialFunction": ""
						}],  # Changed "File D" and "File E" to lowercase
				"Subdirectories": {"gitRepo": {  # Changed "Subdirectory 1" to "subdirectory 1"
						"Files": [{
						"name": "launcher.py", 
						"content": "Experimental Missile. Only for Dr. Curry's Use. Launch Code required.", 
						"permissions": {"read": true, "write": true, "execute": true}, 
						"specialFunction": "condLaunch"
						},{
						"name": "launchCode.env", 
						"content": "launchCode ???", 
						"permissions": {"read": true, "write": true, "execute": false}, 
						"specialFunction": "condSet"
						},{
						"name": "instructions.txt", 
						"content": "We need to input the password Haskell Curry set in order to send this missle. Search around and put it in the launchCode then push to the remote branch. Then we can run the launch code file to set the permissions and finally shoot the beam.", 
						"permissions": {"read": true, "write": false, "execute": false}, 
						"specialFunction": "old"
						},
						],
							
						"Subdirectories": {},
						"parent": "missileLab",  # Reference to the parent directory
						"textInfo" : "We are in the repository. How could we git the missle codes on the remote server?"  # Reference to the parent directory
					}
					},
				"parent": "Root",  # Reference to the parent directory
				"textInfo" : "It seems like this repository uses git. git help could be useful"
			}
		},
		"parent": null,  # Root has no parent
		"textInfo" : "Welcome to the Files! Kill the invader SLIME KING! Try using ls and cd to explore below. Remember to type man if you are stuck!"
	},
	"sudo" : "bashyboy",
	"attackers" : [{
		"pid": 2, 
		"name": "slimeVirus", 
		"status": "running"
		},{
		"pid": 3, 
		"name": "coronaVirus", 
		"status": "running"}]
}
