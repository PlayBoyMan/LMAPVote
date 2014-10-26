--[[
	LMAPVote - 1.5.2
	Copyright ( C ) 2014 ~ L7D
--]]

LMapvote.map = LMapvote.map or { }
LMapvote.map.buffer = { }

function LMapvote.map.Register( mapname, mapimage )
	if ( string.find( mapname, "*" ) ) then
		local find = file.Find( "maps/" .. mapname .. ".bsp", "GAME" )
		for k, v in pairs( find ) do
			LMapvote.map.buffer[ #LMapvote.map.buffer + 1 ] = {
				Name = string.StripExtension( v ),
				Image = ""
			}	
		end
	else
		LMapvote.map.buffer[ #LMapvote.map.buffer + 1 ] = {
			Name = mapname,
			Image = mapimage
		}	
	end
end

function LMapvote.map.GetDataByName( mapname )
	for key, value in pairs( LMapvote.map.buffer ) do
		if ( value.Name == mapname ) then
			return value
		else
			if ( key == #LMapvote.map.buffer ) then
				return nil
			end
		end
	end
end

--[[ 
	How can i register map?
	
	Yes here you are ;)
	Link : https://github.com/L7D/LMAPVote/wiki/How-can-i-register-map%3F
--]]

LMapvote.map.Register( "gm_*", "" )

-- WARNING - Do not insert 'LMapvote.map.Register' codes bottom this. :p
do
	for i = 1, #LMapvote.map.buffer do
		if ( !LMapvote.map.buffer[ i ].Image or LMapvote.map.buffer[ i ].Image == "" ) then continue end
		resource.AddFile( "materials/" .. LMapvote.map.buffer[ i ].Image )
	end
end