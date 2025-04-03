package rules

groups: [NAME=string]: #RuleGroup & {name: NAME}

#RuleGroup: {
	name: string
	rules: [...#Rule]
}

#Rule: #AlertRule | #RecordingRule

#AlertRule: {
	alert: string

	annotations: summary: *"" | string
}

#RecordingRule: {
	record: string
	expr:   string
}
