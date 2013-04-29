#!/usr/bin/env lua5.2
local getopt = require("getopt")

local o = {
    { a = { "v", "version" }, g = 0, f = function () print("--version or -v") end },
    { a = { "h", "help" }, g = 0, f = function  () print("--help or -h") end },
    { a = { "1", "single" }, g = 1, f = function (t)
        print("-1 or --single")
        print("ARGS:")
        print(table.unpack(t))
    end  },
    { a = { "2", "pair" }, g = 2, f = function (t)
        print("-2 or --double")
        print("ARGS")
        print(table.unpack(t))
    end}
}

local noop = getopt(o)
for k,v in ipairs(noop) do print(k,v) end
