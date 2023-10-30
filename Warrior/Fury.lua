local _G, setmetatable, pairs, type, math    = _G, setmetatable, pairs, type, math
local huge                                     = math.huge
local math_random                            = math.random

local TMW                                     = _G.TMW

local Action                                 = _G.Action

local CONST                                 = Action.Const
local Listener                                 = Action.Listener
local Create                                 = Action.Create
local GetToggle                                = Action.GetToggle
local GetLatency                            = Action.GetLatency
local GetGCD                                = Action.GetGCD
local GetCurrentGCD                            = Action.GetCurrentGCD
local ShouldStop                            = Action.ShouldStop
local BurstIsON                                = Action.BurstIsON
local AuraIsValid                            = Action.AuraIsValid
local InterruptIsValid                        = Action.InterruptIsValid
local DetermineUsableObject                    = Action.DetermineUsableObject

local Utils                                    = Action.Utils
local BossMods                                = Action.BossMods
local TeamCache                                = Action.TeamCache
local EnemyTeam                                = Action.EnemyTeam
local FriendlyTeam                            = Action.FriendlyTeam
local LoC                                     = Action.LossOfControl
local Player                                = Action.Player
local MultiUnits                            = Action.MultiUnits
local UnitCooldown                            = Action.UnitCooldown
local Unit                                    = Action.Unit
local IsUnitEnemy                            = Action.IsUnitEnemy
local IsUnitFriendly                        = Action.IsUnitFriendly

local ShouldDisarm                            = Action.ShouldDisarm
local ShouldSpellReflect                    = Action.ShouldSpellReflect
local GroupNeedPeel                            = Action.GroupNeedPeel
local ToogleBurstZR                            = Action.ToogleBurstZR

local InterveneReflectPvP                    = Action.InterveneReflectPvP

local Azerite                                 = LibStub("AzeriteTraits")

local ACTION_CONST_WARRIOR_FURY                = CONST.WARRIOR_FURY
local ACTION_CONST_AUTOTARGET                = CONST.AUTOTARGET
local ACTION_CONST_SPELLID_FREEZING_TRAP    = CONST.SPELLID_FREEZING_TRAP

local IsIndoors, UnitIsUnit                    = _G.IsIndoors, _G.UnitIsUnit

