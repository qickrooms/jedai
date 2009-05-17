package jedai.business.exceptions;

import java.io.IOException;

public class ExistingUserException extends IOException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public ExistingUserException(String msg) {
		super(msg);
	}
}
