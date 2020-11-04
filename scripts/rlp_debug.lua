local t = mods.RussianLanguagePack
local rebuildname = t.rebuildname

function testname(name, key, rtrn)
    local str = ""
    local function add(txt) str = str .. txt .. "\n" end
    if name and (not key) and type(name)=="string" and rawget(STRINGS.NAMES, name:upper()) then key=name:upper() name=STRINGS.NAMES[key] end

    add("Идти к "..rebuildname(name,"WALKTO", key))
    add("Осмотреть "..rebuildname(name,"DEFAULTACTION", key))
    if key then
        add("Был убит "..rebuildname(name,"KILL",key))
    end
    add("Сменить скин у "..rebuildname(name,"reskin", key))

    if rtrn then
        return str  
    end
    print(str)
end

--Сохраняет в файле fn все имена с действием, указанным в параметре action)
function debugnames(name, mode)
    local filename = t.StorePath..(name or "rlp_names")..".txt"
    local str1,str2
    local names={}
    local f=assert(io.open(filename, "w"))
    for k, v in pairs(STRINGS.NAMES) do
        if type(v) == "table" and not v[1] then
            print("skipped", k)
        else
            f:write(string.format((mode and "#. STRINGS.NAMES.%s\n" or "\n*********************************\nПеревод %s (%s)\n"), mode and k:upper() or k, type(v) == "table" and v[1] or v))
            f:write(testname(k, nil, true))
        end
    end
    f:close()
end

