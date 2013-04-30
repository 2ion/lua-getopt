# getopt.lua

This Lua module provides the getopt() function for getopt-like option
parsing. Options will be processed in consecutive order. The option
format is as follows:

* Long options have names with a length > 1 and are prefixed with 2
  dashes, e.g. --version. Long options take an arbitrary number
  of arguments.
* Short options have names with a length == 1 and are prefixed with
  a single dash, e.g. -v. Short options take an arbitrary number of
  arguments.
* Option names may consist of characters of the Lua character class
  [%d%w].
* Sequential instances of short options may be contracted, e.g. the
  sequence -v -h may become -vh. If a short option requires an
  argument, it must be specified as the last option in a
  contraction.
* Between an option and its argument, there must be a space
  character.
* The special option -- terminates the option processing.

The option processing uses a lookup table, which is passed to the
getopt() function:

```
getopt(optspec[, argv])
```

```lua
    local getopt = require("getopt")
    local noops = getopt({
        { a = { "v", "version" }, f = function(t) return end, g = 0 },
        { a = { "i", "input" }, f = function(t) return end, g = 1 }
    })
```

In the spec table, each option may be assigned >= 1 aliases (the a key).
If an alias has > 1 characters, it will be treated as a long option,
otherwise as a short option. These aliases point to a handler function
(f key), which will be called each time the option is encountered with
the option's arguments. The arguments are passed in a list. The number
of arguments the option requires is g, which may be NIL, 0 or >= 0.

getopt() returns a list of all arguments that weren't options (or
option arguments).

If an option given does not satisfy the option specification's
requirements, getopt() will print a warning and try to call an error
handler, which may be specified per option under the "eh" key.

getopt() processes the _G.arg list by default. An alternative list may
be passed as the second argument to getopt().

# Dependencies

* Lua 5.2
* Penlight library (pl.tablex)

# Todo

* re-implement getopt() warnings as a default error handler for code
  cleanup

# License

See the LICENSE file for the full legal text.

```
getopt.lua - getopt-style option parsing in Lua
Copyright (C) 2013 Jens Oliver John <asterisk@2ion.de>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
```
