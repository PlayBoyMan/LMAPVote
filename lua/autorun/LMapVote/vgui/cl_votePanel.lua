--[[
	LMAPVote - Development Version 0.5a
		Copyright ( C ) 2014 ~ L7D
--]]


--[[
	- LMapvote.GeneratePolyBarTII(x,y, width, height, mod) function source -
	https://github.com/BlackVoid/deathrun/blob/master/gamemode/vgui/polygenerator.lua
	
	Author : https://github.com/BlackVoid
	Thanks 'BlackVoid', i like you.
--]]
function LMapvote.GeneratePolyBarTII( x, y, width, height, mod )
	mod = mod or 15
	Poly = { }

	Poly[1] = { }
	Poly[1]["x"] = x
	Poly[1]["y"] = y
	Poly[1]["u"] = 1
	Poly[1]["v"] = 1

	Poly[2] = { }
	Poly[2]["x"] = x+width+mod
	Poly[2]["y"] = y
	Poly[2]["u"] = 1
	Poly[2]["v"] = 1

	Poly[3] = { }
	Poly[3]["x"] = x+width
	Poly[3]["y"] = y+height
	Poly[3]["u"] = 1
	Poly[3]["v"] = 1

	Poly[4] = { }
	Poly[4]["x"] = x+mod
	Poly[4]["y"] = y+height
	Poly[4]["u"] = 1
	Poly[4]["v"] = 1

	return Poly
end

--[[
	- LMapvote.DrawCircle(originX,originY,radius,thick,startAng,distAng,iter) function source -
	: Night-Eagle's circle drawing library
	: 1.1
	: https://code.google.com/p/wintersurvival/source/browse/trunk/gamemode/cl_circle.lua?r=154
--]]
function LMapvote.DrawCircle(originX,originY,radius,thick,startAng,distAng,iter)
        startAng = math.rad(startAng)
        distAng = math.rad(distAng)
        if (not iter) or iter <= 1 then
                iter = 8
        else
                iter = math.Round(iter)
        end
        
        local stepAng = math.abs(distAng)/iter
        
        if thick then //The circle is hollow (Outline)
                if distAng > 0 then
                        for i = 0, iter-1 do
                                local eradius = radius + thick
                                local cur1 = stepAng*i+startAng
                                local cur2 = cur1+stepAng
                                local points = {
                                        {
                                                x=math.cos(cur2)*radius+originX,
                                                y=-math.sin(cur2)*radius+originY,
                                                u=0,
                                                v=0,
                                        },
                                        {
                                                x=math.cos(cur2)*eradius+originX,
                                                y=-math.sin(cur2)*eradius+originY,
                                                u=1,
                                                v=0,
                                        },
                                        {
                                                x=math.cos(cur1)*eradius+originX,
                                                y=-math.sin(cur1)*eradius+originY,
                                                u=1,
                                                v=1,
                                        },
                                        {
                                                x=math.cos(cur1)*radius+originX,
                                                y=-math.sin(cur1)*radius+originY,
                                                u=0,
                                                v=1,
                                        },
                                }
                                
                                surface.DrawPoly(points)
                        end
                else
                        for i = 0, iter-1 do
                                local eradius = radius + thick
                                local cur1 = stepAng*i+startAng
                                local cur2 = cur1+stepAng
                                local points = {
                                        {
                                                x=math.cos(cur1)*radius+originX,
                                                y=math.sin(cur1)*radius+originY,
                                                u=0,
                                                v=0,
                                        },
                                        {
                                                x=math.cos(cur1)*eradius+originX,
                                                y=math.sin(cur1)*eradius+originY,
                                                u=1,
                                                v=0,
                                        },
                                        {
                                                x=math.cos(cur2)*eradius+originX,
                                                y=math.sin(cur2)*eradius+originY,
                                                u=1,
                                                v=1,
                                        },
                                        {
                                                x=math.cos(cur2)*radius+originX,
                                                y=math.sin(cur2)*radius+originY,
                                                u=0,
                                                v=1,
                                        },
                                }
                                
                                surface.DrawPoly(points)
                        end
                end
        else
                if distAng > 0 then
                        local points = { }
                        
                        if math.abs(distAng) < 360 then
                                points[1] = {
                                        x = originX,
                                        y = originY,
                                        u = .5,
                                        v = .5,
                                }
                                iter = iter + 1
                        end
                        
                        for i = iter-1,0,-1 do
                                local cur1 = stepAng*i+startAng
                                local cur2 = cur1+stepAng
                                table.insert(points,{
                                        x=math.cos(cur1)*radius+originX,
                                        y=-math.sin(cur1)*radius+originY,
                                        u=(1+math.cos(cur1))/2,
                                        v=(1+math.sin(-cur1))/2,
                                })
                        end
                        
                        surface.DrawPoly(points)
                else
                        local points = { }
                        
                        if math.abs(distAng) < 360 then
                                points[1] = {
                                        x = originX,
                                        y = originY,
                                        u = .5,
                                        v = .5,
                                }
                                iter = iter + 1
                        end
                        
                        for i = 0,iter-1 do
                                local cur1 = stepAng*i+startAng
                                local cur2 = cur1+stepAng
                                table.insert(points,{
                                        x=math.cos(cur1)*radius+originX,
                                        y=math.sin(cur1)*radius+originY,
                                        u=(1+math.cos(cur1))/2,
                                        v=(1+math.sin(cur1))/2,
                                })
                        end
                        
                        surface.DrawPoly(points)
                end
        end