Action[ACTION_CONST_WARRIOR_FURY] = {
    -- Racial
    ArcaneTorrent                             = Create({ Type = "Spell", ID = 50613                                                                             }),
    BloodFury                                 = Create({ Type = "Spell", ID = 20572                                                                              }),
    Fireblood                                   = Create({ Type = "Spell", ID = 265221                                                                             }),
    AncestralCall                              = Create({ Type = "Spell", ID = 274738                                                                             }),
    Berserking                                = Create({ Type = "Spell", ID = 26297                                                                            }),
    ArcanePulse                                  = Create({ Type = "Spell", ID = 260364                                                                            }),
    QuakingPalm                                  = Create({ Type = "Spell", ID = 107079                                                                             }),
    Haymaker                                  = Create({ Type = "Spell", ID = 287712                                                                             }),
    WarStomp                                  = Create({ Type = "Spell", ID = 20549                                                                             }),
    BullRush                                  = Create({ Type = "Spell", ID = 255654                                                                             }),
    BagofTricks                               = Create({ Type = "Spell", ID = 312411                                                                             }),
    GiftofNaaru                               = Create({ Type = "Spell", ID = 59544                                                                            }),
    LightsJudgment                               = Create({ Type = "Spell", ID = 255647                                                                            }),
    Shadowmeld                                  = Create({ Type = "Spell", ID = 58984                                                                            }), -- usable in Action Core
    Stoneform                                  = Create({ Type = "Spell", ID = 20594                                                                            }),
    WilloftheForsaken                          = Create({ Type = "Spell", ID = 7744                                                                            }), -- usable in Action Core
    EscapeArtist                              = Create({ Type = "Spell", ID = 20589                                                                            }), -- usable in Action Core
    EveryManforHimself                          = Create({ Type = "Spell", ID = 59752                                                                            }), -- usable in Action Core
    Regeneratin                                  = Create({ Type = "Spell", ID = 291944                                                                            }), -- not usable in APL but user can Queue it
    -- CrownControl
    IntimidatingShout                        = Create({ Type = "Spell", ID = 5246, isIntimidatingShout = true                                                }),
    StormBolt                                  = Create({ Type = "Spell", ID = 107570, isTalent = true, isStormBolt = true                                        }),
    StormBoltGreen                              = Create({ Type = "SpellSingleColor", ID = 107570, Color = "GREEN", Desc = "[1] CC", QueueForbidden = true         }),
    Pummel                                    = Create({ Type = "Spell", ID = 6552, isPummel = true                                                            }),
    PummelGreen                                = Create({ Type = "SpellSingleColor", ID = 6552, Color = "GREEN", Desc = "[2] Kick", QueueForbidden = true        }),
    Disarm                                    = Create({ Type = "Spell", ID = 236077, isTalent = true                                                         }),    -- PvP Talent
    -- Supportive
    Taunt                                      = Create({ Type = "Spell", ID = 355, Desc = "[6] PvP Pets Taunt", QueueForbidden = true                            }),
    BattleShout                                = Create({ Type = "Spell", ID = 6673                                                                            }),
    -- Self Defensives
    RallyingCry                                = Create({ Type = "Spell", ID = 97462                                                                             }),
    BerserkerRage                            = Create({ Type = "Spell", ID = 18499                                                                             }),
    IgnorePain                                = Create({ Type = "Spell", ID = 190456                                                                             }),
    ShieldBlock                                = Create({ Type = "Spell", ID = 2565                                                                             }),
    SpellReflection                            = Create({ Type = "Spell", ID = 23920                                                                             }),
    EnragedRegeneration                        = Create({ Type = "Spell", ID = 184364                                                                             }),
    VictoryRush                                = Create({ Type = "Spell", ID = 34428                                                                            }),
    -- Burst
    Recklessness                            = Create({ Type = "Spell", ID = 1719                                                                            }),
    -- Rotation
    DragonRoar                                = Create({ Type = "Spell", ID = 118000, isTalent = true                                                            }), -- Talent
    Bladestorm                                = Create({ Type = "Spell", ID = 46924, isTalent = true                                                            }),    -- Talent
    Siegebreaker                            = Create({ Type = "Spell", ID = 280772, isTalent = true                                                         }),    -- Talent
    Onslaught                                = Create({ Type = "Spell", ID = 315720, isTalent = true                                                         }),    -- Talent
    Rampage                                    = Create({ Type = "Spell", ID = 184367                                                                            }),
    ThunderousRoar                                    = Create({ Type = "Spell", ID = 384318                                                                            }),
    Bloodthirst                                = Create({ Type = "Spell", ID = 23881                                                                            }),
    Execute                                    = Create({ Type = "Spell", ID = 5308                                                                            }),
    RagingBlow                                = Create({ Type = "Spell", ID = 85288                                                                            }),
    Whirlwind                                = Create({ Type = "Spell", ID = 190411                                                                            }),
    Hamstring                                = Create({ Type = "Spell", ID = 1715                                                                             }),
    ShatteringThrow                            = Create({ Type = "Spell", ID = 64382                                                                             }),
    ShieldSlam                                = Create({ Type = "Spell", ID = 23922                                                                             }),
    Slam                                    = Create({ Type = "Spell", ID = 1464                                                                             }),
    HeroicThrow                                = Create({ Type = "Spell", ID = 57755                                                                             }),
    PiercingHowl                            = Create({ Type = "Spell", ID = 12323                                                                             }),
    Bloodrage                                = Create({ Type = "Spell", ID = 329038, isTalent = true                                                            }), -- PvP Talent
    DeathWish                                = Create({ Type = "Spell", ID = 199261, isTalent = true                                                            }), -- PvP Talent
    ImprovedWhirlwind                                = Create({ Type = "Spell", ID = 12950, isTalent = true                                                         }),    -- Talent
    AshenJuggernaut                                = Create({ Type = "Spell", ID = 392536, isTalent = true                                                         }),    -- Talent
    OdynsFury                                = Create({ Type = "Spell", ID = 385059, isTalent = true                                                         }),    -- Talent
    DancingBlades                                = Create({ Type = "Spell", ID = 391683, isTalent = true                                                         }),    -- Talent
    AngerManagement                                = Create({ Type = "Spell", ID = 152278, isTalent = true                                                         }),    -- Talent
    Tenderize                                = Create({ Type = "Spell", ID = 388933, isTalent = true                                                         }),    -- Talent
    WreckingThrow                                = Create({ Type = "Spell", ID = 384110, isTalent = true                                                         }),    -- Talent
    Annihilator                                = Create({ Type = "Spell", ID = 383916, isTalent = true                                                         }),    -- Talent
    Bloodbath                                    = Create({ Type = "Spell", ID = 335096                                                                             }),
    WrathAndFury                                = Create({ Type = "Spell", ID = 392936, isTalent = true                                                         }),    -- Talent
    TitanicRage                                = Create({ Type = "Spell", ID = 394329, isTalent = true                                                         }),    -- Talent
    OverWhelmingRage                                = Create({ Type = "Spell", ID = 382767, isTalent = true                                                         }),    -- Talent
    -- Convenant
    SpearofBastion                            = Create({ Type = "Spell", ID = 307865                                                                             }),
    ConquerorsBanner                        = Create({ Type = "Spell", ID = 324143                                                                             }),
    AncientAftershock                        = Create({ Type = "Spell", ID = 325886                                                                             }),
    Condemn                                    = Create({ Type = "Spell", ID = 317349                                                                             }),
    -- Movememnt
    Charge                                    = Create({ Type = "Spell", ID = 100                                                                                }),
    Intervene                                = Create({ Type = "Spell", ID = 3411                                                                            }),
    HeroicLeap                                = Create({ Type = "Spell", ID = 6544                                                                            }),
    -- Items
    PotionofUnbridledFury                     = Create({ Type = "Potion",  ID = 169299                                                                         }),
    GalecallersBoon                          = Create({ Type = "Trinket", ID = 159614                                                                         }),
    LustrousGoldenPlumage                    = Create({ Type = "Trinket", ID = 159617                                                                         }),
    PocketsizedComputationDevice             = Create({ Type = "Trinket", ID = 167555                                                                         }),
    AshvanesRazorCoral                       = Create({ Type = "Trinket", ID = 169311                                                                         }),
    AzsharasFontofPower                      = Create({ Type = "Trinket", ID = 169314                                                                         }),
    RemoteGuidanceDevice                     = Create({ Type = "Trinket", ID = 169769                                                                         }),
    WrithingSegmentofDrestagath              = Create({ Type = "Trinket", ID = 173946                                                                         }),
    DribblingInkpod                          = Create({ Type = "Trinket", ID = 169319                                                                         }),
    CorruptedAspirantsMedallion                = Create({ Type = "Trinket", ID = 184058                                                                         }),
    -- Gladiator Badges/Medallions
    DreadGladiatorsMedallion                 = Create({ Type = "Trinket", ID = 161674                                                                         }),
    DreadCombatantsInsignia                  = Create({ Type = "Trinket", ID = 161676                                                                         }),
    DreadCombatantsMedallion                 = Create({ Type = "Trinket", ID = 161811, Hidden = true                                                         }),    -- Game has something incorrect with displaying this
    DreadGladiatorsBadge                     = Create({ Type = "Trinket", ID = 161902                                                                         }),
    DreadAspirantsMedallion                  = Create({ Type = "Trinket", ID = 162897                                                                         }),
    DreadAspirantsBadge                      = Create({ Type = "Trinket", ID = 162966                                                                         }),
    SinisterGladiatorsMedallion              = Create({ Type = "Trinket", ID = 165055                                                                         }),
    SinisterGladiatorsBadge                  = Create({ Type = "Trinket", ID = 165058                                                                         }),
    SinisterAspirantsMedallion               = Create({ Type = "Trinket", ID = 165220                                                                         }),
    SinisterAspirantsBadge                   = Create({ Type = "Trinket", ID = 165223                                                                         }),
    NotoriousGladiatorsMedallion             = Create({ Type = "Trinket", ID = 167377                                                                         }),
    NotoriousGladiatorsBadge                 = Create({ Type = "Trinket", ID = 167380                                                                         }),
    NotoriousAspirantsMedallion              = Create({ Type = "Trinket", ID = 167525                                                                         }),
    NotoriousAspirantsBadge                  = Create({ Type = "Trinket", ID = 167528                                                                         }),
    -- LegendaryPowers
    CadenceofFujieda                        = Create({ Type = "Spell", ID = 335555, Hidden = true                                                             }),
    Deathmaker                                = Create({ Type = "Spell", ID = 335567, Hidden = true                                                             }),
    Leaper                                    = Create({ Type = "Spell", ID = 335214, Hidden = true                                                             }),
    MisshapenMirror                            = Create({ Type = "Spell", ID = 335253, Hidden = true                                                             }),
    RecklessDefense                            = Create({ Type = "Spell", ID = 335582, Hidden = true                                                             }),
    SeismicReverberation                    = Create({ Type = "Spell", ID = 335758, Hidden = true                                                             }),
    SignetofTormentedKings                    = Create({ Type = "Spell", ID = 335266, Hidden = true                                                             }),
    WilloftheBerserker                        = Create({ Type = "Spell", ID = 335594, Hidden = true                                                             }),
    -- Hidden
    SiegebreakerDebuff                        = Create({ Type = "Spell", ID = 280773, Hidden = true                                                             }), -- Simcraft
    EnrageBuff                                = Create({ Type = "Spell", ID = 184362, Hidden = true                                                             }), -- Simcraft
    MeatCleaverBuff                            = Create({ Type = "Spell", ID = 85739, Hidden = true                                                             }), -- Simcraft
    CrushingAssaultBuff                        = Create({ Type = "Spell", ID = 278826, Hidden = true                                                            }), -- Simcraft
    RecklessAbandon                            = Create({ Type = "Spell", ID = 202751, Hidden = true, isTalent = true                                            }), -- Talent
    Seethe                                    = Create({ Type = "Spell", ID = 335091, Hidden = true, isTalent = true                                            }), -- Talent
    Cruelty                                    = Create({ Type = "Spell", ID = 335070, Hidden = true, isTalent = true                                            }), -- Talent
    Overwatch                                = Create({ Type = "Spell", ID = 329035, isTalent = true, isTalent = true                                        }),    -- PvP Talent
    TauntSpear                                = Create({ Type = "Spell", ID = 6673, Hidden = true                                                                }), -- Simcraft
    -- Hidden  PvP Debuffs
    BidingShotDebuff                        = Create({ Type = "Spell", ID = 117405, Hidden = true                                                            }),
    ScatterShotDebuff                        = Create({ Type = "Spell", ID = 213691, Hidden = true                                                            }),
}

