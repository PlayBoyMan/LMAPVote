--[[
	LMAPVote - 1.4
	Copyright ( C ) 2014 ~ L7D
--]]

local VOTEPANEL = { }

function VOTEPANEL:Init( )
	self.w = ScrW( ) * 0.85
	self.h = ScrH( ) * 0.85
	self.x = ScrW( ) / 2 - self.w / 2
	self.y = ScrH( ) / 2 - self.h / 2

	self.ProgressTab = { }
	self.Type = 1
	self.imageTable = { }
	self.imageTablebuffer = { }
	self.FirstChatEntryClicked = false
	
	if ( self.Frame and self.BackPanel ) then
		self.Frame:Remove( )
		self.Frame = nil
		self.BackPanel:Remove( )
		self.BackPanel = nil
	end

	self.VoicePressed01 = false
	self.blur = Material( "pp/blurscreen" )
	self.screenBL = 1
	self.screenblur = 0
	self.VoteEndTimePercent = 0
	self.VoteEndTimePercent_Ani = 0
	
	self:Setup( )

	self.BackPanel = vgui.Create( "DPanel" )
	self.BackPanel:SetSize( ScrW( ), ScrH( ) )
	self.BackPanel:MakePopup( )
	self.BackPanel:Center( )
	self.BackPanel.Paint = function( pnl, w, h )
		// A code by Nutscript -- https://github.com/Chessnut/NutScript/blob/master/gamemode/derma/cl_charmenu.lua
		pnl:MoveToBack( )
		
		local x, y = pnl:LocalToScreen( 0, 0 )

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( self.blur )

		if ( self.screenblur <= LMapvote.config.VotePanel_BlurEffect_ammount ) then
			self.screenblur = self.screenblur + 0.01
		end
		
		for i = 1, 3 do
			self.blur:SetFloat( "$blur", ( i / 3 ) * self.screenblur )
			self.blur:Recompute( )

			render.UpdateScreenEffectTexture( )
			surface.DrawTexturedRect( x * -1, y * -1, w, h )
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
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )

		draw.SimpleText( "LMAPVote", "LMapVote_font_01", 15, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Copyright ( C ) 2014 ~ L7D", "LMapVote_font_05", 15, h - 40, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Version - " .. LMapvote.config.Version, "LMapVote_font_05", 15, h - 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		if ( self.Type == 1 ) then
			self.VoteEndTimePercent = GetGlobalInt( "LMapvote.system.vote.Timer" ) / LMapvote.config.VoteTime
			self.VoteEndTimePercent_Ani = Lerp( 0.03, self.VoteEndTimePercent_Ani, self.VoteEndTimePercent * 360 )
			
			draw.NoTexture( )
			if ( GetGlobalInt( "LMapvote.system.vote.Timer" ) <= 10 ) then
				surface.SetDrawColor( 255, 150, 150, 255 )
			else
				surface.SetDrawColor( 0, 0, 0, 255 )
			end
			LMapvote.geometry.DrawCircle( w - 30, 25, 10, 3, 90, self.VoteEndTimePercent_Ani, 100 )
		else
			self.RightMenu:SetVisible( false )
			self.LeftMenu:SetVisible( false )
			self.Chat:SetVisible( false )
			self.ChatEntry:SetVisible( false )
			self.ChatRun:SetVisible( false )
			self.VoiceMenu:SetVisible( false )
			self.Voice:SetVisible( false )
			
			surface.SetDrawColor( 10, 10, 10, 8 )
			surface.SetMaterial( Material( "gui/center_gradient" ) )
			surface.DrawTexturedRect( w / 2 - ( w / 2 ) / 2, 0, w / 2, 50 )
			
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

	self.RightMenu = vgui.Create( "DPanelList", self.Frame )
	self.RightMenu:SetPos( ( 15 + self.w * 0.13 ) + 15, 50 )
	self.RightMenu:SetSize( self.w * 0.55 - 30, self.h * 0.6 )
	self.RightMenu:SetSpacing( 5 )
	self.RightMenu:EnableHorizontal( false )
	self.RightMenu:EnableVerticalScrollbar( true )		
	self.RightMenu.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	self.LeftMenu = vgui.Create( "DPanelList", self.Frame )
	self.LeftMenu:SetPos( 15, 50 )
	self.LeftMenu:SetSize( self.w * 0.13, self.h - 110 )
	self.LeftMenu:SetSpacing( 10 )
	self.LeftMenu:EnableHorizontal( true )
	self.LeftMenu:EnableVerticalScrollbar( true )		
	self.LeftMenu.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	self.VoiceMenu = vgui.Create( "DPanelList", self.Frame )
	self.VoiceMenu:SetPos( self.w - ( self.w * 0.3 ) - 15, 50 )
	self.VoiceMenu:SetSize( self.w * 0.3, self.h * 0.6 )
	self.VoiceMenu:SetSpacing( 10 )
	self.VoiceMenu:EnableHorizontal( true )
	self.VoiceMenu:EnableVerticalScrollbar( true )		
	self.VoiceMenu.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end

	self.Chat = vgui.Create( "DPanelList", self.Frame )
	self.Chat:SetPos( 30 + self.w * 0.13, self.h * 0.6 + 65 )
	self.Chat:SetSize( self.w * 0.85 - 20, self.h * 0.4 - 125 )
	self.Chat:SetSpacing( 2 )
	self.Chat:EnableHorizontal( false )
	self.Chat:EnableVerticalScrollbar( true )		
	self.Chat.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	self.ChatRun = vgui.Create( "DButton", self.Frame )
	self.ChatRun:SetSize( self.w * 0.1, 40 )
	self.ChatRun:SetPos( self.w - ( self.w * 0.25 ) - 30, self.h * 0.9 + 30 )
	self.ChatRun:SetFont( "LMapVote_font_03" )
	self.ChatRun:SetText( "Chat Send" )
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
	
	self.Voice = vgui.Create( "DButton", self.Frame )
	self.Voice:SetSize( self.w * 0.15, 40 )
	self.Voice:SetPos( self.w - ( self.w * 0.15 ) - 15, self.h * 0.9 + 30 )
	self.Voice:SetFont( "LMapVote_font_03" )
	self.Voice:SetText( "Voice Chat Start" )
	self.Voice.OnceRun = false
	self.Voice.Running = false
	self.Voice.Rotate = 0
	self.Voice.Rotate_Ani = 0
	self.Voice.OnCursorEntered = function( )
		RunConsoleCommand( "+voicerecord" )
		self.Voice.OnceRun = false
		self.Voice.Running = true
	end
	self.Voice.OnCursorExited = function( )
		if ( !self.Voice.OnceRun ) then
			RunConsoleCommand( "-voicerecord" )
			self.Voice.OnceRun = true
			self.Voice.Running = false
		end
	end
	self.Voice:SetColor( Color( 0, 0, 0, 255 ) )
	self.Voice.Paint = function( pnl, w, h )
		if ( self.Voice.Running ) then
			if ( self.Voice.Rotate_Ani == 0 and self.Voice.Rotate <= 360 ) then
				self.Voice.Rotate = self.Voice.Rotate + 5
				if ( self.Voice.Rotate_Ani == 0 and self.Voice.Rotate >= 360 ) then
					self.Voice.Rotate_Ani = 1
				end
			end
			if ( self.Voice.Rotate_Ani == 1 ) then
				self.Voice.Rotate = self.Voice.Rotate - 1
				if ( self.Voice.Rotate <= 0 ) then
					self.Voice.Rotate_Ani = 0
				end
			end
			
			draw.NoTexture( )
			surface.SetDrawColor( 255, 0, 0, 255 )
			LMapvote.geometry.DrawCircle( 30, h / 2, 8, 3, 10, self.Voice.Rotate, 360, 10 )
			draw.SimpleText( "Recording ...", "LMapVote_font_03", w * 0.35, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			self.Voice:SetText( "" )
		else
			self.Voice:SetText( "Voice Chat Start" )
		end
		draw.RoundedBox( 0, 0, 0, w, 1, Color( 255, 150, 150, 255 ) )
		draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 255, 150, 150, 255 ) )
		draw.RoundedBox( 0, 0, 0, 1, h, Color( 255, 150, 150, 255 ) )
		draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 255, 150, 150, 255 ) )
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	self.ChatEntry = vgui.Create( "DTextEntry", self.Frame )
	self.ChatEntry:SetPos( 30 + self.w * 0.13, self.h * 0.9 + 30 )
	self.ChatEntry:SetSize( self.w * 0.6 - 45, 40 )	
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

