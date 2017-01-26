javaaddpath('C:\Users\Administrator\Downloads\TwsJavaClient.jar')
df = com.ib.client.DataFeed;
ip_address = '127.0.0.1'; % host running IB TWS
port = 7496;
df.connect(ip_address, port, randi(1e6));

% download 1 year of daily bars (that is max)
days_back = 252;
bars = df.backfill_daily_bars('XLF', days_back);
T = datenum(cell(bars.datetime));
Pc = bars.close;
Po = bars.open;
V = bars.volume;
 
% download 10 days of minute bars
days_back = 10;
bars = df.backfill_1min_bars('XLF', days_back);
T = datenum(cell(bars.datetime));
Pc = bars.close;
Po = bars.open;
V = bars.volume;
 
% disconnect
df.disconnect();