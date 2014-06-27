--[[
	LMAPVote - Development Version 0.5a
		Copyright ( C ) 2014 ~ L7D
--]]

LMapvote.config = LMapvote.config or { }


LMapvote.config.Version = "0.5a"

LMapvote.config.HavePermission = function( pl )
	if ( pl:IsSuperAdmin( ) ) then
		return true
	else
		return false
	end
end