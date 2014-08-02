--[[
	LMAPVote - 1.3
	Copyright ( C ) 2014 ~ L7D
--]]

LMapvote.system.vote = LMapvote.system.vote or { }

LMAPVOTE_SYNC_ENUM__ALL = 1
LMAPVOTE_SYNC_ENUM__PROGRESSONLY = 2
LMAPVOTE_SYNC_ENUM__CHATONLY = 3
LMAPVOTE_SYNC_ENUM__PROGRESSALL = 4

function LMapvote.system.vote.Sync( enum, tab )
	if ( !enum ) then
		return
	end
	
	if ( LMapvote.system.vote.GetStatus( ) == false ) then
		return
	end

	local function enum1_func( )
		if ( LMapvote.system.vote.coreTable ) then
			for _, ent in pairs( player.GetAll( ) ) do
				netstream.Start(
					ent, 
					"LMapvote.system.vote.sync",
					{ Type = enum, Table = LMapvote.system.vote.coreTable }
				)
			end
		end
	end
	
	local function enum2_func( )
		if ( LMapvote.system.vote.coreTable ) then
			for _, ent in pairs( player.GetAll( ) ) do
				netstream.Start(
					ent, 
					"LMapvote.system.vote.sync",
					{ Type = 2, Table = LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] }
				)
			end
		end
	end
	
	local function enum3_func( caller, text )
		if ( LMapvote.system.vote.coreTable ) then
			LMapvote.system.vote.coreTable[ "Chat" ][ #LMapvote.system.vote.coreTable[ "Chat" ] + 1 ] = {
				caller = caller,
				text = text
			}
			for _, ent in pairs( player.GetAll( ) ) do
				netstream.Start(
					ent, 
					"LMapvote.system.vote.sync",
					{ Type = 3, Table = LMapvote.system.vote.coreTable[ "Chat" ] }
				)
			end
		end
	end
	
	local function enum4_func( caller, map )
		if ( LMapvote.system.vote.coreTable ) then
			if ( map and type( map ) == "string" ) then
				local work_co = 0
				local count = 0
				
				for key, value in pairs( LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] ) do
					if ( key ) then
						count = count + 1
					end
				end
				
				for key, value in pairs( LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] ) do
					work_co = work_co + 1
					for i = 1, #value.Voter do
						if ( value.Voter[ i ] == caller:Name( ) ) then
							table.remove( value.Voter, i )
							value.Count = value.Count - 1
						end
					end
					if ( work_co == count ) then
						LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ][map].Voter[ #LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ][map].Voter + 1 ] = caller:Name( )
						LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ][map].Count = LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ][map].Count + 1
						for _, ent in pairs( player.GetAll( ) ) do
							netstream.Start(
								ent, 
								"LMapvote.system.vote.sync",
								{ Type = 5, Table = LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] }
							)
						end
						return
					end
				end
			else
				return
			end
		else
			return
		end
	end

	netstream.Hook( "LMapvote.system.vote.sync_type1_toserver", function( )
		enum1_func( )
	end )
	
	netstream.Hook( "LMapvote.system.vote.sync_type2_toserver", function( )
		enum2_func( )
	end )
	
	netstream.Hook( "LMapvote.system.vote.sync_type3_toserver", function( caller, data )
		enum3_func( caller, data )
	end )
	
	netstream.Hook( "LMapvote.system.vote.sync_type4_toserver", function( caller, data )
		enum4_func( data[1], data[2] )
	end )

	if ( enum == 1 ) then
		if ( SERVER ) then
			enum1_func( )
		elseif ( CLIENT ) then
			netstream.Start( "LMapvote.system.vote.sync_type1_toserver", 1 )
		end
	end
	
	if ( enum == 2 ) then
		if ( SERVER ) then
			enum2_func( )
		elseif ( CLIENT ) then
			netstream.Start( "LMapvote.system.vote.sync_type2_toserver", 1 )
		end	
	end
	
	if ( enum == 3 ) then
		if ( SERVER ) then
			enum3_func( )
		elseif ( CLIENT ) then
			netstream.Start( "LMapvote.system.vote.sync_type3_toserver", tab )
		end	
	end

	if ( enum == 4 ) then
		if ( SERVER ) then
			enum4_func( )
		elseif ( CLIENT ) then
			netstream.Start( "LMapvote.system.vote.sync_type4_toserver", { tab.Caller, tab.Map } )
		end	
	end
end

function LMapvote.system.vote.GetTimeLeft( )
	return GetGlobalInt( "LMapvote.system.vote.Timer", 30 )
end

function LMapvote.system.vote.GetStatus( )
	return GetGlobalBool( "LMapvote.system.vote.Status", false )
end