hook.Add( "RenderScreenspaceEffects", "LMapvote.system.RenderScreenspaceEffects", function( )
	if ( !LMapvote.config.VotePanel_MonochromeEffect ) then
		return
	end
	if ( !votePanel ) then
		return
	end
	if ( !votePanel.Frame or !votePanel.BackPanel ) then
		local s = votePanel.screenBL
		votePanel.screenBL = Lerp( 0.03, s, 1 )
		
		if ( s >= 1 ) then
			hook.Remove( "RenderScreenspaceEffects", "LMapvote.system.RenderScreenspaceEffects" )
		end
	else
		local s = votePanel.screenBL
		votePanel.screenBL = Lerp( 0.01, s, 0 )
	end
	
	local colorData = {}
	colorData["$pp_colour_addr"] = 0
	colorData["$pp_colour_addg"] = 0
	colorData["$pp_colour_addb"] = 0
	colorData["$pp_colour_brightness"] = 0
	colorData["$pp_colour_contrast"] = 1
	colorData["$pp_colour_colour"] = votePanel.screenBL
	colorData["$pp_colour_mulr"] = 0
	colorData["$pp_colour_mulg"] = 0
	colorData["$pp_colour_mulb"] = 0
	
	DrawColorModify(colorData)
end )

function VOTEPANEL:Setup( )
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
end

