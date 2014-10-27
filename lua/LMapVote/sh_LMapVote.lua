--[[
	LMAPVote - 1.5.3
	Copyright ( C ) 2014 ~ L7D
--]]

LMapvote = LMapvote or { }
LMapvote.kernel = LMapvote.kernel or { }
LMapvote.system = LMapvote.system or { }

LMapvote.rgb = {
	Red = Color( 255, 0, 0 ),
	Green = Color( 0, 255, 0 ),
	Blue = Color( 0, 0, 255 ),
	Error = Color( 0, 255, 255 ),
	White = Color( 255, 255, 255 ),
	Violet = Color( 255, 0, 255 )
}

function LMapvote.kernel.Print( colCode, message )
	MsgC( colCode, "[LMAPVote] " .. message .. "\n" )
end

function LMapvote.kernel.FindPlayerByName( name )
	if ( type( name ) == "string" ) then
		local lowerst_name = string.lower( name )
		for key, value in pairs( player.GetAll( ) ) do
			local ply_name = string.lower( value:Name( ) )
			if ( string.match( ply_name, lowerst_name ) ) then
				return value
			else
				if ( key == #player.GetAll( ) ) then
					return ""
				end
			end
		end
	end
end

function LMapvote.kernel.SteamIDTo64( steamID )
	if ( !steamID ) then
		return ""
	end
	if ( string.match( steamID, "STEAM_[0-5]:[0-9]:[0-9]+" ) ) then
		return util.SteamIDTo64( steamID )
	else
		return ""
	end
end

function LMapvote.kernel.Include( fileName )
	if ( !fileName ) then return end
	if ( string.find( fileName, "sv_" ) and SERVER ) then
		include( fileName )
	elseif ( string.find( fileName, "sh_" ) ) then
		AddCSLuaFile( fileName )
		if ( SERVER ) then
			include( fileName )
		else
			include( fileName )
		end
	elseif ( string.find( fileName, "cl_" ) ) then
		if ( SERVER ) then
			AddCSLuaFile( fileName )
		else
			include( fileName )
		end
	end
end

function LMapvote.kernel.IncludeFolder( folder )
	if ( !folder ) then return end
	local find = file.Find( "LMapvote/" .. folder .. "/*.lua", "LUA" ) or nil
	if ( !find ) then return end
	for key, value in pairs( find ) do
		if ( string.find( value, "sv_" ) and SERVER ) then
			include( "LMapvote/" .. folder .. "/" .. value )
		elseif ( string.find( value, "sh_" ) ) then
			AddCSLuaFile( "LMapvote/" .. folder .. "/" .. value )
			if ( SERVER ) then
				include( "LMapvote/" .. folder .. "/" .. value )
			else
				include( "LMapvote/" .. folder .. "/" .. value )
			end
		elseif ( string.find( value, "cl_" ) ) then
			if ( SERVER ) then
				AddCSLuaFile( "LMapvote/" .. folder .. "/" .. value )
			else
				include( "LMapvote/" .. folder .. "/" .. value )
			end
		end
	end
end

LMapvote.kernel.Include( "sh_config.lua" )
LMapvote.kernel.Include( "libs/sh_von.lua" )
LMapvote.kernel.Include( "libs/sh_netstream.lua" )

LMapvote.kernel.Include( "system/sh_vote_core.lua" )
LMapvote.kernel.Include( "system/sh_maps.lua" )
LMapvote.kernel.Include( "system/sh_update.lua" )

LMapvote.kernel.Include( "cl/cl_derma_msg.lua" )
LMapvote.kernel.Include( "cl/cl_font.lua" )
LMapvote.kernel.Include( "cl/cl_geometry.lua" )

LMapvote.kernel.Include( "vgui/cl_adminPanel.lua" )
LMapvote.kernel.Include( "vgui/cl_votePanel.lua" )

LMapvote.kernel.Print( LMapvote.rgb.Green, "LMAPVote loaded, Version - " .. LMapvote.config.Version )
LMapvote.kernel.Print( LMapvote.rgb.Green, "= Copyright\n* LMAPVote by 'L7D'\n* Netstream by 'Alexander Grist-Hucker'\n* vON by 'Alexandru-Mihai Maftei'" )