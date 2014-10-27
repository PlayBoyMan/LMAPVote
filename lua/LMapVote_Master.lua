--[[
	LMAPVote - 1.5
	Copyright ( C ) 2014 ~ L7D
--]]

if ( SERVER ) then
	AddCSLuaFile( "LMapVote/sh_LMapVote.lua" )
	AddCSLuaFile( "LMapVote/cl_LMapVote.lua" )
	include( "LMapVote/sh_LMapVote.lua" )
	include( "LMapVote/sv_LMapVote.lua" )
else
	include( "LMapVote/sh_LMapVote.lua" )
	include( "LMapVote/cl_LMapVote.lua" )
end