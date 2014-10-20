--[[
	LMAPVote - 1.5
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
			for _, ent in pairs( player.GetAll( ) ) do
				netstream.Start( ent, "LMapvote.update.Send", {
					Tab = LMapvote.update.buffer
				} )
			end
			if ( LMapvote.config.Version != LMapvote.update.buffer[ "Latest_Version" ] ) then
				LMapvote.kernel.Print( LMapvote.rgb.Error, "You need update! - " .. LMapvote.update.buffer[ "Latest_Version" ] )
			end
		end
			
		http.Fetch( "http://textuploader.com/k6d5/raw",
			function( value )
				if ( string.find( value, "Error 404</p>" ) ) then
					LMapvote.update.buffer = { }
					for _, ent in pairs( player.GetAll( ) ) do
						netstream.Start( ent, "LMapvote.update.Send", {
							Tab = LMapvote.update.buffer
						} )
					end
					SetGlobalBool( "LMapvote.update.Status", false )
					SetGlobalString( "LMapvote.update.Reason", "404 ERROR." )
					LMapvote.kernel.Print( LMapvote.rgb.Red, "Update check failed, - 404 ERROR." )
					return
				end
				SetGlobalBool( "LMapvote.update.Status", true )
				SetGlobalString( "LMapvote.update.Reason", "" )
				run( value )
			end,
			function( err )
				LMapvote.kernel.Print( LMapvote.rgb.Red, "Update check failed, - " .. err )
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
		netstream.Start( "LMapvote.update.FunctionSend", 1 )
	end
end
	
if ( SERVER ) then
	LMapvote.update.buffer = LMapvote.update.buffer or { }

	hook.Add( "PlayerAuthed", "LMapvote.update.PlayerAuthed", function( pl )
		LMapvote.update.Check( )
		netstream.Start( pl, "LMapvote.update.Send", {
			Tab = LMapvote.update.buffer
		} )
	end )
	
elseif ( CLIENT ) then
	LMapvote.update.buffer = LMapvote.update.buffer or { }
	
	netstream.Hook( "LMapvote.update.Send", function( data )
		LMapvote.update.buffer = data.Tab
		
		if ( LMapvote.panel.adminPanel and IsValid( LMapvote.panel.adminPanel ) ) then
			LMapvote.panel.adminPanel.UpdateCheckDeleayed = false
		end
	end )
end