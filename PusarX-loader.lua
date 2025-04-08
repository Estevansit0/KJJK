repeat wait() until game:IsLoaded()

if script_key and script_key ~= "" then
    if tostring(game.GameId) == "6664476231" then
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/80c7ecb3c4c3572d11f93a827668d010.lua"))()
    elseif tostring(game.GameId) == "4161970303" then
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/63e793c36cea61b3f023ced8f5c01b21.lua"))()
    elseif tostring(game.GameId) == "6793832056" then
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/ed3ce8fd051c24a59e6a55665ffafe6f.lua"))()
    elseif tostring(game.GameId) == "6471449680" then
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/b77a8a312c23c219f9999f86216096b8.lua"))()
    elseif tostring(game.GameId) == "4069560710" then
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/cea901b8ac07971c217016667c549213.lua"))()
    end
end
