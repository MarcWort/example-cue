package rules

import (
	"strings"
)

#Entry: close({
	name: string
	custom: query: ["Should be in summary"]
})

_standalone: [G=string]: #Entry & {
	name: G
}

_standalone: Stage: {}

groups: one_rulegroup: rules: [
	for n, g in _standalone {
		{
			alert: n
			annotations: {
				_custom_extra: strings.Join(g.custom.query, ",")
				summary:       "Summary \(_custom_extra)"
			}
		}
	},
	#RecordingRule & {
		record: "record"
		expr: "expr"
	}
]

groups: [NAME=string]: #RuleGroup & {name: NAME}

#RuleGroup: {
	name: string
	rules: [...#Rule]
}

#Rule: #AlertRule | #RecordingRule

#AlertRule: {
	alert: string

	// annotations: summary: *"" | string // # Remove Comment to get no error but empty string
	annotations: {...}
}

#RecordingRule: {
	record: string
	expr:   string
}