--Action:CreateCovenantsFor(ACTION_CONST_WARRIOR_FURY)
Action:CreateEssencesFor(ACTION_CONST_WARRIOR_FURY)
local A = setmetatable(Action[ACTION_CONST_WARRIOR_FURY], { __index = Action })

local player                                 = "player"
local target                                 = "target"
local Temp                                     = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                        = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                 = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMagPhys                            = {"TotalImun", "DamageMagicImun", "DamagePhysImun"},
    DisablePhys                                = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    BerserkerRageLoC                        = {"FEAR", "INCAPACITATE"},
    IsSlotTrinketBlocked                    = {
        [A.AshvanesRazorCoral.ID]            = true,
        [A.CorruptedAspirantsMedallion.ID]    = true,
    },
    InterveneInstaIDs                        = {A.BidingShotDebuff.ID, A.ScatterShotDebuff.ID},
    SpellReflectTimer                        = 0,
    IsRallyngCrySupportive                    = false,
}
-- Initialization
Listener:Add("ACTION_EVENT_WARRIOR_SPELL_REFLECT", "UNIT_SPELLCAST_SUCCEEDED", function(...)
        local source, _, spellID = ...
        if source == player and A.SpellReflection.ID == spellID then
            Temp.SpellReflectTimer = (math_random(25, 50) / 100)
        end
end)

-- Util functions
local function SpellReflectTimerInit()
    if Temp.SpellReflectTimer == 0 then
        Temp.SpellReflectTimer = (math_random(25, 50) / 100)
    end
end
TMW:RegisterCallback("TMW_ACTION_IS_INITIALIZED", SpellReflectTimerInit)

-- Reset Vars
local function ResetVars()
    if Temp.IsRallyngCrySupportive then
        Temp.IsRallyngCrySupportive = false
    end
end
TMW:RegisterCallback("TMW_ACTION_ENTERING", ResetVars)

function Action:IsSuspended(delay, reset)
    -- @return boolean
    -- Returns true if action should be delayed before use, reset argument is a internal refresh cycle of expiration future time
    if (self.expirationSuspend or 0) + reset <= TMW.time then
        self.expirationSuspend = TMW.time + delay
    end

    return self.expirationSuspend > TMW.time
end

-- [1] CC AntiFake Rotation
local function AntiFakeStun(unitID)
    return
    IsUnitEnemy(unitID) and
    Unit(unitID):GetRange() <= 20 and
    Unit(unitID):IsControlAble("stun") and
    A.StormBoltGreen:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true)
end
A[1] = function(icon)
    if     A.StormBoltGreen:IsReady(nil, true, nil, true) and AntiFakeStun("target")
    then
        return A.StormBoltGreen:Show(icon)
    end
end

-- [2] Kick AntiFake Rotation
A[2] = function(icon)
    local unitID
    if IsUnitEnemy("mouseover") then
        unitID = "mouseover"
    elseif IsUnitEnemy("target") then
        unitID = "target"
    end

    if unitID then
        local castLeft, _, _, _, notKickAble = Unit(unitID):IsCastingRemains()
        if castLeft > 0 then
            if not notKickAble and A.PummelGreen:IsReady(unitID, nil, nil, true) and A.PummelGreen:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
                return A.PummelGreen:Show(icon)
            end

            if A.StormBoltGreen:IsReady(unitID, nil, nil, true) and Unit(unitID):IsControlAble("stun") and A.StormBoltGreen:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true) then
                return A.StormBoltGreen:Show(icon)
            end

            -- Racials
            if A.QuakingPalm:IsRacialReadyP(unitID, nil, nil, true) then
                return A.QuakingPalm:Show(icon)
            end

            if A.Haymaker:IsRacialReadyP(unitID, nil, nil, true) then
                return A.Haymaker:Show(icon)
            end

            if A.WarStomp:IsRacialReadyP(unitID, nil, nil, true) then
                return A.WarStomp:Show(icon)
            end

            if A.BullRush:IsRacialReadyP(unitID, nil, nil, true) then
                return A.BullRush:Show(icon)
            end
        end
    end
end

local function isCurrentlyTanking()
    local IsTanking = Unit(player):IsTankingAoE(16) or Unit(player):IsTanking("target", 16)

    return IsTanking
end

local function CanIgnorePain(variation)
    if Unit(player):HasBuffs(A.IgnorePain.ID, true) > 0 then
        local description     = A.IgnorePain:GetSpellDescription()
        local summary         = description[1]
        local total         = summary * variation

        if Unit(player):HasBuffs(A.IgnorePain.ID, true) < (0.5 * total) then
            return true
        else
            return false
        end
    else
        return true
    end
end
-----------------------------------------
--                 ROTATION
-----------------------------------------
-- Locals - Other
local function SelfDefensives()
    -- RallyingCry
    local RallyingCry = GetToggle(2, "RallyingCry")
    if     RallyingCry >= 0 and A.RallyingCry:IsReady(player) and
    (
        (     -- Auto
            RallyingCry >= 100 and
            (
                (
                    not A.IsInPvP and
                    Unit(player):HealthPercent() < 25 and
                    Unit(player):TimeToDieX(5) < 6
                ) or
                (
                    A.IsInPvP and
                    (
                        Unit(player):UseDeff() or
                        (
                            Unit(player, 5):HasFlags() and
                            Unit(player):GetRealTimeDMG() > 0 and
                            Unit(player):IsFocused(nil, true)
                        )
                    )
                )
            ) and
            Unit(player):HasBuffs("DeffBuffs") == 0
        ) or
        (    -- Custom
            RallyingCry < 100 and
            Unit(player):HealthPercent() <= RallyingCry
        )
    )
    then
        return A.RallyingCry
    end

    -- EnragedRegeneration
    local EnragedRegeneration = GetToggle(2, "EnragedRegeneration")
    if     EnragedRegeneration >= 0 and A.EnragedRegeneration:IsReady(player) and
    (
        (     -- Auto
            EnragedRegeneration >= 100 and
            (
                (
                    not A.IsInPvP and
                    Unit(player):HealthPercent() < 40 and
                    Unit(player):TimeToDieX(20) < 6
                ) or
                (
                    A.IsInPvP and
                    (
                        Unit(player):UseDeff() or
                        (
                            Unit(player, 5):HasFlags() and
                            Unit(player):GetRealTimeDMG() > 0 and
                            Unit(player):IsFocused(nil, true)
                        )
                    )
                )
            ) and
            Unit(player):HasBuffs("DeffBuffs") == 0
        ) or
        (    -- Custom
            EnragedRegeneration < 100 and
            Unit(player):HealthPercent() <= EnragedRegeneration
        )
    )
    then
        return A.EnragedRegeneration
    end

    -- Stoneform (On Deffensive)
    local Stoneform = GetToggle(2, "Stoneform")
    if     Stoneform >= 0 and A.Stoneform:IsRacialReadyP(player) and
    (
        (     -- Auto
            Stoneform >= 100 and
            (
                (
                    not A.IsInPvP and
                    Unit(player):TimeToDieX(65) < 3
                ) or
                (
                    A.IsInPvP and
                    (
                        Unit(player):UseDeff() or
                        (
                            Unit(player, 5):HasFlags() and
                            Unit(player):GetRealTimeDMG() > 0 and
                            Unit(player):IsFocused()
                        )
                    )
                )
            )
        ) or
        (    -- Custom
            Stoneform < 100 and
            Unit(player):HealthPercent() <= Stoneform
        )
    )
    then
        return A.Stoneform
    end

    -- Ignore Pain
    local IgnorePain = GetToggle(2, "IgnorePain")
    if IgnorePain >= 0 and A.IgnorePain:IsReady(player) and CanIgnorePain(1.3) and
    (
        (    -- Auto
            IgnorePain >= 100 and isCurrentlyTanking() and
            (
                Unit(player):TimeToDieX(60) < 2 or
                (
                    A.IsInPvP and
                    Unit(player):HealthPercent() < 70 and
                    Unit(player):IsFocused(nil, true)
                )
            )
        ) or -- Custom
        (
            IgnorePain < 100 and
            Unit(player):HealthPercent() < IgnorePain
        )
    )
    then
        return A.IgnorePain
    end

    -- VictoryRush
    local VictoryRush = GetToggle(2, "VictoryRush")
    if VictoryRush >= 0 and IsUnitEnemy("target") and A.VictoryRush:IsReady("target") and Unit(player):HealthPercent() <= VictoryRush and A.VictoryRush:AbsentImun("target", Temp.TotalAndPhys) then
        return A.VictoryRush
    end

    -- Stoneform (Self Dispel)
    if not A.IsInPvP and A.Stoneform:IsRacialReady(player, true) and AuraIsValid(player, "UseDispel", "Dispel") then
        return A.Stoneform
    end
