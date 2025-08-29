-- name: [CS] WinbowBreaker \\#2328c0\\Charlotte
-- description: thanks to Cooliokid956 for programming the health metre, and for rewriting a lot of code.\n\n\\#ff7777\\This Pack requires Character Select\nto use as a Library!
-- category: cs

--[[
    API Documentation for Character Select can be found below:
    https://github.com/Squishy6094/character-select-coop/wiki/API-Documentation

    Use this if you're curious on how anything here works >v<
    (This is an edited version of the Template File by Squishy)
]]

local CST_DOC = 0
local TEXT_MOD_NAME = "WinbowBreaker Charlotte"

-- Stops mod from loading if Character Select isn't on
if not _G.charSelectExists then
    djui_popup_create("\\#ffffdc\\\n"..TEXT_MOD_NAME.."\nRequires the Character Select Mod\nto use as a Library!\n\nPlease turn on the Character Select Mod\nand Restart the Room!", 6)
    return 0
end
--E_MODEL_GLOW = smlua_model_util_get_id("glows_geo") -- regeneffect

local E_MODEL_CUSTOM_MODEL = smlua_model_util_get_id("CthewinB_geo") -- main costume
local E_MODEL_COMFY = smlua_model_util_get_id("CthewinBomfy_geo") -- COMFY costume
E_MODEL_BABYKAK = smlua_model_util_get_id("babykakk_geo") -- laughing my arse off about the fact that this shit is actually possible
--local E_MODEL_8THCHA = smlua_model_util_get_id("Cthe8th_geo") -- 8th doctor costume
--local E_MODEL_OLDFIT = smlua_model_util_get_id("classiclassic_geo") -- classic costume
--local E_MODEL_SWAGGER = smlua_model_util_get_id("swaggyC_geo") -- swagger costume

--icons
local TEX_CUSTOM_LIFE_ICON = get_texture_info("Cicon")
local TEX_GIRL_LIFE_ICON = get_texture_info("Cicongirl")

-- All Located in "sound" Name them whatever you want. Remember to include the .ogg extension
local VOICETABLE_WINBREAKER = {
    [CHAR_SOUND_OKEY_DOKEY] = 'dsi-startup2.mp3', -- Starting game
    [CHAR_SOUND_LETS_A_GO] = 'Silent.ogg', -- Starting level
    [CHAR_SOUND_PUNCH_YAH] = 'Silent.ogg', -- Punch 1
    [CHAR_SOUND_PUNCH_WAH] = 'Silent.ogg', -- Punch 2
    [CHAR_SOUND_PUNCH_HOO] = {'Silent.ogg', 'Silent.ogg'}, -- Punch 3
    [CHAR_SOUND_YAH_WAH_HOO] = {'Silent.ogg', 'Silent.ogg', 'Silent.ogg'}, -- First/Second jump sounds
    [CHAR_SOUND_HOOHOO] = {'charwup.ogg', 'charwup.ogg'}, -- Third jump sound
    [CHAR_SOUND_YAHOO_WAHA_YIPPEE] = {'wahoo2.ogg', 'yippeeorsomething.ogg', 'charhooray.ogg'}, -- Triple jump sounds
    [CHAR_SOUND_UH] = 'walldonk.ogg', -- Wall bonk
    [CHAR_SOUND_UH2] = 'charhup.ogg', -- Landing after long jump
    [CHAR_SOUND_UH2_2] = 'charhup.ogg', -- Same sound as UH2; jumping onto ledge
    [CHAR_SOUND_HAHA] = 'charoop.ogg', -- Landing triple jump
    [CHAR_SOUND_YAHOO] = {'wahooorsomething.ogg', 'wahoo2.ogg', 'yippeeorsomethingg.ogg', 'charhooray.ogg'}, -- Long jump
    [CHAR_SOUND_DOH] = 'walldonk.ogg', -- Long jump wall bonk
    [CHAR_SOUND_WHOA] = 'charwup.ogg', -- Grabbing ledge
    [CHAR_SOUND_EEUH] = 'chareffort.ogg', -- Climbing over ledge
    [CHAR_SOUND_WAAAOOOW] = 'Silent.ogg', -- Falling a long distance
    [CHAR_SOUND_TWIRL_BOUNCE] = {'yippeeorsomething.ogg', 'wahooorsomething.ogg', 'yippeeorsomethingg.ogg'}, -- Bouncing off of a flower spring
    [CHAR_SOUND_GROUND_POUND_WAH] = 'Silent.ogg',
    [CHAR_SOUND_HRMM] = 'chareffort.ogg', -- Lifting something
    [CHAR_SOUND_HERE_WE_GO] = {'transrights.ogg', "akaktuseoncesaidhooray.ogg"}, -- Star get
    [CHAR_SOUND_SO_LONGA_BOWSER] = 'fuckyou.ogg', -- Throwing Bowser
--DAMAGE
    [CHAR_SOUND_ATTACKED] = 'walldonk.ogg', -- Damaged
    [CHAR_SOUND_PANTING] = 'Silent.ogg', -- Low health
    [CHAR_SOUND_ON_FIRE] = 'charscream.ogg', -- Burned
--SLEEP SOUNDS
    [CHAR_SOUND_IMA_TIRED] = 'Silent.ogg', -- Mario feeling tired
    [CHAR_SOUND_YAWNING] = 'Silent.ogg', -- Mario yawning before he sits down to sleep
    [CHAR_SOUND_SNORING1] = 'Silent.ogg', -- Snore Inhale
    [CHAR_SOUND_SNORING2] = 'Silent.ogg', -- Exhale
    [CHAR_SOUND_SNORING3] = 'Silent.ogg', -- Sleep talking / mumbling
--COUGHING (USED IN THE GAS MAZE)
    [CHAR_SOUND_COUGHING1] = 'Cough1.ogg', -- Cough take 1
    [CHAR_SOUND_COUGHING2] = 'Cough2.ogg', -- Cough take 2
    [CHAR_SOUND_COUGHING3] = 'Cough3.ogg', -- Cough take 3
--DEATH
    [CHAR_SOUND_DYING] = 'chardead.ogg', -- Dying from damage
    [CHAR_SOUND_DROWNING] = 'drownt.ogg', -- Running out of air underwater
    [CHAR_SOUND_MAMA_MIA] = 'Silent.ogg', -- Booted out of level
--CUSTOM
  --  [CHAR_SOUND_FLAMEON] = 'flintandsteeel.ogg',
}

