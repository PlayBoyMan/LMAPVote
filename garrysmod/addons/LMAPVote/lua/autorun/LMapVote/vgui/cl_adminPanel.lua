--[[
	LMAPVote - 1.1
	Copyright ( C ) 2014 ~ L7D
--]]

concommand.Add( "LMAPVote_admin", function( pl )
	if ( LMapvote.config.HavePermission( pl ) ) then
		if ( !adminPanel ) then
			adminPanel = vgui.Create( "LMapVote_ADMIN" )
		else
			if ( adminPanel.Frame ) then
				adminPanel.Frame:Remove( )
				adminPanel.Frame = nil
			end
			adminPanel = vgui.Create( "LMapVote_ADMIN" )
		end
	end
end )

local ADMINPANEL = { }

function ADMINPANEL:Init( )
	self.w = ScrW( )
	self.h = ScrH( )
	self.x = ScrW( ) / 2 - self.w / 2
	self.y = ScrH( ) / 2 - self.h / 2

	if ( self.Frame ) then
		self.Frame:Remove( )
		self.Frame = nil
	end
	
	if ( !LMapvote.config.HavePermission( LocalPlayer( ) ) ) then
		return
	end

	self.UpdateCheckDeleayed = false
	
	self.Frame = vgui.Create( "DFrame" )
	self.Frame:SetSize( self.w, self.h )
	self.Frame:SetPos( self.x, self.y )
	self.Frame:SetTitle( "" )
	self.Frame:ShowCloseButton( false )
	self.Frame:MakePopup( )
	self.Frame:Center( )
	self.Frame.Paint = function( pnl, w, h )
		if ( !LMapvote.config.HavePermission( LocalPlayer( ) ) ) then
			if ( self.Frame and IsValid( self.Frame ) ) then
				self.Frame:Remove( )
				self.Frame = nil
				return
			end
		end
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )

		draw.SimpleText( "LMAPVote Administrator", "LMapVote_font_01", 13, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Welcome " .. LocalPlayer( ):Name( ), "LMapVote_font_03", w - 15, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Copyright ( C ) 2014 ~ L7D", "LMapVote_font_05", w - 15, h - 40, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Version - " .. LMapvote.config.Version, "LMapVote_font_05", w - 15, h - 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end
	
	
	self.Frame.Panel01 = vgui.Create( "DPanel", self.Frame )
	
	self.Frame.Panel01.w = self.w / 3 - ( 10 * 3 ) - ( 15 )
	self.Frame.Panel01.h = self.h * 0.4
	self.Frame.Panel01.x = 15
	self.Frame.Panel01.y = 50
	self.Frame.Panel01.ShowType = 1
	self.Frame.Panel01.Light = 235
	
	self.Frame.Panel01:SetSize( self.Frame.Panel01.w, self.Frame.Panel01.h )
	self.Frame.Panel01:SetPos( self.Frame.Panel01.x, self.Frame.Panel01.y )
	self.Frame.Panel01.Paint = function( pnl, w, h )
		local sin = math.sin( CurTime( ) * 8 )
		if ( sin ) then
			self.Frame.Panel01.Light = ( 235 / 1 ) * sin
			if ( self.Frame.Panel01.Light <= 50 ) then
				self.Frame.Panel01.Light = 50
			end
		end
		
		if ( GetGlobalBool( "LMapvote.update.Status", false ) == true ) then
			if ( LMapvote.update.buffer[ "Latest_Version" ] and LMapvote.config.Version ) then
				if ( LMapvote.update.buffer[ "Latest_Version" ] != LMapvote.config.Version ) then
					draw.RoundedBox( 0, 0, 40, w, 1, Color( 215, 150, 150, self.Frame.Panel01.Light ) )
			
					draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 150, 150, self.Frame.Panel01.Light ) )
					draw.RoundedBox( 0, 0, 0, 1, h, Color( 215, 150, 150, self.Frame.Panel01.Light ) )
			
					draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 215, 150, 150, self.Frame.Panel01.Light ) )
					draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 215, 150, 150, self.Frame.Panel01.Light ) )
				else
					draw.RoundedBox( 0, 0, 40, w, 1, Color( 215, 215, 215, 235 ) )
			
					draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 215, 215, 235 ) )
					draw.RoundedBox( 0, 0, 0, 1, h, Color( 215, 215, 215, 235 ) )
					
					draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 215, 215, 215, 235 ) )
					draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 215, 215, 215, 235 ) )
				end
			end
		else
			draw.RoundedBox( 0, 0, 40, w, 1, Color( 215, 215, 215, 235 ) )
			
			draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 215, 215, 235 ) )
			draw.RoundedBox( 0, 0, 0, 1, h, Color( 215, 215, 215, 235 ) )
			
			draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 215, 215, 215, 235 ) )
			draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 215, 215, 215, 235 ) )
		end
		
		if ( self.Frame.Panel01.ShowType == 1 ) then
			draw.SimpleText( "Update Dashboard", "LMapVote_font_03", 15, 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			self.Frame.Panel01.ChangelogMenu:SetVisible( false )	
			if ( LMapvote.update.buffer ) then
				if ( GetGlobalBool( "LMapvote.update.Status", false ) == true ) then
					if ( LMapvote.update.buffer[ "Server_Status" ] ) then
						draw.SimpleText( "Server Status - " .. LMapvote.update.buffer[ "Server_Status" ], "LMapVote_font_02", w / 2, h * 0.3 - 30, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( "Server Status - Offline :(", "LMapVote_font_02", w / 2, h * 0.3 - 30, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
					
					if ( LMapvote.update.buffer[ "Latest_Version" ] ) then
						draw.SimpleText( "Server Latest Version - " .. LMapvote.update.buffer[ "Latest_Version" ] or "Error", "LMapVote_font_03", w / 2, h * 0.3, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
					
					if ( LMapvote.config.Version ) then
						draw.SimpleText( "Your Version - " .. LMapvote.config.Version or "Error", "LMapVote_font_03", w / 2, h * 0.3 + 30, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
					
					if ( LMapvote.update.buffer[ "Latest_Version" ] and LMapvote.config.Version ) then
						if ( LMapvote.update.buffer[ "Latest_Version" ] == LMapvote.config.Version ) then
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.SetMaterial( Material( "icon16/tick.png" ) )
							surface.DrawTexturedRect( w / 2 - w * 0.4, h * 0.6 - 16 / 2, 16, 16 )
							draw.SimpleText( "Your using latest version, thanks.", "LMapVote_font_02", w / 2, h * 0.6, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							self.Frame.Panel01.UpdateLink:SetVisible( false )
							self.Frame.Panel01.CheckUpdate:SetVisible( true )
							self.Frame.Panel01.ShowChangeLog:SetVisible( true )
							self.Frame.Panel01.ShowChangeLog:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 70 )
							self.Frame.Panel01.CheckUpdate:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 35 )
						else
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.SetMaterial( Material( "icon16/error.png" ) )
							surface.DrawTexturedRect( w / 2 - surface.GetTextSize( "You need update." ), h * 0.6 - 16 / 2, 16, 16 )
							draw.SimpleText( "You need update.", "LMapVote_font_02", w / 2, h * 0.6, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							self.Frame.Panel01.UpdateLink:SetVisible( true )
							self.Frame.Panel01.CheckUpdate:SetVisible( true )
							self.Frame.Panel01.ShowChangeLog:SetVisible( true )
							self.Frame.Panel01.ShowChangeLog:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 105 )
							self.Frame.Panel01.CheckUpdate:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 70 )
							self.Frame.Panel01.UpdateLink:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 35 )
						end
					end
				else
					draw.SimpleText( "Update system error, 404 Error.", "LMapVote_font_02", w / 2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					self.Frame.Panel01.CheckUpdate:SetVisible( true )
					self.Frame.Panel01.ShowChangeLog:SetVisible( true )
					self.Frame.Panel01.UpdateLink:SetVisible( false )
					self.Frame.Panel01.ShowChangeLog:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 70 )
					self.Frame.Panel01.CheckUpdate:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 35 )
				end
			else
				draw.SimpleText( "Update system error.", "LMapVote_font_02", w / 2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		elseif ( self.Frame.Panel01.ShowType == 2 ) then
			draw.SimpleText( "Changelog", "LMapVote_font_03", 15, 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			self.Frame.Panel01.UpdateLink:SetVisible( false )
			self.Frame.Panel01.CheckUpdate:SetVisible( false )
			self.Frame.Panel01.ChangelogMenu:SetVisible( true )	
		end
	end
	
	self.Frame.Panel01.CheckUpdate = vgui.Create( "DButton", self.Frame.Panel01 )
	self.Frame.Panel01.CheckUpdate:SetSize( self.Frame.Panel01.w - 10, 30 )
	self.Frame.Panel01.CheckUpdate:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 70 )
	self.Frame.Panel01.CheckUpdate:SetFont( "LMapVote_font_03" )
	self.Frame.Panel01.CheckUpdate:SetText( "Check update" )
	self.Frame.Panel01.CheckUpdate:SetColor( Color( 0, 0, 0, 255 ) )
	self.Frame.Panel01.CheckUpdate.Block = false
	self.Frame.Panel01.CheckUpdate.Rotate = 0
	self.Frame.Panel01.CheckUpdate.Status = true
	self.Frame.Panel01.CheckUpdate.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( !self.Frame.Panel01.CheckUpdate.Block ) then
			if ( self.Frame ) then
				self.Frame.Panel01.CheckUpdate.Status = true
				self.UpdateCheckDeleayed = true
				self.Frame.Panel01.CheckUpdate.Block = true
				
			end
			LMapvote.update.Check( )
			timer.Simple( 3, function( )
				if ( self and IsValid( self ) ) then
					self.Frame.Panel01.CheckUpdate.Status = false
				end
			end )
		else
			if ( GetGlobalBool( "LMapvote.update.Status", false ) == false ) then
				if ( self.Frame ) then
					self.Frame.Panel01.CheckUpdate.Status = true
					self.UpdateCheckDeleayed = true
					self.Frame.Panel01.CheckUpdate.Block = true
					
				end
				LMapvote.update.Check( )
				timer.Simple( 3, function( )
					if ( self and IsValid( self ) ) then
						self.Frame.Panel01.CheckUpdate.Status = false
					end
				end )			
			end
		end
	end
	self.Frame.Panel01.CheckUpdate.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
		
		if ( GetGlobalBool( "LMapvote.update.Status", false ) == true ) then
			self.Frame.Panel01.CheckUpdate.Status = true
		end
		
		if ( self.UpdateCheckDeleayed ) then
			if ( self.Frame.Panel01.CheckUpdate.Rotate <= 360 ) then
				self.Frame.Panel01.CheckUpdate.Rotate = self.Frame.Panel01.CheckUpdate.Rotate + 10
			else
				self.Frame.Panel01.CheckUpdate.Rotate = 0
			end
		else
			self.Frame.Panel01.CheckUpdate.Block = false
			if ( self.Frame.Panel01.CheckUpdate.Rotate >= 0 ) then
				self.Frame.Panel01.CheckUpdate.Rotate = self.Frame.Panel01.CheckUpdate.Rotate - 10
			end
			if ( self.Frame.Panel01.CheckUpdate.Rotate <= 0 ) then
				self.Frame.Panel01.CheckUpdate.Rotate = 0
			end
		end
		
		draw.NoTexture( )
		if ( self.Frame.Panel01.CheckUpdate.Status ) then
			surface.SetDrawColor( 0, 0, 0, 255 )
		else
			surface.SetDrawColor( 255, 0, 0, 255 )
			LMapvote.geometry.DrawCircle( 30, h / 2, 8, 2, 90, 360, 100 )
			return
		end
		LMapvote.geometry.DrawCircle( 30, h / 2, 8, 2, 90, self.Frame.Panel01.CheckUpdate.Rotate, 100 )
	end
	
	self.Frame.Panel01.UpdateLink = vgui.Create( "DButton", self.Frame.Panel01 )
	self.Frame.Panel01.UpdateLink:SetSize( self.Frame.Panel01.w - 10, 30 )
	self.Frame.Panel01.UpdateLink:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 35 )
	self.Frame.Panel01.UpdateLink:SetFont( "LMapVote_font_03" )
	self.Frame.Panel01.UpdateLink:SetText( "Update link" )
	self.Frame.Panel01.UpdateLink:SetColor( Color( 0, 0, 0, 255 ) )
	self.Frame.Panel01.UpdateLink.DoClick = function( )
		LMapvote.PlayButtonSound( )
		gui.OpenURL( "http://github.com/L7D/LMAPVote" )
	end
	self.Frame.Panel01.UpdateLink.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	self.Frame.Panel01.ShowChangeLog = vgui.Create( "DButton", self.Frame.Panel01 )
	self.Frame.Panel01.ShowChangeLog:SetSize( self.Frame.Panel01.w - 10, 30 )
	self.Frame.Panel01.ShowChangeLog:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 105 )
	self.Frame.Panel01.ShowChangeLog:SetFont( "LMapVote_font_03" )
	self.Frame.Panel01.ShowChangeLog:SetText( "Show changelog" )
	self.Frame.Panel01.ShowChangeLog:SetColor( Color( 0, 0, 0, 255 ) )
	self.Frame.Panel01.ShowChangeLog.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( self.Frame.Panel01.ShowType == 1 ) then
			self.Frame.Panel01.ShowType = 2
			self.Frame.Panel01.ShowChangeLog:SetText( "<" )
			self.Frame.Panel01.ShowChangeLog:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 35 )
			self:Refresh_Changelog( )
		elseif ( self.Frame.Panel01.ShowType == 2 ) then
			self.Frame.Panel01.ShowType = 1
			self.Frame.Panel01.ShowChangeLog:SetText( "Show changelog" )
		end
	end
	self.Frame.Panel01.ShowChangeLog.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	self.Frame.Panel01.ChangelogMenu = vgui.Create( "DPanelList", self.Frame.Panel01 )
	self.Frame.Panel01.ChangelogMenu:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, 45 )
	self.Frame.Panel01.ChangelogMenu:SetSize( self.Frame.Panel01.w - 10, self.Frame.Panel01.h - ( 45 + 40 ) )
	self.Frame.Panel01.ChangelogMenu:SetSpacing( 0 )
	self.Frame.Panel01.ChangelogMenu:EnableHorizontal( false )
	self.Frame.Panel01.ChangelogMenu:EnableVerticalScrollbar( true )	
	self.Frame.Panel01.ChangelogMenu:SetVisible( false )
	self.Frame.Panel01.ChangelogMenu.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	
	self.Frame.Panel02 = vgui.Create( "DPanel", self.Frame )
	
	self.Frame.Panel02.w = self.w / 3 - ( 10 * 3 ) - ( 15 )
	self.Frame.Panel02.h = self.h * 0.4
	self.Frame.Panel02.x = self.w * 0.5 - self.Frame.Panel02.w / 2
	self.Frame.Panel02.y = 50
	
	self.Frame.Panel02:SetSize( self.Frame.Panel02.w, self.Frame.Panel02.h )
	self.Frame.Panel02:SetPos( self.Frame.Panel02.x, self.Frame.Panel02.y )
	self.Frame.Panel02.Paint = function( pnl, w, h )
	
		draw.RoundedBox( 0, 0, 40, w, 1, Color( 215, 215, 215, 235 ) )
		
		draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 215, 215, 235 ) )
		draw.RoundedBox( 0, 0, 0, 1, h, Color( 215, 215, 215, 235 ) )
		
		draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 215, 215, 215, 235 ) )
		draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 215, 215, 215, 235 ) )
		
		draw.SimpleText( "Map List Dashboard", "LMapVote_font_03", 15, 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	self.Frame.Panel02.MaplistMenu = vgui.Create( "DPanelList", self.Frame.Panel02 )
	self.Frame.Panel02.MaplistMenu:SetPos( self.Frame.Panel02.w / 2 - ( self.Frame.Panel02.w - 10 ) / 2, 45 )
	self.Frame.Panel02.MaplistMenu:SetSize( self.Frame.Panel02.w - 10, self.Frame.Panel02.h - 50 )
	self.Frame.Panel02.MaplistMenu:SetSpacing( 5 )
	self.Frame.Panel02.MaplistMenu:EnableHorizontal( true )
	self.Frame.Panel02.MaplistMenu:EnableVerticalScrollbar( false )	
	self.Frame.Panel02.MaplistMenu.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	
	self:Refresh_Maplist( )
	
	
	
	self.Frame.Panel03 = vgui.Create( "DPanel", self.Frame )
	
	self.Frame.Panel03.w = self.w / 3 - ( 10 * 3 ) - ( 15 )
	self.Frame.Panel03.h = self.h * 0.4
	self.Frame.Panel03.x = ( self.w * 0.7 ) - 15
	self.Frame.Panel03.y = 50
	self.Frame.Panel03.ShowType = 1
	
	self.Frame.Panel03:SetSize( self.Frame.Panel03.w, self.Frame.Panel03.h )
	self.Frame.Panel03:SetPos( self.Frame.Panel03.x, self.Frame.Panel03.y )
	self.Frame.Panel03.Paint = function( pnl, w, h )
	
		draw.RoundedBox( 0, 0, 40, w, 1, Color( 215, 215, 215, 235 ) )
		
		draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 215, 215, 235 ) )
		draw.RoundedBox( 0, 0, 0, 1, h, Color( 215, 215, 215, 235 ) )
		
		draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 215, 215, 215, 235 ) )
		draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 215, 215, 215, 235 ) )
		
		draw.SimpleText( "Vote Status Dashboard", "LMapVote_font_03", 15, 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		if ( LMapvote.system.vote.GetStatus( ) == true ) then
			draw.SimpleText( "Vote has currently progressing.", "LMapVote_font_03", w / 2, h * 0.2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( LMapvote.system.vote.GetTimeLeft( ) .. " 3 second after do map vote finished.", "LMapVote_font_03", w / 2, h * 0.4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "Vote has not currently progressing.", "LMapVote_font_03", w / 2, h * 0.2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	
	self.Frame.Panel03.Vote = vgui.Create( "DButton", self.Frame.Panel03 )
	self.Frame.Panel03.Vote:SetSize( self.Frame.Panel03.w - 10, 30 )
	self.Frame.Panel03.Vote:SetPos( self.Frame.Panel03.w / 2 - ( self.Frame.Panel03.w - 10 ) / 2, self.Frame.Panel03.h - 35 )
	self.Frame.Panel03.Vote:SetFont( "LMapVote_font_02" )
	self.Frame.Panel03.Vote:SetText( "Vote Start" )
	self.Frame.Panel03.Vote:SetColor( Color( 0, 0, 0, 255 ) )
	self.Frame.Panel03.Vote.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( LMapvote.system.vote.GetStatus( ) == true ) then
			Derma_Query( "Are you sure stop map vote?", "WARNING",
				"YES", function() 
					RunConsoleCommand( "LMAPVote_vote_stop" )
				end,
				"NO", function()
							
				end
			)
		else
			Derma_Query( "Are you sure start map vote?", "WARNING",
				"YES", function() 
					RunConsoleCommand( "LMAPVote_vote_start" )
					if ( self.Frame and IsValid( self.Frame ) ) then
						self.Frame:Remove( )
						self.Frame = nil
						return
					end
				end,
				"NO", function()
							
				end
			)
		end
	end
	self.Frame.Panel03.Vote.Paint = function( pnl, w, h )
		if ( LMapvote.system.vote.GetStatus( ) == true ) then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 150, 150, 150 ) )
			self.Frame.Panel03.Vote:SetText( "Vote Stop" )
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 150, 255, 150, 150 ) )
			self.Frame.Panel03.Vote:SetText( "Vote Start" )
		end
	end
	
	
	
	self.Frame.Panel04 = vgui.Create( "DPanel", self.Frame )
	
	self.Frame.Panel04.w = self.w / 3 - ( 10 * 3 ) - ( 15 )
	self.Frame.Panel04.h = self.h * 0.4
	self.Frame.Panel04.x = 15
	self.Frame.Panel04.y = self.h * 0.5
	
	self.Frame.Panel04.CS_Status_Rotate = 0
	self.Frame.Panel04.SYNC_Status_Rotate = 0
	
	self.Frame.Panel04:SetSize( self.Frame.Panel04.w, self.Frame.Panel04.h )
	self.Frame.Panel04:SetPos( self.Frame.Panel04.x, self.Frame.Panel04.y )
	self.Frame.Panel04.Paint = function( pnl, w, h )
	
		draw.RoundedBox( 0, 0, 40, w, 1, Color( 215, 215, 215, 235 ) )
		
		draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 215, 215, 235 ) )
		draw.RoundedBox( 0, 0, 0, 1, h, Color( 215, 215, 215, 235 ) )
		
		draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 215, 215, 215, 235 ) )
		draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 215, 215, 215, 235 ) )
		
		draw.SimpleText( "Cloud Server Connection Status", "LMapVote_font_03", 15, 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		local server_status = LMapvote.system.cloud.GetStatus( )
		local server_status_msg = "nil"
		local server_status_col = Color( 255, 0, 0, 255 )
		
		if ( server_status == 0 ) then
			server_status_msg = "Online :)"
			server_status_col = Color( 0, 0, 0, 255 )
		elseif ( server_status == 1 ) then
			server_status_msg = "Connecting ..."
			server_status_col = Color( 0, 0, 0, 255 )			
		elseif ( server_status == 2 ) then
			server_status_msg = "Connection Error :("
			server_status_col = Color( 255, 0, 0, 255 )			
		elseif ( server_status == 3 ) then
			server_status_msg = "Configuration MySQL Error :("
			server_status_col = Color( 255, 0, 0, 255 )			
		elseif ( server_status == 4 ) then
			server_status_msg = "MySQLoo Version is not latest ..."
			server_status_col = Color( 255, 0, 0, 255 )			
		elseif ( server_status == 5 ) then
			server_status_msg = "Stopped by user setting ..."
			server_status_col = Color( 255, 0, 0, 255 )			
		elseif ( server_status == 6 ) then
			server_status_msg = "Getting Cloud server IP by hostname server ..."
			server_status_col = Color( 0, 0, 0, 255 )		
		end
		
		if ( server_status != 1 ) then
			self.Frame.Panel04.StatusChange:SetAlpha( 255 )
			if ( server_status == 0 or server_status == 2 ) then
				self.Frame.Panel04.StatusChange:SetVisible( true )
				self.Frame.Panel04.StatusChange:SetText( "Disconnect to Cloud server" )
			else
				self.Frame.Panel04.StatusChange:SetVisible( true )
				self.Frame.Panel04.StatusChange:SetText( "Connect to Cloud server" )
			end
		else
			self.Frame.Panel04.StatusChange:SetAlpha( 100 )
			self.Frame.Panel04.StatusChange:SetText( "Working ..." )
		end
		
		local sync_status = LMapvote.system.cloud.GetSyncStatus( )
		local sync_status_msg = ""
		
		if ( server_status == 1 ) then
			if ( self.Frame.Panel04.CS_Status_Rotate <= 360 ) then
				self.Frame.Panel04.CS_Status_Rotate = self.Frame.Panel04.CS_Status_Rotate + 20
			else
				self.Frame.Panel04.CS_Status_Rotate = 0
			end
		end
		
		if ( sync_status != 0 ) then
			if ( self.Frame.Panel04.SYNC_Status_Rotate <= 360 ) then
				self.Frame.Panel04.SYNC_Status_Rotate = self.Frame.Panel04.SYNC_Status_Rotate + 15
			else
				self.Frame.Panel04.SYNC_Status_Rotate = 0
			end
		end
		
		
		// self.Frame.Panel04.SYNC_Status_Rotate
		
		if ( server_status == 1 ) then
			draw.NoTexture( )
			surface.SetDrawColor( 0, 0, 0, 255 )
			LMapvote.geometry.DrawCircle( ( w / 2 - 8 / 2 ) + 0.5 + surface.GetTextSize( server_status_msg ), h * 0.3, 8, 2, 90, self.Frame.Panel04.CS_Status_Rotate, 100 )
		end
		
		draw.SimpleText( "Cloud Server Connection Status", "LMapVote_font_02", w / 2, h * 0.2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( server_status_msg, "LMapVote_font_05", w / 2, h * 0.3, server_status_col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		// GetGlobalString( "LMapvote.system.cloud.HostName", "nil" )
		
		local hostname = GetGlobalString( "LMapvote.system.cloud.HostName", "nil" )
		if ( hostname != "nil" ) then
			draw.SimpleText( "Cloud Server Host - " .. hostname, "LMapVote_font_04", 20, h * 0.6, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Cloud Server DataBase - " .. LMapvote.config.CloudSVR_DataBase, "LMapVote_font_04", 20, h * 0.7, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		else
			if ( server_status == 0 ) then
				draw.SimpleText( "Cloud Server Host - Using custom HostIP", "LMapVote_font_04", 20, h * 0.6, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( "Cloud Server DataBase - Using custom DataBase", "LMapVote_font_04", 20, h * 0.7, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( "Cloud Server Host - Offline :(", "LMapVote_font_04", 20, h * 0.6, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( "Cloud Server DataBase - Offline :(", "LMapVote_font_04", 20, h * 0.7, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
		end

		if ( server_status == 2 or server_status == 3 ) then
			draw.SimpleText( LMapvote.system.cloud.GetRecTimeLeft( ) .. " second after do reconnect ...", "LMapVote_font_05", w / 2, h * 0.4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		if ( sync_status == 1 ) then
			sync_status_msg = "FREEBOARD."
		elseif ( sync_status == 2 ) then
			sync_status_msg = "TEST SYNC..."
		end
		
		if ( sync_status_msg != "" ) then
			draw.SimpleText( "Syncing to server ... - " .. sync_status_msg, "LMapVote_font_05", 40, h - 60, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.NoTexture( )
			surface.SetDrawColor( 255, 0, 255, 255 )
			LMapvote.geometry.DrawCircle( 20, h - 60, 8, 2, 90, self.Frame.Panel04.SYNC_Status_Rotate, 100 )
		end
	end
	
	self.Frame.Panel04.StatusChange = vgui.Create( "DButton", self.Frame.Panel04 )
	self.Frame.Panel04.StatusChange:SetSize( self.Frame.Panel04.w - 10, 30 )
	self.Frame.Panel04.StatusChange:SetPos( self.Frame.Panel04.w / 2 - ( self.Frame.Panel04.w - 10 ) / 2, self.Frame.Panel04.h - 35 )
	self.Frame.Panel04.StatusChange:SetFont( "LMapVote_font_02" )
	self.Frame.Panel04.StatusChange:SetText( "Disconnect to Cloud server" )
	self.Frame.Panel04.StatusChange:SetColor( Color( 0, 0, 0, 255 ) )
	self.Frame.Panel04.StatusChange.DoClick = function( )
		LMapvote.PlayButtonSound( )
		local server_status = LMapvote.system.cloud.GetStatus( )
		if ( server_status != 1 ) then
			if ( server_status == 0 or server_status == 2 ) then
				Derma_Query( "Are you sure disconnect to cloud server?", "WARNING",
					"YES", function() 
						netstream.Start( "LMapvote.system.cloud.StatusChange", 0 )
					end,
					"NO", function()
								
					end
				)
			else
				Derma_Query( "Are you sure connect to cloud server?", "WARNING",
					"YES", function() 
						netstream.Start( "LMapvote.system.cloud.StatusChange", 1 )
					end,
					"NO", function()
								
					end
				)
			end
		else
			Derma_Message( "Still working, please wait ...", "NOTICE", "OK" )
		end
	end
	self.Frame.Panel04.StatusChange.Paint = function( pnl, w, h )
		local server_status = LMapvote.system.cloud.GetStatus( )
		if ( server_status == 0 or server_status == 2 ) then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 150, 150, 100 ) )
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
		end
	end
	
	
	self.Frame.Panel05 = vgui.Create( "DPanel", self.Frame )
	
	self.Frame.Panel05.w = self.w / 3 - ( 10 * 3 ) - ( 15 )
	self.Frame.Panel05.h = self.h * 0.4
	self.Frame.Panel05.x = self.w * 0.5 - self.Frame.Panel04.w / 2
	self.Frame.Panel05.y = self.h * 0.5
	
	self.Frame.Panel05:SetSize( self.Frame.Panel05.w, self.Frame.Panel05.h )
	self.Frame.Panel05:SetPos( self.Frame.Panel05.x, self.Frame.Panel05.y )
	self.Frame.Panel05.Paint = function( pnl, w, h )
	
		draw.RoundedBox( 0, 0, 40, w, 1, Color( 215, 215, 215, 235 ) )
		
		draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 215, 215, 235 ) )
		draw.RoundedBox( 0, 0, 0, 1, h, Color( 215, 215, 215, 235 ) )
		
		draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 215, 215, 215, 235 ) )
		draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 215, 215, 215, 235 ) )
		
		draw.SimpleText( "Cloud Service", "LMapVote_font_03", 15, 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		local server_status = LMapvote.system.cloud.GetStatus( )
		
		if ( server_status != 0 ) then
			draw.SimpleText( "If you want use Cloud service, must be connected by cloud server!", "LMapVote_font_05", w / 2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	
	self.Frame.Panel05.FreeBoard = vgui.Create( "DButton", self.Frame.Panel05 )
	self.Frame.Panel05.FreeBoard:SetSize( self.Frame.Panel05.w - 10, 30 )
	self.Frame.Panel05.FreeBoard:SetPos( self.Frame.Panel05.w / 2 - ( self.Frame.Panel05.w - 10 ) / 2, self.Frame.Panel05.h - 35 )
	self.Frame.Panel05.FreeBoard:SetFont( "LMapVote_font_03" )
	self.Frame.Panel05.FreeBoard:SetText( "Freeboard" )
	self.Frame.Panel05.FreeBoard:SetColor( Color( 0, 0, 0, 255 ) )
	self.Frame.Panel05.FreeBoard.DoClick = function( )
		LMapvote.PlayButtonSound( )
		local server_status = LMapvote.system.cloud.GetStatus( )
		if ( server_status != 0 ) then
			return
		end
		
		self:Freeboardboard_Open( )
	end
	self.Frame.Panel05.FreeBoard.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	

	
	
	
	self.Frame.CloseButton = vgui.Create( "DButton", self.Frame )
	self.Frame.CloseButton:SetPos( 10, self.h - 40 )
	self.Frame.CloseButton:SetSize( self.w * 0.15, 30 )
	self.Frame.CloseButton:SetText( "Close" )
	self.Frame.CloseButton:SetFont( "LMapVote_font_02" )
	self.Frame.CloseButton:SetColor( Color( 0, 0, 0, 255 ) )
	self.Frame.CloseButton.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 150, 150, 100 ) )
	end
	self.Frame.CloseButton.DoClick = function( )
		LMapvote.PlayButtonSound( )
		self.Frame:Remove( )
		self.Frame = nil
	end
end

function ADMINPANEL:Refresh_Changelog( )
	if ( !LMapvote.update.buffer ) then return end
	if ( self.Frame.Panel01.ShowType != 2 ) then return end
	if ( !LMapvote.update.buffer[ "Update_Log" ] ) then
		Derma_Message( "Can't load changelog data.", "ERROR", "OK" )
		return
	end
	self.Frame.Panel01.ChangelogMenu:Clear( )
	
	for key, value in pairs( LMapvote.update.buffer[ "Update_Log" ] ) do
		local delata = 0
		local panel = vgui.Create( "DPanel" )
		panel:SetSize( self.Frame.Panel01.ChangelogMenu:GetWide( ), 30 )
		panel:SetAlpha( 0 )
		panel:AlphaTo( 255, 0.03, delta )
		delata = delata + 0.02
		panel.Paint = function( pnl, w, h )
			if ( value.status != "0" ) then
				if ( value.status == "1" ) then
					draw.RoundedBox( 0, w - 50, 0, 50, h, Color( 150, 255, 150, 100 ) )
					draw.SimpleText( "Add", "LMapVote_font_02", w - 10, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				elseif ( value.status == "2" ) then
					draw.RoundedBox( 0, w - 50, 0, 50, h, Color( 150, 255, 255, 100 ) )
					draw.SimpleText( "Fix", "LMapVote_font_02", w - 14, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end
			else
				draw.RoundedBox( 0, w - 85, 0, 85, h, Color( 0, 0, 0, 200 ) )
				draw.SimpleText( "Release", "LMapVote_font_02", w - 14, h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			draw.SimpleText( key .. ".  " .. value.text, "LMapVote_font_04", 5, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		
		self.Frame.Panel01.ChangelogMenu:AddItem( panel )
	end
end

function ADMINPANEL:Freeboardboard_Open( )

	
	if ( self.FreeBoard ) then
		self.FreeBoard:Remove( )
		self.FreeBoard = nil
	end
	
	if ( !LMapvote.config.HavePermission( LocalPlayer( ) ) ) then
		return
	end

	self.FreeBoard = vgui.Create( "DFrame" )
	
	self.FreeBoard.w = ScrW( )
	self.FreeBoard.h = ScrH( )
	self.FreeBoard.x = ScrW( ) / 2 - self.FreeBoard.w / 2
	self.FreeBoard.y = ScrH( ) / 2 - self.FreeBoard.h / 2
	
	self.FreeBoard:SetSize( self.FreeBoard.w, self.FreeBoard.h )
	self.FreeBoard:SetPos( self.FreeBoard.x, self.FreeBoard.y )
	self.FreeBoard:SetTitle( "" )
	self.FreeBoard:ShowCloseButton( false )
	self.FreeBoard:MakePopup( )
	self.FreeBoard:Center( )
	self.FreeBoard.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )

		draw.SimpleText( "LMAPVote Free board", "LMapVote_font_01", 10, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	
	self.FreeBoard.FreeBoardList = vgui.Create( "DPanelList", self.FreeBoard )
	self.FreeBoard.FreeBoardList:SetPos( self.FreeBoard.w / 2 - ( self.FreeBoard.w - 20 ) / 2, 50 )
	self.FreeBoard.FreeBoardList:SetSize( self.FreeBoard.w - 20, self.FreeBoard.h - 100 )
	self.FreeBoard.FreeBoardList:SetSpacing( 5 )
	self.FreeBoard.FreeBoardList:EnableHorizontal( false )
	self.FreeBoard.FreeBoardList:EnableVerticalScrollbar( true )	
	self.FreeBoard.FreeBoardList.Paint = function( pnl, w, h )
		if ( !LMapvote.system.cloud.Cache[ "FREE_BOARD" ] ) then
			draw.SimpleText( "Can't load free board data.", "LMapVote_font_01", w / 2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			return
		end
		if ( #LMapvote.system.cloud.Cache[ "FREE_BOARD" ] == 0 ) then
			draw.SimpleText( "Peoples has not write thread.", "LMapVote_font_01", w / 2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			return
		end
	end
	
	
	
	//LMapvote.system.cloud.BoardAdd
	
	function self.FreeBoard.FreeBoardList.Refresh( )
		print("Refresh!")
		self.FreeBoard.FreeBoardList:Clear( )
		if ( !LMapvote.system.cloud.Cache[ "FREE_BOARD" ] ) then
			Derma_Message( "Can't load free board data.", "ERROR", "OK" )
			return
		end
		
		table.sort( LMapvote.system.cloud.Cache[ "FREE_BOARD" ], function( a, b )
			return a.ID > b.ID
		
		end )
		
		for key, value in pairs( LMapvote.system.cloud.Cache[ "FREE_BOARD" ] ) do
			local panel = vgui.Create( "DPanel" )
			panel:SetSize( self.FreeBoard.FreeBoardList:GetWide( ), 100 )
			panel.Paint = function( pnl, w, h )
				if ( !LMapvote.system.cloud.Cache[ "FREE_BOARD" ][ key ] ) then
					return
				end
				
				draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 5 ) )
				
				if ( tonumber( value.ID ) == #LMapvote.system.cloud.Cache[ "FREE_BOARD" ] ) then
					draw.SimpleText( "★ Latest Thread", "LMapVote_font_02", w * 0.85, h * 0.2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end
				
				if ( value.Author_SteamID == "STEAM_0:1:25704824" ) then
					draw.SimpleText( "◆ Administrator - L7D", "LMapVote_font_02", 10, h * 0.2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				//draw.SimpleText( key, "LMapVote_font_01", 10, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( value.Title or "ERROR", "LMapVote_font_03", 10, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( "By " .. value.Author_Name or "ERROR", "LMapVote_font_03", 10, h * 0.8, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				draw.SimpleText( value.Author_ServerName or "ERROR", "LMapVote_font_03", w * 0.85, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

				draw.SimpleText( #value.Comment .. "'s comments is exists.", "LMapVote_font_05", w * 0.85, h * 0.8, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			local lookbutton = vgui.Create( "DButton", panel )
			lookbutton:SetPos( panel:GetWide( ) - ( panel:GetWide( ) * 0.1 ) - 10, panel:GetTall( ) / 2 - ( panel:GetTall( ) - 15 ) / 2 )
			lookbutton:SetSize( panel:GetWide( ) * 0.1, panel:GetTall( ) - 15 )
			lookbutton:SetText( "Open thread" )
			lookbutton:SetFont( "LMapVote_font_03" )
			lookbutton:SetColor( Color( 0, 0, 0, 255 ) )
			lookbutton.Paint = function( pnl, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
			end
			lookbutton.DoClick = function( )
				LMapvote.PlayButtonSound( )
				self:FreeBoard_LookDetail( value )
			end
			
			local deletebutton = vgui.Create( "DButton", panel )
			deletebutton:SetPos( panel:GetWide( ) - panel:GetWide( ) * 0.15, 5 )
			deletebutton:SetSize( 30, 30 )
			deletebutton:SetText( "" )
			deletebutton.Paint = function( pnl, w, h )
				if ( value.Author_SteamID == LocalPlayer( ):SteamID( ) ) then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( Material( "icon16/cancel.png" ) )
					surface.DrawTexturedRect( w / 2, h / 2 - 16 / 2, 16, 16 )
				end
			end
			deletebutton.DoClick = function( )
				if ( value.Author_SteamID == LocalPlayer( ):SteamID( ) ) then
					LMapvote.PlayButtonSound( )
					netstream.Start( "LMapvote.system.cloud.RemoveBoard", { value.ID, value.Title } )
				else
					Derma_Message( "You can't delete this thread!", "ERROR", "OK" )
					return
				end
			end
			
			self.FreeBoard.FreeBoardList:AddItem( panel )
		
		end
		
	end
	
	
	self.FreeBoard.FreeBoardList.Refresh( )
	
	self.FreeBoard.AddBoardButton = vgui.Create( "DButton", self.FreeBoard )
	self.FreeBoard.AddBoardButton:SetPos( self.FreeBoard.w / 2 - ( self.w * 0.15 ) / 2, self.FreeBoard.h - 40 )
	self.FreeBoard.AddBoardButton:SetSize( self.w * 0.15, 30 )
	self.FreeBoard.AddBoardButton:SetText( "Thread add" )
	self.FreeBoard.AddBoardButton:SetFont( "LMapVote_font_02" )
	self.FreeBoard.AddBoardButton:SetColor( Color( 0, 0, 0, 255 ) )
	self.FreeBoard.AddBoardButton.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 150, 255, 150, 100 ) )
	end
	self.FreeBoard.AddBoardButton.DoClick = function( )
		LMapvote.PlayButtonSound( )
		self:FreeBoard_Add_Func( LMapvote.system.cloud.Cache[ "FREE_BOARD" ] )
	end
	
	
	self.FreeBoard.SyncButton = vgui.Create( "DButton", self.FreeBoard )
	self.FreeBoard.SyncButton:SetPos( self.FreeBoard.w - ( self.w * 0.25 ) - 10, self.FreeBoard.h - 40 )
	self.FreeBoard.SyncButton:SetSize( self.w * 0.25, 30 )
	self.FreeBoard.SyncButton:SetText( "Sync request to Cloud server" )
	self.FreeBoard.SyncButton:SetFont( "LMapVote_font_03" )
	self.FreeBoard.SyncButton:SetColor( Color( 0, 0, 0, 255 ) )
	self.FreeBoard.SyncButton.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	self.FreeBoard.SyncButton.DoClick = function( )
		LMapvote.PlayButtonSound( )
		LMapvote.system.cloud.Get_NOTICEBOARD_DATA( true )
	end

	
	self.FreeBoard.CloseButton = vgui.Create( "DButton", self.FreeBoard )
	self.FreeBoard.CloseButton:SetPos( 10, self.FreeBoard.h - 40 )
	self.FreeBoard.CloseButton:SetSize( self.w * 0.15, 30 )
	self.FreeBoard.CloseButton:SetText( "Close" )
	self.FreeBoard.CloseButton:SetFont( "LMapVote_font_02" )
	self.FreeBoard.CloseButton:SetColor( Color( 0, 0, 0, 255 ) )
	self.FreeBoard.CloseButton.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 150, 150, 100 ) )
	end
	self.FreeBoard.CloseButton.DoClick = function( )
		LMapvote.PlayButtonSound( )
		self.FreeBoard:Remove( )
		self.FreeBoard = nil
	end
end


function ADMINPANEL:FreeBoard_LookDetail( tab )

	if ( self.FreeBoard_Detail ) then
		self.FreeBoard_Detail:Remove( )
		self.FreeBoard_Detail = nil
	end

	self.FreeBoard_Detail = vgui.Create( "DFrame" )
	
	self.FreeBoard_Detail.w = ScrW( ) * 0.7
	self.FreeBoard_Detail.h = ScrH( )
	self.FreeBoard_Detail.x = ScrW( ) + self.FreeBoard_Detail.w
	self.FreeBoard_Detail.y = ScrH( ) / 2 - self.FreeBoard_Detail.h / 2
	
	
	self.FreeBoard_Detail:SetSize( self.FreeBoard_Detail.w, self.FreeBoard_Detail.h )
	self.FreeBoard_Detail:SetPos( self.FreeBoard_Detail.x, self.FreeBoard_Detail.y )
	self.FreeBoard_Detail:MoveTo( ScrW( ) - self.FreeBoard_Detail.w, self.FreeBoard_Detail.y, 0.3, 0 )
	
	self.FreeBoard_Detail:SetTitle( "" )
	self.FreeBoard_Detail:ShowCloseButton( false )
	self.FreeBoard_Detail:MakePopup( )
	self.FreeBoard_Detail.Paint = function( pnl, w, h )
		if ( self.FreeBoard_Detail and IsValid( self.FreeBoard_Detail ) and !self.FreeBoard_Detail_AddComment ) then
			self.FreeBoard_Detail:MoveToFront( )
		end
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )

		draw.SimpleText( tab.Title or "ERRPR" .. " 's Detail", "LMapVote_font_02", 15, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "By " .. tab.Author_Name or "ERROR", "LMapVote_font_03", 15, 50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		
		// tab.Author_ServerName
		draw.SimpleText( tab.Author_ServerName or "ERROR", "LMapVote_font_03", w - 15, 50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( tab.Time or "ERROR", "LMapVote_font_03", w - 15, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( "Comments", "LMapVote_font_02", 15, h * 0.6, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		if ( tab.Comment ) then
			if ( #tab.Comment == 0 ) then
				draw.SimpleText( "No comments!", "LMapVote_font_01", w / 2, h * 0.8, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				self.FreeBoard_Detail.CommentList:SetVisible( false )
			else
				self.FreeBoard_Detail.CommentList:SetVisible( true )
			end
		end
	end
	
	self.FreeBoard_Detail.Value = vgui.Create( "DTextEntry", self.FreeBoard_Detail )
	self.FreeBoard_Detail.Value:SetPos( self.FreeBoard_Detail.w / 2 - ( self.FreeBoard_Detail.w - 20 ) / 2, 70 )
	self.FreeBoard_Detail.Value:SetSize( self.FreeBoard_Detail.w - 20, self.FreeBoard_Detail.h * 0.5 )	
	self.FreeBoard_Detail.Value:SetFont( "LMapVote_font_04" )
	self.FreeBoard_Detail.Value:SetText( tab.Value )
	self.FreeBoard_Detail.Value:SetMultiline( true )
	self.FreeBoard_Detail.Value:SetEditable( false )
	self.FreeBoard_Detail.Value:SetAllowNonAsciiCharacters( true )
	self.FreeBoard_Detail.Value.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, 1, Color( 0, 0, 0, 255 ) )
		draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 0, 0, 0, 255 ) )
			
		pnl:DrawTextEntryText( Color( 0, 0, 0 ), Color( 0, 0, 0 ), Color( 0, 0, 0 ) )
	end
	
	
	self.FreeBoard_Detail.CommentList = vgui.Create( "DPanelList", self.FreeBoard_Detail )
	self.FreeBoard_Detail.CommentList:SetPos( self.FreeBoard_Detail.w / 2 - ( self.FreeBoard_Detail.w - 20 ) / 2, self.FreeBoard_Detail.h * 0.6 + 20 )
	self.FreeBoard_Detail.CommentList:SetSize( self.FreeBoard_Detail.w - 20, self.FreeBoard_Detail.h * 0.25 )
	self.FreeBoard_Detail.CommentList:SetSpacing( 2 )
	self.FreeBoard_Detail.CommentList:EnableHorizontal( false )
	self.FreeBoard_Detail.CommentList:EnableVerticalScrollbar( true )	
	self.FreeBoard_Detail.CommentList.Paint = function( pnl, w, h )
	
	end
	
	function self.FreeBoard_Detail.CommentList.Refresh( )
		self.FreeBoard_Detail.CommentList:Clear( )
		if ( !tab.Comment ) then
			return
		end
		for key, value in pairs( tab.Comment ) do
			local panel = vgui.Create( "DPanel" )
			panel:SetSize( self.FreeBoard_Detail.CommentList:GetWide( ), 60 )
			panel.Paint = function( pnl, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 3 ) )
				draw.SimpleText( value.AuthorServerName or "ERROR", "LMapVote_font_04", 10, 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( value.AuthorName or "ERROR", "LMapVote_font_02", 10, h - 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( " - " .. value.Value or "ERROR", "LMapVote_font_03", 50 + surface.GetTextSize( value.AuthorName or "" ), h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( value.Time or "ERROR", "LMapVote_font_04", w - 10, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			// AuthorName, AuthorServerName
			self.FreeBoard_Detail.CommentList:AddItem( panel )
		end
	end
	
	
	self.FreeBoard_Detail.CommentList.Refresh( )
	
	self.FreeBoard_Detail.CommentAdd = vgui.Create( "DButton", self.FreeBoard_Detail )
	self.FreeBoard_Detail.CommentAdd:SetPos( self.FreeBoard_Detail.w - ( self.FreeBoard_Detail.w * 0.2 ) - 10, self.FreeBoard_Detail.h - 60 )
	self.FreeBoard_Detail.CommentAdd:SetSize( self.FreeBoard_Detail.w * 0.2, 50 )
	self.FreeBoard_Detail.CommentAdd:SetText( "Comment add" )
	self.FreeBoard_Detail.CommentAdd:SetFont( "LMapVote_font_03" )
	self.FreeBoard_Detail.CommentAdd:SetColor( Color( 0, 0, 0, 255 ) )
	self.FreeBoard_Detail.CommentAdd.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	self.FreeBoard_Detail.CommentAdd.DoClick = function( )
		LMapvote.PlayButtonSound( )
		self:FreeBoard_LookDetail_AddComment( tab )
	end
	
	self.FreeBoard_Detail.CloseButton = vgui.Create( "DButton", self.FreeBoard_Detail )
	self.FreeBoard_Detail.CloseButton:SetPos( 10, self.FreeBoard_Detail.h - 60 )
	self.FreeBoard_Detail.CloseButton:SetSize( 50, 50 )
	self.FreeBoard_Detail.CloseButton:SetText( ">" )
	self.FreeBoard_Detail.CloseButton:SetFont( "LMapVote_font_01" )
	self.FreeBoard_Detail.CloseButton:SetColor( Color( 0, 0, 0, 255 ) )
	self.FreeBoard_Detail.CloseButton.Paint = function( pnl, w, h )

	end
	self.FreeBoard_Detail.CloseButton.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( self.FreeBoard_Detail ) then
			self.FreeBoard_Detail:MoveTo( ScrW( ) + self.FreeBoard_Detail.w, self.FreeBoard_Detail.y, 0.3, 0 )
			timer.Simple( 0.3, function( )
				if ( self.FreeBoard_Detail ) then
					self.FreeBoard_Detail:Remove( )
					self.FreeBoard_Detail = nil
				end
				if ( self.FreeBoard_Detail_AddComment ) then
					self.FreeBoard_Detail_AddComment:Remove( )
					self.FreeBoard_Detail_AddComment = nil
				end
			end )
		end
	end
end



function ADMINPANEL:FreeBoard_LookDetail_AddComment( tab )

	if ( self.FreeBoard_Detail_AddComment ) then
		self.FreeBoard_Detail_AddComment:Remove( )
		self.FreeBoard_Detail_AddComment = nil
	end

	self.FreeBoard_Detail_AddComment = vgui.Create( "DFrame" )
	
	self.FreeBoard_Detail_AddComment.w = ScrW( ) * 0.7
	self.FreeBoard_Detail_AddComment.h = ScrH( ) * 0.2
	self.FreeBoard_Detail_AddComment.x = ScrW( ) - self.FreeBoard_Detail_AddComment.w
	self.FreeBoard_Detail_AddComment.y = ScrH( ) + self.FreeBoard_Detail_AddComment.h
	
	
	self.FreeBoard_Detail_AddComment:SetSize( self.FreeBoard_Detail_AddComment.w, self.FreeBoard_Detail_AddComment.h )
	self.FreeBoard_Detail_AddComment:SetPos( self.FreeBoard_Detail_AddComment.x, self.FreeBoard_Detail_AddComment.y )
	self.FreeBoard_Detail_AddComment:MoveTo( self.FreeBoard_Detail_AddComment.x, ScrH( ) - self.FreeBoard_Detail_AddComment.h, 0.3, 0 )
	
	self.FreeBoard_Detail_AddComment:SetTitle( "" )
	self.FreeBoard_Detail_AddComment:ShowCloseButton( false )
	self.FreeBoard_Detail_AddComment:MakePopup( )
	self.FreeBoard_Detail_AddComment.Paint = function( pnl, w, h )
		if ( self.FreeBoard_Detail_AddComment and IsValid( self.FreeBoard_Detail_AddComment ) ) then
			self.FreeBoard_Detail_AddComment:MoveToFront( )
		end
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )
		draw.SimpleText( "Comment add", "LMapVote_font_03", 10, 10, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		if ( #self.FreeBoard_Detail_AddComment.Value:GetValue( ) < 100 ) then
			draw.SimpleText( #self.FreeBoard_Detail_AddComment.Value:GetValue( ) .. "/100", "LMapVote_font_03", w / 2, h - 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( #self.FreeBoard_Detail_AddComment.Value:GetValue( ) .. "/100", "LMapVote_font_03", w / 2, h - 20, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	
	self.FreeBoard_Detail_AddComment.Value = vgui.Create( "DTextEntry", self.FreeBoard_Detail_AddComment )
	self.FreeBoard_Detail_AddComment.Value:SetPos( self.FreeBoard_Detail_AddComment.w / 2 - ( self.FreeBoard_Detail_AddComment.w - 20 ) / 2, 30 )
	self.FreeBoard_Detail_AddComment.Value:SetSize( self.FreeBoard_Detail_AddComment.w - 20, self.FreeBoard_Detail_AddComment.h - 90 )	
	self.FreeBoard_Detail_AddComment.Value:SetFont( "LMapVote_font_04" )
	self.FreeBoard_Detail_AddComment.Value:SetText( "" )
	self.FreeBoard_Detail_AddComment.Value:SetMultiline( false )
	self.FreeBoard_Detail_AddComment.Value:SetAllowNonAsciiCharacters( true )
	self.FreeBoard_Detail_AddComment.Value.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, 1, Color( 0, 0, 0, 255 ) )
		draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 0, 0, 0, 255 ) )
			
		pnl:DrawTextEntryText( Color( 0, 0, 0 ), Color( 0, 0, 0 ), Color( 0, 0, 0 ) )
	end

	self.FreeBoard_Detail_AddComment.CommentAdd = vgui.Create( "DButton", self.FreeBoard_Detail_AddComment )
	self.FreeBoard_Detail_AddComment.CommentAdd:SetPos( self.FreeBoard_Detail_AddComment.w - 60, self.FreeBoard_Detail_AddComment.h - 60 )
	self.FreeBoard_Detail_AddComment.CommentAdd:SetSize( 50, 50 )
	self.FreeBoard_Detail_AddComment.CommentAdd:SetText( "+" )
	self.FreeBoard_Detail_AddComment.CommentAdd:SetFont( "LMapVote_font_01" )
	self.FreeBoard_Detail_AddComment.CommentAdd:SetColor( Color( 0, 0, 0, 255 ) )
	self.FreeBoard_Detail_AddComment.CommentAdd.Paint = function( pnl, w, h )

	end
	self.FreeBoard_Detail_AddComment.CommentAdd.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( #self.FreeBoard_Detail_AddComment.Value:GetValue( ) >= 100 ) then
			return
		end
		netstream.Start( "LMapvote.system.cloud.CommendAdd",
			{
				CommentTab = {
					ID = #tab + 1,
					AuthorServerName = GetHostName( ),
					AuthorName = LocalPlayer( ):Name( ),
					AuthorSteamID = LocalPlayer( ):SteamID( ),
					Value = self.FreeBoard_Detail_AddComment.Value:GetValue( ),
					Time = os.date( )
				},
				Tab = tab
			}
		)
		if ( self.FreeBoard_Detail_AddComment ) then
			self.FreeBoard_Detail_AddComment:MoveTo( self.FreeBoard_Detail_AddComment.x, ScrH( ) + self.FreeBoard_Detail_AddComment.h, 0.3, 0 )
			timer.Simple( 0.3, function( )
				if ( self.FreeBoard_Detail_AddComment ) then
					self.FreeBoard_Detail_AddComment:Remove( )
					self.FreeBoard_Detail_AddComment = nil
				end
			end )
		end
		if ( self.FreeBoard_Detail ) then
			self.FreeBoard_Detail:MoveTo( ScrW( ) + self.FreeBoard_Detail.w, self.FreeBoard_Detail.y, 0.3, 0 )
			timer.Simple( 0.3, function( )
				if ( self.FreeBoard_Detail ) then
					self.FreeBoard_Detail:Remove( )
					self.FreeBoard_Detail = nil
				end
			end )
		end
	end
	
	self.FreeBoard_Detail_AddComment.CloseButton = vgui.Create( "DButton", self.FreeBoard_Detail_AddComment )
	self.FreeBoard_Detail_AddComment.CloseButton:SetPos( 10, self.FreeBoard_Detail_AddComment.h - 60 )
	self.FreeBoard_Detail_AddComment.CloseButton:SetSize( 50, 50 )
	self.FreeBoard_Detail_AddComment.CloseButton:SetText( "X" )
	self.FreeBoard_Detail_AddComment.CloseButton:SetFont( "LMapVote_font_01" )
	self.FreeBoard_Detail_AddComment.CloseButton:SetColor( Color( 0, 0, 0, 255 ) )
	self.FreeBoard_Detail_AddComment.CloseButton.Paint = function( pnl, w, h )

	end
	self.FreeBoard_Detail_AddComment.CloseButton.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( self.FreeBoard_Detail_AddComment ) then
			self.FreeBoard_Detail_AddComment:MoveTo( self.FreeBoard_Detail_AddComment.x, ScrH( ) + self.FreeBoard_Detail_AddComment.h, 0.3, 0 )
			timer.Simple( 0.3, function( )
				if ( self.FreeBoard_Detail_AddComment ) then
					self.FreeBoard_Detail_AddComment:Remove( )
					self.FreeBoard_Detail_AddComment = nil
				end
			end )
		end
	end
end


function ADMINPANEL:FreeBoard_Add_Func( tab )

	if ( self.FreeBoard_Add ) then
		self.FreeBoard_Add:Remove( )
		self.FreeBoard_Add = nil
	end

	self.FreeBoard_Add = vgui.Create( "DFrame" )
	
	self.FreeBoard_Add.w = ScrW( )
	self.FreeBoard_Add.h = ScrH( ) * 0.5
	self.FreeBoard_Add.x = ScrW( ) - self.FreeBoard_Add.w
	self.FreeBoard_Add.y = ScrH( ) + self.FreeBoard_Add.h
	
	
	self.FreeBoard_Add:SetSize( self.FreeBoard_Add.w, self.FreeBoard_Add.h )
	self.FreeBoard_Add:SetPos( self.FreeBoard_Add.x, self.FreeBoard_Add.y )
	self.FreeBoard_Add:MoveTo( self.FreeBoard_Add.x, ScrH( ) - self.FreeBoard_Add.h, 0.3, 0 )
	
	self.FreeBoard_Add:SetTitle( "" )
	self.FreeBoard_Add:ShowCloseButton( false )
	self.FreeBoard_Add:MakePopup( )
	self.FreeBoard_Add.Paint = function( pnl, w, h )
		if ( self.FreeBoard_Add and IsValid( self.FreeBoard_Add ) ) then
			self.FreeBoard_Add:MoveToFront( )
		end
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )
		draw.SimpleText( "Thread add", "LMapVote_font_03", 10, 15, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( "WARNING - Title and Value is must be over 10 character!", "LMapVote_font_03", w / 2, h - 30, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	self.FreeBoard_Add.Title = vgui.Create( "DTextEntry", self.FreeBoard_Add )
	self.FreeBoard_Add.Title:SetPos( self.FreeBoard_Add.w / 2 - ( self.FreeBoard_Add.w - 20 ) / 2, 30 )
	self.FreeBoard_Add.Title:SetSize( self.FreeBoard_Add.w - 20, 50 )	
	self.FreeBoard_Add.Title:SetFont( "LMapVote_font_04" )
	self.FreeBoard_Add.Title:SetText( "" )
	self.FreeBoard_Add.Title:SetMultiline( false )
	self.FreeBoard_Add.Title:SetAllowNonAsciiCharacters( true )
	self.FreeBoard_Add.Title.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, 1, Color( 0, 0, 0, 255 ) )
		draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 0, 0, 0, 255 ) )
			
		pnl:DrawTextEntryText( Color( 0, 0, 0 ), Color( 0, 0, 0 ), Color( 0, 0, 0 ) )
	end
	
	self.FreeBoard_Add.Value = vgui.Create( "DTextEntry", self.FreeBoard_Add )
	self.FreeBoard_Add.Value:SetPos( self.FreeBoard_Add.w / 2 - ( self.FreeBoard_Add.w - 20 ) / 2, self.FreeBoard_Add.h * 0.2 )
	self.FreeBoard_Add.Value:SetSize( self.FreeBoard_Add.w - 20, self.FreeBoard_Add.h * 0.65 )	
	self.FreeBoard_Add.Value:SetFont( "LMapVote_font_04" )
	self.FreeBoard_Add.Value:SetText( "" )
	self.FreeBoard_Add.Value:SetMultiline( true )
	self.FreeBoard_Add.Value:SetAllowNonAsciiCharacters( true )
	self.FreeBoard_Add.Value.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, 1, Color( 0, 0, 0, 255 ) )
		draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 0, 0, 0, 255 ) )
			
		pnl:DrawTextEntryText( Color( 0, 0, 0 ), Color( 0, 0, 0 ), Color( 0, 0, 0 ) )
	end

	self.FreeBoard_Add.Add = vgui.Create( "DButton", self.FreeBoard_Add )
	self.FreeBoard_Add.Add:SetPos( self.FreeBoard_Add.w - 60, self.FreeBoard_Add.h - 60 )
	self.FreeBoard_Add.Add:SetSize( 50, 50 )
	self.FreeBoard_Add.Add:SetText( "+" )
	self.FreeBoard_Add.Add:SetFont( "LMapVote_font_01" )
	self.FreeBoard_Add.Add:SetColor( Color( 0, 0, 0, 255 ) )
	self.FreeBoard_Add.Add.Paint = function( pnl, w, h )

	end
	self.FreeBoard_Add.Add.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( #self.FreeBoard_Add.Title:GetValue( ) < 10 ) then
			Derma_Message( "Title is must be over 10 character!", "ERROR", "OK" )
			return
		end
		if ( #self.FreeBoard_Add.Value:GetValue( ) < 10 ) then
			Derma_Message( "Value is must be over 10 character!", "ERROR", "OK" )
			return
		end
		netstream.Start( "LMapvote.system.cloud.BoardAdd", 
			{
				Tab = {
					Time = os.date( ),
					Title = self.FreeBoard_Add.Title:GetValue( ),
					Author_Name = LocalPlayer( ):Name( ),
					Author_SteamID = LocalPlayer( ):SteamID( ),
					Value = self.FreeBoard_Add.Value:GetValue( ),
					Comment = { }
				}
			}
		)
		if ( self.FreeBoard_Add ) then
			self.FreeBoard_Add:MoveTo( self.FreeBoard_Add.x, ScrH( ) + self.FreeBoard_Add.h, 0.3, 0 )
			timer.Simple( 0.3, function( )
				if ( self.FreeBoard_Add ) then
					self.FreeBoard_Add:Remove( )
					self.FreeBoard_Add = nil
				end
			end )
		end
	end
	
	self.FreeBoard_Add.CloseButton = vgui.Create( "DButton", self.FreeBoard_Add )
	self.FreeBoard_Add.CloseButton:SetPos( 10, self.FreeBoard_Add.h - 60 )
	self.FreeBoard_Add.CloseButton:SetSize( 50, 50 )
	self.FreeBoard_Add.CloseButton:SetText( "X" )
	self.FreeBoard_Add.CloseButton:SetFont( "LMapVote_font_01" )
	self.FreeBoard_Add.CloseButton:SetColor( Color( 0, 0, 0, 255 ) )
	self.FreeBoard_Add.CloseButton.Paint = function( pnl, w, h )

	end
	self.FreeBoard_Add.CloseButton.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( self.FreeBoard_Add ) then
			self.FreeBoard_Add:MoveTo( self.FreeBoard_Add.x, ScrH( ) + self.FreeBoard_Add.h, 0.3, 0 )
			timer.Simple( 0.3, function( )
				if ( self.FreeBoard_Add ) then
					self.FreeBoard_Add:Remove( )
					self.FreeBoard_Add = nil
				end
			end )
		end
	end
end

function ADMINPANEL:Refresh_Maplist( )
	if ( !LMapvote.map.buffer ) then
		Derma_Message( "Can't load map data.", "ERROR", "OK" )
		return
	end
	self.Frame.Panel02.MaplistMenu:Clear( )
	
	local imageTable = { }
	
	for key, value in pairs( LMapvote.map.buffer ) do
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
	
	for key, value in pairs( LMapvote.map.buffer ) do
		local delata = 0
		local panel = vgui.Create( "DPanel" )
		panel:SetSize( 100, 100 )
		panel:SetAlpha( 0 )
		panel:AlphaTo( 255, 0.03, delta )
		delata = delata + 0.02
		panel.Paint = function( pnl, w, h )
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

			draw.RoundedBox( 0, 0, h - 20, w, 20, Color( 0, 0, 0, 100 ) )
			draw.SimpleText( value.Name, "LMapVote_font_04", w / 2, h - ( 20 / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		self.Frame.Panel02.MaplistMenu:AddItem( panel )
	end
end

vgui.Register( "LMapVote_ADMIN", ADMINPANEL, "Panel" )