end

local function countInterruptGCD(unitID)
    if not A.Pummel:IsReadyByPassCastGCD(unitID) or not A.Pummel:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
        return true
    end
end

local function Interrupts(unitID)
    local useKick, useCC, useRacial, notInterruptable, castRemainsTime
    local isMythicPlus    = false
    if GetToggle(2, "ZakLLInterrupts") and (IsInRaid() or A.InstanceInfo.KeyStone > 1) then
        isMythicPlus = true
        useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID, "ZakLLInterrupts", true, countInterruptGCD(unitID))
    else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID, nil, nil, countInterruptGCD(unitID))
    end

    -- Can waste interrupt action due delays caused by ping, interface input
    if castRemainsTime < GetLatency() then
        return
    end

    if useKick and not notInterruptable and A.Pummel:IsReady(unitID) and A.Pummel:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
        return A.Pummel
    end

    if useRacial and A.QuakingPalm:AutoRacial(unitID) then
        return A.QuakingPalm
    end

    if useRacial and A.Haymaker:AutoRacial(unitID) then
        return A.Haymaker
    end

    if useRacial and A.WarStomp:AutoRacial(unitID) then
        return A.WarStomp
    end

    if useRacial and A.BullRush:AutoRacial(unitID) then
        return A.BullRush
    end

    if useCC and A.StormBolt:IsReady(unitID) and (Unit(unitID):IsControlAble("stun") or isMythicPlus) and A.StormBolt:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true) then
        return A.StormBolt
    end

    if useCC and A.IntimidatingShout:IsReady(unitID, true) and Unit(unitID):GetRange() <= 8 and (Unit(unitID):IsControlAble("fear") or isMythicPlus) and A.IntimidatingShout:AbsentImun(unitID, Temp.TotalAndPhysAndCC, true) then
        return A.IntimidatingShout
    end
end

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

local function UseItems(unitID)
    --if A.Trinket1:IsReady(unitID) and A.Trinket1:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] and A.Trinket1:AbsentImun(unitID, Temp.TotalAndMagPhys) then
    --    return A.Trinket1
    --end

    --if A.Trinket2:IsReady(unitID) and A.Trinket2:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] and A.Trinket2:AbsentImun(unitID, Temp.TotalAndMagPhys) then
    --    return A.Trinket2
    --end
end

