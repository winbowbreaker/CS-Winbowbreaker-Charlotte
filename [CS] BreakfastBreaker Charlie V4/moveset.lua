if not _G.charSelectExists then return end

local gCharlieStates = {}
for i = 0, MAX_PLAYERS do
    gCharlieStates[i] = {}
    local c = gCharlieStates[i]
    c.grav = 0
    c.facing = 0
    c.scale = { x = 1, y = 1, z = 1 }
    c.timer = 0
    c.backlaunch = 0
    c.savedmomentum = 0
end

--wallslide
ACT_WALL_SLIDE = (0x0BF | ACT_FLAG_AIR | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
function act_wall_slide(m)
    local c = gCharlieStates[m.playerIndex]
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        local rc = set_mario_action(m, ACT_WALL_KICK_AIR, 0)
        m.vel.y = 62.0
        mario_set_forward_vel(m, 35 + c.savedmomentum * 0.75)
        if m.forwardVel < 20.0 then
            m.forwardVel = 40.0
        end
        m.wallKickTimer = 0
        return rc
    end

    -- attempt to stick to the wall a bit. if it's 0, sometimes you'll get kicked off of slightly sloped walls
    mario_set_forward_vel(m, -1.0)

    m.particleFlags = m.particleFlags | PARTICLE_DUST

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject)
    set_mario_animation(m, MARIO_ANIM_START_WALLKICK)

    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        mario_set_forward_vel(m, 0.0)
        if check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then
            return set_mario_action(m, ACT_FREEFALL_LAND, 0)
        end
    end

    m.actionTimer = m.actionTimer + 1
    if m.wall == nil and m.actionTimer > 2 then
        mario_set_forward_vel(m, 0.0)
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    return 0
end
function act_wall_slide_gravity(m)
    m.vel.y = m.vel.y - 3

    if m.vel.y < -45 then
        m.vel.y = -45
    end
end
hook_mario_action(ACT_WALL_SLIDE, { every_frame = act_wall_slide, gravity = act_wall_slide_gravity } )

--wallslide above

ACT_CUSTOMTWIRLING = allocate_mario_action(ACT_GROUP_AIRBORNE|ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION|ACT_FLAG_ATTACKING|ACT_FLAG_AIR|ACT_FLAG_DIVING)
function act_customtwirling(m)
    local c = gCharlieStates[m.playerIndex]
    
    if (m.input & INPUT_ZERO_MOVEMENT ~= 0) then
        mario_set_forward_vel(m, m.forwardVel / 1.1)
        c.facing = m.intendedYaw
    m.faceAngle.y = c.facing
    end
     if (m.input & INPUT_ZERO_MOVEMENT == 0) then
        mario_set_forward_vel(m, m.forwardVel + 2)
        if m.forwardVel > 55 then
            mario_set_forward_vel(m, 55)
        end
    end

    c.facing = m.intendedYaw
    m.faceAngle.y = c.facing

    local stepResult = perform_air_step(m, 0)
    if stepResult == AIR_STEP_LANDED then --hitting the gound
        return set_mario_action(m, ACT_IDLE, 0)
    elseif m.wall then -- otherwise if we hit a wall
        m.faceAngle.y = -c.facing
        mario_bonk_reflection(m, true)
    end
    c.facing = m.intendedYaw
    m.faceAngle.y = c.facing
    m.vel.y = -10
    smlua_anim_util_set_animation(m.marioObj, "spinnylad")
end
hook_mario_action(ACT_CUSTOMTWIRLING, act_customtwirling)

ACT_LAUNCHEDBYEXPLODE = allocate_mario_action(ACT_GROUP_AIRBORNE|ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION|ACT_FLAG_ATTACKING|ACT_FLAG_AIR|ACT_FLAG_DIVING)
function act_launchedbyexplode(m)
    local c = gCharlieStates[m.playerIndex]

    c.grav = c.grav -5
    c.backlaunch = c.backlaunch + 0.25
    m.faceAngle.y = c.facing
    spawn_sync_object(id_bhvCoinSparkles, E_MODEL_BURN_SMOKE, m.pos.x, m.pos.y, m.pos.z, nil)
    m.vel.y = c.grav
    mario_set_forward_vel(m, c.backlaunch)

    local stepResult = perform_air_step(m, 0)
    if stepResult == AIR_STEP_LANDED then --hitting the gound
        return set_mario_action(m, ACT_BACKWARD_GROUND_KB, 0)
    elseif m.wall then -- otherwise if we hit a wall
        m.faceAngle.y = -c.facing
        mario_bonk_reflection(m, true)
        play_sound(SOUND_GENERAL_BOING2, m.marioObj.header.gfx.cameraToObject)
        return set_mario_action(m, ACT_LAUNCHEDBYEXPLODEF, 0)
    end

    smlua_anim_util_set_animation(m.marioObj, "spinnything")
    if m.forwardVel > 0 then 
        mario_set_forward_vel(m, 0)
    end
