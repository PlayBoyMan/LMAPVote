--[[
	LMAPVote - 1.5
	Copyright ( C ) 2014 ~ L7D
--]]

for i = 15, 64 do
	surface.CreateFont(
		"LMAPVote_font01_" .. i, 
		{
			font = "Segoe UI",
			size = i,
			weight = 1000
		}
	)
	
	surface.CreateFont(
		"LMAPVote_font02_" .. i, 
		{
			font = "Segoe UI Bold",
			size = i,
			weight = 1000
		}
	)
	
	surface.CreateFont(
		"LMAPVote_font03_" .. i, 
		{
			font = "Segoe UI Light",
			size = i,
			weight = 1000
		}
	)
end