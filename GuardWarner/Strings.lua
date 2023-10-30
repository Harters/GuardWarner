local strings = {
    TITLE = "Guard Warner",
    AUTHOR = "DungMerchant",
    VERSION = "1.1",
    WEBSITE = "https://www.esoui.com/downloads/info3590-GuardWarner.html",

    -- label texts
    SHOW_BOUNTY_TIMER_LABEL = "Show bounty time remaining until upstanding",
    LARGE_SHIELD_LABEL = "Show the larger shield icon",
    KOS_WARNING_LABEL = "Show red shield when guards  kill on sight",
    KOS_ALERT_SOUND_LABEL = "Play alert sound when guards kill on sight",
    BOUNTY_WARNING_LABEL = "Show yellow shield when guards demand bounty",
    BOUNTY_ALERT_SOUND_LABEL = "Play alert sound when guards demand bounty",
    UPSTANDING_WARNING_LABEL = "Show green shield icon when upstanding",
    UPSTANDING_ALERT_SOUND_LABEL = "Play alert sound when upstanding",
}

for stringId, stringValue in pairs(strings) do
    ZO_CreateStringId(stringId , stringValue)
    SafeAddVersion(stringId, 1)
end