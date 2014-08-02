--[[
	LMAPVote - 1.3
	Copyright ( C ) 2014 ~ L7D
--]]

LMapvote.font = LMapvote.font or { }
LMapvote.font.buffer = { }

function LMapvote.font.Add( id, font, size, weight )
	LMapvote.font.buffer[ #LMapvote.font.buffer + 1 ] = {
		ID = id,
		Font = font,
		Size = size,
		Weight = weight
	}
end

LMapvote.font.Add( "LMapVote_font_01", "Segoe UI Light", 40, 1000 )
LMapvote.font.Add( "LMapVote_font_02", "Segoe UI", 20, 1000 )
LMapvote.font.Add( "LMapVote_font_03", "Segoe UI Light", 20, 1000 )
LMapvote.font.Add( "LMapVote_font_04", "Segoe UI", 15, 1000 )
LMapvote.font.Add( "LMapVote_font_05", "Segoe UI Light", 15, 1000 )
LMapvote.font.Add( "LMapVote_font_06", "Segoe UI Bold", 25, 1000 )
LMapvote.font.Add( "LMapVote_font_07", "Segoe UI Light", 30, 1000 )
LMapvote.font.Add( "LMapVote_font_08", "Segoe UI", 23, 1000 )

do
	for i = 1, #LMapvote.font.buffer do
		if ( !LMapvote.font.buffer[ i ] ) then continue end
		if ( !LMapvote.font.buffer[ i ].ID or !LMapvote.font.buffer[ i ].Font ) then continue end
		if ( !LMapvote.font.buffer[ i ].Size ) then
			LMapvote.font.buffer[ i ].Size = 15
		end
		if ( !LMapvote.font.buffer[ i ].Weight ) then
			LMapvote.font.buffer[ i ].Weight = 1000
		end
		
		surface.CreateFont(
			LMapvote.font.buffer[ i ].ID, 
			{
				font = LMapvote.font.buffer[ i ].Font,
				size = LMapvote.font.buffer[ i ].Size,
				weight = LMapvote.font.buffer[ i ].Weight
			}
		)
	end
end