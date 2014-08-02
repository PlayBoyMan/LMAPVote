--[[
	LMAPVote - 1.3
	Copyright ( C ) 2014 ~ L7D
--]]

local VOTEPANEL = { }

function VOTEPANEL:Init( )
	self.w = ScrW( )
	self.h = ScrH( )
	self.x = ScrW( ) / 2 - self.w / 2
	self.y = ScrH( ) / 2 - self.h / 2

	self.ProgressTab = { }
	self.Type = 1
	self.imageTable = { }
	self.imageTablebuffer = { }
	
	self.FirstChatEntryClicked = false
	
	if ( self.Frame ) then
		self.Frame:Remove( )
		self.Frame = nil
	end
	
	local percent = 0
	local percentAni = 0
	local percentBoxAni = 0
	
	local timePercent = 0
	local timePercentBoxAni = 0
	
	self.percent_count = 0
	
	for key, value in pairs( LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] ) do
		if ( #value.Voter != 0 ) then
			self.percent_count = self.percent_count + 1
		end
	end
	
	for key, value in pairs( LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] ) do
		self.imageTablebuffer[ #self.imageTablebuffer + 1 ] = { Voter = value.Voter, Map = key, Count = value.Count }
	end

	for key, value in pairs( self.imageTablebuffer ) do
		if ( !LMapvote.map.GetDataByName( value.Map ).Image or LMapvote.map.GetDataByName( value.Map ).Image == "" ) then
			if ( file.Exists( "maps/thumb/" .. value.Map .. ".png", "GAME" ) ) then
				self.imageTable[ value.Map ] = 1
			else
				self.imageTable[ value.Map ] = 0
			end
		else
			if ( file.Exists( "materials/" .. LMapvote.map.GetDataByName( value.Map ).Image, "GAME" ) ) then
				self.imageTable[ value.Map ] = 2
			else
				self.imageTable[ value.Map ] = 0
			end
		end
	end
	
	self.Frame = vgui.Create( "DFrame" )
	self.Frame:SetSize( self.w, self.h )
	self.Frame:SetPos( self.x, self.y )
	self.Frame:SetTitle( "" )
	self.Frame:ShowCloseButton( false )
	self.Frame:SetDraggable( false )
	self.Frame:MakePopup( )
	self.Frame:Center( )
	self.Frame.Paint = function( pnl, w, h )
		percent = self.percent_count / #player.GetAll( )
		timePercent = GetGlobalInt( "LMapvote.system.vote.Timer" ) / tonumber( LMapvote.config.VoteTime )
		
		timePercentBoxAni = Lerp( 0.05, timePercentBoxAni, timePercent * ( w * 0.6 ) )
		
		percentAni = Lerp( 0.05, percentAni, percent * 100 )
		percentBoxAni = Lerp( 0.03, percentBoxAni, percent * 360 )
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )
		
		draw.SimpleText( "LMAPVote", "LMapVote_font_01", 15, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Copyright ( C ) 2014 ~ L7D", "LMapVote_font_05", 15, h - 40, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Version - " .. LMapvote.config.Version, "LMapVote_font_05", 15, h - 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		if ( self.Type == 1 ) then
			draw.RoundedBox( 0, 15, h * 0.5 + 65, w * 0.2 - 15, h * 0.35, Color( 10, 10, 10, 8 ) )
			
			local timer01 = LMapvote.geometry.GeneratePolyBarTII( w * 0.2, 20, w * 0.6, 10 )
			local timer02 = LMapvote.geometry.GeneratePolyBarTII( w * 0.2, 20, timePercentBoxAni, 10 )

			draw.NoTexture( )
			surface.SetDrawColor( 10, 10, 10, 30 )			
			surface.DrawPoly( timer01 )
				
			draw.NoTexture( )
			surface.SetDrawColor( 0, 0, 0, 200 )			
			surface.DrawPoly( timer02 )
			
			draw.NoTexture( )
			surface.SetDrawColor( 0, 0, 0, 255 )
			LMapvote.geometry.DrawCircle( ( 15 + w * 0.2 - 15 ) / 2, ( h * 0.5 + 65 ) + ( h * 0.35 ) / 2, 80, 8, 90, percentBoxAni, 100)
			
			draw.NoTexture( )
			surface.SetDrawColor( 0, 0, 0, 255 )
			LMapvote.geometry.DrawCircle( ( 15 + w * 0.2 - 15 ) / 2, ( h * 0.5 + 65 ) + ( h * 0.35 ) / 2, 80, 2, 90, 360, 100)

			draw.SimpleText( "Vote Percent", "LMapVote_font_03", ( 15 + w * 0.2 - 15 ) / 2, ( h * 0.5 + 65 ) + ( h * 0.35 ) / 2 - 120, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( math.Round( percentAni ) .. " %", "LMapVote_font_01", ( 15 + w * 0.2 - 15 ) / 2, ( h * 0.5 + 65 ) + ( h * 0.35 ) / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			draw.SimpleText( GetGlobalInt( "LMapvote.system.vote.Timer" ), "LMapVote_font_03", w * 0.2 - 30, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		else
			self.LeftMenu:SetVisible( false )
			self.CenterMenu:SetVisible( false )
			self.Chat:SetVisible( false )
			self.ChatEntry:SetVisible( false )
			self.ChatRun:SetVisible( false )
			
			draw.RoundedBox( 0, 0, 0, w, 50, Color( 0, 0, 0, 15 ) )

			draw.SimpleText( "Vote Result", "LMapVote_font_01", w / 2, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			if ( LMapvote.system.vote.result ) then
				if ( LMapvote.system.vote.result.Won ) then
					local data = LMapvote.map.GetDataByName( LMapvote.system.vote.result.Won )
					
					draw.RoundedBox( 0, w / 2 - ( w * 0.2 / 2 ), h * 0.4 - ( h * 0.2 / 2 ), w * 0.2, h * 0.2, Color( 0, 0, 0, 100 ) )
					
					if ( !data.Image or data.Image == "" ) then
						if ( file.Exists( "maps/thumb/" .. data.Name .. ".png", "GAME" ) ) then
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.SetMaterial( Material( "maps/thumb/" .. data.Name .. ".png" ) )
							surface.DrawTexturedRect( w / 2 - ( w * 0.2 / 2 ), h * 0.4 - ( h * 0.2 / 2 ), w * 0.2, h * 0.2 )		
						end
					else
						if ( file.Exists( "materials/" .. data.Image, "GAME" ) ) then
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.SetMaterial( Material( data.Image ) )
							surface.DrawTexturedRect( w / 2 - ( w * 0.2 / 2 ), h * 0.4 - ( h * 0.2 / 2 ), w * 0.2, h * 0.2 )
						end
					end
					
					draw.SimpleText( data.Name, "LMapVote_font_01", w / 2, h * 0.6, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					if ( LMapvote.system.vote.result.Count ) then
						draw.SimpleText( LMapvote.system.vote.result.Count .. " players voted.", "LMapVote_font_03", w / 2, h * 0.6 + 50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
				end
			end
		end
	end

	self.LeftMenu = vgui.Create( "DPanelList", self.Frame )
	self.LeftMenu:SetPos( 15, 50 )
	self.LeftMenu:SetSize( self.w * 0.5 - 15, self.h * 0.5 )
	self.LeftMenu:SetSpacing( 5 )
	self.LeftMenu:EnableHorizontal( false )
	self.LeftMenu:EnableVerticalScrollbar( true )		
	self.LeftMenu.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	self.CenterMenu = vgui.Create( "DPanelList", self.Frame )
	self.CenterMenu:SetPos( self.w * 0.5 + 15, 50 )
	self.CenterMenu:SetSize( self.w - ( self.w * 0.5 + 30 ), self.h * 0.5 )
	self.CenterMenu:SetSpacing( 10 )
	self.CenterMenu:EnableHorizontal( true )
	self.CenterMenu:EnableVerticalScrollbar( true )		
	self.CenterMenu.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	local think = true
	
	self.Chat = vgui.Create( "DPanelList", self.Frame )
	self.Chat:SetPos( self.w * 0.2 + 15, self.h * 0.5 + 65 )
	self.Chat:SetSize( self.w * 0.8 - 30, self.h * 0.35 )
	self.Chat:SetSpacing( 2 )
	self.Chat:EnableHorizontal( false )
	self.Chat:EnableVerticalScrollbar( true )		
	self.Chat.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	self.ChatRun = vgui.Create( "DButton", self.Frame )
	self.ChatRun:SetSize( self.w * 0.1, 30 )
	self.ChatRun:SetPos( self.w * 0.9 - 15, self.h * 0.9 + 30 )
	self.ChatRun:SetFont( "LMapVote_font_03" )
	self.ChatRun:SetText( "Send" )
	self.ChatRun:SetColor( Color( 0, 0, 0, 255 ) )
	self.ChatRun.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( string.len( self.ChatEntry:GetValue( ) ) > 0 ) then
			LMapvote.system.vote.Sync( LMAPVOTE_SYNC_ENUM__CHATONLY, self.ChatEntry:GetValue( ) )
			self.ChatEntry:SetText( "" )
			self.ChatEntry:RequestFocus( )
		else
			self.ChatEntry:SetText( "" )
			self.ChatEntry:RequestFocus( )
		end
	end
	self.ChatRun.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	self.ChatEntry = vgui.Create( "DTextEntry", self.Frame )
	self.ChatEntry:SetPos( self.w * 0.2 + 15, self.h * 0.9 + 30 )
	self.ChatEntry:SetSize( self.w * 0.7 - ( 30 + 15 ), 30 )	
	self.ChatEntry:SetFont( "LMapVote_font_04" )
	self.ChatEntry:SetText( "Chat message here ..." )
	self.ChatEntry:SetAllowNonAsciiCharacters( true )
	self.ChatEntry.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 0, 0, 0, 255 ) )
			
		pnl:DrawTextEntryText( Color( 0, 0, 0 ), Color( 0, 0, 0 ), Color( 0, 0, 0 ) )
	end
	self.ChatEntry.OnTextChanged = function( )
		if ( !self.FirstChatEntryClicked ) then
			self.ChatEntry:SetText( "" )
			self.FirstChatEntryClicked = true
		end
	end
	
	self.ChatEntry.OnEnter = function( )
		LMapvote.PlayButtonSound( )
		if ( string.len( self.ChatEntry:GetValue( ) ) > 0 ) then
			LMapvote.system.vote.Sync( LMAPVOTE_SYNC_ENUM__CHATONLY, self.ChatEntry:GetValue( ) )
			self.ChatEntry:SetText( "" )
			self.ChatEntry:RequestFocus( )
		else
			self.ChatEntry:SetText( "" )
			self.ChatEntry:RequestFocus( )
		end
	end
	
	self:Refresh_Progress( )
	self:Refresh_MapList( )
	self:Refresh_Chat( )
end

function VOTEPANEL:Result_Send( )
	surface.PlaySound( "buttons/button1.wav" )
	self.Type = 2
	timer.Simple( 5, function( )
		self:Result_Receive( )
	end )
end

function VOTEPANEL:Result_Receive( )
	netstream.Start( "LMapvote.system.vote.ResultReceive", 1 )
end

function VOTEPANEL:Refresh_Progress( keycode )
	self.LeftMenu:Clear( )
	
	local buffer = { }
	local buffer2 = { }

	for key, value in pairs( LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] ) do
		buffer[ #buffer + 1 ] = { Voter = value.Voter, Map = key, Count = value.Count }
	end
		
	table.sort( buffer, function( a, b )
		return a.Count > b.Count
	end )

	for i = 1, #buffer do
		buffer2[ buffer[ i ].Map ] = { Voter = buffer[ i ].Voter, Count = buffer[ i ].Count }
	end
		
	LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] = buffer2
	
	--[[

	for key, value in pairs( buffer ) do
		if ( !LMapvote.map.GetDataByName( value.Map ).Image or LMapvote.map.GetDataByName( value.Map ).Image == "" ) then
			if ( file.Exists( "maps/thumb/" .. value.Map .. ".png", "GAME" ) ) then
				self.imageTable[ value.Map ] = 1
			else
				self.imageTable[ value.Map ] = 0
			end
		else
			if ( file.Exists( "materials/" .. LMapvote.map.GetDataByName( value.Map ).Image, "GAME" ) ) then
				self.imageTable[ value.Map ] = 2
			else
				self.imageTable[ value.Map ] = 0
			end
		end
	end
	
	--]]
	
	for key, value in pairs( buffer ) do
		progressPanel = vgui.Create( "DPanel" )
		progressPanel:SetSize( self.LeftMenu:GetWide( ), 100 )
		progressPanel.Paint = function( pnl, w, h )

		--[[
			draw.RoundedBox( 0, 5, h / 2 - 90 / 2, 90, 90, Color( 0, 0, 0, 100 ) )
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			if ( !LMapvote.map.GetDataByName( value.Map ).Image or LMapvote.map.GetDataByName( value.Map ).Image == "" ) then
				surface.SetMaterial( Material( "maps/thumb/" .. value.Map .. ".png" ) )
			else
				surface.SetMaterial( Material( LMapvote.map.GetDataByName( value.Map ).Image ) )
			end
			surface.DrawTexturedRect( 5, h / 2 - 90 / 2, 90, 90 )
			
		--]]
			draw.RoundedBox( 0, 0, 0, 90, h, Color( 0, 0, 0, 100 ) )
			
			if ( self.imageTable[ value.Map ] ) then
				if ( self.imageTable[ value.Map ] == 1 ) then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "maps/thumb/" .. value.Map .. ".png" ) )
					surface.DrawTexturedRect( 0, 0, 90, h )				
				elseif ( self.imageTable[ value.Map ] == 2 ) then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( LMapvote.map.GetDataByName( value.Map ).Image ) )
					surface.DrawTexturedRect( 0, 0, 90, h )			
				elseif ( self.imageTable[ value.Map ] == 0 ) then
					draw.SimpleText( "No map icon :/", "LMapVote_font_04", 90 / 2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			end
			
			if ( key == 1 ) then
				draw.RoundedBox( 0, 0, 0, w, 30, Color( 255, 255, 255, 200 ) )
			end

			draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 10 ) )
			
			if ( key == 1 ) then
				draw.SimpleText( "1st", "LMapVote_font_02", 15, 15, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
			draw.SimpleText( value.Map, "LMapVote_font_02", 15 + 90, 15, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( value.Count .. " players voted", "LMapVote_font_03", self.LeftMenu:GetWide( ) - 15, 15, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		end
				
		progressPanel.players = vgui.Create( "DPanelList", progressPanel )
		progressPanel.players:SetPos( 15 + 90, 40 )
		progressPanel.players:SetSize( progressPanel:GetWide( ) - ( 30 + 90 ), 50 )
		progressPanel.players:SetSpacing( 2 )
		progressPanel.players:EnableHorizontal( true )
		progressPanel.players:EnableVerticalScrollbar( false )		
		progressPanel.players.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 10 ) )
		end
				
		for key2, value2 in pairs( value.Voter ) do
			local avatar = vgui.Create( "AvatarImage" )
			avatar:SetPos( 0, 0 )
			avatar:SetSize( 30, 30 )
			avatar:SetPlayer( LMapvote.kernel.FindPlayerByName( value2 ), 64 )
			avatar:SetToolTip( value2 )
					
			progressPanel.players:AddItem( avatar )
		end
	
		self.LeftMenu:AddItem( progressPanel )
	end
end

function VOTEPANEL:Refresh_MapList( )
	self.CenterMenu:Clear( )
	
	local imageTable = { }
	
	for key, value in pairs( LMapvote.system.vote.coreTable[ "MapList" ] ) do
		if ( !value.Image or value.Image == "" ) then
			if ( file.Exists( "maps/thumb/" .. value.Name .. ".png", "GAME" ) ) then
				imageTable[ value.Name ] = 1
			else
				imageTable[ value.Name ] = 0
			end
		else
			if ( file.Exists( "materials/" .. value.Image, "GAME" ) ) then
				imageTable[ value.Name ] = 2
			else
				imageTable[ value.Name ] = 0
			end
		end
	end
	
	
	for key, value in pairs( LMapvote.system.vote.coreTable[ "MapList" ] ) do
		local map = vgui.Create( "DButton" )
		map:SetText( "" )
		map:SetSize( 150, 150 )
		map.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
			
			if ( imageTable[ value.Name ] ) then
				if ( imageTable[ value.Name ] == 1 ) then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "maps/thumb/" .. value.Name .. ".png" ) )
					surface.DrawTexturedRect( 0, 0, w, h )				
				elseif ( imageTable[ value.Name ] == 2 ) then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( value.Image ) )
					surface.DrawTexturedRect( 0, 0, w, h )			
				elseif ( imageTable[ value.Name ] == 0 ) then
					draw.SimpleText( "No map icon :/", "LMapVote_font_04", w / 2, h / 2 - ( 20 / 2 ), Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			end

			draw.RoundedBox( 0, 0, h - 30, w, 30, Color( 0, 0, 0, 100 ) )			
			draw.SimpleText( value.Name, "LMapVote_font_02", w / 2, h - ( 30 / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		map.DoClick = function( )
			LMapvote.PlayButtonSound( )
			LMapvote.system.vote.Vote( LocalPlayer( ), value.Name )
			timer.Simple( 0.3, function( )
				self.percent_count = 0
				for key, value in pairs( LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] ) do
					if ( #value.Voter != 0 ) then
						self.percent_count = self.percent_count + 1
					end
				end
			end )
		end

		self.CenterMenu:AddItem( map )
	end
end

function VOTEPANEL:Refresh_Chat( keys )

	if ( keys == 1 ) then
		for key, value in pairs( LMapvote.system.vote.coreTable[ "Chat" ] ) do
			if ( key == #LMapvote.system.vote.coreTable[ "Chat" ] ) then
				local chats = vgui.Create( "DPanel" )
				chats:SetSize( self.Chat:GetWide( ), 20 )
				chats.Paint = function( pnl, w, h )
					draw.SimpleText( value.caller:Name( ) .. " : " .. value.text, "LMapVote_font_04", 25, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				local avatar = vgui.Create( "AvatarImage", chats )
				avatar:SetPos( 0, 0 )
				avatar:SetSize( 20, 20 )
				avatar:SetPlayer( LMapvote.kernel.FindPlayerByName( value.caller:Name( ) ), 64 )
				
				self.Chat:AddItem( chats )
				timer.Simple( 0.1, function( )
					self.Chat.VBar:SetScroll( #LMapvote.system.vote.coreTable[ "Chat" ] * 50 )
				end )
			end
		end
	else
		self.Chat:Clear( )
		for key, value in pairs( LMapvote.system.vote.coreTable[ "Chat" ] ) do
			local chats = vgui.Create( "DPanel" )
			chats:SetSize( self.Chat:GetWide( ), 20 )
			chats.Paint = function( pnl, w, h )
				draw.SimpleText( value.caller:Name( ) .. " : " .. value.text, "LMapVote_font_04", 25, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
				
			local avatar = vgui.Create( "AvatarImage", chats )
			avatar:SetPos( 0, 0 )
			avatar:SetSize( 20, 20 )
			avatar:SetPlayer( LMapvote.kernel.FindPlayerByName( value.caller:Name( ) ), 64 )
				
			self.Chat:AddItem( chats )
			
			if ( key == #LMapvote.system.vote.coreTable[ "Chat" ] ) then
				timer.Simple( 0.3, function( )
					self.Chat.VBar:SetScroll( #LMapvote.system.vote.coreTable[ "Chat" ] * 50 )
				end )
			end
		end
	end
end

vgui.Register( "LMapVote_VOTE", VOTEPANEL, "Panel" )