-- [3] Single Rotation
A[3] = function(icon)
    local EnemyRotation--, FriendlyRotation
    local isMoving             = Player:IsMoving()                    -- @boolean
    local inCombat             = Unit(player):CombatTime()            -- @number
    local inAoE                = GetToggle(2, "AoE")                -- @boolean
    local inDisarm            = LoC:Get("DISARM") > 0                -- @boolean
    local inMelee             = false                                -- @boolean


    --print(GroupNeedPeel(player, 80))
    -- BerserkerRage
    -- Note: Loss of Control, IsReadyP!
    if LoC:IsValid(Temp.BerserkerRageLoC) and GetToggle(2, "UseBerserkerRage-LoC") and A.BerserkerRage:IsReadyP(player) and not A.BerserkerRage:IsSuspended((math_random(25, 40) / 100) - GetLatency(), 6) then
        return A.BerserkerRage:Show(icon)
    end

    -- Defensive
    if inCombat > 0 then
        local SelfDefensive = SelfDefensives()
        if SelfDefensive then
            return SelfDefensive:Show(icon)
        end
        -- Spell Reflection
        if ShouldSpellReflect(player, Temp.SpellReflectTimer) then
            return A.SpellReflection:Show(icon)
        end
        -- Defensive Trinkets
        --if Unit(player):HealthPercent() <= GetToggle(2, "TrinketDefensive") then
        --if A.Trinket1:IsReady(player, true) and A.Trinket1:GetItemCategory() ~= "DPS" and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] then
        --    return A.Trinket1:Show(icon)
        --end

        --if A.Trinket2:IsReady(player, true) and A.Trinket2:GetItemCategory() ~= "DPS" and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] then
        --    return A.Trinket2:Show(icon)
        --end
        --end
    end

    -- RallyingCry Party Supportive
    if Temp.IsRallyngCrySupportive then
        Temp.IsRallyngCrySupportive = false
        return A.RallyingCry:Show(icon)
    end

    -- Rotations
    function EnemyRotation(unitID)
        -- Variables
        local isBurst            = BurstIsON(unitID)
        inMelee                 = A.Bloodthirst:IsInRange(unitID)

        -- Check if target is explosive or totem for dont use AoE spells
        if Unit(unitID):IsExplosives() or (A.Zone ~= "none" and Unit(unitID):IsTotem()) then
            inAoE = false
        end

        -- Out of combat / Precombat
        if unitID and inCombat == 0 then
            local Pull = BossMods:GetPullTimer()

            -- WorldveinResonance => MemoryofLucidDreams => GuardianofAzeroth => Charge
            if Pull > 0 then
                -- Timing
                local extra_time = GetCurrentGCD() + 0.1
                local WorldveinResonance, MemoryofLucidDreams, GuardianofAzeroth, Charge
                local ChiWave, ChiBurst, InvokeXuentheWhiteTiger, GuardianofAzeroth, RushingJadeWind, RippleinSpace

                -- Azerite Essence - WorldveinResonance
                if isBurst and A.WorldveinResonance:AutoHeartOfAzerothP(unitID, true) then
                    WorldveinResonance = true
                    extra_time = extra_time + GetGCD()
                end

                -- Azerite Essence - MemoryofLucidDreams
                if isBurst and A.MemoryofLucidDreams:AutoHeartOfAzerothP(unitID, true) then
                    MemoryofLucidDreams = true
                    extra_time = extra_time + GetGCD()
                end

                -- Azerite Essence - GuardianofAzeroth
                if isBurst and A.GuardianofAzeroth:AutoHeartOfAzerothP(unitID, true) then
                    GuardianofAzeroth = true
                    extra_time = extra_time + GetGCD()
                end

                -- Charge
                if A.Charge:IsReady(unitID, true, nil, true) then
                    Charge = true
                    extra_time = extra_time + GetGCD()
                end

                -- Pull Rotation
                if not inDisarm and A.PotionofUnbridledFury:IsReady(unitID, true, nil, true) and Pull <= 2.5 then
                    return A.PotionofUnbridledFury:Show(icon)
                end

                if WorldveinResonance and not ShouldStop() and Pull <= extra_time then
                    return A.WorldveinResonance:Show(icon)
                end

                if MemoryofLucidDreams and not ShouldStop() and Pull <= extra_time then
                    return A.MemoryofLucidDreams:Show(icon)
                end

                if GuardianofAzeroth and not ShouldStop() and Pull <= extra_time then
                    return A.GuardianofAzeroth:Show(icon)
                end

                if Charge and not ShouldStop() and Pull <= extra_time then
                    return A.Charge:Show(icon)
                end

                -- Return
                return
            end
        end

        -- Purge
        if A.ArcaneTorrent:AutoRacial(unitID) then
            return A.ArcaneTorrent:Show(icon)
        end

        -- Interrupts
        local Interrupt = Interrupts(unitID)
        if Interrupt then
            return Interrupt:Show(icon)
        end

        -- PvP CrownControl
        -- Disarm
        if ShouldDisarm(unitID) then
            return A.Disarm:Show(icon)
        end

        -- PvP CrownControl (Enemy Healer)
        if A.IsInPvP then
            -- IntimidatingShout
            local EnemyHealerUnitID = EnemyTeam("HEALER"):GetUnitID(8)
            if EnemyHealerUnitID ~= "none" and not UnitIsUnit(unitID, EnemyHealerUnitID) and A.IntimidatingShout:IsReady(EnemyHealerUnitID, true, nil, true) and Unit(EnemyHealerUnitID):IsControlAble("fear", 99) and Unit(EnemyHealerUnitID):InCC() <= GetLatency() + GetCurrentGCD() and A.IntimidatingShout:AbsentImun(EnemyHealerUnitID, Temp.TotalAndPhysAndCC, true) then
                return A.IntimidatingShout:Show(icon)
            end

            -- StormBolt
            -- Note: Stop running primary target
            if not inMelee and Unit(unitID):IsHealer() and A.StormBolt:IsReady(unitID) and GetToggle(2, "StormBoltTargetRun") and Unit(unitID):IsControlAble("stun", 99) and Unit(unitID):HasBuffs("Speed") > 0 and Unit(unitID):InCC() <= GetCurrentGCD() and A.StormBolt:AbsentImun(EnemyHealerUnitID, Temp.TotalAndPhysAndCCAndStun, true) then
                return A.StormBolt:Show(icon)
            end
        end

        -- [[ CDs ]]
        local function CDs()
            --rampage,if=cooldown.recklessness.remains<3
            if A.Rampage:IsReady(unitID) and A.Recklessness:GetCooldown() < 3 and A.Recklessness:GetCooldown() > 0 and A.Rampage:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.Rampage:Show(icon)
            end

            --recklessness,if=!essence.condensed_lifeforce.major&!essence.blood_of_the_enemy.major|cooldown.guardian_of_azeroth.remains>1|buff.guardian_of_azeroth.up|cooldown.blood_of_the_enemy.remains<gcd
            if A.Recklessness:IsReadyByPassCastGCD(unitID) and (A.RecklessAbandon:IsSpellLearned() and Player:RageDeficit() >= 50 or not A.RecklessAbandon:IsSpellLearned()) then
                return A.Recklessness:Show(icon)
            end

            --blood_fury,if=buff.recklessness.up
            if A.BloodFury:AutoRacial(unitID) and Unit(player):HasBuffs(A.Recklessness.ID, true) > 0 then
                return A.BloodFury:Show(icon)
            end

            --fireblood,if=buff.recklessness.up
            if A.Fireblood:AutoRacial(unitID) and Unit(player):HasBuffs(A.Recklessness.ID, true) > 0 then
                return A.Fireblood:Show(icon)
            end

            --ancestral_call,if=buff.recklessness.up
            if A.AncestralCall:AutoRacial(unitID) and Unit(player):HasBuffs(A.Recklessness.ID, true) > 0 then
                return A.AncestralCall:Show(icon)
            end

            --berserking,if=buff.recklessness.up
            if A.Berserking:AutoRacial(unitID) and Unit(player):HasBuffs(A.Recklessness.ID, true) > 0 then
                return A.Berserking:Show(icon)
            end

            --bag_of_tricks,if=buff.recklessness.down&debuff.siegebreaker.down&buff.enrage.up
            if A.BagofTricks:AutoRacial(unitID) and Unit(player):HasBuffs(A.Recklessness.ID, true) == 0 and Unit(unitID):HasDeBuffs(A.SiegebreakerDebuff.ID) == 0 and Unit(player):HasBuffs(A.EnrageBuff.ID, true) > 0 then
                return A.BagofTricks:Show(icon)
            end

            --lights_judgment,if=buff.recklessness.down&debuff.siegebreaker.down
            if A.LightsJudgment:AutoRacial(unitID) and Unit(player):HasBuffs(A.Recklessness.ID, true) == 0 and Unit(unitID):HasDeBuffs(A.SiegebreakerDebuff.ID) == 0 and Unit(player):HasBuffs(A.EnrageBuff.ID, true) > 0 then
                return A.LightsJudgment:Show(icon)
            end

            if A.SpearofBastion:IsReady(unitID, true) and inMelee and A.SpearofBastion:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.SpearofBastion:Show(icon)
            end

            if A.ConquerorsBanner:IsReady(player) and inMelee and Unit(player):HasBuffs(A.Recklessness.ID, true) > 0 then
                return A.ConquerorsBanner:Show(icon)
            end

            if A.AncientAftershock:IsReady(player) and inMelee and Unit(player):HasBuffs(A.Recklessness.ID, true) > 0 then
                return A.AncientAftershock:Show(icon)
            end


            if A.Trinket1:IsReady(unitID) and A.Trinket1:GetItemCategory() ~= "DEFF" and A.Trinket1:AbsentImun(unitID, Temp.TotalAndMagPhys) and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] then
                return A.Trinket1:Show(icon)
            end

            if A.Trinket2:IsReady(unitID) and A.Trinket2:GetItemCategory() ~= "DEFF" and A.Trinket2:AbsentImun(unitID, Temp.TotalAndMagPhys) and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] then
                return A.Trinket2:Show(icon)
            end

        end

        -- [[ Multi Targets ]]
        local function MT()

          -- actions.multi_target+=/odyns_fury,if=active_enemies>1&talent.titanic_rage&(!buff.meat_cleaver.up|buff.avatar.up|buff.recklessness.up)
          if A.OdynsFury:IsReady(unitID) and inAoE and inMelee and MultiUnits:GetByRange(8, 2) > 1 and A.TitanicRage:IsTalentLearned() and (Unit(player):HasBuffs(A.MeatCleaverBuff.ID) == 0 or Unit(player):HasBuffs(A.Avatar.ID) > 0 or Unit(player):HasBuffs(A.Recklessness.ID) > 0) then
            return A.OdynsFury:Show(icon)
          end

          -- actions.multi_target+=/whirlwind,if=spell_targets.whirlwind>1&talent.improved_whirlwind&!buff.meat_cleaver.up|raid_event.adds.in<2&talent.improved_whirlwind&!buff.meat_cleaver.up
          if A.Whirlwind:IsReady(unitID) and inAoE and inMelee and MultiUnits:GetByRange(8, 2) > 1 and A.ImprovedWhirlwind:IsTalentLearned() and Unit(player):HasBuffs(A.MeatCleaverBuff.ID) == 0 then
            return A.Whirlwind:Show(icon)
          end

          -- actions.multi_target+=/execute,if=buff.ashen_juggernaut.up&buff.ashen_juggernaut.remains<gcd
          if A.Execute:IsReady(unitID) and Unit(player):HasBuffs(A.AshenJuggernaut.ID) > 0 and Unit(player):HasBuffs(A.AshenJuggernaut.ID) < A.GetGCD() then
            return A.Execute:Show(icon)
          end

          -- actions.multi_target+=/thunderous_roar,if=buff.enrage.up&(spell_targets.whirlwind>1|raid_event.adds.in>15)
          if A.ThunderousRoar:IsReady(unitID) and Unit(player):HasBuffs(A.EnrageBuff.ID) > 0 and inAoE and inMelee and MultiUnits:GetByRange(8, 2) > 1 then
            return A.ThunderousRoar:Show(icon)
          end

          -- actions.multi_target+=/odyns_fury,if=active_enemies>1&buff.enrage.up&raid_event.adds.in>15
          if A.OdynsFury:IsReady(unitID) and inAoE and inMelee and MultiUnits:GetByRange(8, 2) > 1 and Unit(player):HasBuffs(A.EnrageBuff.ID) > 0 then
            return A.OdynsFury:Show(icon)
          end

          -- actions.multi_target+=/bloodbath,if=set_bonus.tier30_4pc&action.bloodthirst.crit_pct_current>=95

          -- actions.multi_target+=/bloodthirst,if=set_bonus.tier30_4pc&action.bloodthirst.crit_pct_current>=95

          -- actions.multi_target+=/crushing_blow,if=talent.wrath_and_fury&buff.enrage.up

          -- actions.multi_target+=/execute,if=buff.enrage.up
          if A.Execute:IsReady(unitID) and Unit(player):HasBuffs(A.EnrageBuff.ID) > 0 then
            return A.Execute:Show(icon)
          end

          -- actions.multi_target+=/odyns_fury,if=buff.enrage.up&raid_event.adds.in>15
          if A.OdynsFury:IsReady(unitID) and Unit(player):HasBuffs(A.EnrageBuff.ID) > 0 then
            return A.OdynsFury:Show(icon)
          end

          -- actions.multi_target+=/rampage,if=buff.recklessness.up|buff.enrage.remains<gcd|(rage>110&talent.overwhelming_rage)|(rage>80&!talent.overwhelming_rage)
          if A.Rampage:IsReady(unitID) and (Unit(player):HasBuffs(A.Recklessness.ID) > 0 or Unit(player):HasBuffs(A.AshenJuggernaut.ID) < A.GetGCD() or (Player:Rage() > 110 and A.OverwhelmingRage:IsTalentLearned()) or (Player:Rage() > 80 and not A.OverWhelmingRage:IsTalentLearned())) then
            return A.Rampage:Show(icon)
          end

          -- actions.multi_target+=/execute
          if A.Execute:IsReady(unitID) then
            return A.Execute:Show(icon)
          end

          -- actions.multi_target+=/bloodbath,if=buff.enrage.up&talent.reckless_abandon&!talent.wrath_and_fury
          if A.Bloodbath:IsReady(unitID) and Unit(player):HasBuffs(A.EnrageBuff.ID) > 0 and A.RecklessAbandon:IsTalentLearned() and not A.WrathAndFury:IsTalentLearned() then
            return A.Bloodbath:Show(icon)
          end

          -- actions.multi_target+=/bloodthirst,if=buff.enrage.down|(talent.annihilator&!buff.recklessness.up)
          if A.Bloodthirst:IsReady(unitID) and Unit(player):HasBuffs(A.EnrageBuff.ID) == 0 or (A.Annihilator:IsTalentLearned() and Unit(player):HasBuffs(A.Recklessness.ID) == 0) then
            return A.Bloodthirst:Show(icon)
          end

          -- actions.multi_target+=/onslaught,if=!talent.annihilator&buff.enrage.up|talent.tenderize
          if A.Onslaught:IsReady(unitID) and (not A.Annihilator:IsTalentLearned() and Unit(player):HasBuffs(A.EnrageBuff.ID) > 0 or A.Tenderize:IsTalentLearned()) then
            return A.Onslaught:Show(icon)
          end

          -- actions.multi_target+=/raging_blow,if=charges>1&talent.wrath_and_fury
          if A.RagingBlow:IsReady(unitID) and A.RagingBlow:GetSpellChargesFrac() > 1 and A.WrathAndFury:IsTalentLearned() then
            return A.RagingBlow:Show(icon)
          end

          -- actions.multi_target+=/crushing_blow,if=charges>1&talent.wrath_and_fury

          -- actions.multi_target+=/bloodbath,if=buff.enrage.down|!talent.wrath_and_fury
          if A.Bloodbath:IsReady(unitID) and (Unit(player):HasBuffs(A.EnrageBuff.ID) == 0 or not A.WrathAndFury:IsTalentLearned()) then
            return A.Bloodbath:Show(icon)
          end
          -- actions.multi_target+=/crushing_blow,if=buff.enrage.up&talent.reckless_abandon

          -- actions.multi_target+=/bloodthirst,if=!talent.wrath_and_fury
          if A.Bloodthirst:IsReady(unitID) and not A.WrathAndFury:IsTalentLearned() then
            return A.Bloodthirst:Show(icon)
          end

          -- actions.multi_target+=/raging_blow,if=charges>=1
          if A.RagingBlow:IsReady(unitID) and A.RagingBlow:GetSpellChargesFrac() > 1 then
            return A.RagingBlow:Show(icon)
          end

          -- actions.multi_target+=/rampage
          if A.Rampage:IsReady(unitID) then
            return A.Rampage:Show(icon)
          end

          -- actions.multi_target+=/slam,if=talent.annihilator
          if A.Slam:IsReady(unitID) and A.Annihilator:IsTalentLearned() then
            return A.Slam:Show(icon)
          end

          -- actions.multi_target+=/bloodbath
          if A.Bloodbath:IsReady(unitID) then
            return A.Bloodbath:Show(icon)
          end

          -- actions.multi_target+=/raging_blow
          if A.RagingBlow:IsReady(unitID) then
            return A.RagingBlow:Show(icon)
          end
          -- actions.multi_target+=/crushing_blow

          -- actions.multi_target+=/whirlwind
          if A.Whirlwind:IsReady(unitID) and inAoE and inMelee then
            return A.Whirlwind:Show(icon)
          end

        end

        -- [[ Single Target ]]
        local function ST()

          -- actions.single_target=whirlwind,if=spell_targets.whirlwind>1&talent.improved_whirlwind&!buff.meat_cleaver.up|raid_event.adds.in<2&talent.improved_whirlwind&!buff.meat_cleaver.up
          if A.Whirlwind:IsReady(unitID, true) and inAoE and inMelee and MultiUnits:GetByRange(8, 2) > 1 and Unit(player):HasBuffs(A.MeatCleaverBuff.ID) == 0 and A.ImprovedWhirlwind:IsTalentLearned() then
              return A.Whirlwind:Show(icon)
          end

          -- actions.single_target+=/execute,if=buff.ashen_juggernaut.up&buff.ashen_juggernaut.remains<gcd
          if A.Execute:IsReady(unitID) and Unit(player):HasBuffs(A.AshenJuggernaut.ID) > 0 then
            return A.Execute:Show(icon)
          end

          -- actions.single_target+=/thunderous_roar,if=buff.enrage.up&(spell_targets.whirlwind>1|raid_event.adds.in>15)
          if A.ThunderousRoar:IsReady(unitID) and Unit(player):HasBuffs(A.EnrageBuff.ID) > 0 and inAoE and inMelee and MultiUnits:GetByRange(8, 2) > 1 then
            return A.ThunderousRoar:Show(icon)
          end

          -- actions.single_target+=/odyns_fury,if=buff.enrage.up&(spell_targets.whirlwind>1|raid_event.adds.in>15)&(talent.dancing_blades&buff.dancing_blades.remains<5|!talent.dancing_blades)
          if A.OdynsFury:IsReady(unitID) and (Unit(player):HasBuffs(A.EnrageBuff.ID) > 0 and inAoE and inMelee and MultiUnits:GetByRange(8, 2) > 1 and (A.DancingBlades:IsTalentLearned() and Unit(player):HasBuffs(A.DancingBlades.ID) < 5 or not A.DancingBlades:IsTalentLearned())) then
            return A.OdynsFury:Show(icon)
          end

          -- actions.single_target+=/rampage,if=talent.anger_management&(buff.recklessness.up|buff.enrage.remains<gcd|rage.pct>85)
          if A.Rampage:IsReady(unitID) and (A.AngerManagement:IsTalentLearned() and (Unit(player):HasBuffs(A.Recklessness.ID) > 0 or Unit(player):HasBuffs(A.EnrageBuff.ID) < A.GetGCD() or Player:RagePercentage() > 85)) then
            return A.Rampage:Show(icon)
          end

          -- actions.single_target+=/bloodbath,if=set_bonus.tier30_4pc&action.bloodthirst.crit_pct_current>=95
          -- actions.single_target+=/bloodthirst,if=set_bonus.tier30_4pc&action.bloodthirst.crit_pct_current>=95

          -- actions.single_target+=/execute,if=buff.enrage.up
          if A.Execute:IsReady(unitID) and Unit(player):HasBuffs(A.EnrageBuff.ID) > 0 then
            return A.Execute:Show(icon)
          end

          -- actions.single_target+=/onslaught,if=buff.enrage.up|talent.tenderize
          if A.Onslaught:IsReady(unitID) and (Unit(player):HasBuffs(A.EnrageBuff.ID) > 0 or A.Tenderize:IsTalentLearned()) then
            return A.Onslaught:Show(icon)
          end

          -- actions.single_target+=/crushing_blow,if=talent.wrath_and_fury&buff.enrage.up

          -- actions.single_target+=/rampage,if=talent.reckless_abandon&(buff.recklessness.up|buff.enrage.remains<gcd|rage.pct>85)
          if A.Rampage:IsReady(unitID) and (A.RecklessAbandon:IsTalentLearned() and (Unit(player):HasBuffs(A.Recklessness.ID) > 0 or Unit(player):HasBuffs(A.EnrageBuff.ID) < A.GetGCD() or Player:RagePercentage() > 85)) then
            return A.Rampage:Show(icon)
          end

          -- actions.single_target+=/rampage,if=talent.anger_management
          if A.Rampage:IsReady(unitID) and A.AngerManagement:IsTalentLearned() then
            return A.Rampage:Show(icon)
          end

          -- actions.single_target+=/execute
          if A.Execute:IsReady(unitID) then
            return A.Execute:Show(icon)
          end

          -- actions.single_target+=/bloodbath,if=buff.enrage.up&talent.reckless_abandon&!talent.wrath_and_fury
          if A.Bloodbath:IsReady(unitID) and Unit(player):HasBuffs(A.EnrageBuff.ID) > 0 and A.RecklessAbandon:IsTalentLearned() and not A.WrathAndFury:IsTalentLearned() then
            return A.Bloodbath:Show(icon)
          end

          -- actions.single_target+=/bloodthirst,if=buff.enrage.down|(talent.annihilator&!buff.recklessness.up)
          if A.Bloodthirst:IsReady(unitID) and (Unit(player):HasBuffs(A.EnrageBuff.ID) == 0 or (A.Annihilator:IsTalentLearned() or Unit(player):HasBuffs(A.Recklessness.ID) == 0)) then
            return A.Bloodthirst:Show(icon)
          end

          -- actions.single_target+=/raging_blow,if=charges>1&talent.wrath_and_fury
          if A.RagingBlow:IsReady(unitID) and A.RagingBlow:GetSpellChargesFrac() > 1 and A.WrathAndFury:IsTalentLearned() then
            return A.RagingBlow:Show(icon)
          end

          -- actions.single_target+=/crushing_blow,if=charges>1&talent.wrath_and_fury

          -- actions.single_target+=/bloodbath,if=buff.enrage.down|!talent.wrath_and_fury
          if A.Bloodbath:IsReady(unitID) and (Unit(player):HasBuffs(A.EnrageBuff.ID) == 0 or not A.WrathAndFury:IsTalentLearned()) then
            return A.Bloodbath:Show(icon)
          end

          -- actions.single_target+=/crushing_blow,if=buff.enrage.up&talent.reckless_abandon

          -- actions.single_target+=/bloodthirst,if=!talent.wrath_and_fury
          if A.Bloodthirst:IsReady(unitID) and not A.WrathAndFury:IsTalentLearned() then
            return A.Bloodthirst:Show(icon)
          end

          -- actions.single_target+=/raging_blow,if=charges>1
          if A.RagingBlow:IsReady(unitID) and A.RagingBlow:GetSpellChargesFrac() > 1 then
            return A.RagingBlow:Show(icon)
          end

          -- actions.single_target+=/rampage
          if A.Rampage:IsReady(unitID) then
            return A.Rampage:Show(icon)
          end

          -- actions.single_target+=/slam,if=talent.annihilator
          if A.Slam:IsReady(unitID) and A.Annihilator:IsTalentLearned() then
            return A.Slam:Show(icon)
          end

          -- actions.single_target+=/bloodbath
          if A.Bloodbath:IsReady(unitID) then
            return A.Bloodbath:Show(icon)
          end

          -- actions.single_target+=/raging_blow
          if A.RagingBlow:IsReady(unitID) then
            return A.RagingBlow:Show(icon)
          end

          -- actions.single_target+=/crushing_blow

          -- actions.single_target+=/bloodthirst
          if A.Bloodthirst:IsReady(unitID) then
            return A.Bloodthirst:Show(icon)
          end

          -- actions.single_target+=/whirlwind
          if A.Whirlwind:IsReady(unitID) and inAoE and inMelee then
            return A.Whirlwind:Show(icon)
          end

          -- actions.single_target+=/wrecking_throw
          if A.WreckingThrow:IsReady(unitID) then
            return A.WreckingThrow:Show(icon)
          end

          -- actions.single_target+=/storm_bolt

        end

        -- Hamstring
        if (A.IsInPvP or (Unit(unitID):IsControlAble() and Unit(unitID):IsMovingOut())) and A.Hamstring:IsReady(unitID) and Unit(unitID):GetMaxSpeed() >= 100 and Unit(unitID):HasDeBuffs("Slowed") == 0 and not Unit(unitID):IsTotem() and not Unit(unitID):IsExplosives() and not Unit(unitID):IsCracklingShard() and A.Hamstring:AbsentImun(unitID, Temp.DisablePhys, true) then
            return A.Hamstring:Show(icon)
        end

        -- PiercingHowl
        if A.IsInPvP and A.PiercingHowl:IsReady(unitID, true) and not inMelee and Unit(unitID):GetRange() <= 12 and Unit(unitID):GetMaxSpeed() >= 100 and Unit(unitID):HasDeBuffs("Slowed") == 0 and not Unit(unitID):IsTotem() and not Unit(unitID):IsExplosives() and not Unit(unitID):IsCracklingShard() and A.PiercingHowl:AbsentImun(unitID, Temp.DisablePhys, true) then
            return A.PiercingHowl:Show(icon)
        end

        -- CDs
        if isBurst and (inMelee or A.LastPlayerCastName == A.Charge:Info()) and CDs() then
            return true
        end

        -- Multi Target
        if MultiUnits:GetByRange(8, 3) > 2 then
          if MT() then
            return true
          end
        end

        --Single Target
        if ST() then
            return true
        end

        -- HeroicThrow
        -- PvP Opener
        if A.Zone == "arena" and inCombat == 0 and A.HeroicThrow:IsReady(unitID) and not Unit(unitID):IsTotem() and EnemyTeam():HasInvisibleUnits() and A.HeroicThrow:AbsentImun(unitID, Temp.TotalAndPhys) then
            return A.HeroicThrow:Show(icon)
        end

        -- GiftofNaaru
        if A.GiftofNaaru:AutoRacial(player) and Unit(player):TimeToDie() < 10 then
            return A.GiftofNaaru:Show(icon)
        end

        -- Misc
        -- HeroicThrow
        if not inMelee and A.HeroicThrow:IsReady(unitID) and Unit(unitID):GetRange() > 15 and Unit(unitID):CombatTime() > 0 and A.HeroicThrow:AbsentImun(unitID, Temp.TotalAndPhys) then
            return A.HeroicThrow:Show(icon)
        end

        -- Movement
        if not inMelee and Unit(unitID):IsMovingIn() and Player:IsMovingTime() > 1.5 and not Player:IsMounted() then
            if A.Charge:IsReady(unitID) and Unit(unitID):GetRange() > 10 then -- 10 lower!
                return A.Charge:Show(icon)
            end
        end
    end

    -- BattleShout
    if A.BattleShout:IsReady(player) and (Unit(player):HasBuffs(A.BattleShout.ID) == 0) then
        return A.BattleShout:Show(icon)
    end

    -- Target
    if IsUnitEnemy("target") and EnemyRotation("target") then
        return true
    end

    -- Misc
    -- PvP: Whirlwind
    if A.IsInPvP and A.Zone == "arena" and inCombat == 0 and not Player:IsMounted() and GetToggle(2, "CatchInvisible") and A.Whirlwind:IsReady(nil, true) then
        local hasInvisibleUnits, invisibleUnitID = EnemyTeam():HasInvisibleUnits()
        if hasInvisibleUnits and not Unit(invisibleUnitID):IsVisible() and not EnemyTeam("HEALER"):IsBreakAble(8) and (MultiUnits:GetByRangeInCombat(nil, 1) >= 1 or FriendlyTeam():PlayersInCombat(nil, 4)) then
            return A.Whirlwind:Show(icon)
        end
    end
