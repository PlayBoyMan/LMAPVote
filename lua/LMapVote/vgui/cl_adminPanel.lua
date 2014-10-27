--[[
	LMAPVote - 1.5.3
	Copyright ( C ) 2014 ~ L7D
--]]

concommand.Add( "LMAPVote_admin", function( pl )
	if ( LMapvote.config.HavePermission( pl ) ) then
		if ( !LMapvote.panel.adminPanel ) then
			LMapvote.panel.adminPanel = vgui.Create( "LMapVote_ADMIN" )
		else
			LMapvote.panel.adminPanel:Close( )
			LMapvote.panel.adminPanel = vgui.Create( "LMapVote_ADMIN" )
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
	self.Frame:SetDraggable( false )
	self.Frame:MakePopup( )
	self.Frame.Paint = function( pnl, w, h )
		if ( !LMapvote.config.HavePermission( LocalPlayer( ) ) ) then
			if ( self.Frame and IsValid( self.Frame ) ) then
				self.Frame:Remove( )
				self.Frame = nil
				return
			end
		end

		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )

		draw.SimpleText( "LMAPVote Administrator", "LMAPVote_font01_30", 15, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Welcome " .. LocalPlayer( ):Name( ), "LMAPVote_font01_20", w - 15, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Copyright ( C ) 2014 ~ L7D", "LMAPVote_font01_15", w - 15, h - 40, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Version - " .. LMapvote.config.Version, "LMAPVote_font01_15", w - 15, h - 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
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
					surface.SetDrawColor( 215, 150, 150, self.Frame.Panel01.Light / 3 )
					surface.SetMaterial( Material( "gui/gradient" ) )
					surface.DrawTexturedRect( 0, 0, w, 40 )
					
					draw.RoundedBox( 0, 0, 40, w, 1, Color( 215, 150, 150, self.Frame.Panel01.Light ) )
			
					draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 150, 150, self.Frame.Panel01.Light ) )
					draw.RoundedBox( 0, 0, 0, 1, h, Color( 215, 150, 150, self.Frame.Panel01.Light ) )
			
					draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 215, 150, 150, self.Frame.Panel01.Light ) )
					draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 215, 150, 150, self.Frame.Panel01.Light ) )
				else
					surface.SetDrawColor( 0, 0, 0, 15 )
					surface.SetMaterial( Material( "gui/gradient" ) )
					surface.DrawTexturedRect( 0, 0, w, 40 )
					
					draw.RoundedBox( 0, 0, 40, w, 1, Color( 215, 215, 215, 235 ) )
			
					draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 215, 215, 235 ) )
					draw.RoundedBox( 0, 0, 0, 1, h, Color( 215, 215, 215, 235 ) )
					
					draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 215, 215, 215, 235 ) )
					draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 215, 215, 215, 235 ) )
				end
			end
		else
			surface.SetDrawColor( 0, 0, 0, 15 )
			surface.SetMaterial( Material( "gui/gradient" ) )
			surface.DrawTexturedRect( 0, 0, w, 40 )
					
			draw.RoundedBox( 0, 0, 40, w, 1, Color( 215, 215, 215, 235 ) )
			
			draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 215, 215, 235 ) )
			draw.RoundedBox( 0, 0, 0, 1, h, Color( 215, 215, 215, 235 ) )
			
			draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 215, 215, 215, 235 ) )
			draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 215, 215, 215, 235 ) )
		end
		
		if ( self.Frame.Panel01.ShowType == 1 ) then
			draw.SimpleText( "Software Update Dashboard", "LMAPVote_font01_20", 15, 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			self.Frame.Panel01.ChangelogMenu:SetVisible( false )	
			if ( LMapvote.update.buffer ) then
				if ( GetGlobalBool( "LMapvote.update.Status", false ) == true ) then
					if ( LMapvote.update.buffer[ "Server_Status" ] ) then
						draw.SimpleText( "Server Status - " .. LMapvote.update.buffer[ "Server_Status" ], "LMAPVote_font01_20", w / 2, h * 0.3 - 30, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( "Server Status - OFFLINE :<", "LMAPVote_font01_20", w / 2, h * 0.3 - 30, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
					
					if ( LMapvote.update.buffer[ "Latest_Version" ] ) then
						draw.SimpleText( "Server Latest Version - " .. LMapvote.update.buffer[ "Latest_Version" ] or "Error", "LMAPVote_font01_20", w / 2, h * 0.3, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
					
					if ( LMapvote.config.Version ) then
						draw.SimpleText( "Your Version - " .. LMapvote.config.Version or "Error", "LMAPVote_font01_20", w / 2, h * 0.3 + 30, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
					
					if ( LMapvote.update.buffer[ "Latest_Version" ] and LMapvote.config.Version ) then
						if ( LMapvote.update.buffer[ "Latest_Version" ] == LMapvote.config.Version ) then
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.SetMaterial( Material( "icon16/tick.png" ) )
							surface.DrawTexturedRect( w / 2, h * 0.5 - 16 / 2, 16, 16 )
							draw.SimpleText( "Your LMAPVote is latest version, Thank you :)", "LMAPVote_font01_15", w / 2, h * 0.6, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							self.Frame.Panel01.UpdateLink:SetVisible( false )
							self.Frame.Panel01.CheckUpdate:SetVisible( true )
							self.Frame.Panel01.ShowChangeLog:SetVisible( true )
							self.Frame.Panel01.ShowChangeLog:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 70 )
							self.Frame.Panel01.CheckUpdate:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 35 )
						else
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.SetMaterial( Material( "icon16/error.png" ) )
							surface.DrawTexturedRect( w / 2, h * 0.5 - 16 / 2, 16, 16 )
							draw.SimpleText( "You need Update.. :<", "LMAPVote_font01_15", w / 2, h * 0.6, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							self.Frame.Panel01.UpdateLink:SetVisible( true )
							self.Frame.Panel01.CheckUpdate:SetVisible( true )
							self.Frame.Panel01.ShowChangeLog:SetVisible( true )
							self.Frame.Panel01.ShowChangeLog:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 105 )
							self.Frame.Panel01.CheckUpdate:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 70 )
							self.Frame.Panel01.UpdateLink:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 35 )
						end
					end
				else
					surface.SetDrawColor( 255, 150, 150, 90 )
					surface.SetMaterial( Material( "gui/center_gradient" ) )
					surface.DrawTexturedRect( w / 2 - ( w / 2 ) / 2, h / 2 - 40, w / 2, 25 )
					
					draw.SimpleText( "ERROR", "LMAPVote_font01_20", w / 2, h / 2 - 30, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					draw.SimpleText( "Update check failed - " .. GetGlobalString( "LMapvote.update.Reason", "" ), "LMAPVote_font01_15", w / 2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					self.Frame.Panel01.CheckUpdate:SetVisible( true )
					self.Frame.Panel01.ShowChangeLog:SetVisible( false )
					self.Frame.Panel01.UpdateLink:SetVisible( false )
					self.Frame.Panel01.ShowChangeLog:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 70 )
					self.Frame.Panel01.CheckUpdate:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 35 )
				end
			else
				surface.SetDrawColor( 255, 150, 150, 90 )
				surface.SetMaterial( Material( "gui/center_gradient" ) )
				surface.DrawTexturedRect( w / 2 - ( w / 2 ) / 2, h / 2 - 40, w / 2, 25 )
				
				draw.SimpleText( "ERROR", "LMAPVote_font01_20", w / 2, h / 2 - 30, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "Update check failed - " .. GetGlobalString( "LMapvote.update.Reason", "" ), "LMAPVote_font01_15", w / 2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		elseif ( self.Frame.Panel01.ShowType == 2 ) then
			draw.SimpleText( "Update log", "LMAPVote_font01_20", 15, 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			self.Frame.Panel01.UpdateLink:SetVisible( false )
			self.Frame.Panel01.CheckUpdate:SetVisible( false )
			self.Frame.Panel01.ChangelogMenu:SetVisible( true )	
		end
	end
	
	self.Frame.Panel01.CheckUpdate = vgui.Create( "DButton", self.Frame.Panel01 )
	self.Frame.Panel01.CheckUpdate:SetSize( self.Frame.Panel01.w - 10, 30 )
	self.Frame.Panel01.CheckUpdate:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 70 )
	self.Frame.Panel01.CheckUpdate:SetFont( "LMAPVote_font01_20" )
	self.Frame.Panel01.CheckUpdate:SetText( "Check update" )
	self.Frame.Panel01.CheckUpdate:SetColor( Color( 0, 0, 0, 255 ) )
	self.Frame.Panel01.CheckUpdate.Block = false
	self.Frame.Panel01.CheckUpdate.Rotate = 0
	self.Frame.Panel01.CheckUpdate.Status = true
	self.Frame.Panel01.CheckUpdate.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( !self.Frame ) then return end
		if ( !self.Frame.Panel01.CheckUpdate.Block ) then
			if ( self.Frame ) then
				self.Frame.Panel01.CheckUpdate.Status = true
				self.UpdateCheckDeleayed = true
				self.Frame.Panel01.CheckUpdate.Block = true
				
			end
			LMapvote.update.Check( )
			timer.Simple( 3, function( )
				if ( self.Frame and IsValid( self.Frame ) ) then
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
					if ( self.Frame and IsValid( self.Frame ) ) then
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
				self.Frame.Panel01.CheckUpdate.Rotate = self.Frame.Panel01.CheckUpdate.Rotate + 5
			else
				self.Frame.Panel01.CheckUpdate.Rotate = 0
			end
		else
			self.Frame.Panel01.CheckUpdate.Block = false
			if ( self.Frame.Panel01.CheckUpdate.Rotate >= 0 ) then
				self.Frame.Panel01.CheckUpdate.Rotate = self.Frame.Panel01.CheckUpdate.Rotate - 5
			end
			if ( self.Frame.Panel01.CheckUpdate.Rotate <= 0 ) then
				self.Frame.Panel01.CheckUpdate.Rotate = 0
			end
		end
		
		if ( !self.Frame.Panel01.CheckUpdate.Status ) then
			surface.SetDrawColor( 255, 150, 150, 150 )
			surface.SetMaterial( Material( "gui/center_gradient" ) )
			surface.DrawTexturedRect( 0, 0, w, h )
		end
		
		draw.NoTexture( )
		if ( self.Frame.Panel01.CheckUpdate.Status ) then
			surface.SetDrawColor( 0, 0, 0, 255 )
		else
			surface.SetDrawColor( 255, 0, 0, 255 )
			LMapvote.geometry.DrawCircle( 30, h / 2, 8, 3, 90, 360, 100 )
			return
		end
		LMapvote.geometry.DrawCircle( 30, h / 2, 8, 3, 90, self.Frame.Panel01.CheckUpdate.Rotate, 100 )
	end
	
	self.Frame.Panel01.UpdateLink = vgui.Create( "DButton", self.Frame.Panel01 )
	self.Frame.Panel01.UpdateLink:SetSize( self.Frame.Panel01.w - 10, 30 )
	self.Frame.Panel01.UpdateLink:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 35 )
	self.Frame.Panel01.UpdateLink:SetFont( "LMAPVote_font01_20" )
	self.Frame.Panel01.UpdateLink:SetText( "Update URL" )
	self.Frame.Panel01.UpdateLink:SetColor( Color( 0, 0, 0, 255 ) )
	self.Frame.Panel01.UpdateLink.DoClick = function( )
		LMapvote.PlayButtonSound( )
		gui.OpenURL( "http://github.com/L7D/LMAPVote" )
	end
	self.Frame.Panel01.UpdateLink.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 20 ) )
	end
	
	self.Frame.Panel01.ShowChangeLog = vgui.Create( "DButton", self.Frame.Panel01 )
	self.Frame.Panel01.ShowChangeLog:SetSize( self.Frame.Panel01.w - 10, 30 )
	self.Frame.Panel01.ShowChangeLog:SetPos( self.Frame.Panel01.w / 2 - ( self.Frame.Panel01.w - 10 ) / 2, self.Frame.Panel01.h - 105 )
	self.Frame.Panel01.ShowChangeLog:SetFont( "LMAPVote_font01_20" )
	self.Frame.Panel01.ShowChangeLog:SetText( "Show Update log" )
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
			self.Frame.Panel01.ShowChangeLog:SetText( "Show Update log" )
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
	
	self.Frame.Panel02.w = self.w * 0.7 - 50
	self.Frame.Panel02.h = self.h * 0.4
	self.Frame.Panel02.x = ( 30 + self.w / 3 - ( 10 * 3 ) - ( 15 ) )
	self.Frame.Panel02.y = 50
	
	self.Frame.Panel02:SetSize( self.Frame.Panel02.w, self.Frame.Panel02.h )
	self.Frame.Panel02:SetPos( self.Frame.Panel02.x, self.Frame.Panel02.y )
	self.Frame.Panel02.Paint = function( pnl, w, h )
		surface.SetDrawColor( 0, 0, 0, 15 )
		surface.SetMaterial( Material( "gui/gradient" ) )
		surface.DrawTexturedRect( 0, 0, w, 40 )
		
		draw.RoundedBox( 0, 0, 40, w, 1, Color( 215, 215, 215, 235 ) )
		
		draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 215, 215, 235 ) )
		draw.RoundedBox( 0, 0, 0, 1, h, Color( 215, 215, 215, 235 ) )
		
		draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 215, 215, 215, 235 ) )
		draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 215, 215, 215, 235 ) )
		
		draw.SimpleText( "Map List Dashboard", "LMAPVote_font01_20", 15, 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
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

	self.Frame.Panel03 = vgui.Create( "DPanel", self.Frame )
	
	self.Frame.Panel03.w = self.w / 3 - ( 10 * 3 ) - ( 15 )
	self.Frame.Panel03.h = self.h * 0.4
	self.Frame.Panel03.x = 15
	self.Frame.Panel03.y = self.h * 0.5
	self.Frame.Panel03.ShowType = 1
	self.Frame.Panel03.CurrRotated = 0
	
	self.Frame.Panel03:SetSize( self.Frame.Panel03.w, self.Frame.Panel03.h )
	self.Frame.Panel03:SetPos( self.Frame.Panel03.x, self.Frame.Panel03.y )
	self.Frame.Panel03.Paint = function( pnl, w, h )
		surface.SetDrawColor( 0, 0, 0, 15 )
		surface.SetMaterial( Material( "gui/gradient" ) )
		surface.DrawTexturedRect( 0, 0, w, 40 )
		
		draw.RoundedBox( 0, 0, 40, w, 1, Color( 215, 215, 215, 235 ) )
		
		draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 215, 215, 235 ) )
		draw.RoundedBox( 0, 0, 0, 1, h, Color( 215, 215, 215, 235 ) )
		
		draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 215, 215, 215, 235 ) )
		draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 215, 215, 215, 235 ) )
		
		draw.SimpleText( "Vote Status Dashboard", "LMAPVote_font01_20", 15, 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		if ( LMapvote.system.vote.GetStatus( ) == true ) then
			if ( self.Frame.Panel03.CurrRotated <= 360 ) then
				self.Frame.Panel03.CurrRotated = self.Frame.Panel03.CurrRotated + 3
			else
				self.Frame.Panel03.CurrRotated = 0
			end
			draw.NoTexture( )
			surface.SetDrawColor( 100, 255, 100, 255 )
			LMapvote.geometry.DrawCircle( 50, h * 0.3, 10, 3, 90, self.Frame.Panel03.CurrRotated, 100 )
			draw.SimpleText( "Vote has currently progressing.", "LMAPVote_font01_20", w / 2, h * 0.3, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( string.ToMinutesSeconds( LMapvote.system.vote.GetTimeLeft( ) ) .. " after do map vote finished.", "LMAPVote_font01_20", w / 2, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			self.Frame.Panel03.CurrRotated = 0
			draw.SimpleText( "Vote has not currently progressing.", "LMAPVote_font01_20", w / 2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	
	self.Frame.Panel03.Vote = vgui.Create( "DButton", self.Frame.Panel03 )
	self.Frame.Panel03.Vote:SetSize( self.Frame.Panel03.w - 10, 30 )
	self.Frame.Panel03.Vote:SetPos( self.Frame.Panel03.w / 2 - ( self.Frame.Panel03.w - 10 ) / 2, self.Frame.Panel03.h - 35 )
	self.Frame.Panel03.Vote:SetFont( "LMAPVote_font01_20" )
	self.Frame.Panel03.Vote:SetText( "" )
	self.Frame.Panel03.Vote:SetColor( Color( 0, 0, 0, 255 ) )
	self.Frame.Panel03.Vote.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( LMapvote.system.vote.GetStatus( ) == true ) then
			LMapvote.derma.queryMSG( "Are you sure stop map vote?", "WARNING", "Yes", "No", function( ) RunConsoleCommand( "LMAPVote_vote_stop" ) end )
		else
			LMapvote.derma.queryMSG( "Are you sure start map vote?", "WARNING", "Yes", "No", function( ) RunConsoleCommand( "LMAPVote_vote_start" ) end )
		end
	end
	self.Frame.Panel03.Vote.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 20 ) )
		if ( LMapvote.system.vote.GetStatus( ) == true ) then
			self.Frame.Panel03.Vote:SetText( "VOTE STOP" )
		else
			self.Frame.Panel03.Vote:SetText( "VOTE START" )
		end
	end

	self.Frame.Contact = vgui.Create( "DButton", self.Frame )
	self.Frame.Contact:SetPos( 30 + self.w * 0.15, self.h - 40 )
	self.Frame.Contact:SetSize( self.w * 0.15, 30 )
	self.Frame.Contact:SetText( "Contact ME :)" )
	self.Frame.Contact:SetFont( "LMAPVote_font01_20" )
	self.Frame.Contact:SetColor( Color( 0, 0, 0, 255 ) )
	self.Frame.Contact.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 15 ) )
	end
	self.Frame.Contact.DoClick = function( )
		LMapvote.PlayButtonSound( )
		LMapvote.derma.message( "Thanks for using LMAPVote, I always thanks by yours!", "Thanks", "OK" )
		gui.OpenURL( "http://steamcommunity.com/profiles/76561198011675377" )
	end

	self.Frame.CloseButton = vgui.Create( "DButton", self.Frame )
	self.Frame.CloseButton:SetPos( 15, self.h - 40 )
	self.Frame.CloseButton:SetSize( self.w * 0.15, 30 )
	self.Frame.CloseButton:SetText( "Close" )
	self.Frame.CloseButton:SetFont( "LMAPVote_font01_20" )
	self.Frame.CloseButton:SetColor( Color( 0, 0, 0, 255 ) )
	self.Frame.CloseButton.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 150, 150, 100 ) )
	end
	self.Frame.CloseButton.DoClick = function( )
		LMapvote.PlayButtonSound( )
		self:Close( )
	end
	
	self:Refresh_Maplist( )
