-- name: [CS] BreakfastBreaker \\#2328c0\\Charlie
-- description: thanks to Cooliokid956 for programming the health metre, and for rewriting a lot of code.\n\n\\#ff7777\\This Pack requires Character Select\nto use as a Library!

--[[
    API Documentation for Character Select can be found below:
    https://github.com/Squishy6094/character-select-coop/wiki/API-Documentation

    Use this if you're curious on how anything here works >v<
    (This is an edited version of the Template File by Squishy)
]]

local CST_DOC = 0
local TEXT_MOD_NAME = "BreakfastBreaker Charlie"

-- Stops mod from loading if Character Select isn't on
if not _G.charSelectExists then
    djui_popup_create("\\#ffffdc\\\n"..TEXT_MOD_NAME.."\nRequires the Character Select Mod\nto use as a Library!\n\nPlease turn on the Character Select Mod\nand Restart the Room!", 6)
    return 0
end
local E_MODEL_GLOW = smlua_model_util_get_id("glows_geo") -- regeneffect

local E_MODEL_CUSTOM_MODEL = smlua_model_util_get_id("winbch_geo") -- main costume
local E_MODEL_4THCHA = smlua_model_util_get_id("winbch4th_geo") -- 4th doctor costume
local E_MODEL_CHAGIRL = smlua_model_util_get_id("gwinbch_geo") -- girl costume
local E_MODEL_CHAGIRLHEATHER = smlua_model_util_get_id("heathergwinbch_geo") -- heather costume
local E_MODEL_CHRRRL = smlua_model_util_get_id("gwinbchrrli_geo") -- chrrli costume

--icons
local TEX_CUSTOM_LIFE_ICON = get_texture_info("Cicon")
local TEX_GIRL_LIFE_ICON = get_texture_info("Cicongirl")

