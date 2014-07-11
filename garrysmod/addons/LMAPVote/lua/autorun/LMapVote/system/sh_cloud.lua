--[[
	LMAPVote - 1.1
	Copyright ( C ) 2014 ~ L7D
--]]

LMapvote.system.cloud = LMapvote.system.cloud or { }

LMapvote.config.CloudSVR_CustomHOST = nil
LMapvote.config.CloudSVR_AccID = "lmapvote_guest"
LMapvote.config.CloudSVR_AccPWD = "1234"
LMapvote.config.CloudSVR_DataBase = "lmapvote"
LMapvote.config.CloudSVR_MySQLPort = 3306

function LMapvote.system.cloud.Get_NOTICEBOARD_DATA( usesync )
	if ( SERVER ) then
		LMapvote.system.cloud.SetSyncStatus( 1 )
	end
	local function func( )
		local query_01 = LMapvote.system.cloud.MODULE:query( "SELECT * FROM `FREE_BOARD`" )
		if ( query_01 ) then
			query_01:start( )
			query_01.onSuccess = function( q, data )
				local cache = { }
				local deserial_comment = nil
				cache = data

				table.sort( cache, function( a, b )
					return a.ID < b.ID
				end )
				
				for i = 1, #cache do
					if ( cache[ i ] ) then
						if ( cache[ i ].Comment ) then
							if ( type( cache[ i ].Comment ) == "string" and #cache[ i ].Comment > 0 ) then
								deserial_comment = von.deserialize( cache[ i ].Comment )
								cache[ i ].Comment = deserial_comment
								deserial_comment = nil
							else
								cache[ i ].Comment = { }
							end
						else	
							cache[ i ].Comment = { }
						end
					end
				end
					
				LMapvote.system.cloud.Cache[ "FREE_BOARD" ] = cache

				if ( usesync ) then
					for _, ent in pairs( player.GetAll( ) ) do
						netstream.Start(
							ent, 
							"LMapvote.system.cloud.sync",
							{ Type = 1, Table = LMapvote.system.cloud.Cache[ "FREE_BOARD" ] }
						)
					end
				end
					
				timer.Simple( math.random( 2, 4 ), function( )
					LMapvote.system.cloud.SetSyncStatus( 0 )
				end )
			end
			query_01.onError = function( query, err )
				timer.Simple( math.random( 2, 4 ), function( )
					LMapvote.system.cloud.SetSyncStatus( 0 )
				end )
				LMapvote.kernel.Print( LMapvote.rgb.Error, "[CLOUDERROR] LMapvote.system.cloud.Get_NOTICEBOARD_DATA function has returned error - " .. err )
			end
		end
	end

	netstream.Hook( "LMapvote.system.cloud.Get_NOTICEBOARD_DATA_toserver", function( )
		func( )
	end )
		
	if ( SERVER ) then
		func( )
	elseif ( CLIENT ) then
		netstream.Start( "LMapvote.system.cloud.Get_NOTICEBOARD_DATA_toserver", 1 )
	end
end


function LMapvote.system.cloud.GetStatus( )
	return GetGlobalInt( "LMapvote.system.cloud.Status", 2 )
end
	
function LMapvote.system.cloud.GetSyncStatus( )
	return GetGlobalInt( "LMapvote.system.cloud.SyncStatus", 0 )
end	
	
function LMapvote.system.cloud.GetRecTimeLeft( )
	return GetGlobalInt( "LMapvote.system.cloud.Rec_Timeleft", 0 )
end		
	

if ( SERVER ) then
	if ( !mysqloo ) then
		require( "mysqloo" )
		LMapvote.kernel.Print( LMapvote.rgb.Error, "Loaded mysqloo module!" )
	end
	
	CreateConVar( "LMAPVote_Cloud", "1", { FCVAR_NONE } )
	
	if ( file.Exists( "LMAPVOTE/C_status.txt", "DATA" ) ) then
		local value = file.Read( "LMAPVOTE/C_status.txt", "DATA" ) or "0"
		if ( value == "1" ) then
			RunConsoleCommand( "LMAPVote_Cloud", "1" )
		else
			RunConsoleCommand( "LMAPVote_Cloud", "0" )
		end
	else
		file.CreateDir( "LMAPVOTE" )
		file.Write( "LMAPVOTE/C_status.txt", "1" )				
	end

	cvars.AddChangeCallback( "LMAPVote_Cloud", function( cvar, pervV, newV )
		if ( tostring( newV ) == "1" ) then
			LMapvote.system.cloud.Connect( 1 )
			file.CreateDir( "LMAPVOTE" )
			file.Write( "LMAPVOTE/C_status.txt", "1" )			
		else
			LMapvote.system.cloud.Disconnect( )
			file.CreateDir( "LMAPVOTE" )
			file.Write( "LMAPVOTE/C_status.txt", "0" )
		end
	end )
	
	LMapvote.system.cloud.MODULE = LMapvote.system.cloud.MODULE or nil
	LMapvote.system.cloud.Cache = LMapvote.system.cloud.Cache or { }
	LMapvote.system.cloud.RecTimeLeftPlus = LMapvote.system.cloud.RecTimeLeftPlus or 0

	if ( GetGlobalInt( "LMapvote.system.cloud.Status", 9999 ) == 9999 ) then
		SetGlobalInt( "LMapvote.system.cloud.Status", 2 )
	end
	
	netstream.Hook( "LMapvote.system.cloud.StatusChange", function( caller, data )
		if ( data == 1 ) then
			RunConsoleCommand( "LMAPVote_Cloud", "1" )
		else
			RunConsoleCommand( "LMAPVote_Cloud", "0" )
		end
	end )
	
	netstream.Hook( "LMapvote.system.cloud.CommendAdd", function( caller, data )
		LMapvote.system.cloud.Insert_NOTICEBOARD_DATA_Comment( data.CommentTab, data.Tab )
	end )
	
	netstream.Hook( "LMapvote.system.cloud.BoardAdd", function( caller, data )
		LMapvote.system.cloud.Insert_NOTICEBOARD_DATA( data.Tab )
	end )
	
	netstream.Hook( "LMapvote.system.cloud.RemoveBoard", function( caller, data )
		LMapvote.system.cloud.Remove_NOTICEBOARD_DATA( data[1], data[2] )
	end )
	
	function LMapvote.system.cloud.Connect( force )
		if ( mysqloo.VERSION < 8 ) then
			LMapvote.kernel.Print( LMapvote.rgb.Error, "[CLOUDERROR] Your not using latest mysqloo!, please update your mysqloo module!" )
			LMapvote.system.cloud.SetStatus( 4 )
			return
		end
		if ( !force and LMapvote.system.cloud.GetStatus( ) == 5 ) then
			return
		end
		
		if ( !LMapvote.config.CloudSVR_CustomHOST ) then
			LMapvote.system.cloud.SetStatus( 6 )
			LMapvote.kernel.Print( LMapvote.rgb.Green, "Connecting to Hostname server ..." )
		
			http.Fetch( "http://Lmapvote-cloudsvr.oa.to",
				function( value )
					LMapvote.kernel.Print( LMapvote.rgb.Green, "Found hostname! - " .. value )
					timer.Simple( math.random( 1, 3 ), function( )
						LMapvote.system.cloud.MODULE = mysqloo.connect( value, LMapvote.config.CloudSVR_AccID, LMapvote.config.CloudSVR_AccPWD, LMapvote.config.CloudSVR_DataBase, LMapvote.config.CloudSVR_MySQLPort )
						LMapvote.system.cloud.MODULE:connect( )	
						LMapvote.system.cloud.SetStatus( LMapvote.system.cloud.MODULE:status( ) )
						
						SetGlobalString( "LMapvote.system.cloud.HostName", value )
						
						function LMapvote.system.cloud.MODULE:onConnected( )
							LMapvote.kernel.Print( LMapvote.rgb.Green, "Connected to Cloud server is complete :>" )
							LMapvote.system.cloud.SetStatus( LMapvote.system.cloud.MODULE:status( ) )
							LMapvote.system.cloud.SetSyncStatus( 0 )
							if ( LMapvote.system.cloud.GetStatus( ) == 0 ) then
								LMapvote.system.cloud.SyncALL( )
							end
						end
							
						function LMapvote.system.cloud.MODULE:onConnectionFailed( err )
							LMapvote.kernel.Print( LMapvote.rgb.Error, "[CLOUDERROR] Can't connect cloud server!, please check cloud server - " .. err )
							LMapvote.system.cloud.SetStatus( 2 )
							LMapvote.system.cloud.SetSyncStatus( 0 )
							timer.Start( "LMapvote.system.cloud.ServerReconnect" )
						end
					end )
				end,
				function( err )
					LMapvote.kernel.Print( LMapvote.rgb.Error, "[CLOUDERROR] Can't connect hostname server! - " .. err )
				end
			)
		else
			SetGlobalString( "LMapvote.system.cloud.HostName", "nil" )
			LMapvote.system.cloud.MODULE = mysqloo.connect( LMapvote.config.CloudSVR_CustomHOST, LMapvote.config.CloudSVR_AccID, LMapvote.config.CloudSVR_AccPWD, LMapvote.config.CloudSVR_DataBase, LMapvote.config.CloudSVR_MySQLPort )
			LMapvote.system.cloud.MODULE:connect( )	
			LMapvote.system.cloud.SetStatus( LMapvote.system.cloud.MODULE:status( ) )
						
			function LMapvote.system.cloud.MODULE:onConnected( )
				LMapvote.kernel.Print( LMapvote.rgb.Green, "Connected to Cloud server is complete :>" )
				LMapvote.system.cloud.SetStatus( LMapvote.system.cloud.MODULE:status( ) )
				LMapvote.system.cloud.SetSyncStatus( 0 )
				if ( LMapvote.system.cloud.GetStatus( ) == 0 ) then
					LMapvote.system.cloud.SyncALL( )
				end
			end
							
			function LMapvote.system.cloud.MODULE:onConnectionFailed( err )
				LMapvote.kernel.Print( LMapvote.rgb.Error, "[CLOUDERROR] Can't connect cloud server!, please check cloud server - " .. err )
				LMapvote.system.cloud.SetStatus( 2 )
				LMapvote.system.cloud.SetSyncStatus( 0 )
				timer.Start( "LMapvote.system.cloud.ServerReconnect" )
			end
		end
	end

	function LMapvote.system.cloud.Disconnect( )
		if ( !LMapvote.system.cloud.MODULE ) then
			return false
		end

		LMapvote.system.cloud.MODULE:wait( )	
		LMapvote.system.cloud.SetStatus( 5 )
		LMapvote.system.cloud.SetSyncStatus( 0 )
		LMapvote.system.cloud.MODULE = nil
		SetGlobalString( "LMapvote.system.cloud.HostName", "nil" )
		LMapvote.kernel.Print( LMapvote.rgb.Red, "Disconnect by cloud server. :<" )
		
		return true
	end

	function LMapvote.system.cloud.SetStatus( status )
		SetGlobalInt( "LMapvote.system.cloud.Status", status )
	end
	
	function LMapvote.system.cloud.SetSyncStatus( status )
		SetGlobalInt( "LMapvote.system.cloud.SyncStatus", status )
	end
	
	function LMapvote.system.cloud.SyncALL( )
		LMapvote.system.cloud.Get_NOTICEBOARD_DATA( true )
	end

	function LMapvote.system.cloud.Insert_NOTICEBOARD_DATA_Comment( comment_tab, tab )
		tab.Comment[ #tab.Comment + 1 ] = comment_tab
		tab.Comment = von.serialize( tab.Comment )
		local query_01 = LMapvote.system.cloud.MODULE:query( "DELETE FROM `FREE_BOARD` WHERE ID LIKE '" .. LMapvote.system.cloud.MODULE:escape( tab.ID ) .."' AND Title LIKE '%" .. LMapvote.system.cloud.MODULE:escape( tab.Title ) .. "%'" )
		if ( query_01 ) then
			query_01:start( )
			query_01.onSuccess = function( q, data )
				local query_02 = LMapvote.system.cloud.MODULE:query( "INSERT INTO `FREE_BOARD`( ID, Time, Title, Author_Name, Author_SteamID, Value, Comment ) VALUES ( '" .. LMapvote.system.cloud.MODULE:escape( tab.ID ) .. "', '" .. LMapvote.system.cloud.MODULE:escape( tab.Time ) .. "', '" .. LMapvote.system.cloud.MODULE:escape( tab.Title ) .. "', '" .. LMapvote.system.cloud.MODULE:escape( tab.Author_Name ) .. "', '" .. LMapvote.system.cloud.MODULE:escape( tab.Author_SteamID ) .. "', '" .. LMapvote.system.cloud.MODULE:escape( tab.Value ) .. "', '" .. LMapvote.system.cloud.MODULE:escape( tab.Comment ) .. "' )" )
				if ( query_02 ) then
					query_02:start( )
					query_02.onSuccess = function( q, data )
						
						LMapvote.system.cloud.Get_NOTICEBOARD_DATA( true )
					end
					query_02.onError = function( query, err )
						LMapvote.kernel.Print( LMapvote.rgb.Error, "[CLOUDERROR] LMapvote.system.cloud.Insert_NOTICEBOARD_DATA_Comment function has returned error - " .. err )
					end
				end
			end
			query_01.onError = function( query, err )
				LMapvote.kernel.Print( LMapvote.rgb.Error, "[CLOUDERROR] LMapvote.system.cloud.Insert_NOTICEBOARD_DATA_Comment function has returned error - " .. err )
			end
		end
	end
	
	function LMapvote.system.cloud.Insert_NOTICEBOARD_DATA( tab )	
		local id = "1"
		
		if ( #LMapvote.system.cloud.Cache[ "FREE_BOARD" ] != 0 ) then
			local cacheId = nil
			cacheId = tonumber( LMapvote.system.cloud.Cache[ "FREE_BOARD" ][ #LMapvote.system.cloud.Cache[ "FREE_BOARD" ] ].ID ) + 1
			id = tostring( cacheId )
		end
		
		local query_02 = LMapvote.system.cloud.MODULE:query( "INSERT INTO `FREE_BOARD`( ID, Time, Title, Author_Name, Author_ServerName, Author_SteamID, Value, Comment ) VALUES ( '" .. LMapvote.system.cloud.MODULE:escape( id ) .. "', '" .. LMapvote.system.cloud.MODULE:escape( tab.Time ) .. "', '" .. LMapvote.system.cloud.MODULE:escape( tab.Title ) .. "', '" .. LMapvote.system.cloud.MODULE:escape( tab.Author_Name ) .. "', '"  .. LMapvote.system.cloud.MODULE:escape( GetConVarString( "hostname" ) ) .. "', '" .. LMapvote.system.cloud.MODULE:escape( tab.Author_SteamID ) .. "', '" .. LMapvote.system.cloud.MODULE:escape( tab.Value ) .. "', '" .. LMapvote.system.cloud.MODULE:escape( "" ) .. "' )" )
		if ( query_02 ) then
			query_02:start( )
			query_02.onSuccess = function( q, data )
				LMapvote.system.cloud.Get_NOTICEBOARD_DATA( true )
			end
			query_02.onError = function( query, err )
				LMapvote.kernel.Print( LMapvote.rgb.Error, "[CLOUDERROR] LMapvote.system.cloud.Insert_NOTICEBOARD_DATA function has returned error - " .. err )
			end
		end
	end
	
	function LMapvote.system.cloud.Remove_NOTICEBOARD_DATA( one, two )
		local query_01 = LMapvote.system.cloud.MODULE:query( "DELETE FROM `FREE_BOARD` WHERE ID LIKE '" .. LMapvote.system.cloud.MODULE:escape( one ) .."' AND Title LIKE '%" .. LMapvote.system.cloud.MODULE:escape( two ) .. "%'" )
		if ( query_01 ) then
			query_01:start( )
			query_01.onSuccess = function( q, data )
				LMapvote.system.cloud.Get_NOTICEBOARD_DATA( true )
			end
			query_01.onError = function( query, err )
				LMapvote.kernel.Print( LMapvote.rgb.Error, "[CLOUDERROR] LMapvote.system.cloud.Remove_NOTICEBOARD_DATA function has returned error - " .. err )
			end
		end
	end
	
	do
		if ( GetConVarString( "LMAPVote_Cloud" ) == "1" ) then
			 LMapvote.system.cloud.Connect( ) -- :)
		end
	end
	
	timer.Create( "LMapvote.system.cloud.ServerReconnect", 1, 0, function( )
		if ( LMapvote.system.cloud.GetStatus( ) == 0 ) then
			timer.Stop( "LMapvote.system.cloud.ServerReconnect" )
			return
		end
		if ( LMapvote.system.cloud.GetStatus( ) == 1 ) then
			return
		end
		if ( LMapvote.system.cloud.GetStatus( ) == 4 ) then
			return
		end
		if ( LMapvote.system.cloud.GetStatus( ) == 5 ) then
			return
		end
		
		local timeLeft = GetGlobalInt( "LMapvote.system.cloud.Rec_Timeleft", 0 )
		if ( timeLeft > 0 ) then
			SetGlobalInt( "LMapvote.system.cloud.Rec_Timeleft", timeLeft - 1 )
		elseif ( timeLeft <= 0 ) then
			LMapvote.kernel.Print( LMapvote.rgb.Error, "Reconnect by cloud server in progressing ..." )
			LMapvote.system.cloud.MODULE = nil
			LMapvote.system.cloud.SetSyncStatus( 0 )
			LMapvote.system.cloud.Connect( )
			LMapvote.system.cloud.RecTimeLeftPlus = LMapvote.system.cloud.RecTimeLeftPlus + 5
			SetGlobalInt( "LMapvote.system.cloud.Rec_Timeleft", 10 + LMapvote.system.cloud.RecTimeLeftPlus )
		end
	end )

	
	timer.Create( "LMapvote.system.cloud.StatusCheck", 8, 0, function( )
		if ( !LMapvote.system.cloud.MODULE ) then
			return
		end
		if ( LMapvote.system.cloud.GetStatus( ) == 5 ) then
			return
		end
		LMapvote.system.cloud.SetStatus( LMapvote.system.cloud.MODULE:status( ) )
		if ( LMapvote.system.cloud.GetStatus( ) != 0 ) then
			timer.Start( "LMapvote.system.cloud.ServerReconnect" )
		end
	end )
	
	timer.Create( "LMapvote.system.cloud.SyncALLProgress", 15, 0, function( )
		if ( LMapvote.system.cloud.GetStatus( ) != 0 ) then
			return
		end
		if ( LMapvote.system.cloud.GetStatus( ) == 0 ) then
			LMapvote.system.cloud.SyncALL( )
		end		
	end )
	
	do
		if ( LMapvote.system.cloud.GetStatus( ) == 0 ) then
			timer.Stop( "LMapvote.system.cloud.ServerReconnect" )
		end
	end
	
elseif ( CLIENT ) then
	LMapvote.system.cloud.Cache = LMapvote.system.cloud.Cache or { }
	
	netstream.Hook( "LMapvote.system.cloud.sync", function( data )
		if ( data.Type == 1 ) then
			LMapvote.system.cloud.Cache[ "FREE_BOARD" ] = data.Table
			if ( adminPanel ) then
				if ( adminPanel.FreeBoard and IsValid( adminPanel.FreeBoard ) ) then
					adminPanel.FreeBoard.FreeBoardList.Refresh( )
				end
			end
		end
	end )
	
	
	netstream.Hook( "LMapvote.system.cloud.StatusChange_ReceiveClient", function( data )
		if ( data == 1 ) then
			Derma_Message( "Disconnect finished.", "NOTICE", "OK" )
		else
			Derma_Message( "Disconnect failed.", "ERROR", "OK" )
		end
	end )
end