local VOICETABLE_MUTEDMAN = {
    [CHAR_SOUND_OKEY_DOKEY] = 'Silent.ogg', -- Starting game
    [CHAR_SOUND_LETS_A_GO] = 'Silent.ogg', -- Starting level
    [CHAR_SOUND_PUNCH_YAH] = 'Silent.ogg', -- Punch 1
    [CHAR_SOUND_PUNCH_WAH] = 'Silent.ogg', -- Punch 2
    [CHAR_SOUND_PUNCH_HOO] = {'Silent.ogg', 'Silent.ogg'}, -- Punch 3
    [CHAR_SOUND_YAH_WAH_HOO] = {'Silent.ogg', 'Silent.ogg', 'Silent.ogg'}, -- First/Second jump sounds
    [CHAR_SOUND_HOOHOO] = 'Silent.ogg', -- Third jump sound
    [CHAR_SOUND_YAHOO_WAHA_YIPPEE] = {'Silent.ogg', 'Silent.ogg'}, -- Triple jump sounds
    [CHAR_SOUND_UH] = 'Silent.ogg', -- Wall bonk
    [CHAR_SOUND_UH2] = 'Silent.ogg', -- Landing after long jump
    [CHAR_SOUND_UH2_2] = 'Silent.ogg', -- Same sound as UH2; jumping onto ledge
    [CHAR_SOUND_HAHA] = 'Silent.ogg', -- Landing triple jump
    [CHAR_SOUND_YAHOO] = {'Silent.ogg', 'Silent.ogg', 'Silent.ogg'}, -- Long jump
    [CHAR_SOUND_DOH] = 'Silent.ogg', -- Long jump wall bonk
    [CHAR_SOUND_WHOA] = 'Silent.ogg', -- Grabbing ledge
    [CHAR_SOUND_EEUH] = 'Silent.ogg', -- Climbing over ledge
    [CHAR_SOUND_WAAAOOOW] = 'Silent.ogg', -- Falling a long distance
    [CHAR_SOUND_TWIRL_BOUNCE] = 'Silent.ogg', -- Bouncing off of a flower spring
    [CHAR_SOUND_GROUND_POUND_WAH] = 'Silent.ogg', 
    [CHAR_SOUND_HRMM] = 'Silent.ogg', -- Lifting something
    [CHAR_SOUND_HERE_WE_GO] = 'Silent.ogg', -- Star get
    [CHAR_SOUND_SO_LONGA_BOWSER] = 'Silent.ogg', -- Throwing Bowser
--DAMAGE
    [CHAR_SOUND_ATTACKED] = 'Silent.ogg', -- Damaged
    [CHAR_SOUND_PANTING] = 'Silent.ogg', -- Low health
    [CHAR_SOUND_ON_FIRE] = 'Silent.ogg', -- Burned
--SLEEP SOUNDS
    [CHAR_SOUND_IMA_TIRED] = 'Silent.ogg', -- Mario feeling tired
    [CHAR_SOUND_YAWNING] = 'Silent.ogg', -- Mario yawning before he sits down to sleep
    [CHAR_SOUND_SNORING1] = 'Silent.ogg', -- Snore Inhale
    [CHAR_SOUND_SNORING2] = 'Silent.ogg', -- Exhale
    [CHAR_SOUND_SNORING3] = 'Silent.ogg', -- Sleep talking / mumbling
--COUGHING (USED IN THE GAS MAZE)
    [CHAR_SOUND_COUGHING1] = 'Silent.ogg', -- Cough take 1
    [CHAR_SOUND_COUGHING2] = 'Silent.ogg', -- Cough take 2
    [CHAR_SOUND_COUGHING3] = 'Silent.ogg', -- Cough take 3
--DEATH
    [CHAR_SOUND_DYING] = 'Silent.ogg', -- Dying from damage
    [CHAR_SOUND_DROWNING] = 'Silent.ogg', -- Running out of air underwater
    [CHAR_SOUND_MAMA_MIA] = 'Silent.ogg' -- Booted out of level
--CUSTOM
   -- [CHAR_SOUND_FLAMEON] = 'Silent.ogg',
}

