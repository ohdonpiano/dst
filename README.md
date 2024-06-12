# dst

Daylight saving time plugin

## What it does

Access iOS and Android native TimeZone and Calendar utilities to get the next daylight saving
transition DateTime.
The developer can specify the start check date and the TimeZone name for the specific DST.

## Usage

```dart

final plugin = Dst();
final nextTransitionDate = await plugin.nextDaylightSavingTransitionAfterDate(DateTime.now(), "Europe/Rome");
```

