-- i no longer have any idea of how most of these stuff work
-- this is day 4 or 5 of writing this
-- sda please use this well :pray:

local vars = {
    -- predefined parts
    ["Rockets"] = GetParts("Rocket"), 
    ["Thrusters"] = GetParts("Thruster"),
}

local signs = GetParts("Sign")
local size = signs[1].Size.Y
local blocks = {} -- -y, z, x
local code = [[

local vars = {
    ["Rockets"] = GetParts("Rocket"), 
    ["Thrusters"] = GetParts("Thruster"),
}

]]
local tempCode = ""


for i,v in pairs(signs) do
    local pos = Microcontroller.CFrame:PointToObjectSpace(v.Position)
    blocks[(-pos.Y + 3*size/2) // size] = blocks[(-pos.Y + 3*size/2) // size] or {}
    blocks[(-pos.Y + 3*size/2) // size][(-pos.Z + 3*size/2) // size] = blocks[(-pos.Y + 3*size/2) // size][(-pos.Z + 3*size/2) // size] or {}
    table.insert(blocks[(-pos.Y + 3*size/2) // size][(-pos.Z + 3*size/2) // size], v)
end

for i1,v1 in pairs(blocks) do 
    for i2,v2 in pairs(v1) do
        for i3,v3 in pairs(v2) do 
            local closest = i3
            for i=i3+1,#v2 do
                if (v2[i].Position - Microcontroller.Position).Magnitude < (v2[closest].Position - Microcontroller.Position).Magnitude then
                    closest = i
                end
            end
            v2[i3], v2[closest] = v2[closest], v2[i3]
        end
    end
end

local args = {}

--[[
args structuring
{
    [1] = {
        ["Start"]: int = line,
        ["EndSyntax"]: str = ")" or "do" or "then"
        ["Count"]: int = unpassed args remaining,
        ["Block"]: pilotobj = sign,
        ["Index"]: int = depth of block in indent,
        ["Sep"]: str = seperator,
        ["EndAct"]: function = the action to take after ending the bracket (optional),
    }
}
]]

local var, loadableVar
local line, indent, depth = 0, 1, 1
local argEnd, indentPos, exited = 0, 0, 0

local syntax = { -- have fun! :zrowning:
    -- ohhh im yandevving it
   ["say"] = function()
        args[#args+1] = {
            ["Start"] = indent,
            ["EndSyntax"] = ")",
            ["Count"] = 1,
            ["Block"] = blocks[line][indent][depth],
            ["Index"] = depth,
            ["Sep"] = "",
        }
        return "print("
    end,

    ["join"] = "..",

    ["list"] = "{}",

    ["add"] = "+",

    ["subtract"] = "-",

    ["multiply by"] = "*",

    ["divide by"] = "/",

    ["modulo"] = "%",

    ["remainder of divide by"] = "%",

    ["to the power of"] = "^",

    ["length of"] = "#",

    ["#"] = "#",

    ["is equal to"] = "==",

    ["is not equal to"] = "~=",

    ["is greater than"] = ">",

    ["is less than"] = "<",

    ["is greater than or equal to"] = ">=",

    ["is less than or equal to"] = "<=",

    ["<="] = "<=",

    [">="] = ">=",

    ["<"] = "<",

    [">"] = ">",

    ["~="] = "~="

    ["=="] = "==",

    ["^"] = "^",

    ["%"] = "%",

    ["/"] = "/",

    ["*"] = "*",

    ["-"] = "-",

    ["+"] = "+",

    ["{}"] = "{}",

    [".."] = "..",

    [","] = ",",

    ["("] = "(",

    [")"] = ")",

    ["and"] = "and",
    
    ["or"] = "or",

    ["not"] = "not",

    ["nil"] = "nil",

    ["false"] = "false",

    ["true"] = "true",

    ["skip current loop iteration"] = "continue",

    ["exit loop"] = "break",

    ["break"] = "break",

    ["continue"] = "continue",

    ["return"] = "return",

    ["if"] = "if",

    ["elseif"] = "elseif",

    ["else"] = "else",

    ["then"] = "then",

    ["while"] = "while",

    ["do"] = "do",

    ["end"] = "end",

    ["for each key and item in list do"] = function()
        tempCode = code
        code = ""
        args[#args+1] = {
            ["Start"] = indent,
            ["EndSyntax"] = "",
            ["Count"] = 3,
            ["Block"] = blocks[line][indent][depth],
            ["Index"] = depth,
            ["Sep"] = "evilseperator",
            ["EndAct"] = function()
                local s = string.split(code, "evilseperator")
                code = "for i"..tostring(line)..",v"..tostring(line).." in pairs("..s[3]..") do vars["..s[1].."], vars["..s[2].."] = i"..tostring(line)..",v"..tostring(line)
                vars[JSONDecode(s[1])], vars[JSONDecode(s[2])] = 0, 0
                code = tempCode..code
                tempCode = ""
            end,
        }
        return ""
    end,

    ["repeat n times"] = function()
        args[#args+1] = {
            ["Start"] = indent,
            ["EndSyntax"] = " do",
            ["Count"] = 1,
            ["Block"] = blocks[line][indent][depth],
            ["Index"] = depth,
            ["Sep"] = "",
        }
        return "for i"..tostring(line).." = 1, "
    end,

    ["create new vector3"] = function()
        args[#args+1] = {
            ["Start"] = indent,
            ["EndSyntax"] = ")",
            ["Count"] = 3,
            ["Block"] = blocks[line][indent][depth],
            ["Index"] = depth,
            ["Sep"] = ",",
        }
        return "Vector3.new("
    end,

    ["set varaible to value"] = function()
        tempCode = code
        code = ""
        args[#args+1] = {
            ["Start"] = indent,
            ["EndSyntax"] = "",
            ["Count"] = 2,
            ["Block"] = blocks[line][indent][depth],
            ["Index"] = depth,
            ["Sep"] = "=",
            ["EndAct"] = function()
                code = tempCode..code
                tempCode = ""
            end,
        }
        return ""
    end,
            
        
}

for i,v in pairs(blocks) do
    for j,k in pairs(v) do
        for l,m in pairs(k) do
            print(i,j,l,m.SignText)
        end end end


for _,_ in pairs(blocks) do
    local smallest = 400000
    for i,v in pairs(blocks) do
        if i - line < smallest - line and i - line > 0 then
            smallest = i
        end
    end
    local i,v = smallest, blocks[smallest]
    argEnd, indentPos, exited = 0, 0, 1
    line, indent, depth = i, 1, 1
    while #args > 0 or indent == 1 do
        for j,k in pairs((v and v[indent]) or {}) do
            depth = j
            if j <= indentPos then
                if j == #v[1] and indent == 1 and #args == 0 then
                    indent = 0
                    break
                end
            
            
            
            
            
            else
                local pos = Microcontroller.CFrame:PointToObjectSpace(k.Position)
                
                print(require("repr")(vars))
                print(loadableVar)
                print(code)
                print(indent, depth)
                local f = false
                if indent ~= 1 then
                    if (Microcontroller.CFrame:PointToObjectSpace(args[#args].Block.Position).X + (args[#args].Block.Size.X / 2) > pos.X and pos.X > Microcontroller.CFrame:PointToObjectSpace(args[#args].Block.Position).X - (args[#args].Block.Size.X / 2) or indent == 1) then
                        f = true
                    end
                else
                    f = true
                end

                if f then
                    if syntax[k.SignText] then
                        if type(syntax[k.SignText]) == "function" then
                            code = code..(var or "").." "..syntax[k.SignText]()
                        else
                            code = code..(var or "").." "..syntax[k.SignText]
                        end
                        var = nil
                        loadableVar = nil
                    elseif (not var) and (vars[tonumber(k.SignText) or k.SignText] or (args[#args].Block.SignText == "set varaible to value" and args[#args].Count == 2)) then
                        var = "vars["..(tonumber(k.SignText) or "'"..k.SignText.."'").."]"
                        loadableVar = vars[tonumber(k.SignText) or k.SignText]
                        vars[tonumber(k.SignText) or k.SignText] = vars[tonumber(k.SignText) or k.SignText] or {}
                    elseif (loadableVar or vars)[tonumber(k.SignText) or k.SignText] or (args[#args].Block.SignText == "set varaible to value" and args[#args].Count == 2) then
                        var = var.."["..(tonumber(k.SignText) or "'"..k.SignText.."'").."]"
                        loadableVar = loadableVar[tonumber(k.SignText) or k.SignText]
                        loadableVar[tonumber(k.SignText) or k.SignText] = loadableVar[tonumber(k.SignText) or k.SignText] or {}
                    else
                        code = code..(var or "").." "..(tonumber(k.SignText) or " '"..k.SignText.."'")
                        var = nil
                        loadableVar = nil
                    end
                end
            end
            
            

            


            
            if #args > 0 then
                if args[#args].Start == indent then
                    indent += 1
                    break
                end
                if #v[indent] == j then
                    args[#args].Count -= 1
                    if args[#args].Count <= 0 then
                        indent += argEnd
                        if indent - args[#args].Start > argEnd then
                            argEnd = indent - args[#args].Start
                        end
                        -- todo: compare argEnd with new argEnd
                        -- this should work :pray:
                        indent = args[#args].Start
                        exited = #args
                        code = code..(var or "").." "..args[#args].EndSyntax
                        var = nil
                        loadableVar = nil
                        if args[#args].EndAct then
                            args[#args].EndAct()
                        end
                        indentPos = args[#args].Index
                        args[#args] = nil
                    else
                        code = code..(var or "")..args[#args].Sep
                        var = nil
                        loadableVar = nil
                        indent += 1
                        indentPos = 0
                        if #args < exited then
                            indent += argEnd
                            argEnd = 0
                        end
                    end
                    break
                end
            end
            if j == #v[1] and indent == 1 and #args == 0 then
                indent = 0
                break
            end
        end
        code = code..(var or "")
        var = nil
        loadableVar = nil
    end
    code = code.."\n"
    line = i + 1
end


print(code)
Microcontroller.Code = code