VOICETABLE_CHARLOTTEGIRL = {
    [CHAR_SOUND_OKEY_DOKEY] = 'dsi-startup2.mp3', -- Starting game
    [CHAR_SOUND_LETS_A_GO] = 'Silent.ogg', -- Starting level
    [CHAR_SOUND_PUNCH_YAH] = 'Silent.ogg', -- Punch 1
    [CHAR_SOUND_PUNCH_WAH] = 'Silent.ogg', -- Punch 2
    [CHAR_SOUND_PUNCH_HOO] = {'Silent.ogg', 'Silent.ogg'}, -- Punch 3
    [CHAR_SOUND_YAH_WAH_HOO] = {'Silent.ogg', 'Silent.ogg', 'Silent.ogg'}, -- First/Second jump sounds
    [CHAR_SOUND_HOOHOO] = 'Silent.ogg', -- Third jump sound
    [CHAR_SOUND_YAHOO_WAHA_YIPPEE] = {'girljump.ogg', 'wahoogirl.ogg'}, -- Triple jump sounds
    [CHAR_SOUND_UH] = 'girlugh.ogg', -- Wall bonk
    [CHAR_SOUND_UH2] = 'Silent.ogg', -- Landing after long jump
    [CHAR_SOUND_UH2_2] = 'Silent.ogg', -- Same sound as UH2; jumping onto ledge
    [CHAR_SOUND_HAHA] = 'Silent.ogg', -- Landing triple jump
    [CHAR_SOUND_YAHOO] = {'wahoogirl.ogg', 'wahoogirl2.ogg', 'wahoogirl.ogg', 'wahoogirl2.ogg', 'wahooorsmth.ogg'}, -- Long jump
    [CHAR_SOUND_DOH] = 'Silent.ogg', -- Long jump wall bonk
    [CHAR_SOUND_WHOA] = 'Silent.ogg', -- Grabbing ledge
    [CHAR_SOUND_EEUH] = 'Silent.ogg', -- Climbing over ledge
    [CHAR_SOUND_WAAAOOOW] = 'Silent.ogg', -- Falling a long distance
    [CHAR_SOUND_TWIRL_BOUNCE] = 'Silent.ogg', -- Bouncing off of a flower spring
    [CHAR_SOUND_GROUND_POUND_WAH] = 'Silent.ogg', 
    [CHAR_SOUND_HRMM] = 'Silent.ogg', -- Lifting something
    [CHAR_SOUND_HERE_WE_GO] = {'wahooorsmth.ogg', 'girlflint.ogg'}, -- Star get
    [CHAR_SOUND_SO_LONGA_BOWSER] = 'Silent.ogg', -- Throwing Bowser
--DAMAGE
    [CHAR_SOUND_ATTACKED] = 'Silent.ogg', -- Damaged
    [CHAR_SOUND_PANTING] = 'Silent.ogg', -- Low health
    [CHAR_SOUND_ON_FIRE] = 'girlAAAAAAA.ogg', -- Burned
--SLEEP SOUNDS
    [CHAR_SOUND_IMA_TIRED] = {'girlcomin.ogg', 'girlflint.ogg', 'toothpastegirl.ogg'}, -- Mario feeling tired
    [CHAR_SOUND_YAWNING] = 'Silent.ogg', -- Mario yawning before he sits down to sleep
    [CHAR_SOUND_SNORING1] = 'Silent.ogg', -- Snore Inhale
    [CHAR_SOUND_SNORING2] = 'Silent.ogg', -- Exhale
    [CHAR_SOUND_SNORING3] = 'Silent.ogg', -- Sleep talking / mumbling
--COUGHING (USED IN THE GAS MAZE)
    [CHAR_SOUND_COUGHING1] = 'Silent.ogg', -- Cough take 1
    [CHAR_SOUND_COUGHING2] = 'Silent.ogg', -- Cough take 2
    [CHAR_SOUND_COUGHING3] = 'Silent.ogg', -- Cough take 3
--DEATH
    [CHAR_SOUND_DYING] = 'sobgirl.ogg', -- Dying from damage
    [CHAR_SOUND_DROWNING] = 'Silent.ogg', -- Running out of air underwater
    [CHAR_SOUND_MAMA_MIA] = 'Silent.ogg' -- Booted out of level
--CUSTOM
   -- [CHAR_SOUND_FLAMEON] = 'flintandsteeel.ogg',
}

