-- Translation.lua
-- 技能名称翻译功能模块
-- 提供中英文技能名称互转功能
-- 适用于Hekili插件
-- 作者：胡里胡涂

local addon, ns = ...
local Hekili = _G[ addon ]

-- 获取Hekili的类和状态引用
local class = Hekili.Class
local state = Hekili.State

-- 常用字符串和表操作函数本地化
local format, lower, match = string.format, string.lower, string.match
local insert, remove, sort, wipe = table.insert, table.remove, table.sort, table.wipe

-- 获取游戏API函数
local GetSpellInfo = ns.GetUnpackedSpellInfo
local GetSpellDescription = C_Spell.GetSpellDescription

-- 判断字符串是否包含中文
-- @param str 要检查的字符串
-- @return boolean 如果包含中文返回true，否则返回false
local function isChinese(str)
    if str == "" then
        return str
    end
    if string.match(str, "^%d+$") then
        return true  -- 纯数字视为中文处理
    end
    -- 使用UTF-8编码范围匹配中文字符
    -- 添加中文标点符号和全角字符支持
    return string.find(str, "[\228-\233][\128-\191][\128-\191]") ~= nil or 
           string.find(str, "[\239-\241][\128-\191][\128-\191]") ~= nil or  -- 中文标点
           string.find(str, "[\227][\128-\191][\128-\191]") ~= nil or       -- 全角字符
           string.find(str, "[\194-\223][\128-\191]") ~= nil                -- 其他中文符号
end

-- 天赋查询缓存表
local talentCache = {}
local lastCacheUpdate = 0
local CACHE_EXPIRE_TIME = 300 -- 5分钟缓存过期时间

-- 通过天赋名称获取法术ID
-- @param talentName 天赋名称
-- @return number|nil 法术ID，找不到返回nil
local function getTalentSpellID(talentName)
    -- 参数检查
    if not talentName or type(talentName) ~= "string" or talentName == "" then
        return nil, "无效的天赋名称"
    end
    
    -- 检查缓存是否过期
    local now = GetTime()
    if now - lastCacheUpdate > CACHE_EXPIRE_TIME then
        wipe(talentCache)
        lastCacheUpdate = now
    end
    
    -- 先检查缓存
    if talentCache[talentName] ~= nil then
        return talentCache[talentName]
    end
    
    -- 获取当前天赋配置
    local configID = C_ClassTalents.GetActiveConfigID()
    if not configID then 
        return nil, "无法获取天赋配置ID"
    end
    
    -- 批量获取天赋树信息
    local configInfo = C_Traits.GetConfigInfo(configID)
    if not configInfo or not configInfo.treeIDs or #configInfo.treeIDs == 0 then
        return nil, "无法获取天赋树信息"
    end
    
    -- 预加载所有天赋节点
    local nodes = {}
    for _, treeID in ipairs(configInfo.treeIDs) do
        local treeNodes = C_Traits.GetTreeNodes(treeID)
        if treeNodes then
            for _, nodeID in ipairs(treeNodes) do
                insert(nodes, nodeID)
            end
        end
    end
    
    if #nodes == 0 then
        return nil, "天赋树节点为空"
    end
    
    -- 批量处理节点
    for _, nodeID in ipairs(nodes) do
        local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID)
        if nodeInfo and nodeInfo.entryIDs then
            for _, entryID in ipairs(nodeInfo.entryIDs) do
                local entryInfo = C_Traits.GetEntryInfo(configID, entryID)
                if entryInfo and entryInfo.definitionID then
                    local defInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)
                    if defInfo and defInfo.spellID then
                        local spellInfo = C_Spell.GetSpellInfo(defInfo.spellID)
                        if spellInfo and spellInfo.name == talentName then
                            -- 存入缓存
                            talentCache[talentName] = defInfo.spellID
                            return defInfo.spellID
                        end
                    end
                end
            end
        end
    end
    
    -- 未找到时也缓存nil结果，避免重复查询
    talentCache[talentName] = nil
    return nil, "未找到匹配的天赋"
end

-- 翻译缓存表
local spellCache = {}
local lastSpellCacheUpdate = 0
local SPELL_CACHE_EXPIRE = 300 -- 5分钟缓存过期时间

-- 翻译技能名称（中英文互转）
-- @param input 输入的名称（可以是中文或英文）
-- @return string|nil 翻译后的名称，找不到返回nil
local function transSpell(input)
    if not input or type(input) ~= "string" or input == "" then
        return nil, "无效的输入"
    end
    
    -- 检查缓存是否过期
    local now = GetTime()
    if now - lastSpellCacheUpdate > SPELL_CACHE_EXPIRE then
        wipe(spellCache)
        lastSpellCacheUpdate = now
    end
    
    -- 先检查缓存
    if spellCache[input] ~= nil then
        return spellCache[input]
    end
    
    -- 处理英文转中文的情况
    if not isChinese(input) then
        -- 检查是否是技能
        local ability = Hekili.Class.abilities[input]
        if ability then
            local result = ability.name
            spellCache[input] = result
            print(format("查询到的技能：%s", C_Spell.GetSpellLink(ability.id)))
            return result
        end

        -- 检查是否是光环
        local aura = Hekili.Class.auras[input]
        if aura then
            local result = aura.name
            spellCache[input] = result
            print(format("查询到的光环：%s", C_Spell.GetSpellLink(aura.id)))
            return result
        end

        -- 检查是否是天赋
        local talent = Hekili.Class.talents[input]
        if talent then
            local spellInfo = C_Spell.GetSpellInfo(talent[2])
            if spellInfo then
                local result = spellInfo.name
                spellCache[input] = result
                print(format("查询到的天赋：%s", C_Spell.GetSpellLink(spellInfo.spellID)))
                return result
            end
        end
    else
        -- 处理中文转英文的情况
        
        -- 在技能表中查找匹配的中文名称
        for key, ability in pairs(Hekili.Class.abilities) do
            if ability.name == input then
                local result = (type(key) == "number" or isChinese(key)) and ability.key or key
                spellCache[input] = result
                print(format("查询到的技能：%s", C_Spell.GetSpellLink(ability.itemSpellID or ability.id)))
                return result
            end
        end

        -- 在光环表中查找匹配的中文名称
        for key, ability in pairs(Hekili.Class.auras) do
            if ability.name == input and not isChinese(key) then
                spellCache[input] = key
                print(format("查询到的光环：%s", C_Spell.GetSpellLink(ability.id)))
                return key
            end
        end

        -- 在天赋表中查找匹配的中文名称
        local spellid = getTalentSpellID(input)
        if spellid then
            for key, ability in pairs(Hekili.Class.talents) do
                if ability[2] == spellid and not isChinese(key) then
                    spellCache[input] = key
                    print(format("查询到的天赋：%s", C_Spell.GetSpellLink(ability[2])))
                    return key
                end
            end
        end
    end
    
    -- 未找到时也缓存nil结果，避免重复查询
    spellCache[input] = nil
    return nil, "未找到匹配项"
