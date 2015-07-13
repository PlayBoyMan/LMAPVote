--[[
	LMAPVote - 1.6
	Copyright ( C ) 2015 ~ L7D
--]]

LMapvote = LMapvote or { kernel = { }, system = { } }
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
	name = name:lower( )
	
	for key, value in pairs( player.GetAll( ) ) do
		if ( value:Name( ):lower( ):match( name ) ) then
			return value
		else
			if ( key == #player.GetAll( ) ) then
				return ""
			end
		end
	end
end

function LMapvote.kernel.Include( fileName )
	fileName = fileName:lower( )
	
	if ( fileName:find( "sv_" ) and SERVER ) then
		include( fileName )
	elseif ( fileName:find( "sh_" ) ) then
		AddCSLuaFile( fileName )
		
		if ( SERVER ) then
			include( fileName )
		else
			include( fileName )
		end
	elseif ( fileName:find( "cl_" ) ) then
		if ( SERVER ) then
			AddCSLuaFile( fileName )
		else
			include( fileName )
		end
	end
end

function LMapvote.kernel.IncludeFolder( folder )
	local find = file.Find( "LMapvote/" .. folder .. "/*.lua", "LUA" )

	for key, value in pairs( find or { } ) do
		if ( value:find( "sv_" ) and SERVER ) then
			include( "LMapvote/" .. folder .. "/" .. value )
		elseif ( value:find( "sh_" ) ) then
			AddCSLuaFile( "LMapvote/" .. folder .. "/" .. value )
			
			if ( SERVER ) then
				include( "LMapvote/" .. folder .. "/" .. value )
			else
				include( "LMapvote/" .. folder .. "/" .. value )
			end
		elseif ( value:find( "cl_" ) ) then
			if ( SERVER ) then
				AddCSLuaFile( "LMapvote/" .. folder .. "/" .. value )
			else
				include( "LMapvote/" .. folder .. "/" .. value )
			end
		end
	end
end

LMapvote.kernel.Include( "sh_config.lua" )
LMapvote.kernel.Include( "libs/sh_pon.lua" )
LMapvote.kernel.Include( "libs/sh_netstream2.lua" )

LMapvote.kernel.Include( "system/sh_vote_core.lua" )
LMapvote.kernel.Include( "system/sh_maps.lua" )
LMapvote.kernel.Include( "system/sh_update.lua" )

LMapvote.kernel.Include( "cl/cl_derma_msg.lua" )
LMapvote.kernel.Include( "cl/cl_font.lua" )
LMapvote.kernel.Include( "cl/cl_geometry.lua" )

LMapvote.kernel.Include( "vgui/cl_adminPanel.lua" )
LMapvote.kernel.Include( "vgui/cl_votePanel.lua" )

LMapvote.kernel.Print( LMapvote.rgb.Green, "LMAPVote loaded, Version - " .. LMapvote.config.Version )
LMapvote.kernel.Print( LMapvote.rgb.Green, "= Copyright\n* LMAPVote by 'L7D'\n* Netstream2 by 'Alexander Grist-Hucker'\n* pON by 'thelastpenguin™'" )