VOICETABLE_HOORAY = {
    [CHAR_SOUND_OKEY_DOKEY] = 'hisonlysound.ogg', -- Starting game
    [CHAR_SOUND_LETS_A_GO] = 'hisonlysound.ogg', -- Starting level
    [CHAR_SOUND_PUNCH_YAH] = 'hisonlysound.ogg', -- Punch 1
    [CHAR_SOUND_PUNCH_WAH] = 'hisonlysound.ogg', -- Punch 2
    [CHAR_SOUND_PUNCH_HOO] = {'hisonlysound.ogg', 'hisonlysound.ogg'}, -- Punch 3
    [CHAR_SOUND_YAH_WAH_HOO] = {'hisonlysound.ogg', 'hisonlysound.ogg', 'hisonlysound.ogg'}, -- First/Second jump sounds
    [CHAR_SOUND_HOOHOO] = 'hisonlysound.ogg', -- Third jump sound
    [CHAR_SOUND_YAHOO_WAHA_YIPPEE] = {'hisonlysound.ogg', 'hisonlysound.ogg'}, -- Triple jump sounds
    [CHAR_SOUND_UH] = 'hisonlysound.ogg', -- Wall bonk
    [CHAR_SOUND_UH2] = 'hisonlysound.ogg', -- Landing after long jump
    [CHAR_SOUND_UH2_2] = 'hisonlysound.ogg', -- Same sound as UH2; jumping onto ledge
    [CHAR_SOUND_HAHA] = 'hisonlysound.ogg', -- Landing triple jump
    [CHAR_SOUND_YAHOO] = {'hisonlysound.ogg', 'hisonlysound.ogg', 'hisonlysound.ogg'}, -- Long jump
    [CHAR_SOUND_DOH] = 'hisonlysound.ogg', -- Long jump wall bonk
    [CHAR_SOUND_WHOA] = 'hisonlysound.ogg', -- Grabbing ledge
    [CHAR_SOUND_EEUH] = 'hisonlysound.ogg', -- Climbing over ledge
    [CHAR_SOUND_WAAAOOOW] = 'hisonlysound.ogg', -- Falling a long distance
    [CHAR_SOUND_TWIRL_BOUNCE] = 'hisonlysound.ogg', -- Bouncing off of a flower spring
    [CHAR_SOUND_GROUND_POUND_WAH] = 'hisonlysound.ogg', 
    [CHAR_SOUND_HRMM] = 'hisonlysound.ogg', -- Lifting something
    [CHAR_SOUND_HERE_WE_GO] = 'hisonlysound.ogg', -- Star get
    [CHAR_SOUND_SO_LONGA_BOWSER] = 'hisonlysound.ogg', -- Throwing Bowser
--DAMAGE
    [CHAR_SOUND_ATTACKED] = 'hisonlysound.ogg', -- Damaged
    [CHAR_SOUND_PANTING] = 'hisonlysound.ogg', -- Low health
    [CHAR_SOUND_ON_FIRE] = 'hisonlysound.ogg', -- Burned
--SLEEP SOUNDS
    [CHAR_SOUND_IMA_TIRED] = 'hisonlysound.ogg', -- Mario feeling tired
    [CHAR_SOUND_YAWNING] = 'hisonlysound.ogg', -- Mario yawning before he sits down to sleep
    [CHAR_SOUND_SNORING1] = 'hisonlysound.ogg', -- Snore Inhale
    [CHAR_SOUND_SNORING2] = 'hisonlysound.ogg', -- Exhale
    [CHAR_SOUND_SNORING3] = 'hisonlysound.ogg', -- Sleep talking / mumbling
--COUGHING (USED IN THE GAS MAZE)
    [CHAR_SOUND_COUGHING1] = 'hisonlysound.ogg', -- Cough take 1
    [CHAR_SOUND_COUGHING2] = 'hisonlysound.ogg', -- Cough take 2
    [CHAR_SOUND_COUGHING3] = 'hisonlysound.ogg', -- Cough take 3
--DEATH
    [CHAR_SOUND_DYING] = 'hisonlysound.ogg', -- Dying from damage
    [CHAR_SOUND_DROWNING] = 'hisonlysound.ogg', -- Running out of air underwater
    [CHAR_SOUND_MAMA_MIA] = 'hisonlysound.ogg' -- Booted out of level
--CUSTOM
   -- [CHAR_SOUND_FLAMEON] = 'hisonlysound.ogg',
}

