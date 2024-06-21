## 1.0.3

* improved example by showing 2 different time zones at once and by converting the UTC
  transitionDate in local time using the corresponding time zone

## 1.0.2

* added macos platform
* improved example transitionDate print: the exact time of change (-1 second)

## 1.0.1

* added result model DstTransition
* added offsetChange in hours, the amount if time (generally 1 hour) added or subtracted (value is
  negative) to the actual datetime
* added isDSTActive as boolean, true if DST is active immediately after a transition

## 1.0.0

* added primary method Future<DateTime> nextDaylightSavingTransitionAfterDate(DateTime date)
* added native ios and android impl