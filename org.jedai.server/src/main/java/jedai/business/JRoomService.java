package jedai.business;

import org.red5.server.api.Red5;
import org.red5.server.api.ScopeUtils;

import jedai.domain.Room;
import jedai.vo.RoomVO;

/*
 * Jedai Networking Framework - http://jedai.googlecode.com
 * 
 * Copyright (c) 2006-2009 by respective authors (see below). All rights reserved.
 * 
 * This library is free software; you can redistribute it and/or modify it under the 
 * terms of the GNU Lesser General Public License as published by the Free Software 
 * Foundation; either version 2.1 of the License, or (at your option) any later 
 * version. 
 * 
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY 
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License along 
 * with this library; if not, write to the Free Software Foundation, Inc., 
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
 */

/**
 * @author dominickaccattato
 *
 */
public class JRoomService implements IRoomService {


	@Override
	public void createRoom(RoomVO room) {
		String roomName = room.getName();

		//Red5.getConnectionLocal().getScope();

//		ils.resolveScope(appScope, roomName);
//		if (roomScope == null) {
//			if (appScope.createChildScope
		
	}

	@Override
	public void deleteRoom(RoomVO room) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateRoom(RoomVO room) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void getRoom(int roomId) {
		// TODO Auto-generated method stub
		
	}

}
