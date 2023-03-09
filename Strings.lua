local strings = {
    TITLE = "Guard Warner",
    AUTHOR = "DungMerchant",
    VERSION = "1.0",
    WEBSITE = "https://www.esoui.com/addons.php",

    -- label text
    HEAT_WARNING = "Show shield icon when heat is on",
    HEAT_ALERT_SOUND = "Play alert sound when heat is on",
    NO_HEAT_WARNING = "Always show shield icon (regardless of heat)",
    NO_HEAT_ALERT_SOUND = "Always play alert sound",
}

for stringId, stringValue in pairs(strings) do
    ZO_CreateStringId(stringId , stringValue)
    SafeAddVersion(stringId, 1)
end