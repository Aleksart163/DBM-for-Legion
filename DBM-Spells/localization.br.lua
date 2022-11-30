if GetLocale() ~= "ptBR" then return end

local L

--Прошляпанное очко Мурчаля ✔✔

-------------------
-- Feitiços Raid --
-------------------
L= DBM:GetModLocalization("Spells")

L:SetGeneralLocalization({
	name = "Feitiços Raid"
})

L:SetOptionLocalization({
	YellOnHeroism = "Relatar quando alguém usa o feitiço $spell:32182 ou similar",
	YellOnResurrect = "Relatar quando um feitiço foi usado em alguém $spell:20484 ou similar",
	YellOnPortal = "Relatar quando alguém abrir $spell:224871 oder ein ähnliches",
	YellOnSoulwell = "Relatar quando alguém usa o feitiço $spell:29893",
	YellOnSoulstone = "Relatar quando um feitiço foi usado em alguém $spell:20707",
	YellOnRitualofSummoning = "Relatar quando alguém usa o feitiço $spell:698",
	YellOnSpiritCauldron = "Relatar quando alguém coloca $spell:188036",
	YellOnLavish = "Relatar quando alguém coloca $spell:201352 ou similar",
	YellOnRepair = "Relatar quando alguém coloca $spell:199109 ou similar",
	YellOnPylon = "Relatar quando alguém coloca $spell:199115"
})

L:SetMiscLocalization{
	HeroismYell = "%s %s usa um %s!",
	PortalYell = "%s %s abre %s!",
	SoulwellYell = "%s %s puts %s!",
	SoulstoneYell = "%s %s aplica %s on %s!",
	SummoningYell = "%s %s começa %s!"
}