if ( SERVER ) then
	LMapvote.system.vote.coreTable = LMapvote.system.vote.coreTable or { }
	
	function LMapvote.system.vote.SetStatus( status )
		SetGlobalBool( "LMapvote.system.vote.Status", status )
	end
	
	if ( LMapvote.system.vote.GetStatus( ) == false ) then
		LMapvote.system.vote.SetStatus( false )
		SetGlobalInt( "LMapvote.system.vote.Timer", tonumber( LMapvote.config.VoteTime ) )
	end

	function LMapvote.system.vote.Start( )
		if ( LMapvote.system.vote.GetStatus( ) == true ) then
			return "Vote has currently progressing."
		end

		if ( !LMapvote.system.vote.coreTable ) then
			LMapvote.system.vote.coreTable = { }
		else
			LMapvote.system.vote.coreTable = { }
		end
		
		SetGlobalInt( "LMapvote.system.vote.Timer", tonumber( LMapvote.config.VoteTime ) )
		LMapvote.system.vote.SetStatus( true )
		
		LMapvote.system.vote.coreTable = {
			Chat = { },
			Core = { Vote = { } },
			MapList = { }
		}
		
		local mapFileCache = { }
		
		for key, value in pairs( LMapvote.map.buffer ) do
			mapFileCache[ #mapFileCache + 1 ] = { Dir = "maps/" .. value.Name .. ".bsp", Dir_noext = "maps/" .. value.Name, Name = value.Name, Image = value.Image }
		end
		
		LMapvote.system.vote.coreTable[ "MapList" ] = mapFileCache
		
		for key, value in pairs( LMapvote.system.vote.coreTable[ "MapList" ] ) do
			LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ][ value.Name ] = {
				Voter = { },
				Count = 0
			}
		end
		
		LMapvote.system.vote.Sync( LMAPVOTE_SYNC_ENUM__ALL )
		
		for _, ent in pairs( player.GetAll( ) ) do
			netstream.Start(
				ent, 
				"LMapvote.system.vote.PanelCall",
				1
			)
		end
		
		local current_receiver = 0
		local wonMap = ""
		local runinit = false
		
		timer.Create( "LMapvote.system.vote.Timer", 1, 0, function( )
			if ( LMapvote.system.vote.GetStatus( ) == false ) then
				timer.Destroy( "LMapvote.system.vote.Timer" )
				return
			end
			if ( GetGlobalInt( "LMapvote.system.vote.Timer" ) == 0 ) then
				if ( !runinit ) then
					for _, ent in pairs( player.GetAll( ) ) do
						if ( !ent:IsBot( ) ) then
							netstream.Start(
								ent, 
								"LMapvote.system.vote.ResultSend",
								{ Won = LMapvote.system.vote.GetWinnerMap( ).map, Count = LMapvote.system.vote.GetWinnerMap( ).count }
							)
						end
					end
					runinit = true
				end

				wonMap = LMapvote.system.vote.GetWinnerMap( ).map

				netstream.Hook( "LMapvote.system.vote.ResultReceive", function( caller, data )
					if ( IsValid( caller ) ) then
						current_receiver = current_receiver + 1
					end
				end )

				local player_Count = 0
				
				for _, ent in pairs( player.GetAll( ) ) do
					if ( IsValid( ent ) ) then
						if ( !ent:IsBot( ) ) then
							player_Count = player_Count + 1
						end
					end
				end

				if ( current_receiver >= player_Count ) then
					SetGlobalInt( "LMapvote.system.vote.Timer", tonumber( LMapvote.config.VoteTime ) )
					LMapvote.system.vote.SetStatus( false )
					for _, ent in pairs( player.GetAll( ) ) do
						if ( IsValid( ent ) ) then
							if ( !ent:IsBot( ) ) then
								netstream.Start(
									ent, 
									"LMapvote.system.vote.StopCall",
									1
								)
							end
						end
					end
					RunConsoleCommand( "changelevel", wonMap )
				end
				
			end
			if ( GetGlobalInt( "LMapvote.system.vote.Timer" ) > 0 ) then
				SetGlobalInt( "LMapvote.system.vote.Timer", GetGlobalInt( "LMapvote.system.vote.Timer" ) - 1 )
			end
		end )
		
		return nil
	end
	
	function LMapvote.system.vote.GetWinnerMap( )
		if ( LMapvote.system.vote.GetStatus( ) == false ) then
			return { count = 0, map = game.GetMap( ) }
		end
		if ( !LMapvote.system.vote.coreTable ) then
			return { count = 0, map = game.GetMap( ) }
		end
		
		local buffer = { }
		
		for key, value in pairs( LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] ) do
			buffer[ #buffer + 1 ] = { map = key, count = value.Count }
		end
		
		local notzero = false
		
		for i = 1, #buffer do
			if ( buffer[ i ].count == 0 ) then
				if ( i == #buffer ) then
					if ( !notzero ) then
						return { count = 0, map = game.GetMap( ) }
					end
				end
			else
				notzero = true
			end
		end
		
		table.sort( buffer, function( a, b )
			return a.count > b.count
		end )

		return { count = buffer[ 1 ].count, map = buffer[ 1 ].map }
	end

	function LMapvote.system.vote.Stop( )
		if ( LMapvote.system.vote.GetStatus( ) == false ) then
			return "Vote has not currently progressing." 
		end
		
		if ( timer.Exists( "LMapvote.system.vote.Timer" ) ) then
			timer.Destroy( "LMapvote.system.vote.Timer" )	
		end
		
		SetGlobalInt( "LMapvote.system.vote.Timer", tonumber( LMapvote.config.VoteTime ) )
		LMapvote.system.vote.SetStatus( false )
		
		LMapvote.system.vote.coreTable = { }
		LMapvote.system.vote.Sync( LMAPVOTE_SYNC_ENUM__ALL )
		
		for _, ent in pairs( player.GetAll( ) ) do
			netstream.Start(
				ent, 
				"LMapvote.system.vote.StopCall",
				1
			)
		end
		
		return nil
	end

	hook.Add( "PlayerInitialSpawn", "LMapvote.system.vote.PlayerInitialSpawn", function( pl )
		LMapvote.system.vote.Sync( LMAPVOTE_SYNC_ENUM__ALL )
		if ( LMapvote.system.vote.GetStatus( ) == true ) then
			netstream.Start(
				pl, 
				"LMapvote.system.vote.PanelCall",
				1
			)
		end
	end )

	concommand.Add( "LMapVote_vote_start", function( pl )
		if ( IsValid( pl ) ) then
			if ( LMapvote.config.HavePermission( pl ) ) then
				local run = LMapvote.system.vote.Start( )
				if ( run ) then
					pl:ChatPrint( run )
				end
			else
				pl:ChatPrint( "You don't have permission to this command." )
				return
			end
		else
			local run = LMapvote.system.vote.Start( )
			if ( run ) then
				LMapvote.kernel.Print( LMapvote.rgb.Red, run )
			end
		end
	end )
	
	concommand.Add( "LMapVote_vote_stop", function( pl )
		if ( IsValid( pl ) ) then
			if ( LMapvote.config.HavePermission( pl ) ) then
				local run = LMapvote.system.vote.Stop( )
				if ( run ) then
					pl:ChatPrint( run )
				end
			else
				pl:ChatPrint( "You don't have permission to this command." )
				return
			end
		else
			local run = LMapvote.system.vote.Stop( )
			if ( run ) then
				LMapvote.kernel.Print( LMapvote.rgb.Red, run )
			end
		end
	end )
	
elseif ( CLIENT ) then
	LMapvote.system.vote.coreTable = LMapvote.system.vote.coreTable or { }
	LMapvote.system.vote.result = LMapvote.system.vote.result or { }

	netstream.Hook( "LMapvote.system.vote.ResultSend", function( data )
		LMapvote.system.vote.result = data
		if ( !votePanel ) then
			votePanel = vgui.Create( "LMapVote_VOTE" )
			votePanel:Result_Send( )
		else
			votePanel:Result_Send( )
		end
	end )

	netstream.Hook( "LMapvote.system.vote.sync", function( data )
		if ( data.Type == 1 ) then
			LMapvote.system.vote.coreTable = data.Table
		elseif ( data.Type == 2 ) then
			LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] = data.Table
		elseif ( data.Type == 3 ) then
			LMapvote.system.vote.coreTable[ "Chat" ] = data.Table
			if ( votePanel ) then
				votePanel:Refresh_Chat( 1 )
			end
		elseif ( data.Type == 5 ) then	
			local buffer = LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ]
			LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] = data.Table
			if ( votePanel ) then
				for key, value in pairs( LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] ) do
					for key2, value2 in pairs( buffer ) do
						if ( value.Count != value2.Count ) then
							votePanel:Refresh_Progress( key )
						end
					end
				end
			end
		end
	end )
	
	netstream.Hook( "LMapvote.system.vote.PanelCall", function( )
		if ( !votePanel ) then
			votePanel = vgui.Create( "LMapVote_VOTE" )
		else
			if ( votePanel.Frame ) then
				votePanel.Frame:Remove( )
				votePanel.Frame = nil
			end
			votePanel = vgui.Create( "LMapVote_VOTE" )
		end
	end )

	netstream.Hook( "LMapvote.system.vote.StopCall", function( )
		if ( votePanel ) then
			if ( votePanel.Frame ) then
				votePanel.Frame:Remove( )
				votePanel.Frame = nil
			end
		end
	end )

	function LMapvote.system.vote.Vote( caller, map )
		if ( LMapvote.system.vote.GetStatus( ) == false ) then
			return
		end
		LMapvote.system.vote.Sync( LMAPVOTE_SYNC_ENUM__PROGRESSALL, {
			Caller = caller,
			Map = map
		} )
	end
end