ANIMTABLE_CHARLOTTE = {
    [CHAR_ANIM_RUNNING] = 'notstolenfromsaul',
    [CHAR_ANIM_WALKING] = 'notstolenfromsaul',

    --[CHAR_ANIM_CROUCHING] = 'idlemoment',

    [CHAR_ANIM_IDLE_HEAD_CENTER] = 'idlemoment',
    [CHAR_ANIM_IDLE_HEAD_LEFT] = 'idlemoment',
    [CHAR_ANIM_IDLE_HEAD_RIGHT] = 'idlemoment',
    [charSelect.CS_ANIM_MENU] = 'idlealtt'
   -- [CHAR_ANIM_TWIRL] = 'spinnything',
}

animTables = {
    ANIMTABLE_CHARLOTTE
}

-- All Located in "actors"
local CAPTABLE_CHAR = {
    normal = smlua_model_util_get_id("CthewinB_geo"),
    wing = smlua_model_util_get_id("CthewinB_geo"),
    metal = smlua_model_util_get_id("CthewinB_geo"),
}

PALETTE_CHARLOTTE = {
    name = "Charlotte",
    [PANTS]  = "111217FF",
    [SHIRT]  = "0F0D32FF",
    [GLOVES] = "E5E5FFFF",
    [SHOES]  = "0F0D32FF",
    [HAIR]   = "7A4D24FF",
    [SKIN]   = "F49969FF",
    [CAP]    = "27123DFF",
    [EMBLEM] = "05031AFF"
}

PALETTE_TRANS = {
    name = "Transgender",
    [PANTS]  = "FFFFFFFF",
    [SHIRT]  = "81346AFF",
    [GLOVES] = "E5E5FFFF",
    [SHOES]  = "5BCEFAFF",
    [HAIR]   = "4198B8FF",
    [SKIN]   = "F49969FF",
    [CAP]    = "27123DFF",
    [EMBLEM] = "05031AFF"
}

PALETTE_COMFY = {
    name = "Comfy",
    [PANTS]  = "525252FF",
    [SHIRT]  = "100F24FF",
    [GLOVES] = "FFFFFFFF",
    [SHOES]  = "04040FFF",
    [HAIR]   = "7A4D24FF",
    [SKIN]   = "F49969FF",
    [CAP]    = "27123DFF",
    [EMBLEM] = "A80932FF"
}

PALETTE_CHARLOTTE_CLASSIC = {
    name = "Classic Charlotte",
    [PANTS]  = "211E47FF",
    [SHIRT]  = "7F1952FF",
    [GLOVES] = "E5E5FFFF",
    [SHOES]  = "1F1F23FF",
    [HAIR]   = "985A2CFF",
    [SKIN]   = "FF9D6BFF",
    [CAP]    = "27123DFF",
    [EMBLEM] = "05031AFF"
}

PALETTE_CHARLOTTE_SWAGGER = {
    name = "Swagger Charlotte",
    [PANTS]  = "1F1E25FF",
    [SHIRT]  = "28A89CFF",
    [GLOVES] = "E5E5FFFF",
    [SHOES]  = "1F1F23FF",
    [HAIR]   = "985A2CFF",
    [SKIN]   = "FF9D6BFF",
    [CAP]    = "27123DFF",
    [EMBLEM] = "05031AFF"
}

