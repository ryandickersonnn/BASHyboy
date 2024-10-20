extends Node


var file_system = {
	"Root": {  # Changed "Root" to "root"
		"Files": [],  # Keep it as an empty list for files
		"Subdirectories": {  # Changed "Subdirectories" to "subdirectories"
			"directory 1": {  # Changed "Directory 1" to "directory 1"
				"Files": ["file a", "file b"],  # Changed "File A" and "File B" to lowercase
				"Subdirectories": {
					"subdirectory 1": {  # Changed "Subdirectory 1" to "subdirectory 1"
						"Files": [{
							"name": "testfile",
							"content": "This is File A content", 
							"permissions": {
								"read": true, 
								"write": true, 
								"execute": false},
							"specialFunction": "shoot",}],
							
						"Subdirectories": {},
						"parent": "directory 1"  # Reference to the parent directory
					}
				},
				"parent": "Root"  # Reference to the parent directory
			},
			"haskellLab": {  # Changed "Directory 2" to "directory 2"
				"Files": [{
					"name": "beamBlaster", 
					"content": "This is an Attack File", 
					"permissions": {"read": false, "write": true, "execute": false}, 
					"specialFunction": "shoot"
					},{
					"name": "slimeNote", 
					"content": "You need 3 different attacks from 3 different beamBlaster files. Go find them and save the computer \n-Doctor Haskell Curry", 
					"permissions": {"read": true, "write": true, "execute": false}, 
					"specialFunction": ""}
					],  # Changed "File C" to lowercase
				"Subdirectories": {
					"haskellInfo": {  # Changed "Subdirectory 2" to "subdirectory 2"
						"Files": [{
						"name": "password", 
						"content": "You think one of the greats would store a plain text password", 
						"permissions": {"read": true, "write": true, "execute": false}, 
						"specialFunction": ""
						},{
						"name": "topSecret", 
						"content": "Yes I did. My password is:\n bashyboy", 
						"permissions": {"read": false, "write": false, "execute": false}, 
						"specialFunction": ""
						},{
						"name": "curryNotes", 
						"content": "Did you know that currying and the programming language Haskell were named after me. Pretty Cool. :D", 
						"permissions": {"read": true, "write": true, "execute": false}, 
						"specialFunction": ""
						},
						],  # Changed "File CC" to lowercase
						"Subdirectories": {},
						"parent": "haskellLab"  # Reference to the parent directory
					}
				},
				"parent": "Root"  # Reference to the parent directory
			},
			"directory 3": {  # Changed "Directory 3" to "directory 3"
				"Files": ["file d", "file e"],  # Changed "File D" and "File E" to lowercase
				"Subdirectories": {},
				"parent": "Root"  # Reference to the parent directory
			}
		},
		"parent": null  # Root has no parent
	}
}
