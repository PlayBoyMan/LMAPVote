--[[
	LMAPVote - 1.5.2
	Copyright ( C ) 2014 ~ L7D
--]]

LMapvote.config = LMapvote.config or { }

LMapvote.config.Version = "1.5.2" -- Do not edit this. ;>

--[[
	How can i change command and other permission?
	
	Yes here you are ;)
	Link : https://github.com/L7D/LMAPVote/wiki/How-can-i-change-command-and-other-permission%3F
--]]
LMapvote.config.HavePermission = function( pl )
	if ( pl:IsSuperAdmin( ) ) then
		return true
	else
		return false
	end
end

LMapvote.config.VotePanel_MonochromeEffect = true
LMapvote.config.VotePanel_BlurEffect_ammount = 8
LMapvote.config.VoteResult_Sound = "buttons/button1.wav"
LMapvote.config.VoteTime = 60
