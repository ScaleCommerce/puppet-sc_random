# Puppet Module to generate random strings and numbers

This module will produce repeatable randomness. Each node will get a different random string or number, but a given node’s result will be the same every time unless its hostname changes. The resource name is used as an additional seed so that every declared string or number will result in different random values.

## Declare random resources in hiera

```
sc_random::strings:
  my_password:
    size: 10
    characters: abc!+

sc_random::numbers:
  apt_cron_minute:
    max: 60
  apt_cron_hour:
    max: 24
    min: 12
```

`size` deaults to 16. `characters` defaults to alphanumeric. `max` defaults to 101. `min` defaults to 0. The function will produce a number larger than or equal to `min` and **less** than `max`.

## Use random resources in hiera

``` 
files:
  /tmp/my_password:
    content: "%{sc_random::string.my_password}"

crons:
  apt-update-daily:
    command: apt-get update
    hour: "%{sc_random::number.apt_cron_hour}"
    minute: "%{sc_random::number.apt_cron_minute}"


```

## Use random resources in other modules
```
include sc_random
$m = $sc_random::number['apt_cron_hour']
$p = $sc_random::string['my_password']
```