end

A[4] = nil
A[5] = nil

-- Passive
local function FreezingTrapUsedByEnemy()
    if     UnitCooldown:GetCooldown("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) > UnitCooldown:GetMaxDuration("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) - 2 and
    UnitCooldown:IsSpellInFly("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) and
    Unit(player):GetDR("incapacitate") > 0
    then
        local Caster = UnitCooldown:GetUnitID("arena", ACTION_CONST_SPELLID_FREEZING_TRAP)
        if Caster and Unit(Caster):GetRange() <= 40 then
            return true
        end
    end
end

local function ArenaRotation(icon, unitID)
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then
        -- Note: "arena1" is just identification of meta 6
        if unitID == "arena1" and (Unit(player):GetDMG() == 0 or not Unit(player):IsFocused("DAMAGER")) then
            -- PvP Pet Taunt
            if A.Taunt:IsReady() and EnemyTeam():IsTauntPetAble(A.Taunt.ID) then
                -- Freezing Trap
                if FreezingTrapUsedByEnemy() then
                    return A.Taunt:Show(icon)
                end

                -- Casting BreakAble CC
                if EnemyTeam():IsCastingBreakAble(0.25) then
                    return A.Taunt:Show(icon)
                end

                -- Try avoid something totally random at opener (like sap / blind)
                if Unit(player):CombatTime() <= 5 and (Unit(player):CombatTime() > 0 or Unit("target"):CombatTime() > 0 or MultiUnits:GetByRangeInCombat(40, 1) >= 1) then
                    return A.Taunt:Show(icon)
                end

                -- Roots if not available freedom
                if LoC:Get("ROOT") > 0 and not A.Bloodrage:IsReadyP(player) then
                    return A.Taunt:Show(icon)
                end
            end
        end

        -- StormBolt Focus
        if GetToggle(2, "QueueStormBoltFocus") then
            if not Unit("focus"):IsExists() or A.StormBolt:GetCooldown() > 0 then
                SetToggle({2, "QueueStormBoltFocus", A.StormBolt:Info() .." Focus (Arena): "}, nil)
                return true
            end

            if UnitIsUnit(unitID,"focus") and A.StormBolt:IsReadyByPassCastGCD(unitID) then
                return A.StormBolt:Show(icon)
            end
        end

        -- Interrupt - Pummel (checkbox "useKick" for Interrupts tab in "PvP" and "Heal" categories)
        if A.Pummel:CanInterruptPassive(unitID) then
            return A.Pummel:Show(icon)
        end

        -- Interrupt - StormBolt (checkbox "useCC" for Interrupts tab in "PvP" and "Heal" categories)
        if A.StormBolt:CanInterruptPassive(unitID, countInterruptGCD(unitID)) then
            return A.StormBolt:Show(icon)
        end

        -- Disarm
        if ShouldDisarm(unitID) then
            return A.Disarm:Show(icon)
        end

        -- AutoSwitcher
        if unitID == "arena1" and GetToggle(1, "AutoTarget") and IsUnitEnemy("target") and not A.AbsentImun(nil, "target", Temp.TotalAndPhys) and MultiUnits:GetByRangeInCombat(12, 2) >= 2 then
            return A:Show(icon, ACTION_CONST_AUTOTARGET)
        end
    end
end

local function PartyRotation(icon, unitID)
    -- Intevene is ready and unit not in LOS
    if A.Intervene:IsReadyByPassCastGCD(unitID) and not Unit(unitID):InLOS() and not
    -- Don't intervene if I have Avatar & intervene target > 5 yards away
    (
        (
            Unit(target):HealthPercent() < 25
        ) and
        Unit(unitID):GetRange() >= 5
    ) and
    (
        -- Intervene when passes logic from ProfileUI or it is a scatter shot / binding shot
        A.Overwatch:IsSpellLearned() and
        (IntervenePvP(unitID, Temp.SpellReflectTimer) or Unit(unitID):HasDeBuffs(Temp.InterveneInstaIDs) > 0) or
        -- Peel teamate if hp less then 25%
        Unit(player):HealthPercent() < 25
    )
    then
        return A.Intervene:Show(icon)
    end

    -- RallyingCry PvP Supportive
    if A.IsInPvP and A.RallyingCry:IsReady(player) and Unit(unitID):GetRange() < 35 and Unit(unitID):HealthPercent() < GetToggle(2, "RallyingCryParty") then
        Temp.IsRallyngCrySupportive = true
    end
end

A[6] = function(icon)
    if PartyRotation(icon, "party1") then
        return true
    end

    return ArenaRotation(icon, "arena1")
end

A[7] = function(icon)
    if PartyRotation(icon, "party2") then
        return true
    end

    return ArenaRotation(icon, "arena2")
end

A[8] = function(icon)
    return ArenaRotation(icon, "arena3")
end
