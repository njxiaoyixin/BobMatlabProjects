function TradeTimeSeries = F_GenerateTradeTimeSeries(obj,Dates,Exchange,TimeZone,NightSessionFlag)
            if nargin < 5
                NightSessionFlag = 1; %��ҹ��
            end
            if nargin <4
                TimeZone = obj.TimeZone;
            end
            if nargin <3
                Exchange = obj.Exchange;
            end
            
            TradeTimeSeries = [];
            for i=1:numel(Dates)
                ThisTimeSeries = [];
                if strcmpi(Exchange,'CB')
                    
                elseif strcmpi(Exchange,'CM') || strcmpi(Exchange,'NM')
                    
                else %�����ڻ�������
                    if NightSessionFlag
                        if weekday(Dates(i))==2  %�������һ��������忪ʼ��
                            ThisTimeSeries = -3+21/24:(Interval/24/60):25/24;
                        else
                            ThisTimeSeries = -1+21/24:(Interval/24/60):25/24;
                        end
                    end
                    ThisTimeSeries = [ThisTimeSeries,9/24:(Interval/24/60):(10+0.25)/24,(10+0.5)/24:(Interval/24/60):(11+0.5)/24,(13+0.5)/24:(Interval/24/60):15/24]';
                end
                TradeTimeSeries = [TradeTimeSeries,Dates(i)+ThisTimeSeries]';
            end
        end