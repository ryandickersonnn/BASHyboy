# file_system.gd
extends Node

var file_system = {
	"Root": {
		"Files": [],
		"Subdirectories": {
			"Directory1": {
				"Files": ["File A", "File B"],  # 2 files
				"Subdirectories": {
					"Subdirectory 1": {
						"Files": ["File AA"],  # 1 file
						"Subdirectories": {}
					}
				}
			},
			"directory2": {
				"Files": ["File 1C", "File 2C"],  # 1 file
				"Subdirectories": {
					"Subdirectory 2": {
						"Files": ["File CC"],  # 1 file
						"Subdirectories": {}
					}
				}
			},
			"directory3": {
				"Files": ["File D", "File E", "File F"],  # 2 files
				"Subdirectories": {}
			}
		}
	}
}
