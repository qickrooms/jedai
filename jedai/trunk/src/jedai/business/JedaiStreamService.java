package jedai.business;

import org.red5.server.api.IBasicScope;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.event.IEvent;
import org.red5.server.api.service.IServiceCall;
import org.red5.server.api.stream.IBroadcastStream;
import org.red5.server.api.stream.IPlayItem;
import org.red5.server.api.stream.IPlaylistSubscriberStream;
import org.red5.server.api.stream.IStreamAwareScopeHandler;
import org.red5.server.api.stream.ISubscriberStream;

public class JedaiStreamService implements IStreamAwareScopeHandler {

	@Override
	public void streamBroadcastClose(IBroadcastStream stream) {
		// TODO Auto-generated method stub

	}

	@Override
	public void streamBroadcastStart(IBroadcastStream stream) {
		// TODO Auto-generated method stub

	}

	@Override
	public void streamPlaylistItemPlay(IPlaylistSubscriberStream stream,
			IPlayItem item, boolean isLive) {
		// TODO Auto-generated method stub

	}

	@Override
	public void streamPlaylistItemStop(IPlaylistSubscriberStream stream,
			IPlayItem item) {
		// TODO Auto-generated method stub

	}

	@Override
	public void streamPlaylistVODItemPause(IPlaylistSubscriberStream stream,
			IPlayItem item, int position) {
		// TODO Auto-generated method stub

	}

	@Override
	public void streamPlaylistVODItemResume(IPlaylistSubscriberStream stream,
			IPlayItem item, int position) {
		// TODO Auto-generated method stub

	}

	@Override
	public void streamPlaylistVODItemSeek(IPlaylistSubscriberStream stream,
			IPlayItem item, int position) {
		// TODO Auto-generated method stub

	}

	@Override
	public void streamPublishStart(IBroadcastStream stream) {
		// TODO Auto-generated method stub

	}

	@Override
	public void streamRecordStart(IBroadcastStream stream) {
		// TODO Auto-generated method stub

	}

	@Override
	public void streamSubscriberClose(ISubscriberStream stream) {
		// TODO Auto-generated method stub

	}

	@Override
	public void streamSubscriberStart(ISubscriberStream stream) {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean addChildScope(IBasicScope scope) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean connect(IConnection conn, IScope scope, Object[] params) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void disconnect(IConnection conn, IScope scope) {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean join(IClient client, IScope scope) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void leave(IClient client, IScope scope) {
		// TODO Auto-generated method stub

	}

	@Override
	public void removeChildScope(IBasicScope scope) {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean serviceCall(IConnection conn, IServiceCall call) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean start(IScope scope) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void stop(IScope scope) {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean handleEvent(IEvent event) {
		// TODO Auto-generated method stub
		return false;
	}

}