function VOTEPANEL:Result_Send( )
	surface.PlaySound( LMapvote.config.VoteResult_Sound )
	self.Type = 2
	timer.Simple( 5, function( )
		self:Result_Receive( )
	end )
end

function VOTEPANEL:Result_Receive( )
	netstream.Start( "LMapvote.system.vote.ResultReceive", 1 )
end

function VOTEPANEL:Refresh_Voice( )
	self.VoiceMenu:Clear( )
	
	local voiceTable = { }
	
	for key, value in pairs( LMapvote.system.vote.coreTable[ "Voice" ] ) do
		voiceTable[ value ] = { Volume = 0 }
		local voice = vgui.Create( "DPanel" )
		voice:SetSize( self.VoiceMenu:GetWide( ), 50 )
		voice.Paint = function( pnl, w, h )
			voiceTable[ value ].Volume = Lerp( 0.03, voiceTable[ value ].Volume, value:VoiceVolume( ) * h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 10 ) )
			draw.RoundedBox( 0, w - 10, h - voiceTable[ value ].Volume, 10, voiceTable[ value ].Volume, Color( 0, 0, 0, 255 ) )
			draw.SimpleText( value:Name( ), "LMapVote_font_04", voice:GetTall( ) + 15, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		
		local avatar = vgui.Create( "AvatarImage", voice )
		avatar:SetPos( 0, 0 )
		avatar:SetSize( voice:GetTall( ), voice:GetTall( ) )
		avatar:SetPlayer( value, 64 )
		avatar:SetToolTip( value:SteamID() )
	
		self.VoiceMenu:AddItem( voice )
	end
end

function VOTEPANEL:Refresh_Progress( )
	self.RightMenu:Clear( )
	
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

	for key, value in pairs( buffer ) do
		progressPanel = vgui.Create( "DPanel" )
		progressPanel:SetSize( self.RightMenu:GetWide( ), 100 )
		progressPanel.Paint = function( pnl, w, h )
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
			draw.SimpleText( value.Count .. " players voted", "LMapVote_font_03", self.RightMenu:GetWide( ) - 15, 15, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
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
	
		self.RightMenu:AddItem( progressPanel )
	end
end

function VOTEPANEL:Refresh_MapList( )
	self.LeftMenu:Clear( )
	
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
		map:SetSize( self.w * 0.13, self.w * 0.13 )
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

		self.LeftMenu:AddItem( map )
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

hook.Add( "PlayerStartVoice", "LMapvote.system.PlayerStartVoice", function( pl )
	LMapvote.system.vote.Sync( LMAPVOTE_SYNC_ENUM__VOICEONLY, { Ent = pl, Bool = true } )
end )

hook.Add( "PlayerEndVoice", "LMapvote.system.PlayerEndVoice", function( pl )
	LMapvote.system.vote.Sync( LMAPVOTE_SYNC_ENUM__VOICEONLY, { Ent = pl, Bool = false } )
end )