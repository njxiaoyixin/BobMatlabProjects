function OutputTime    = F_ChangeTimeZone(obj,Time,TimeZone,TargetTimeZone)
            import Tools.*
            if nargin < 4
                TargetTimeZone = obj.TargetTimeZone;
            end
            
            if nargin < 3
                TimeZone = obj.TimeZone;
            end
            if ~strcmpi(TargetTimeZone,TimeZone)
                %�����EST����CSTʱ�䣬���ж���ʱ�ĵ�������Ҫ����Ϊ�й�ʱ��
%                 if (strcmpi(TimeZone,'EST') || strcmpi(TimeZone,'CST')) && strcmpi(TargetTimeZone,'CN')
%                     TimeDelay = zeros(size(Time));
%                     for i=1:numel(Time)
%                         disp(i)
%                         if is_Daylight_Savings2(datestr(Time(i),'mm/dd/yyyy'))
%                             TimeDelay(i)=12/24;
%                         else
%                             TimeDelay(i)=13/24;
%                         end
%                     end
%                     
%                     if strcmpi(TimeZone,'CST')  %�в�ʱ������1Сʱ
%                         TimeDelay=TimeDelay+1/24;
%                     end
%                     OutputTime = Time + TimeDelay;
%                 elseif strcmpi(TargetTimeZone,'EST') || strcmpi(TargetTimeZone,'CST')
%                     TimeAhead = zeros(size(Time));
%                     for i=1:numel(Time)
%                         if is_Daylight_Savings2(datestr(Time(i),'mm/dd/yyyy'))
%                             TimeAhead(i)=12/24;
%                         else
%                             TimeAhead(i)=13/24;
%                         end
%                     end
%                     if strcmpi(TimeZone,'CST')  %�в�ʱ������1Сʱ
%                         TimeAhead=TimeAhead+1/24;
%                     end
%                     OutputTime = Time - TimeAhead;
%                 end
                if strcmpi(TimeZone,'EST') 
                    fromTimezone = 'America/New_York';
                elseif strcmpi(TimeZone,'CST')
                    fromTimezone = 'America/Chicago';
                elseif strcmpi(TimeZone,'CN')
                    fromTimezone = 'Asia/Chongqing';
                else
                    fromTimezone = 'Asia/Chongqing';
                end
                
                if strcmpi(TargetTimeZone,'EST')
                    toTimezone = 'America/New_York';
                elseif strcmpi(TargetTimeZone,'CST')
                    toTimezone = 'America/Chicago';
                elseif strcmpi(TargetTimeZone,'CN')
                    toTimezone = 'Asia/Chongqing';
                else
                    toTimezone = 'Asia/Chongqing';
                end
                OutputTime = nan(size(Time));
                %                     disp(i)
                if ~strcmpi(fromTimezone,toTimezone)
                [ OutputTime ] = TimezoneConvert( Time, fromTimezone, toTimezone );
                else
                    OutputTime = Time;
                end
            else
                OutputTime     = Time;
            end
        end
        %����ʱ�䣬�ı�ʱ��