end

-- 导出数据到JSON文件
-- @param filePath 导出文件的路径

-- 自定义简单的JSON转换函数
local function tableToJSON(obj, padding) 
    padding = padding or ""
    local t = type(obj) 
    if t == "number" then 
        return tostring(obj) 
    end 
    if t == "string" then 
        return "\"" .. obj:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t") .. "\"" 
    end 
    if t == "boolean" then 
        return tostring(obj) 
    end 
    local json = "" 
    if t == "table" then 
        local indent = padding .. "  " 
        local isArray = true
        local i = 1
        for k in pairs(obj) do
            if k ~= i then
                isArray = false
                break
            end
            i = i + 1
        end
        if isArray then 
            json = padding .. "[\n" 
            local elements = {} 
            for _, v in ipairs(obj) do 
                table.insert(elements, indent .. tableToJSON(v, indent)) 
            end 
            json = json .. table.concat(elements, ",\n") .. "\n" .. padding .. "]" 
        else 
            json = padding .. "{\n" 
            local keyValues = {} 
            for k, v in pairs(obj) do 
                table.insert(keyValues, indent .. tableToJSON(k) .. ": " .. tableToJSON(v, indent)) 
            end 
            json = json .. table.concat(keyValues, ",\n") .. "\n" .. padding .. "}" 
        end 
    end 
    return json 
end

-- 创建窗口和文本框
local exportWindow = CreateFrame("Frame", "HekiliExportWindow", UIParent, "BasicFrameTemplateWithInset")
exportWindow:SetSize(600, 400)
exportWindow:SetPoint("CENTER")
exportWindow:SetMovable(true)
exportWindow:EnableMouse(true)
exportWindow:RegisterForDrag("LeftButton")
exportWindow:SetScript("OnDragStart", exportWindow.StartMoving)
exportWindow:SetScript("OnDragStop", exportWindow.StopMovingOrSizing)

exportWindow.title = exportWindow:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
exportWindow.title:SetPoint("TOP", 0, -5)
exportWindow.title:SetText("Hekili 导出数据")

local scrollFrame = CreateFrame("ScrollFrame", nil, exportWindow, "UIPanelScrollFrameTemplate") 
scrollFrame:SetPoint("TOPLEFT", 10, -30) 
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)  -- 调整位置为顶部按钮留出空间 

local editBox = CreateFrame("EditBox", nil, scrollFrame) 
editBox:SetMultiLine(true) 
editBox:SetFontObject("GameFontHighlight") 
editBox:SetWidth(scrollFrame:GetWidth()) 
editBox:SetAutoFocus(true) 
editBox:SetTextInsets(5, 5, 5, 5) 
scrollFrame:SetScrollChild(editBox)

-- 平时隐藏窗口
exportWindow:Hide()

local function updateExportWindow()
    local jsonData = {
        keywords = {},
    }
    -- 提取abilities中的中英文名称，过滤数字key和中文key
    for key, ability in pairs(Hekili.Class.abilities) do
        if type(key) ~= 'number' and not isChinese(key) then
            local enName = key
            local zhName = ability.name
            jsonData.keywords[enName] = zhName
        end
    end
    -- 提取auras中的中英文名称，过滤数字key和中文key
    for key, aura in pairs(Hekili.Class.auras) do
        if type(key) ~= 'number' and not isChinese(key) then
            local enName = key
            local zhName = aura.name
            jsonData.keywords[enName] = zhName
        end
    end
    -- 提取talents中的中英文名称，过滤数字key和中文key
    for key, talent in pairs(Hekili.Class.talents) do
        if type(key) ~= 'number' and not isChinese(key) then
            local spellInfo = C_Spell.GetSpellInfo(talent[2])
            if spellInfo then
                local enName = key
                local zhName = spellInfo.name
                jsonData.keywords[enName] = zhName
            end
        end
    end
    -- 将数据转换为JSON字符串
    local jsonString = tableToJSON(jsonData)
    editBox:SetText(jsonString)
    exportWindow:Show()
end

-- 修改斜杠命令以显示窗口
SLASH_HekiliExportJSON1 = '/hky'
SlashCmdList['HekiliExportJSON'] = function(arg) 
    updateExportWindow()
end

Hekili.Trans = {
    isChinese = isChinese,  -- 中文检测函数
    getTalentSpellID = getTalentSpellID,  -- 天赋名称转法术ID
    transSpell = transSpell,  -- 技能名称翻译主函数
    exportToJSON = exportToJSON  -- 导出数据到JSON文件
}