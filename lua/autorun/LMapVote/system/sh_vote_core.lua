--[[
	LMAPVote - 1.5
	Copyright ( C ) 2014 ~ L7D
--]]
LMapvote.system.vote = LMapvote.system.vote or { }

LMAPVOTE_SYNC_ENUM__ALL = 1
LMAPVOTE_SYNC_ENUM__PROGRESSONLY = 2
LMAPVOTE_SYNC_ENUM__CHATONLY = 3
LMAPVOTE_SYNC_ENUM__PROGRESSALL = 4
LMAPVOTE_SYNC_ENUM__VOICEONLY = 5

function LMapvote.system.vote.Sync( enum, tab )
	if ( !enum or !LMapvote.system.vote.GetStatus( ) ) then
		return
	end

	local function enum1_func( )
		if ( !LMapvote.system.vote.coreTable ) then return end
		for _, ent in pairs( player.GetAll( ) ) do
			netstream.Start(
				ent, 
				"LMapvote.system.vote.sync",
				{ Type = enum, Table = LMapvote.system.vote.coreTable }
			)
		end
	end
	
	local function enum2_func( )
		if ( !LMapvote.system.vote.coreTable ) then return end
		for _, ent in pairs( player.GetAll( ) ) do
			netstream.Start(
				ent, 
				"LMapvote.system.vote.sync",
				{ Type = 2, Table = LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] }
			)
		end
	end
	
	local function enum3_func( caller, text )
		if ( !LMapvote.system.vote.coreTable ) then return end
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
	
	local function enum4_func( caller, map )
		if ( !LMapvote.system.vote.coreTable ) then return end
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
					if ( value.Voter[ i ] == caller ) then
						table.remove( value.Voter, i )
						value.Count = value.Count - 1
					end
				end
				if ( work_co == count ) then
					LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ][ map ].Voter[ #LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ][ map ].Voter + 1 ] = caller
					LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ][ map ].Count = LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ][ map ].Count + 1
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
	end
	
	local function enum5_func( ent, bool )
		if ( LMapvote.system.vote.coreTable ) then
			if ( bool ) then
				for i = 1, #LMapvote.system.vote.coreTable[ "Voice" ] do
					if ( LMapvote.system.vote.coreTable[ "Voice" ][ i ] == ent ) then
						LMapvote.system.vote.coreTable[ "Voice" ][ i ] = nil
					end
				end
				LMapvote.system.vote.coreTable[ "Voice" ][ #LMapvote.system.vote.coreTable[ "Voice" ] + 1 ] = ent
			else
				for i = 1, #LMapvote.system.vote.coreTable[ "Voice" ] do
					if ( LMapvote.system.vote.coreTable[ "Voice" ][ i ] == ent ) then
						LMapvote.system.vote.coreTable[ "Voice" ][ i ] = nil
					end
				end
			end
			for _, ent in pairs( player.GetAll( ) ) do
				netstream.Start(
					ent, 
					"LMapvote.system.vote.sync",
					{ Type = 6, Table = LMapvote.system.vote.coreTable[ "Voice" ] }
				)
			end
		end
	end

	if ( SERVER ) then
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
		netstream.Hook( "LMapvote.system.vote.sync_type5_toserver", function( caller, data )
			enum5_func( data[1], data[2] )
		end )
	end

	if ( enum == 1 ) then
		if ( SERVER ) then
			enum1_func( )
		elseif ( CLIENT ) then
			netstream.Start( "LMapvote.system.vote.sync_type1_toserver", 1 )
		end
	elseif ( enum == 2 ) then
		if ( SERVER ) then
			enum2_func( )
		elseif ( CLIENT ) then
			netstream.Start( "LMapvote.system.vote.sync_type2_toserver", 1 )
		end
	elseif ( enum == 3 ) then
		if ( SERVER ) then
			enum3_func( )
		elseif ( CLIENT ) then
			netstream.Start( "LMapvote.system.vote.sync_type3_toserver", tab )
		end
	elseif ( enum == 4 ) then
		if ( SERVER ) then
			enum4_func( )
		elseif ( CLIENT ) then
			netstream.Start( "LMapvote.system.vote.sync_type4_toserver", { tab.Caller, tab.Map } )
		end
	elseif ( enum == 5 ) then
		if ( SERVER ) then
			enum5_func( )
		elseif ( CLIENT ) then
			netstream.Start( "LMapvote.system.vote.sync_type5_toserver", { tab.Ent, tab.Bool } )
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

		local function Initialization( )
			LMapvote.system.vote.SetStatus( true )
			LMapvote.system.vote.coreTable = { }
			SetGlobalInt( "LMapvote.system.vote.Timer", tonumber( LMapvote.config.VoteTime ) )
			
			LMapvote.system.vote.coreTable = {
				Chat = { },
				Core = { Vote = { } },
				MapList = { },
				Voice = { }
			}
		end
		
		local function mapFileProgress( )
			local mapFileCache = { }
			for key, value in pairs( LMapvote.map.buffer ) do
				mapFileCache[ #mapFileCache + 1 ] = { Dir = "maps/" .. value.Name .. ".bsp", Dir_noext = "maps/" .. value.Name, Name = value.Name, Image = value.Image }
			end
			LMapvote.system.vote.coreTable[ "MapList" ] = mapFileCache
		end
		
		Initialization( )
		mapFileProgress( )

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
				local player_Count = 0
				
				if ( !runinit ) then
					local winnerMap = LMapvote.system.vote.GetWinnerMap( )
					for _, ent in pairs( player.GetAll( ) ) do
						if ( !ent:IsBot( ) ) then
							netstream.Start(
								ent, 
								"LMapvote.system.vote.ResultSend",
								{ Won = winnerMap.map, Count = winnerMap.count }
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

				for _, ent in pairs( player.GetAll( ) ) do
					if ( IsValid( ent ) and ( !ent:IsBot( ) ) ) then
						player_Count = player_Count + 1
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
					if ( timer.Exists( "LMapvote.system.vote.ForceChangeLevel" ) ) then
						timer.Destroy( "LMapvote.system.vote.ForceChangeLevel" )
						return
					end
				end
				
				timer.Create( "LMapvote.system.vote.ForceChangeLevel", 10, 1, function( )
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
					if ( timer.Exists( "LMapvote.system.vote.ForceChangeLevel" ) ) then
						timer.Destroy( "LMapvote.system.vote.ForceChangeLevel" )
					end
				end )
				
			end
			if ( GetGlobalInt( "LMapvote.system.vote.Timer" ) > 0 ) then
				SetGlobalInt( "LMapvote.system.vote.Timer", GetGlobalInt( "LMapvote.system.vote.Timer" ) - 1 )
			end
		end )
		
		return nil
	end
	
	function LMapvote.system.vote.GetWinnerMap( )
		if ( !LMapvote.system.vote.coreTable ) then return { count = 0, map = game.GetMap( ) } end
		if ( !LMapvote.system.vote.GetStatus( ) ) then return { count = 0, map = game.GetMap( ) } end
		local buffer = { }
		local notzero = false
		for key, value in pairs( LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] ) do
			buffer[ #buffer + 1 ] = { map = key, count = value.Count }
		end
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
		
		if ( !buffer[ 1 ] ) then
			return { count = 0, map = game.GetMap( ) }
		end

		return { count = buffer[ 1 ].count, map = buffer[ 1 ].map }
	end

	function LMapvote.system.vote.Stop( )
		if ( !LMapvote.system.vote.GetStatus( ) ) then return "Vote has not currently progressing." end
		if ( timer.Exists( "LMapvote.system.vote.Timer" ) ) then timer.Destroy( "LMapvote.system.vote.Timer" )	end
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
		if ( LMapvote.system.vote.GetStatus( ) ) then
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
				pl:ChatPrint( "You don't have permission do this command." )
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
				pl:ChatPrint( "You don't have permission do this command." )
				return
			end
		else
			local run = LMapvote.system.vote.Stop( )
			if ( run ) then
				LMapvote.kernel.Print( LMapvote.rgb.Red, run )
			end
		end
	end )
else
	LMapvote.system.vote.coreTable = LMapvote.system.vote.coreTable or { }
	LMapvote.system.vote.result = LMapvote.system.vote.result or { }

	netstream.Hook( "LMapvote.system.vote.ResultSend", function( data )
		LMapvote.system.vote.result = data
		if ( !LMapvote.panel.votePanel ) then
			LMapvote.panel.votePanel = vgui.Create( "LMapVote_VOTE" )
			LMapvote.panel.votePanel:Result_Send( )
		else
			LMapvote.panel.votePanel:Result_Send( )
		end
	end )

	netstream.Hook( "LMapvote.system.vote.sync", function( data )
		if ( data.Type == 1 ) then
			LMapvote.system.vote.coreTable = data.Table
		elseif ( data.Type == 2 ) then
			LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] = data.Table
		elseif ( data.Type == 3 ) then
			LMapvote.system.vote.coreTable[ "Chat" ] = data.Table
			if ( !LMapvote.panel.votePanel ) then return end
			LMapvote.panel.votePanel:Refresh_Chat( )
		elseif ( data.Type == 5 ) then	
			local buffer = LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ]
			LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] = data.Table
			if ( !LMapvote.panel.votePanel ) then return end
			LMapvote.panel.votePanel:Refresh_Progress( key )
		elseif ( data.Type == 6 ) then	
			LMapvote.system.vote.coreTable[ "Voice" ] = data.Table
			if ( !LMapvote.panel.votePanel ) then return end
			LMapvote.panel.votePanel:Refresh_Voice( )
		end
	end )
	
	netstream.Hook( "LMapvote.system.vote.PanelCall", function( )
		if ( !LMapvote.panel.votePanel ) then
			LMapvote.panel.votePanel = vgui.Create( "LMapVote_VOTE" )
		else
			LMapvote.panel.votePanel:Close( )
			LMapvote.panel.votePanel = vgui.Create( "LMapVote_VOTE" )
		end
	end )

	netstream.Hook( "LMapvote.system.vote.StopCall", function( )
		if ( !LMapvote.panel.votePanel ) then return end
		LMapvote.panel.votePanel:Close( )
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