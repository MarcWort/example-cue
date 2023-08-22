package rules

import (
	"list"
	"strconv"
	"strings"
)

#Entry: {
	name:         string
	period:       #TimePeriod & {
		periods: [...{
			windows: [...{
				#startTime: m: 0
				#endTime: m:   0
			}]
		}]
	}
}

standalone: [G=string]: #Entry & {
	name: G
}

standalone: "Daily 0-5": {
	period: {
		timezone: "Europe/Berlin"
		periods: [ for _ in list.Range(1,250,1) {
			{
				windows: [{
					start: "00:00"
					end:   "05:00"
				}]
			}
		}]
	}
}


groups: {
	rule: {
		rules: [
			for n, g in standalone {
				{
					alert: "Test"
					annotations: {
						indicator: "Blocked"
						summary:   "Placeholder"
					}
					g.period
				}
			},
		]
	}
}

#timeString: string

#time: {
	_timeString: #timeString
	_timeParts:  strings.SplitN(_timeString, ":", 2)

	h: int
	h: strconv.Atoi(_timeParts[0])

	m: int
	m: strconv.Atoi(_timeParts[1])

	#string: "\((#padding & {in: h}).out):\((#padding & {in: m}).out)"
}

#padding: {
	in:  <10
	out: "0\(in)"
} | {
	in:  >=10
	out: "\(in)"
}

#timeWindow: {
	start:      #timeString
	#startTime: #time & {
		_timeString: start
		h:           !=24
	}

	end:      #timeString
	#endTime: #time & {
		_timeString: end
		h:           >=#startTime.h

		if h == #startTime.h {
			m: >=#startTime.m
		}
	}
}

#period: {
	windows: [...#timeWindow]
}

#TimePeriod: {
	timezone: "Europe/Berlin" | "UTC"
	periods:  [...#period]
}
