--[[
	LMAPVote - 1.5.3
	Copyright ( C ) 2014 ~ L7D
--]]

if ( SERVER ) then
	AddCSLuaFile( "LMapVote_Master.lua" )
	include( "LMapVote_Master.lua" )
else
	include( "LMapVote_Master.lua" )
end