PALETTE_MADMARCUS = {
    name = "Mad Marcus",
    [PANTS]  = "336E54FF",
    [SHIRT]  = "E52703FF",
    [GLOVES] = "FFFFFFFF",
    [SHOES]  = "6A0400FF",
    [HAIR]   = "6A0400FF",
    [SKIN]   = "FFD987FF",
    [CAP]    = "E52703FF",
    [EMBLEM] = "E52703FF"
}

local HM_WINBREAKER= {
    label = {
        left = get_texture_info("invis"),
        right = get_texture_info("invis"),
    },
    pie = {
        [1] = get_texture_info("invis1"),
        [2] = get_texture_info("invis1"),
        [3] = get_texture_info("invis1"),
        [4] = get_texture_info("invis1"),
        [5] = get_texture_info("invis1"),
        [6] = get_texture_info("invis1"),
        [7] = get_texture_info("invis1"),
        [8] = get_texture_info("invis1"),
   }
}

local CSloaded = false
local function on_character_select_load()
    CT_WINBREAKER = _G.charSelect.character_add("Charlotte", {"she breaks windows", "probably"}, "WindowBreaker Charlotte", {r = 85, g = 0, b = 150}, E_MODEL_CUSTOM_MODEL, CT_MARIO, TEX_CUSTOM_LIFE_ICON)

    _G.charSelect.character_set_category(CT_WINBREAKER, "DXA")
    _G.charSelect.character_set_category(CT_WINBREAKER, "Silent Hill server")
    _G.charSelect.character_set_category(CT_WINBREAKER, "Squishy Workshop")
    _G.charSelect.character_add_health_meter(CT_WINBREAKER, HM_WINBREAKER)

    local CSGRAFFITICHARLIE = get_texture_info("charlottegraffiti")
    _G.charSelect.character_add_graffiti(CT_WINBREAKER, CSGRAFFITICHARLIE)

    local CSTUNECHARLIE = audio_stream_load("holyshitmusicreal.ogg")
    _G.charSelect.character_add_menu_instrumental(CT_WINBREAKER, CSTUNECHARLIE)
    --main
    _G.charSelect.character_add_caps(E_MODEL_CUSTOM_MODEL, CAPTABLE_CHAR)
    _G.charSelect.character_add_voice(E_MODEL_CUSTOM_MODEL, VOICETABLE_WINBREAKER)
    _G.charSelect.character_add_animations(E_MODEL_CUSTOM_MODEL, ANIMTABLE_CHARLOTTE)
    _G.charSelect.character_add_palette_preset(E_MODEL_CUSTOM_MODEL, PALETTE_CHARLOTTE, "charlotte")
    _G.charSelect.character_add_palette_preset(E_MODEL_CUSTOM_MODEL, PALETTE_TRANS, "trans")

    _G.charSelect.character_add_palette_preset(E_MODEL_MARIO, PALETTE_MADMARCUS, "mad marcus")

    --_G.charSelect.character_add_celebration_star(E_MODEL_CUSTOM_MODEL, E_MODEL_CUSTOM_STAR, TEX_CUSTOM_STAR_ICON)

    --gold
    _G.charSelect.character_add_caps(E_MODEL_COMFY, CAPTABLE_CHAR)
    _G.charSelect.character_add_voice(E_MODEL_COMFY, VOICETABLE_WINBREAKER)
    _G.charSelect.character_add_animations(E_MODEL_COMFY, ANIMTABLE_CHARLOTTE)
    _G.charSelect.character_add_palette_preset(E_MODEL_COMFY, PALETTE_COMFY, "comfy")

    _G.charSelect.character_add_celebration_star(E_MODEL_CUSTOM_MODEL, E_MODEL_CUSTOM_STAR, TEX_CUSTOM_STAR_ICON)

    --[[classic fit
    _G.charSelect.character_add_animations(E_MODEL_OLDFIT, ANIMTABLE_CHARLOTTE)
    _G.charSelect.character_add_voice(E_MODEL_OLDFIT, VOICETABLE_CHARLOTTEGIRL)
    _G.charSelect.character_add_palette_preset(E_MODEL_OLDFIT, PALETTE_CHARLOTTE_CLASSIC)

    _G.charSelect.character_add_caps(E_MODEL_SWAGGER, CAPTABLE_CHAR)
    _G.charSelect.character_add_voice(E_MODEL_SWAGGER, VOICETABLE_CHARLOTTEGIRL)
    _G.charSelect.character_add_animations(E_MODEL_SWAGGER, ANIMTABLE_CHARLOTTE)
    _G.charSelect.character_add_palette_preset(E_MODEL_SWAGGER, PALETTE_CHARLOTTE_SWAGGER)
]]
    --costumes
    _G.charSelect.character_add_costume(CT_WINBREAKER, "comfy Charlotte", {"standing at 5 feet and 8 inches, weighing in at 146 pounds, she is here to...", "have a comfortable rest."}, "WindowBreaker Charlotte", {r = 20, g = 0, b = 150}, E_MODEL_COMFY, CT_WINBREAKER, TEX_LIFE_ICON, nil, nil)
    --[[ _G.charSelect.character_add_costume(CT_WINBREAKER, "Classic Charlotte", {"SHE breaks windows or something", "brought back from the egg days"}, "WindowBreaker Charlotte", {r = 85, g = 0, b = 150}, E_MODEL_OLDFIT, CT_WINBREAKER, TEX_LIFE_ICON, nil, nil)
    _G.charSelect.character_add_costume(CT_WINBREAKER, "The Doctor", {"She breaks windows or time", "would you like a jellybaby officer?"}, "WindowBreaker Charlotte", {r = 0, g = 59, b = 111}, E_MODEL_8THCHA, CT_WINBREAKER, TEX_LIFE_ICON, nil, nil)
    _G.charSelect.character_add_costume(CT_WINBREAKER, "Swag Charlotte", {"the return of :swagger:", "B)"}, "WindowBreaker Charlotte", {r = 0, g = 150, b = 150}, E_MODEL_SWAGGER, CT_WINBREAKER, TEX_LIFE_ICON, nil, nil)
    ]]

    if CT_KAKTUS ~= nil then

    _G.charSelect.character_add_voice(E_MODEL_BABYKAK, VOICETABLE_HOORAY)

    local PALETTE_KAKTUS = {
        name = "Kaktus",
        [PANTS]  = "313149",
        [SHIRT]  = "791E82",
        [GLOVES] = "FFFFFF",
        [SHOES]  = "D8004D",
        [HAIR]   = "743F39",
        [SKIN]   = "DB9C70",
        [CAP]    = "3E8948",
	    [EMBLEM] = "D87644"
    }
        _G.charSelect.character_add_palette_preset(E_MODEL_CUSTOM_MODEL, PALETTE_KAKTUS, "kaktuse")
        _G.charSelect.character_add_palette_preset(E_MODEL_BABYKAK, PALETTE_KAKTUS, "Kaktus")
        _G.charSelect.character_add_costume(CT_KAKTUS, "baby kaktus", {"this little BASTARD is", "1 month younger than charlotte"}, "WindowBreaker Charlotte", {r = 172, g = 80, b = 255}, E_MODEL_BABYKAK, CT_TOAD, KAKTUS_ICON, nil, nil)
    end

    --[[if CT_BEEF_SAUL ~= nil then
    local PALETTE_SAUL = {
        name = "Saul",
        [PANTS]  = "313149",
        [SHIRT]  = "791E82",
        [GLOVES] = "FFFFFF",
        [SHOES]  = "D8004D",
        [HAIR]   = "743F39",
        [SKIN]   = "DB9C70",
        [CAP]    = "3E8948",
	    [EMBLEM] = "D87644"
    }
        _G.charSelect.character_add_palette_preset(E_MODEL_BABYSAUL, PALETTE_SAUL, "Kaktus")
        _G.charSelect.character_add_animations(E_MODEL_BABYSAUL, ANIMTABLE_BEEF_SAUL)
        _G.charSelect.character_add_costume(CT_BEEF_SAUL, "Baby Saul", {"this little BASTARD is", "never going to leave."}, "WindowBreaker Charlotte", {r = 162, g = 196, b = 106}, E_MODEL_BABYSAUL, CT_TOAD, nil, nil, nil)
    end]]

    alts = {}
    add_moveset()
    CSloaded = true
