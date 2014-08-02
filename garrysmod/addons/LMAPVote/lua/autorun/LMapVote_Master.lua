--[[
	LMAPVote - 1.3
	Copyright ( C ) 2014 ~ L7D
--]]

if ( SERVER ) then
	AddCSLuaFile( "LMapVote/SH_LMapVote.lua" )
	AddCSLuaFile( "LMapVote/CL_LMapVote.lua" )
	include( "LMapVote/SH_LMapVote.lua" )
	include( "LMapVote/SV_LMapVote.lua" )
elseif ( CLIENT ) then
	include( "LMapVote/SH_LMapVote.lua" )
	include( "LMapVote/CL_LMapVote.lua" )
end
