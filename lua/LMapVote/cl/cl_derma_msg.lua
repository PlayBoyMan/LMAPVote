--[[
	LMAPVote - 1.6
	Copyright ( C ) 2015 ~ L7D
--]]

LMapvote.derma = LMapvote.derma or { }

function LMapvote.derma.message( msg, title, okstr )
	if ( LMapvote.derma.msg ) then
		LMapvote.derma.msg:Remove( )
		LMapvote.derma.msg = nil
	end
	
	surface.PlaySound( "buttons/combine_button1.wav" )

	LMapvote.derma.msg = vgui.Create( "DFrame" )
	
	LMapvote.derma.msg.w = ScrW( )
	LMapvote.derma.msg.h = ScrH( ) * 0.1
	LMapvote.derma.msg.x = ScrW( ) / 2 - LMapvote.derma.msg.w / 2
	LMapvote.derma.msg.y = ScrH( ) / 2 - LMapvote.derma.msg.h / 2	

	LMapvote.derma.msg:SetSize( LMapvote.derma.msg.w, LMapvote.derma.msg.h )
	LMapvote.derma.msg:SetPos( LMapvote.derma.msg.x, LMapvote.derma.msg.y )
	LMapvote.derma.msg:SetTitle( "" )
	LMapvote.derma.msg:ShowCloseButton( false )
	LMapvote.derma.msg:SetDraggable( false )
	LMapvote.derma.msg:MakePopup( )
	LMapvote.derma.msg.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )
		draw.SimpleText( msg or "Message", "LMAPVote_font02_25", w * 0.2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	LMapvote.derma.msg.OK = vgui.Create( "DButton", LMapvote.derma.msg )
	LMapvote.derma.msg.OK:SetSize( surface.GetTextSize( okstr ) + 15, 20 )
	LMapvote.derma.msg.OK:SetText( okstr or "OK" )
	LMapvote.derma.msg.OK:SetFont( "LMAPVote_font01_20" )
	LMapvote.derma.msg.OK:SetColor( Color( 0, 0, 0, 255 ) )
	LMapvote.derma.msg.OK.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	LMapvote.derma.msg.OK.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( LMapvote.derma.msg ) then
			LMapvote.derma.msg:Remove( )
			LMapvote.derma.msg = nil
		end
	end
	
	LMapvote.derma.msg.OK:SetPos( LMapvote.derma.msg.w - LMapvote.derma.msg.OK:GetWide( ) - 10, LMapvote.derma.msg.h - 30 )
end

function LMapvote.derma.queryMSG( query, title, okstr, nostr, okFunc, noFunc )
	if ( LMapvote.derma.query ) then
		LMapvote.derma.query:Remove( )
		LMapvote.derma.query = nil
	end
	
	surface.PlaySound( "buttons/combine_button1.wav" )

	LMapvote.derma.query = vgui.Create( "DFrame", LMapvote.derma.query_back )
	
	LMapvote.derma.query.w = ScrW( )
	LMapvote.derma.query.h = ScrH( ) * 0.1
	LMapvote.derma.query.x = ScrW( ) / 2 - LMapvote.derma.query.w / 2
	LMapvote.derma.query.y = ScrH( ) / 2 - LMapvote.derma.query.h / 2	

	LMapvote.derma.query:SetSize( LMapvote.derma.query.w, LMapvote.derma.query.h )
	LMapvote.derma.query:SetPos( LMapvote.derma.query.x, LMapvote.derma.query.y )
	LMapvote.derma.query:SetTitle( "" )
	LMapvote.derma.query:ShowCloseButton( false )
	LMapvote.derma.query:SetDraggable( false )
	LMapvote.derma.query:MakePopup( )
	LMapvote.derma.query.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )
		draw.SimpleText( query or "Message", "LMAPVote_font02_25", w * 0.2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	LMapvote.derma.query.OK = vgui.Create( "DButton", LMapvote.derma.query )
	LMapvote.derma.query.OK:SetSize( surface.GetTextSize( okstr ) + 15, 20 )
	LMapvote.derma.query.OK:SetText( okstr or "OK" )
	LMapvote.derma.query.OK:SetFont( "LMAPVote_font01_20" )
	LMapvote.derma.query.OK:SetColor( Color( 0, 0, 0, 255 ) )
	LMapvote.derma.query.OK.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 8 ) )
	end
	LMapvote.derma.query.OK.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( okFunc ) then
			okFunc( )
		end
		if ( LMapvote.derma.query ) then
			LMapvote.derma.query:Remove( )
			LMapvote.derma.query = nil
		end
	end
	
	LMapvote.derma.query.NO = vgui.Create( "DButton", LMapvote.derma.query )
	LMapvote.derma.query.NO:SetSize( surface.GetTextSize( nostr ) + 15, 20 )
	LMapvote.derma.query.NO:SetText( nostr or "NO" )
	LMapvote.derma.query.NO:SetFont( "LMAPVote_font01_20" )
	LMapvote.derma.query.NO:SetColor( Color( 0, 0, 0, 255 ) )
	LMapvote.derma.query.NO.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 150, 150, 100 ) )
	end
	LMapvote.derma.query.NO.DoClick = function( )
		LMapvote.PlayButtonSound( )
		if ( noFunc ) then
			noFunc( )
		end
		if ( LMapvote.derma.query ) then
			LMapvote.derma.query:Remove( )
			LMapvote.derma.query = nil
		end
	end
	
	LMapvote.derma.query.OK:SetPos( LMapvote.derma.query.w - LMapvote.derma.query.OK:GetWide( ) - LMapvote.derma.query.NO:GetWide( ) - 30, LMapvote.derma.query.h - 30 )
	LMapvote.derma.query.NO:SetPos( LMapvote.derma.query.w - LMapvote.derma.query.NO:GetWide( ) - 10, LMapvote.derma.query.h - 30 )
end