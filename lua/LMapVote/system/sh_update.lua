--[[
	LMAPVote - 1.6
	Copyright ( C ) 2015 ~ L7D
--]]

LMapvote.update = LMapvote.update or { buffer = { } }

local function run( str )
	local result = CompileString( str, "LMapvote.update.Check( ) function", false )( )

	LMapvote.update.buffer = result
	
	netstream.Start( nil, "LMapvote.update.Send", {
		result = LMapvote.update.buffer
	} )
	
	if ( LMapvote.config.Version != LMapvote.update.buffer[ "Latest_Version" ] ) then
		LMapvote.kernel.Print( LMapvote.rgb.Error, "You need to update to " .. LMapvote.update.buffer[ "Latest_Version" ] .. " version!" )
	end
end

function LMapvote.update.Check( )
	local function func( )
		LMapvote.update.buffer = { }

		http.Fetch( "http://textuploader.com/k6d5/raw",
			function( value )
				if ( value:find( "Error 404</p>" ) ) then
					LMapvote.update.buffer = { }
					
					netstream.Start( nil, "LMapvote.update.Send", {
						Tab = LMapvote.update.buffer
					} )
					
					SetGlobalBool( "LMapvote.update.Status", false )
					SetGlobalString( "LMapvote.update.Reason", "404 ERROR." )
					LMapvote.kernel.Print( LMapvote.rgb.Red, "Failed to check update! - 404 ERROR." )
					return
				end
				
				SetGlobalBool( "LMapvote.update.Status", true )
				SetGlobalString( "LMapvote.update.Reason", "" )
				run( value )
			end,
			function( err )
				LMapvote.kernel.Print( LMapvote.rgb.Red, "Failed to check update! - " .. err )
				SetGlobalBool( "LMapvote.update.Status", false )
				SetGlobalString( "LMapvote.update.Reason", err )
			end
		)
	end
		
	if ( SERVER ) then
		func( )
		
		netstream.Hook( "LMapvote.update.FunctionSend", function( data )
			func( )
		end )
	elseif ( CLIENT ) then
		if ( LMapvote.panel.adminPanel and IsValid( LMapvote.panel.adminPanel ) ) then
			LMapvote.panel.adminPanel.UpdateCheckDeleayed = true
		end
		
		netstream.Start( "LMapvote.update.FunctionSend" )
	end
end

if ( SERVER ) then
	LMapvote.update.buffer = LMapvote.update.buffer or { }

	hook.Add( "PlayerAuthed", "LMapvote.update.PlayerAuthed", function( pl )
		timer.Simple( 5, function( )
			LMapvote.update.Check( )
		end )
	end )
	
elseif ( CLIENT ) then
	LMapvote.update.buffer = LMapvote.update.buffer or { }
	
	netstream.Hook( "LMapvote.update.Send", function( data )
		LMapvote.update.buffer = data.result
		
		if ( LMapvote.panel.adminPanel and IsValid( LMapvote.panel.adminPanel ) ) then
			LMapvote.panel.adminPanel.UpdateCheckDeleayed = false
		end
	end )
end