end

function ADMINPANEL:Refresh_Changelog( )
	if ( !LMapvote.update.buffer ) then return end
	if ( self.Frame.Panel01.ShowType != 2 ) then return end
	if ( !LMapvote.update.buffer[ "Update_Log" ] ) then
		LMapvote.derma.message( "Can't load update log data, please reopen administrator menu.", "ERROR", "Okay" )
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
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.SetMaterial( Material( "gui/gradient" ) )
			surface.DrawTexturedRect( 0, h - 1, w * 0.8, 1 )
							
			if ( value.status == "0" ) then
				draw.RoundedBox( 0, w - 75, 0, 75, h, Color( 0, 0, 0, 150 ) )
				draw.SimpleText( "Release", "LMAPVote_font01_20", w - 10, h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )				
			elseif ( value.status == "1" ) then
				draw.RoundedBox( 0, w - 50, 0, 50, h, Color( 255, 255, 150, 100 ) )
				draw.SimpleText( "Add", "LMAPVote_font01_20", w - 10, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			elseif ( value.status == "2" ) then
				draw.RoundedBox( 0, w - 40, 0, 40, h, Color( 255, 150, 150, 100 ) )
				draw.SimpleText( "Fix", "LMAPVote_font01_20", w - 10, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )		
			elseif ( value.status == "3" ) then
				draw.RoundedBox( 0, w - 75, 0, 75, h, Color( 255, 150, 255, 100 ) )
				draw.SimpleText( "Module", "LMAPVote_font01_20", w - 10, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )	
			elseif ( value.status == "4" ) then
				draw.RoundedBox( 0, w - 95, 0, 95, h, Color( 0, 255, 255, 100 ) )
				draw.SimpleText( "UI Change", "LMAPVote_font01_20", w - 10, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			elseif ( value.status == "5" ) then
				draw.RoundedBox( 0, w - 75, 0, 75, h, Color( 0, 255, 150, 100 ) )
				draw.SimpleText( "Change", "LMAPVote_font01_20", w - 10, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			draw.SimpleText( key .. ". " .. value.text, "LMAPVote_font01_15", 5, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		
		self.Frame.Panel01.ChangelogMenu:AddItem( panel )
	end
end

function ADMINPANEL:Refresh_Maplist( )
	if ( !LMapvote.map.buffer ) then
		LMapvote.derma.message( "Can't load map data, please reopen administrator menu.", "ERROR", "Okay" )
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
		panel:SetSize( 150, 150 )
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
					draw.SimpleText( "No map icon :/", "LMAPVote_font01_15", w / 2, h / 2 - ( 20 / 2 ), Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			end

			draw.RoundedBox( 0, 0, h - 20, w, 20, Color( 0, 0, 0, 100 ) )
			draw.SimpleText( value.Name, "LMAPVote_font01_15", w / 2, h - ( 20 / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		self.Frame.Panel02.MaplistMenu:AddItem( panel )
	end
end

function ADMINPANEL:Close( )
	if ( !self ) then return end
	if ( !self.Frame ) then return end
	self.Frame:Remove( )
	self.Frame = nil
	LMapvote.panel.adminPanel = nil
end

vgui.Register( "LMapVote_ADMIN", ADMINPANEL, "Panel" )