end
hook_mario_action(ACT_LAUNCHEDBYEXPLODE, act_launchedbyexplode)

ACT_SUPERSPRINT = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_ALLOW_FIRST_PERSON | ACT_FLAG_MOVING | ACT_FLAG_CUSTOM_ACTION)
function act_supersprint(m)
    local startPos = m.pos
    local startYaw = m.faceAngle.y
    mario_set_forward_vel(m, 55)

    local stepResult = perform_ground_step(m)
    if (stepResult == GROUND_STEP_LEFT_GROUND) then
        set_mario_action(m, ACT_FREEFALL, 0)
        set_character_animation(m, CHAR_ANIM_GENERAL_FALL)
    elseif (stepResult == GROUND_STEP_NONE) then
        anim_and_audio_for_walk(m)
        if ((m.intendedMag - m.forwardVel) > 16) then
            set_mario_particle_flags(m, PARTICLE_DUST, 0)
        end
    elseif (stepResult == GROUND_STEP_HIT_WALL) then
         mario_set_forward_vel(m, 30)
         set_mario_action(m, ACT_WALKING, 0)
        m.actionTimer = 0
    end

    if (should_begin_sliding(m) ~= 0) then
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_FIRST_PERSON ~= 0) then
        return begin_braking_action(m)
    end

    if (m.input & INPUT_A_PRESSED ~= 0) then
        return set_jump_from_landing(m)
    end

    if (check_ground_dive_or_punch(m) ~= 0) then
        return 1
    end

    if (m.input & INPUT_ZERO_MOVEMENT ~= 0) then
        return begin_braking_action(m)
    end

    if (analog_stick_held_back(m) ~= 0) then
        return set_mario_action(m, ACT_TURNING_AROUND, 0)
    end

    if (m.input & INPUT_Z_PRESSED ~= 0) then
        return set_mario_action(m, ACT_CROUCH_SLIDE, 0)
    end
    m.actionState = 0

    m.faceAngle.y = m.intendedYaw
    check_ledge_climb_down(m)
    return 0
end
hook_mario_action(ACT_SUPERSPRINT, act_supersprint)

ACT_IDLESECOND = allocate_mario_action(ACT_FLAG_CUSTOM_ACTION|ACT_FLAG_ALLOW_FIRST_PERSON)
function act_idlesecond(m)
    smlua_anim_util_set_animation(m.marioObj, "spinnything")
    if (m.input & INPUT_ZERO_MOVEMENT == 0) then
        return set_mario_action(m, ACT_IDLE, 0)
    end
end
hook_mario_action(ACT_IDLESECOND, act_idlesecond)

function add_moveset()

--local strmspinny = audio_stream_load("crashspin.ogg")

--moveset shit
charSelect.character_hook_moveset(CT_WINBREAKER, HOOK_BEFORE_SET_MARIO_ACTION,
function (m, inc)
    local c = gCharlieStates[m.playerIndex]
    local replace = {
        [ACT_START_CROUCHING]         = ACT_CROUCHING,
        [ACT_STOP_CROUCHING]          = ACT_IDLE,
        [ACT_STEEP_JUMP]              = ACT_JUMP,
        [ACT_TWIRL_LAND]              = ACT_JUMP_LAND_STOP,
     -- [ACT_PUNCHING]                = ACT_SPINNYTHING,
     -- [ACT_MOVE_PUNCHING]           = ACT_SPINNYTHING_AIR,
     -- [ACT_SOFT_BACKWARD_GROUND_KB] = ACT_JUMP_KICK,
     -- [ACT_START_SLEEPING]          = ACT_IDLESECOND,
    }
    if replace[inc] then return replace[inc] end

    --[[if inc == ACT_PUNCHING then
        audio_stream_play(strmspinny, true, 1)
        return ACT_SPINNYTHING
    end]]

    if inc == ACT_SOFT_BONK then
        m.faceAngle.y = m.faceAngle.y + 0x8000
        m.vel.y = c.savedmomentum * 0.9
        return ACT_WALL_SLIDE
    end

    if inc == ACT_BACKWARD_AIR_KB then
        m.faceAngle.y = m.faceAngle.y + 0x8000
        m.vel.y = c.savedmomentum * 0.9
        return ACT_WALL_SLIDE
    end
end)

