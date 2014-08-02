--[[
	LMAPVote - 1.3
	Copyright ( C ) 2014 ~ L7D
--]]

LMapvote.config = LMapvote.config or { }

LMapvote.config.Version = "1.3" -- Do not edit this. ;>

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

LMapvote.config.VoteTime = 60