end

local CST_CHARLIE   = 1
local CST_CHARLOTTE = 2
local CST_DOCTOR    = 3
local CST_HEATHER   = 4
local CST_CHRRL = 5

function charlie_update(m)
  --  if charSelect.character_get_current_number(m.playerIndex) == CT_WINBREAKER and
  --  m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_STAR_DANCE then

    --regenerate
    if charSelect.character_get_current_number(m.playerIndex) == CT_WINBREAKER
    and charSelect.character_get_current_costume(m.playerIndex) == CST_DOCTOR and regenActions[m.action] then
        spawn_non_sync_object(id_bhvCoinSparkles, E_MODEL_GLOW,
            get_hand_foot_pos_x(m, 1),
            get_hand_foot_pos_y(m, 1),
            get_hand_foot_pos_z(m, 1),
            nil)
        spawn_non_sync_object(id_bhvCoinSparkles, E_MODEL_GLOW,
            get_hand_foot_pos_x(m, 0),
            get_hand_foot_pos_y(m, 0),
            get_hand_foot_pos_z(m, 0),
            nil)
    end
end

local voices = {
    [VOICETABLE_WINBREAKER] = 1,
    [VOICETABLE_MUTEDMAN] = 1,
    [VOICETABLE_CHARLOTTEGIRL] = 1,
    [VOICETABLE_HOORAY] = 1
}

