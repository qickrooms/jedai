package jedai.business;

import jedai.vo.RoomVO;

/**
 * @author dominickaccattato
 *
 */
public interface ILobbyService {
	
	/**
	 * @param room
	 */
	public void getRooms(RoomVO room);
	/**
	 * @param room
	 */
	public void getRoom(RoomVO room);
	/**
	 * @param room
	 */
	public void addRoom(RoomVO room);
	/**
	 * @param room
	 */
	public void deleteRoom(RoomVO room);
	/**
	 * @param room
	 */
	public void updateRoom(RoomVO room);
}
