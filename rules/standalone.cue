package rules

import (
	"strings"
)

#AutomainterEntry: close({
	name: string
	custom: query: ["Should be in summary"]
})

standalone: [G=string]: #AutomainterEntry & {
	name: G
}

standalone: Stage: {}

groups: one_rulegroup: rules: [
	for n, g in standalone {
		#AlertRule & {
			alert: n
			annotations: {
				_custom_extra: *"" | string
				if len(g.custom.query) != 0 {
					_custom_extra: " : " + strings.Join([for q in g.custom.query {q}, " + "], ",")
				}
				summary: "Summary \(_custom_extra)"
			}
		}
	},
]
