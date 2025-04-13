if not Night.Premium then
    Night.Assets.Notifications.Send({
        Description = "This is a premium only game, you can buy premium here: https://discord.gg/w8RnktNAnn, copied to clipboard",
        Duration = 5
    })
    if setclipboard then
        setclipboard("https://discord.gg/w8RnktNAnn")
    elseif not setclipboard and toclipboard then
        toclipboard("https://discord.gg/w8RnktNAnn")
    end
end