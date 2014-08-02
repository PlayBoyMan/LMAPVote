--[[
	LMAPVote - 1.3
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
	MsgC( colCode, "[LMapVote] " .. message .. "\n" )
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
	local find = file.Find( "autorun/LMapvote/" .. folder .. "/*.lua", "LUA" ) or nil
	if ( !find ) then return end
	for key, value in pairs( find ) do
		if ( string.find( value, "sv_" ) and SERVER ) then
			include( "autorun/LMapvote/" .. folder .. "/" .. value )
		elseif ( string.find( value, "sh_" ) ) then
			AddCSLuaFile( "autorun/LMapvote/" .. folder .. "/" .. value )
			if ( SERVER ) then
				include( "autorun/LMapvote/" .. folder .. "/" .. value )
			else
				include( "autorun/LMapvote/" .. folder .. "/" .. value )
			end
		elseif ( string.find( value, "cl_" ) ) then
			if ( SERVER ) then
				AddCSLuaFile( "autorun/LMapvote/" .. folder .. "/" .. value )
			else
				include( "autorun/LMapvote/" .. folder .. "/" .. value )
			end
		end
	end
end

LMapvote.kernel.Include( "sh_config.lua" )
LMapvote.kernel.IncludeFolder( "libs" )
LMapvote.kernel.IncludeFolder( "system" )
LMapvote.kernel.IncludeFolder( "cl" )
LMapvote.kernel.IncludeFolder( "vgui" )

LMapvote.kernel.Print( LMapvote.rgb.Green, "LMAPVote loaded, Version - " .. LMapvote.config.Version )