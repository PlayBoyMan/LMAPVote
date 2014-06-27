--[[
	LMAPVote - Development Version 0.5a
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
	
	self.Frame = vgui.Create( "DFrame" )
	self.Frame:SetSize( self.w, self.h )
	self.Frame:SetPos( self.x, self.y )
	self.Frame:SetTitle( "" )
	self.Frame:ShowCloseButton( true )
	self.Frame:MakePopup( )
	self.Frame:Center( )
	self.Frame.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )

		draw.SimpleText( "LMAPVote Administrator", "LMapVote_font_01", 15, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Copyright ( C ) 2014 ~ L7D : Version 0.5A", "LMapVote_font_04", 15, h - 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

end

vgui.Register( "LMapVote_ADMIN", ADMINPANEL, "Panel" )

do
	if ( adminPanel.Frame ) then
		adminPanel.Frame:Remove( )
		adminPanel.Frame = nil
		adminPanel = vgui.Create( "LMapVote_ADMIN" )
	end
end