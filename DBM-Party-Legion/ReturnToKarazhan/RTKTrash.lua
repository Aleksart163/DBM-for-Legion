local mod	= DBM:NewMod("RTKTrash", "DBM-Party-Legion", 11)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 17650 $"):sub(12, -3))
--mod:SetModelID(47785)
mod:SetZone()

mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 228255 228239 227917 227925 228625 228606 229714 227966 228254",
	"SPELL_AURA_APPLIED 228331 229706 229716 228610 229074 230083 230050",
	"SPELL_AURA_APPLIED_DOSE 229074",
	"SPELL_AURA_REFRESH 229074",
	"SPELL_AURA_REMOVED 229489 230083",
--	"SPELL_DAMAGE 204762",
--	"SPELL_MISSED 204762",
--	"UNIT_DIED"
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_MONSTER_EMOTE"
)
--Каражан треш
local warnVolatileCharge			= mod:NewSpellAnnounce(227925, 2)
local warnNullification				= mod:NewTargetAnnounce(230083, 1) --Полная нейтрализация

local specWarnForceBlade			= mod:NewSpecialWarningYouDefensive(230050, nil, nil, nil, 3, 5) --Силовой клинок
local specWarnNullification			= mod:NewSpecialWarningYouFind(230083, nil, nil, nil, 3, 5) --Полная нейтрализация
local specWarnSoulLeech2			= mod:NewSpecialWarningInterrupt(228254, "HasInterrupt", nil, nil, 1, 2) --Поглощение души
local specWarnSoulLeech				= mod:NewSpecialWarningInterrupt(228255, "HasInterrupt", nil, nil, 1, 2)
local specWarnTerrifyingWail		= mod:NewSpecialWarningInterrupt(228239, "HasInterrupt", nil, nil, 1, 2)
local specWarnPoetrySlam			= mod:NewSpecialWarningInterrupt(227917, "HasInterrupt", nil, nil, 1, 2)
local specWarnBansheeWail			= mod:NewSpecialWarningInterrupt(228625, "HasInterrupt", nil, nil, 1, 2)
local specWarnHealingTouch			= mod:NewSpecialWarningInterrupt(228606, "HasInterrupt", nil, nil, 1, 2)
local specWarnConsumeMagic			= mod:NewSpecialWarningInterrupt(229714, "HasInterrupt", nil, nil, 1, 2)
local specWarnFinalCurtain			= mod:NewSpecialWarningDodge(227925, "Melee", nil, nil, 1, 2)
local specWarnVolatileCharge		= mod:NewSpecialWarningMoveAway(228331, nil, nil, nil, 3, 3)

local specWarnBurningBrand			= mod:NewSpecialWarningMoveAway(228610, nil, nil, nil, 3, 3)
local specWarnLeechLife				= mod:NewSpecialWarningDispel(228606, "Healer", nil, nil, 1, 2)
local specWarnCurseofDoom			= mod:NewSpecialWarningDispel(229716, "Healer", nil, nil, 1, 2)
local specWarnRoyalty				= mod:NewSpecialWarningSwitch(229489, nil, nil, nil, 1, 2)
local specWarnFlashlight			= mod:NewSpecialWarningLookAway(227966, nil, nil, nil, 1, 2)

local yellNullification				= mod:NewYell(230083, nil, nil, nil, "YELL") --Полная нейтрализация
local yellVolatileCharge			= mod:NewYell(228331, nil, nil, nil, "YELL")
local yellBurningBrand				= mod:NewYell(228610, nil, nil, nil, "YELL")

local timerAchieve					= mod:NewBuffActiveTimer(480, 229074)

local timerRoleplay					= mod:NewTimer(29, "timerRoleplay", "Interface\\Icons\\Spell_Holy_BorrowedTime", nil, nil, 7) --Ролевая игра

function mod:SPELL_CAST_START(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 228255 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnSoulLeech:Show(args.sourceName)
		specWarnSoulLeech:Play("kickcast")
	elseif spellId == 228239 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnTerrifyingWail:Show(args.sourceName)
		specWarnTerrifyingWail:Play("kickcast")
	elseif spellId == 227917 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnPoetrySlam:Show(args.sourceName)
		specWarnPoetrySlam:Play("kickcast")
	elseif spellId == 228625 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnBansheeWail:Show(args.sourceName)
		specWarnBansheeWail:Play("kickcast")
	elseif spellId == 228606 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnHealingTouch:Show(args.sourceName)
		specWarnHealingTouch:Play("kickcast")
	elseif spellId == 229714 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnConsumeMagic:Show(args.destName)
		specWarnConsumeMagic:Play("kickcast")
	elseif spellId == 227925 and self:AntiSpam(3, 1) then
		specWarnFinalCurtain:Show()
		specWarnFinalCurtain:Play("runout")
	elseif spellId == 227966 and self:AntiSpam(3, 2) then
		specWarnFlashlight:Show()
		specWarnFlashlight:Play("turnaway")
	elseif spellId == 228254 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnSoulLeech2:Show(args.sourceName)
		specWarnSoulLeech2:Play("kickcast")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 228331 then
		warnVolatileCharge:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnVolatileCharge:Show()
			specWarnVolatileCharge:Play("runout")
			yellVolatileCharge:Yell()
		end
	elseif spellId == 228610 then
		if args:IsPlayer() then
			specWarnBurningBrand:Show()
			specWarnBurningBrand:Play("runout")
			yellBurningBrand:Yell()
		end
	elseif spellId == 229706 then
		specWarnLeechLife:Show(args.destName)
		specWarnLeechLife:Play("dispelnow")
	elseif spellId == 229716 then
		specWarnCurseofDoom:Show(args.destName)
		specWarnCurseofDoom:Play("dispelnow")
	elseif spellId == 229074 and self:AntiSpam(3, 3) then
		local uId = DBM:GetRaidUnitId(args.destName)
		local _, _, _, _, _, _, expires = DBM:UnitBuff(uId, args.spellName)
		if expires then
			local debuffTime = expires - GetTime()
			timerAchieve:Stop()
			timerAchieve:Start(debuffTime)
		end
	elseif spellId == 230083 then --Полная нейтрализация
		warnNullification:Show(args.destName)
		if args:IsPlayer() then
			specWarnNullification:Show()
			yellNullification:Yell()
		end
	elseif spellId == 230050 then --Полная нейтрализация
		if args:IsPlayer() then
			specWarnForceBlade:Show()
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED
mod.SPELL_AURA_REFRESH = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 229489 then
		specWarnRoyalty:Show(args.destName)
	end
end

--Assumed event. don't know if it's actually CHAT_MSG_MONSTER_EMOTE
function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L.speedRun then
		self:SendSync("KaraSpeed")
	end
end

function mod:OnSync(msg)
	if msg == "KaraSpeed" then
		timerAchieve:Start()
	elseif msg == "RPBeauty" then
		timerRoleplay:Start(55)
	elseif msg == "RPWestfall" then
		timerRoleplay:Start(51)
	elseif msg == "RPWikket" then
		timerRoleplay:Start(70)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg) --CHAT_MSG_MONSTER_SAY
	if msg == L.Beauty or msg:find(L.Beauty) then
		self:SendSync("RPBeauty")
	elseif msg == L.Westfall or msg:find(L.Westfall) then
		self:SendSync("RPWestfall")
	elseif msg == L.Wikket or msg:find(L.Wikket) then
		self:SendSync("RPWikket")
	end
end
