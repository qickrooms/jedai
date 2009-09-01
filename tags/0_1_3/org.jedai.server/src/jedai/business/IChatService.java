package jedai.business;

import jedai.vo.ChatVO;
import jedai.vo.RoomVO;

/**
 * @author dominickaccattato
 *
 */
public interface IChatService {

	/**
	 * @param chat
	 */
	public void updateChat(ChatVO chat);
}