local function on_character_sound(m, sound)
    if not CSloaded then return end
    if voices[_G.charSelect.character_get_voice(m)] then return _G.charSelect.voice.sound(m, sound) end
end

local function on_character_snore(m)
    if not CSloaded then return end
    if voices[_G.charSelect.character_get_voice(m)] then return _G.charSelect.voice.snore(m) end
end

hook_event(HOOK_ON_MODS_LOADED, on_character_select_load)
hook_event(HOOK_CHARACTER_SOUND, on_character_sound)
hook_event(HOOK_MARIO_UPDATE, on_character_snore)
--[[
local function menupose(m)
    if _G.charSelect.is_menu_open() and
    CT_WINBREAKER == _G.charSelect.character_get_current_number() and m.playerIndex == 0 then
        smlua_anim_util_set_animation(m.marioObj, "idlingman")
        --m.marioBodyState.eyeState = 4
        --m.marioBodyState.handState = MARIO_HAND_PEACE_SIGN
        end
    end

    hook_event(HOOK_MARIO_UPDATE, menupose)]]

local metreCharlie = {
    get_texture_info("0CHA"),
    get_texture_info("1CHA"),
    get_texture_info("2CHA"),
    get_texture_info("3CHA"),
    get_texture_info("4CHA"),
    get_texture_info("5CHA"),
    get_texture_info("6CHA"),
    get_texture_info("7CHA"),
    get_texture_info("8CHA"),
}
--[[
local metreCharlotte = {
    get_texture_info("0CHT"),
    get_texture_info("1CHT"),
    get_texture_info("2CHT"),
    get_texture_info("3CHT"),
    get_texture_info("4CHT"),
    get_texture_info("5CHT"),
    get_texture_info("6CHT"),
    get_texture_info("7CHT"),
    get_texture_info("8CHT"),
}

local metreDoctor = {
    get_texture_info("0DOC"),
    get_texture_info("1DOC"),
    get_texture_info("2DOC"),
    get_texture_info("3DOC"),
    get_texture_info("4DOC"),
    get_texture_info("5DOC"),
    get_texture_info("6DOC"),
    get_texture_info("7DOC"),
    get_texture_info("8DOC"),
}

-- local metreHeather = {
--     get_texture_info("0HTH"),
--     get_texture_info("1HTH"),
--     get_texture_info("2HTH"),
--     get_texture_info("3HTH"),
--     get_texture_info("4HTH"),
--     get_texture_info("5HTH"),
--     get_texture_info("6HTH"),
--     get_texture_info("7HTH"),
--     get_texture_info("8HTH"),
-- }]]

local costumeMetres = {
    metreCharlie,
    metreCharlie,
    metreCharlie,
    metreCharlie
}

local strmDSiStartup = audio_stream_load("dsi-startup.mp3")
local DSiplayed = true

function render_ds_metre()
    local m = gMarioStates[0]
    local metre = costumeMetres[charSelect.character_get_current_costume()]
    if metre and charSelect.character_get_current_number() == CT_WINBREAKER and m.action ~= ACT_END_PEACH_CUTSCENE then
        local numHealthWedges = m.health > 0 and math.min(m.health >> 8, 8) or 0
        local fullyHealed = numHealthWedges >= 8
        if fullyHealed and fullyHealed ~= DSiplayed then
            audio_stream_play(strmDSiStartup, true, 1)
        end
        DSiplayed = fullyHealed
    
        djui_hud_set_resolution(RESOLUTION_N64)
        
        local s = 1
        djui_hud_render_texture(metre[numHealthWedges+1], -10, 255 - (-20 - -100)*s, s, s)
    end
end
hook_event(HOOK_ON_HUD_RENDER_BEHIND, render_ds_metre)

function is_charlotte()
    return CT_WINBREAKER == charSelect.character_get_current_number()
end