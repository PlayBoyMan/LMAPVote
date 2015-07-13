--[[
	LMAPVote - 1.6
	Copyright ( C ) 2015 ~ L7D
--]]

if ( SERVER ) then
	AddCSLuaFile( "LMapVote_Master.lua" )
	include( "LMapVote_Master.lua" )
else
	include( "LMapVote_Master.lua" )
end
