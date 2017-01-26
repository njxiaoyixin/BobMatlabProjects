classdef ibxyx < handle
    properties
        Handle
        ClientId
        Host
        Port
    end
    
    methods
        function obj = ibxyx(Host,Port,ClientId)
            if nargin<3
                ClientId = 2;
            end
            if nargin<2
                Port = 7496;
            end
            if nargin<1
                Host = '127.0.0.1';
            end
            obj.Handle = actxserver('Tws.TwsCtrl.1');
%             obj.Handle.connect('127.0.0.1',7496,3);
            obj.ClientId = ClientId;
            obj.Host = Host;
            obj.Port = Port;
        end
    end
end