local E_MODEL_GLOW = smlua_model_util_get_id("glows_geo") -- regeneffect
local CST_DOCTOR = 3
local regenActions = {
    [ACT_STANDING_DEATH] = 1,
    [ACT_DEATH_ON_BACK] = 1,
    [ACT_DEATH_ON_STOMACH] = 1,
    [ACT_DEATH_EXIT_LAND] = 1
}

function charlie_update(m)
    local c = gCharlieStates[m.playerIndex]
    --djui_chat_message_create("momentum".."\\#dcdcdc\\: "..c.savedmomentum)
    --regenerate
    if charSelect.character_get_current_number(m.playerIndex) == CT_WINBREAKER
    and charSelect.character_get_current_costume(m.playerIndex) == CST_DOCTOR and regenActions[m.action] then
        spawn_non_sync_object(id_bhvCoinSparkles, E_MODEL_SPARKLES,
            get_hand_foot_pos_x(m, 1),
            get_hand_foot_pos_y(m, 1),
            get_hand_foot_pos_z(m, 1),
            nil)
        spawn_non_sync_object(id_bhvCoinSparkles, E_MODEL_SPARKLES,
            get_hand_foot_pos_x(m, 0),
            get_hand_foot_pos_y(m, 0),
            get_hand_foot_pos_z(m, 0),
            nil)
    end

    --idling stuff goes here
    if m.action == ACT_IDLE and is_anim_at_end(m) ~= 0 then
        local idleAnims = {
            "idlemoment",
            "idlemoment",
            "idlemoment",
            "idlealtt"
            -- "add whatever else"
        }
        for _, anims in pairs(animTables) do
            anims[CHAR_ANIM_IDLE_HEAD_CENTER] = idleAnims[math.random(#idleAnims)]
            anims[CHAR_ANIM_IDLE_HEAD_LEFT] = idleAnims[math.random(#idleAnims)]
            anims[CHAR_ANIM_IDLE_HEAD_RIGHT] = idleAnims[math.random(#idleAnims)]
        end
    end

    --bj_scale_xyz(m.marioObj, c.scale.x, c.scale.y, c.scale.z)
    vec3f_copy(m.marioObj.header.gfx.scale, c.scale)

    if m.vel.y >= 0 or m.action == ACT_GROUND_POUND_LAND or m.action ~= ACT_IDLE or m.action == ACT_BUTT_SLIDE_STOP or m.action == ACT_SPINNYTHING then
        c.scale = { x = m.vel.y * -0.0015 + 1, y = m.vel.y*  0.0015 + 1, z = m.vel.y * -0.0015 + 1 }
    end
    if m.vel.y <= 0 and m.action ~= ACT_IDLE and m.action ~= ACT_GROUND_POUND_LAND and m.action ~= ACT_BUTT_SLIDE_STOP and m.action ~= ACT_SPINNYTHING then
        c.scale = { x = m.vel.y * 0.0015 + 1, y = m.vel.y*  -0.0015 + 1, z = m.vel.y * 0.0015 + 1 }
    end

    if m.action ~= ACT_AIR_HIT_WALL and m.action ~= ACT_WALL_SLIDE then
        c.savedmomentum = m.forwardVel
    end
    
    if m.action == ACT_PANTING then
        m.marioBodyState.eyeState = 6
    end

    -- wall slide

    if m.action == ACT_AIR_HIT_WALL and m.prevAction == ACT_LONG_JUMP then
        m.faceAngle.y = m.faceAngle.y + 0x8000
        m.forwardVel = 25
        return set_mario_action(m, ACT_WALL_KICK_AIR, 0)
    end

    if m.action == ACT_WALKING and m.forwardVel > 38 then
            if m.prevAction ~= ACT_SPINNYTHING then
            set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
            play_sound(SOUND_OBJ_MONTY_MOLE_ATTACK, m.marioObj.header.gfx.cameraToObject)
            end
        return set_mario_action(m, ACT_SUPERSPRINT, 0)
    end

    if m.action == ACT_START_SLEEPING then
        return set_mario_action(m, ACT_IDLE, 0)
    --  return set_mario_action(m, ACT_IDLESECOND, 0)
    end

    if m.action == ACT_IDLE or m.action == ACT_BUTT_SLIDE_STOP then
        m.vel.y = m.vel.y * 0.5
    end

    if m.action == ACT_FREEFALL_LAND_STOP and m.vel.y < 0 then
        m.vel.y = m.vel.y * 0.5
    end

    if m.action == ACT_LONG_JUMP and m.forwardVel < -10 then
        m.forwardVel = m.forwardVel - 1
    end

    if m.action == ACT_WALKING then
        c.scale = { x = 1, y = 1, z = 1 }
    end

    if m.action == ACT_WATER_PLUNGE then
        c.scale = { x = 1, y = 1, z = 1 }
    end

    --[[if m.prevAction == ACT_LONG_JUMP and m.action == ACT_ROCKETING and m.controller.buttonDown & B_BUTTON == 0 then 
        return set_mario_action(m, ACT_FORWARD_ROLLOUT, 0)
    end]]

    --[[if m.action == ACT_GROUND_POUND_LAND then
        c.scale.y = c.scale.y - 0.5 
        c.scale.x = c.scale.x + 0.5
        c.scale.z = c.scale.z + 0.5 
        if c.scale.y < 0.5 then
            c.scale = { x = 1.5, y = 0.5, z = 1.5 }
        end
    end]]

    if m.prevAction == ACT_TRIPLE_JUMP and m.action == ACT_GROUND_POUND then
        c.scale = { x = 0.75, y = 1.25, z = 0.75 }
        set_mario_action(m, ACT_SLIDE_KICK, 0)
    end

    if m.action == ACT_SIDE_FLIP and m.vel.y < 0 then
        m.action = ACT_TWIRLING
        --set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
        play_character_sound(m, CHAR_SOUND_TWIRL_BOUNCE)
    end

    if m.action == ACT_DOUBLE_JUMP and m.prevAction == ACT_GROUND_POUND_LAND and m.vel.y < 0 then
        m.action = ACT_TWIRLING
        --set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
        play_character_sound(m, CHAR_SOUND_YAHOO_WAHA_YIPPEE)
    end

    --[[ if m.action == ACT_TRIPLE_JUMP and m.vel.y < 0 then
        m.action = ACT_VERTICAL_WIND
    end]]

    if m.action == ACT_TWIRLING and m.controller.buttonPressed & B_BUTTON ~= 0 then
        set_mario_action(m, ACT_DIVE, 0)
        m.forwardVel = m.forwardVel + 60
        m.vel.y = 50
    end

    if m.action == ACT_SLIDE_KICK and m.prevAction == ACT_GROUND_POUND then
        m.forwardVel = m.forwardVel + 20
        m.vel.y = m.vel.y - 40
    end

    if m.action == ACT_TWIRLING and m.controller.buttonPressed & A_BUTTON ~= 0 then
        set_mario_action(m, ACT_BACKFLIP, 0)
        m.forwardVel = m.forwardVel + 20
        m.vel.y = m.vel.y + 20
    end

    if m.action == ACT_BACKWARD_GROUND_KB and m.controller.buttonPressed & A_BUTTON ~= 0 then
        set_mario_action(m, ACT_IDLE, 0)
    end

    --[[ if m.action == ACT_LONG_JUMP and m.controller.buttonPressed & B_BUTTON ~= 0 then
        rockety = 0
        play_character_sound(m, CHAR_SOUND_IMA_TIRED)
        rockety = 25
        set_mario_action(m, ACT_ROCKETING, 0)
    end]]

    --[[if m.action == ACT_LONG_JUMP and m.controller.buttonPressed & B_BUTTON ~= 0 then
        --play_character_sound(m, CHAR_SOUND_IMA_TIRED)
        m.forwardVel = m.forwardVel + 20
        m.vel.y = m.vel.y + 25
        set_mario_action(m, ACT_DIVE, 0)
    end]]

    if m.action == ACT_DIVE and m.prevAction == ACT_GROUND_POUND then
        m.vel.y = m.vel.y * 1.01
    end

    if m.action == ACT_BACKFLIP then
        m.peakHeight = m.pos.y
    end

    if m.action == ACT_VERTICAL_WIND then
        m.peakHeight = m.pos.y
    end

    --[[ if m.action == ACT_TWIRLING and (m.input & INPUT_Z_DOWN) ~= 0 then
        m.vel.y = m.vel.y - 60
        m.twirlYaw = m.twirlYaw *1.1
    end]]

    --[[ if m.prevAction == ACT_CROUCHING and m.action == ACT_BACKFLIP then
    play_character_sound(m, CHAR_SOUND_IMA_TIRED)
        set_mario_action(m, ACT_UPROCKETING, 0)
    end]]
    --ABANDONED ROCKET SHIT

    if m.action == ACT_GROUND_POUND and m.controller.buttonPressed & B_BUTTON ~= 0 and m.prevAction ~= ACT_DIVE then
        set_mario_action(m, ACT_DIVE, 0)
        m.forwardVel = m.forwardVel + 60
        m.vel.y = 35
    end

    if m.action == ACT_DIVE and m.controller.buttonPressed & Z_TRIG ~= 0 and m.prevAction ~= ACT_GROUND_POUND then
        set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    if m.action == ACT_TRIPLE_JUMP_LAND and m.controller.buttonPressed & A_BUTTON ~= 0 then
        set_mario_action(m, ACT_TRIPLE_JUMP, 0)
    end
    if m.action == ACT_JUMP_KICK and m.controller.buttonPressed & B_BUTTON ~= 0 then
        set_mario_action(m, ACT_JUMP_KICK, 0)
        m.vel.y = m.vel.y + 20
    end

    if m.action == ACT_GROUND_POUND_LAND and m.controller.buttonPressed & A_BUTTON ~= 0 then
        play_sound(SOUND_GENERAL_BOING2, m.marioObj.header.gfx.cameraToObject)
        m.vel.y = m.vel.y * -1
        m.forwardVel = 22
        set_mario_action(m, ACT_DOUBLE_JUMP, 0)
        set_mario_particle_flags(m, PARTICLE_HORIZONTAL_STAR, 0)
        
    end

    if m.action == ACT_GROUND_POUND_LAND and m.controller.buttonPressed & B_BUTTON ~= 0 then
        play_sound(SOUND_GENERAL_BOING2, m.marioObj.header.gfx.cameraToObject)
        m.vel.y = 35
        m.forwardVel = 85
        set_mario_action(m, ACT_DIVE, 0)
        set_mario_particle_flags(m, PARTICLE_HORIZONTAL_STAR, 0)
    end

    if m.action == ACT_VERTICAL_WIND then
        c.timer = c.timer + 1
    end

    if m.action == ACT_VERTICAL_WIND and c.timer == 2 then
        play_character_sound(m, CHAR_SOUND_YAHOO_WAHA_YIPPEE)
    end

    if m.prevAction == ACT_VERTICAL_WIND or m.prevAction == ACT_FORWARD_ROLLOUT then
        c.timer = 0
    end

    if m.action == ACT_WALKING      then m.forwardVel = m.forwardVel * 1.035 end
    if m.action == ACT_HOLD_WALKING then m.forwardVel = m.forwardVel * 1.25  end
    if m.action == ACT_TWIRLING     then m.forwardVel = m.forwardVel * 1.15  end

    if m.action == ACT_JUMP
    or m.action == ACT_DOUBLE_JUMP then m.vel.y = m.vel.y * 1.03  end
    if m.action == ACT_TRIPLE_JUMP then m.vel.y = m.vel.y * 1.03 end
    if m.action == ACT_SIDE_FLIP   then m.vel.y = m.vel.y * 1.04  end

    if m.action == ACT_DIVE      then m.forwardVel = m.forwardVel * 1.25; m.vel.y = m.vel.y * 1.025 end
    if m.action == ACT_LONG_JUMP then m.forwardVel = m.forwardVel * 1.05; m.vel.y = m.vel.y * 1.015 end

    if m.forwardVel >= 85 and m.action == ACT_TWIRLING  then m.forwardVel = 85  end
    if m.forwardVel >= 85 and m.action == ACT_LONG_JUMP then m.forwardVel = 85  end
    if m.forwardVel >= 75 and m.action == ACT_DIVE      then m.forwardVel = 75  end
    if m.forwardVel >= 100                              then m.forwardVel = 100 end
       --[[ if m.action == ACT_ROCKETING or m.action == ACT_ROCKETDESCEND or m.action == ACT_UPROCKETING then
            spawn_non_sync_object(id_bhvCoinSparkles, E_MODEL_RED_FLAME, get_hand_foot_pos_x(m, 0), get_hand_foot_pos_y(m, 0), get_hand_foot_pos_z(m, 0),
                    --- @param o Object
                    function(o)
                    end)
            spawn_non_sync_object(id_bhvCoinSparkles, E_MODEL_RED_FLAME, get_hand_foot_pos_x(m, 1), get_hand_foot_pos_y(m, 1), get_hand_foot_pos_z(m, 1),
                    --- @param o Object
                    function(o)
                    end)
            end]]
end
_G.charSelect.character_hook_moveset(CT_WINBREAKER, HOOK_MARIO_UPDATE, charlie_update)

end