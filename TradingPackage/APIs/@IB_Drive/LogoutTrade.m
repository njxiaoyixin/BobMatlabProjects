function LogoutTrade(obj)
obj.UnRegisterallEvents
obj.LoginId.Handle.disconnect;
disp([datestr(now,'HH:MM:SS'),'---IB�˳���½�ɹ�.---'])
end