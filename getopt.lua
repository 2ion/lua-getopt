#!/usr/bin/env lua5.2
-- getopt.lua - getopt-style option parsing in Lua
-- Copyright (C) 2013 Jens Oliver John <asterisk@2ion.de>
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- 

local tx = require("pl.tablex")

local function warn(t)
    io.stderr:write(string.format(unpack(t)) .. "\n")
end

local function die(t)
    warn(t)
    os.exit(1)
end

local function getopt(optspec)
    local map = {}
    local arg = arg
    local noop = {}
    tx.foreachi(optspec, function (v)
        local body = { f = v.f, g = v.g, eh = v.eh }
        tx.foreachi(v.a, function (a)
             -- local a = #a > 1 and "--" .. a or "-" .. a
            if map[a] then
                warn{ "[=] Option alias %s will override a previous specification", a }
            end
            map[a] = body
        end)
    end)
    while #arg > 0 do
        local function nextn(n)
            if #arg < n + 1 then
                return nil
            end
            local t = {}
            for i=2,n+1 do
                table.insert(t, table.remove(arg, 2))
            end
            return t
        end
        local function process_atom_option(c)
            if c and map[c] then
                if map[c].g and map[c].g > 0 then
                    local oa = nextn(map[c].g)
                    if not oa then
                        warn{ "[!] Option %s requires exactly %d arguments", c, map[c].g }
                        if map[c].eh then map[c].eh() end
                    else
                        map[c].f(oa)
                    end
                else
                    map[c].f()
                end
                return true
            end
        end
        local v = arg[1]
        if v == "--" then
            table.remove(arg, 1)
            return tx.merge(noop, arg, true)
        end
        local c = v:match("^%-%-([%w%d%-]+)")
        if process_atom_option(c) then goto continue end
        c = v:match("^%-([%w%d]+)")
        if c then
            if #c > 1 then
                local cindex = 1
                for char in c:gmatch(".") do
                    if map[char] then
                        if map[char].g and map[char].g > 0 then
                            if cindex == #c then
                                warn{ "[!] Option %s in complex option string %s requires arguments, but is not the last option in the string.", char, c }
                            else
                                local oa = nextn(map[char].g)
                                if not oa then
                                    warn{ "[!] Option %s in %s requires exactly %d arguments", char, c, map[char].g }
                                    if map[char].eh then map[char].eh() end
                                else
                                    map[char].f(oa)
                                end
                            end
                        else
                            map[char].f()
                        end
                    end
                end
            elseif process_atom_option(c) then goto continue end
        end
        ::continue::
        if c then
            table.remove(arg, 1)
        else
            table.insert(noop, table.remove(arg, 1))
        end
    end
    return noop
end

return getopt
