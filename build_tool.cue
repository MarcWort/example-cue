package testingsomestuff

import (
	"encoding/yaml"
	"tool/file"

	"example.com/example/rules"
)

command: "build-rules": task: {
	for name, group in rules.groups {
		(name): file.Create & {
			filename: "rules/\(name).yaml"
			contents: yaml.Marshal({
				groups: [group]
			})
		}
	}
}