end

local VOTEPANEL = { }

function VOTEPANEL:Init( )
	self.w = ScrW( )
	self.h = ScrH( )
	self.x = ScrW( ) / 2 - self.w / 2
	self.y = ScrH( ) / 2 - self.h / 2

	self.ProgressTab = { }
	self.Type = 1
	
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
	
	self.Frame = vgui.Create( "DFrame" )
	self.Frame:SetSize( self.w, self.h )
	self.Frame:SetPos( self.x, self.y )
	self.Frame:SetTitle( "" )
	self.Frame:ShowCloseButton( false )
	self.Frame:MakePopup( )
	self.Frame:Center( )
	self.Frame.Paint = function( pnl, w, h )
		percent = self.percent_count / #player.GetAll( )
		timePercent = GetGlobalInt( "LMapvote.system.vote.Timer" ) / tonumber( GetConVarString( "LMAPVote_VoteTime" ) )
		
		timePercentBoxAni = Lerp( 0.05, timePercentBoxAni, timePercent * ( w * 0.6 ) )
		
		percentAni = Lerp( 0.05, percentAni, percent * 100 )
		percentBoxAni = Lerp( 0.03, percentBoxAni, percent * 360 )
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )

		if ( self.Type == 1 ) then
			draw.RoundedBox( 0, 15, h * 0.5 + 65, w * 0.2 - 15, h * 0.35, Color( 10, 10, 10, 8 ) )
			
			local timer01 = LMapvote.GeneratePolyBarTII( w * 0.2, 20, w * 0.6, 10 )
			local timer02 = LMapvote.GeneratePolyBarTII( w * 0.2, 20, timePercentBoxAni, 10 )

			draw.NoTexture( )
			surface.SetDrawColor( 10, 10, 10, 30 )			
			surface.DrawPoly( timer01 )
				
			draw.NoTexture( )
			surface.SetDrawColor( 0, 0, 0, 200 )			
			surface.DrawPoly( timer02 )
			
			draw.NoTexture( )
			surface.SetDrawColor( 0, 0, 0, 255 )
			LMapvote.DrawCircle( ( 15 + w * 0.2 - 15 ) / 2, ( h * 0.5 + 65 ) + ( h * 0.35 ) / 2, 80, 8, 90, percentBoxAni, 100)
			
			draw.NoTexture( )
			surface.SetDrawColor( 0, 0, 0, 255 )
			LMapvote.DrawCircle( ( 15 + w * 0.2 - 15 ) / 2, ( h * 0.5 + 65 ) + ( h * 0.35 ) / 2, 80, 2, 90, 360, 100)

			draw.SimpleText( "Vote Percent", "LMapVote_font_03", ( 15 + w * 0.2 - 15 ) / 2, ( h * 0.5 + 65 ) + ( h * 0.35 ) / 2 - 120, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( math.Round( percentAni ) .. " %", "LMapVote_font_01", ( 15 + w * 0.2 - 15 ) / 2, ( h * 0.5 + 65 ) + ( h * 0.35 ) / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			draw.SimpleText( "LMAPVote", "LMapVote_font_01", 15, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Copyright ( C ) 2014 ~ L7D", "LMapVote_font_05", 15, h - 40, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Version - " .. LMapvote.config.Version, "LMapVote_font_05", 15, h - 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( GetGlobalInt( "LMapvote.system.vote.Timer" ), "LMapVote_font_03", w * 0.2 - 30, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		else
			self.LeftMenu:SetVisible( false )
			self.CenterMenu:SetVisible( false )
			self.Chat:SetVisible( false )
			self.ChatEntry:SetVisible( false )
			self.ChatRun:SetVisible( false )
			
			draw.SimpleText( "LMAPVote", "LMapVote_font_01", 15, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Copyright ( C ) 2014 ~ L7D", "LMapVote_font_05", 15, h - 40, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Version - " .. LMapvote.config.Version, "LMapVote_font_05", 15, h - 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			draw.SimpleText( "Vote Finished", "LMapVote_font_01", w / 2, 40, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			
			if ( LMapvote.system.vote.result ) then
				if ( LMapvote.system.vote.result.Won ) then
					local data = LMapvote.map.GetDataByName( LMapvote.system.vote.result.Won )
					
					draw.RoundedBox( 0, w / 2 - 100 / 2, h * 0.4, 100, 100, Color( 0, 0, 0, 100 ) )
					
					surface.SetDrawColor( 255, 255, 255, 255 )
					if ( !data.Image or data.Image == "" ) then
						surface.SetMaterial( Material( "LMAPVote/unknown.jpg" ) )
					else
						surface.SetMaterial( Material( data.Image ) )
					end
					surface.DrawTexturedRect( w / 2 - 100 / 2, h * 0.4, 100, 100 )
					
					draw.SimpleText( data.Name, "LMapVote_font_01", w / 2, h * 0.6, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					if ( LMapvote.system.vote.result.Count ) then
						
						draw.SimpleText( LMapvote.system.vote.result.Count .. " players voted.", "LMapVote_font_03", w / 2, h * 0.6 + 40, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
				end
			end
		end
	end

	self.LeftMenu = vgui.Create( "DPanelList", self.Frame )
	self.LeftMenu:SetPos( 15, 50 )
	self.LeftMenu:SetSize( self.w * 0.3 - 15, self.h * 0.5 )
	self.LeftMenu:SetSpacing( 10 )
	self.LeftMenu:EnableHorizontal( false )
	self.LeftMenu:EnableVerticalScrollbar( true )		
	self.LeftMenu.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	self.CenterMenu = vgui.Create( "DPanelList", self.Frame )
	self.CenterMenu:SetPos( self.w * 0.3 + 15, 50 )
	self.CenterMenu:SetSize( self.w - ( self.w * 0.3 + 30 ), self.h * 0.5 )
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
		
	for key, value in pairs( LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] ) do
		buffer[ #buffer + 1 ] = { Voter = value.Voter, Map = key, Count = value.Count }
	end
		
	table.sort( buffer, function( a, b )
		return a.Count > b.Count
	end )
	
	local buffer2 = { }
	
	for i = 1, #buffer do
		buffer2[ buffer[ i ].Map ] = { Voter = buffer[ i ].Voter, Count = buffer[ i ].Count }
	end
		
	LMapvote.system.vote.coreTable[ "Core" ][ "Vote" ] = buffer2
	
	for key, value in pairs( buffer ) do
		progressPanel = vgui.Create( "DPanel" )
		progressPanel:SetSize( self.LeftMenu:GetWide( ), 100 )
		progressPanel.Paint = function( pnl, w, h )

			draw.RoundedBox( 0, 5, h / 2 - 90 / 2, 90, 90, Color( 0, 0, 0, 100 ) )
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			if ( !LMapvote.map.GetDataByName( value.Map ).Image or LMapvote.map.GetDataByName( value.Map ).Image == "" ) then
				surface.SetMaterial( Material( "LMAPVote/unknown.jpg" ) )
			else
				surface.SetMaterial( Material( LMapvote.map.GetDataByName( value.Map ).Image ) )
			end
			surface.DrawTexturedRect( 5, h / 2 - 90 / 2, 90, 90 )
			
			if ( key == 1 ) then
				draw.RoundedBox( 0, 0, 0, w, 30, Color( 255, 255, 255, 100 ) )
				
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
		progressPanel.players:SetSpacing( 10 )
		progressPanel.players:EnableHorizontal( true )
		progressPanel.players:EnableVerticalScrollbar( false )		
		progressPanel.players.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 15 ) )
		end
				
		for key2, value2 in pairs( value.Voter ) do
				
			local panel = vgui.Create( "DPanel", progressPanel.players )
			panel:SetSize( 50, 50 )
			panel.Paint = function( pnl, w, h )

			end
					
			local avatar = vgui.Create( "AvatarImage", panel )
			avatar:SetPos( 0, 0 )
			avatar:SetSize( 50, 50 )
			avatar:SetPlayer( LMapvote.kernel.FindPlayerByName( value2 ), 64 )
					
			progressPanel.players:AddItem( panel )
		end
	
		self.LeftMenu:AddItem( progressPanel )
	end
end

function VOTEPANEL:Refresh_MapList( )
	self.CenterMenu:Clear( )
	for key, value in pairs( LMapvote.system.vote.coreTable[ "MapList" ] ) do
		local map = vgui.Create( "DButton" )
		map:SetText( "" )
		map:SetSize( 150, 150 )
		map.Paint = function( pnl, w, h )
		
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			if ( !value.Image or value.Image == "" ) then
				surface.SetMaterial( Material( "LMAPVote/unknown.jpg" ) )
			else
				surface.SetMaterial( Material( value.Image ) )
			end
			surface.DrawTexturedRect( 0, 0, w, h )

			draw.RoundedBox( 0, 0, h - 30, w, 30, Color( 255, 255, 255, 100 ) )			
			
			draw.SimpleText( value.Name, "LMapVote_font_02", w / 2, h - ( 30 / 2 ), Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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