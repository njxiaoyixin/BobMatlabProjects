function UnRegisterallEvents(obj)
evtListeners = obj.LoginId.Handle.eventlisteners;
for i=1:size(evtListeners,1)
    obj.LoginId.Handle.unregisterevent({evtListeners{i,1} evtListeners{i,2}});
end
end