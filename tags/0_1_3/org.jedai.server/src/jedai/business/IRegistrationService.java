package jedai.business;

import jedai.business.exceptions.ExistingUserException;
import jedai.vo.RegistrationVO;

/**
 * @author dominickaccattato
 *
 */
public interface IRegistrationService {

	/**
	 * @param vo
	 * @return
	 * @throws ExistingUserException
	 */
	public boolean register(RegistrationVO vo) throws ExistingUserException;
}