-- All Located in "sound" Name them whatever you want. Remember to include the .ogg extension
local VOICETABLE_WINBREAKER = {
    [CHAR_SOUND_OKEY_DOKEY] = 'dsi-startup2.mp3', -- Starting game
    [CHAR_SOUND_LETS_A_GO] = 'levelstart2.ogg', -- Starting level
    [CHAR_SOUND_PUNCH_YAH] = 'Silent.ogg', -- Punch 1
    [CHAR_SOUND_PUNCH_WAH] = 'Silent.ogg', -- Punch 2
    [CHAR_SOUND_PUNCH_HOO] = {'Silent.ogg', 'Silent.ogg'}, -- Punch 3
    [CHAR_SOUND_YAH_WAH_HOO] = {'Silent.ogg', 'Silent.ogg', 'Silent.ogg'}, -- First/Second jump sounds
    [CHAR_SOUND_HOOHOO] = {'yipeee.ogg', 'wEee.ogg'}, -- Third jump sound
    [CHAR_SOUND_YAHOO_WAHA_YIPPEE] = {'wee.ogg', 'yipeee.ogg', 'wEee.ogg'}, -- Triple jump sounds
    [CHAR_SOUND_UH] = 'walldonk.ogg', -- Wall bonk
    [CHAR_SOUND_UH2] = 'wup.ogg', -- Landing after long jump
    [CHAR_SOUND_UH2_2] = 'Silent.ogg', -- Same sound as UH2; jumping onto ledge
    [CHAR_SOUND_HAHA] = 'lag.ogg', -- Landing triple jump
    [CHAR_SOUND_YAHOO] = {'wahooo.ogg', 'wahoo2.ogg', 'wahoo3.ogg'}, -- Long jump
    [CHAR_SOUND_DOH] = 'walldonk.ogg', -- Long jump wall bonk
    [CHAR_SOUND_WHOA] = 'wup.ogg', -- Grabbing ledge
    [CHAR_SOUND_EEUH] = 'yup.ogg', -- Climbing over ledge
    [CHAR_SOUND_WAAAOOOW] = 'ohno.ogg', -- Falling a long distance
    [CHAR_SOUND_TWIRL_BOUNCE] = {'wEee.ogg', 'yipeee.ogg'}, -- Bouncing off of a flower spring
    [CHAR_SOUND_GROUND_POUND_WAH] = 'Silent.ogg', 
    [CHAR_SOUND_HRMM] = 'Silent.ogg', -- Lifting something
    [CHAR_SOUND_HERE_WE_GO] = {'ididit.ogg', 'hl3.ogg', 'polarity.ogg', 'drwho2005reference.mp3', 'jellybaby.ogg'}, -- Star get
    [CHAR_SOUND_SO_LONGA_BOWSER] = 'fuckyou.ogg', -- Throwing Bowser
--DAMAGE
    [CHAR_SOUND_ATTACKED] = 'walldonk.ogg', -- Damaged
    [CHAR_SOUND_PANTING] = 'hurting1.ogg', -- Low health
    [CHAR_SOUND_ON_FIRE] = {'FUCKFUCKSHITAUGH.ogg', 'agonyy.ogg', 'FUCKAGH.ogg'}, -- Burned
--SLEEP SOUNDS
    [CHAR_SOUND_IMA_TIRED] = {'flintandsteeel.ogg', 'igiofn.ogg', 'flameon.ogg', 'oppengangamstyle.ogg'}, -- Mario feeling tired
    [CHAR_SOUND_YAWNING] = 'Silent.ogg', -- Mario yawning before he sits down to sleep
    [CHAR_SOUND_SNORING1] = 'Silent.ogg', -- Snore Inhale
    [CHAR_SOUND_SNORING2] = 'Silent.ogg', -- Exhale
    [CHAR_SOUND_SNORING3] = 'Silent.ogg', -- Sleep talking / mumbling
--COUGHING (USED IN THE GAS MAZE)
    [CHAR_SOUND_COUGHING1] = 'Cough1.ogg', -- Cough take 1
    [CHAR_SOUND_COUGHING2] = 'Cough2.ogg', -- Cough take 2
    [CHAR_SOUND_COUGHING3] = 'Cough3.ogg', -- Cough take 3
--DEATH
    [CHAR_SOUND_DYING] = 'dead.ogg', -- Dying from damage
    [CHAR_SOUND_DROWNING] = 'drownt.ogg', -- Running out of air underwater
    [CHAR_SOUND_MAMA_MIA] = 'ohfuckoff.ogg', -- Booted out of level
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

local VOICETABLE_GIRL = {
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

local ANIMTABLE_WINCH = {
    [CHAR_ANIM_RUNNING] = 'newchoppyrun',
    [CHAR_ANIM_WALKING] = 'newchoppyrun',

    --[CHAR_ANIM_CROUCHING] = 'newchoppyidle',

    [CHAR_ANIM_IDLE_HEAD_CENTER] = 'newchoppyidle',
    [CHAR_ANIM_IDLE_HEAD_LEFT] = 'newchoppyidle',
    [CHAR_ANIM_IDLE_HEAD_RIGHT] = 'newchoppyidle',
    [charSelect.CS_ANIM_MENU] = 'idlingman'
   -- [CHAR_ANIM_TWIRL] = 'spinnything',
}

local ANIMTABLE_GWINCH = {
    [CHAR_ANIM_RUNNING] = 'newchoppyrun',
    [CHAR_ANIM_WALKING] = 'newchoppyrun',

    --[CHAR_ANIM_CROUCHING] = 'girlidlenew',

    [CHAR_ANIM_IDLE_HEAD_CENTER] = 'girlidlenew',
    [CHAR_ANIM_IDLE_HEAD_LEFT] = 'girlidlenew',
    [CHAR_ANIM_IDLE_HEAD_RIGHT] = 'girlidlenew',
    [charSelect.CS_ANIM_MENU] = 'idlingman'
   -- [CHAR_ANIM_TWIRL] = 'spinnything',
}

local ANIMTABLE_SNOWINCH = {
    [CHAR_ANIM_RUNNING] = 'newchoppyrun',
    [CHAR_ANIM_WALKING] = 'newchoppyrun',

    [CHAR_ANIM_IDLE_HEAD_CENTER] = 'shiverin',
    [CHAR_ANIM_IDLE_HEAD_LEFT] = 'shiverin',
    [CHAR_ANIM_IDLE_HEAD_RIGHT] = 'shiverin',
  --  [CHAR_ANIM_TWIRL] = 'spinnything',
}

local ANIMTABLE_DRWINCH = {
    [CHAR_ANIM_RUNNING] = 'newchoppyrun',
    [CHAR_ANIM_WALKING] = 'newchoppyrun',

    --[CHAR_ANIM_CROUCHING] = 'newchoppyidle',

    [CHAR_ANIM_IDLE_HEAD_CENTER] = 'newchoppyidle',
    [CHAR_ANIM_IDLE_HEAD_LEFT] = 'newchoppyidle',
    [CHAR_ANIM_IDLE_HEAD_RIGHT] = 'newchoppyidle',
    [charSelect.CS_ANIM_MENU] = 'docpose'
   -- [CHAR_ANIM_TWIRL] = 'spinnything',
}

-- All Located in "actors"
local CAPTABLE_CHAR = {
    normal = smlua_model_util_get_id("winbch_geo"),
    wing = smlua_model_util_get_id("winbch_geo"),
    metal = smlua_model_util_get_id("winbch_geo"),
}

local PALETTE_CHAR = {
    [PANTS]  = "0D133CFF",
    [SHIRT]  = "FF00FFFF",
    [GLOVES] = "FFFFFFFF",
    [SHOES]  = "610061FF",
    [HAIR]   = "6F3C17FF",
    [SKIN]   = "FFA06EFF",
    [CAP]    = "0730AEFF",
    [EMBLEM] = "FFCA8AFF"
}

local PALETTE_HEATHER = {
    [PANTS]  = "215630FF",
    [SHIRT]  = "A34C1CFF",
    [GLOVES] = "FFFFFFFF",
    [SHOES]  = "994424FF",
    [HAIR]   = "6F3C17FF",
    [SKIN]   = "FFA06EFF",
    [CAP]    = "CFC2A4FF",
    [EMBLEM] = "FFCA8AFF"
}

local PALETTE_4THDOC = {
    [PANTS]  = "24528BFF",
    [SHIRT]  = "130A09FF",
    [GLOVES] = "EFEADCFF",
    [SHOES]  = "000000FF",
    [HAIR]   = "6F3C17FF",
    [SKIN]   = "FFA06EFF",
    [CAP]    = "180D0AFF",
    [EMBLEM] = "B8824FFF"
}

local PALETTE_CHAGIRL = {
    [PANTS]  = "123773FF",
    [SHIRT]  = "383838FF",
    [GLOVES] = "FFFFFFFF",
    [SHOES]  = "00994CFF",
    [HAIR]   = "6F3C17FF",
    [SKIN]   = "FFA06EFF",
    [CAP]    = "00B35AFF",
    [EMBLEM] = "FFCA8AFF"
}

local PALETTE_CHRRL = {
    [PANTS]  = "252A3AFF",
    [SHIRT]  = "D2C6A1FF",
    [GLOVES] = "FFFFFFFF",
    [SHOES]  = "090B0FFF",
    [HAIR]   = "6F3C17FF",
    [SKIN]   = "FFA06EFF",
    [CAP]    = "BBB8AEFF",
    [EMBLEM] = "FFCA8AFF"
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
    CT_WINBREAKER = _G.charSelect.character_add("Charlie", {"he breaks windows or breakfasts", "probably"}, "WindowBreaker Charlie", {r = 25, g = 0, b = 200}, E_MODEL_CUSTOM_MODEL, CT_WINBREAKER, TEX_CUSTOM_LIFE_ICON)
    if _G.customMovesExists then
        djui_popup_create("\\#2328c0\\\n"..TEXT_MOD_NAME.."\ndoesn't need the fucking easy custom movesets shit anymore, FUCK YEAH!", 6)
    end

    --_G.charSelect.character_set_category(CT_WINBREAKER, "Smackhead")
    _G.charSelect.character_set_category(CT_WINBREAKER, "DXA")
    _G.charSelect.character_set_category(CT_WINBREAKER, "Squishy Workshop")
    _G.charSelect.character_add_health_meter(CT_WINBREAKER, HM_WINBREAKER)

    --main
    _G.charSelect.character_add_caps(E_MODEL_CUSTOM_MODEL, CAPTABLE_CHAR)
    _G.charSelect.character_add_voice(E_MODEL_CUSTOM_MODEL, VOICETABLE_WINBREAKER)
    _G.charSelect.character_add_animations(E_MODEL_CUSTOM_MODEL, ANIMTABLE_WINCH)
    _G.charSelect.character_add_palette_preset(E_MODEL_CUSTOM_MODEL, PALETTE_CHAR)

    _G.charSelect.character_add_celebration_star(E_MODEL_CUSTOM_MODEL, E_MODEL_CUSTOM_STAR, TEX_CUSTOM_STAR_ICON)

    --4th
    _G.charSelect.character_add_caps(E_MODEL_4THCHA, CAPTABLE_CHAR)
    _G.charSelect.character_add_voice(E_MODEL_4THCHA, VOICETABLE_WINBREAKER)
    _G.charSelect.character_add_animations(E_MODEL_4THCHA, ANIMTABLE_DRWINCH)
    _G.charSelect.character_add_palette_preset(E_MODEL_4THCHA, PALETTE_4THDOC)

    _G.charSelect.character_add_celebration_star(E_MODEL_CUSTOM_MODEL, E_MODEL_CUSTOM_STAR, TEX_CUSTOM_STAR_ICON)

    --girl
    _G.charSelect.character_add_animations(E_MODEL_CHAGIRL, ANIMTABLE_GWINCH)
    _G.charSelect.character_add_voice(E_MODEL_CHAGIRL, VOICETABLE_GIRL)
    _G.charSelect.character_add_palette_preset(E_MODEL_CHAGIRL, PALETTE_CHAGIRL)

    --heather
    _G.charSelect.character_add_animations(E_MODEL_CHAGIRLHEATHER, ANIMTABLE_GWINCH)
    _G.charSelect.character_add_voice(E_MODEL_CHAGIRLHEATHER, VOICETABLE_GIRL)
    _G.charSelect.character_add_palette_preset(E_MODEL_CHAGIRLHEATHER, PALETTE_HEATHER)

        --girl
    _G.charSelect.character_add_animations(E_MODEL_CHRRRL, ANIMTABLE_GWINCH)
    _G.charSelect.character_add_voice(E_MODEL_CHRRRL, VOICETABLE_GIRL)
    _G.charSelect.character_add_palette_preset(E_MODEL_CHRRRL, PALETTE_CHRRL)

    --costumes
    _G.charSelect.character_add_costume(CT_WINBREAKER, "Charlotte", {"she breaks windows or breakfasts", "probably"}, "WindowBreaker Charlie, Voiced by Chrrli", {r = 150, g = 0, b = 200}, E_MODEL_CHAGIRL, CT_WINBREAKER, TEX_GIRL_LIFE_ICON, nil, nil)
    _G.charSelect.character_add_costume(CT_WINBREAKER, "The Doctor", {"he breaks windows or time", "fancy a jellybaby?"}, "WindowBreaker Charlie", {r = 0, g = 59, b = 111}, E_MODEL_4THCHA, CT_WINBREAKER, TEX_LIFE_ICON, nil, nil)
    _G.charSelect.character_add_costume(CT_WINBREAKER, "Heather", {"she silents the fuck outta some hills", "probably"}, "WindowBreaker Charlie, Voiced by Chrrli", {r = 150, g = 0, b = 200}, E_MODEL_CHAGIRLHEATHER, CT_WINBREAKER, TEX_GIRL_LIFE_ICON, nil, nil)
    _G.charSelect.character_add_costume(CT_WINBREAKER, "Chrrlie", {"toaster", "probably"}, "WindowBreaker Charlie, Voiced by Chrrli", {r = 150, g = 0, b = 200}, E_MODEL_CHRRRL, CT_WINBREAKER, TEX_GIRL_LIFE_ICON, nil, nil)

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
    [VOICETABLE_GIRL] = 1,
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
-- }

local costumeMetres = {
    metreCharlie,
    metreCharlotte,
    metreDoctor,
    metreCharlotte,
    metreCharlotte,
    -- metreHeather,
}

local strmDSiStartup = audio_stream_load("dsi-startup.mp3")
local DSiplayed = true

function render_ds_metre()
    local m = gMarioStates[0]
    local metre = costumeMetres[charSelect.character_get_current_costume()]
    if metre and charSelect.character_get_current_number() == CT_WINBREAKER then
        local numHealthWedges = m.health > 0 and math.min(m.health >> 8, 8) or 0
        local fullyHealed = numHealthWedges >= 8
        if fullyHealed and fullyHealed ~= DSiplayed then
            audio_stream_play(strmDSiStartup, true, 1)
        end
        DSiplayed = fullyHealed
    
        djui_hud_set_resolution(RESOLUTION_N64)
        
        local s = .25
        djui_hud_render_texture(metre[numHealthWedges+1], 4, 240 - (384 + 64)*s, s, s)
    end
end
hook_event(HOOK_ON_HUD_RENDER_BEHIND, render_ds_metre)