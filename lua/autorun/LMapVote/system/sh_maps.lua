--[[
	LMAPVote - Development Version 0.5a
		Copyright ( C ) 2014 ~ L7D
--]]

LMapvote.map = LMapvote.map or { }
LMapvote.map.buffer = { }

function LMapvote.map.Register( mapname, mapimage )
	LMapvote.map.buffer[ #LMapvote.map.buffer + 1 ] = {
		Name = mapname,
		Image = mapimage
	}	
end
	
LMapvote.map.Register( "gm_construct", "" )
LMapvote.map.Register( "gm_flatgrass", "" )

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