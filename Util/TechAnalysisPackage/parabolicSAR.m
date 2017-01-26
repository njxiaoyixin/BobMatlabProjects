function [SAR,turnPoints,longshort]= parabolicSAR( high,low,AFstart,AFmax,AFdelta)
% PARABOLICSAR - calculated parabolic SAR for specific hugh and low

% INPUT:
% high - high values vector
% low - low values vector
% AFstart - start value for Wilderes acceleration factor (typical 0.02)
% AFmax - max value for Wilderes acceleration factor (typical 0.2)
% AFdelta - delta value for Wilderes acceleration factor (typical 0.02)
%
% OUTPUT:
% SAR - output vector of parabolc SAR
% turnPoints - turn places in SAR vector
% longshort - long=1, short=-1
%
% EXAMPLE:
% % read JNJ stock data
% url2Read = 'http://ichart.finance.yahoo.com/table.csv?s=JNJ&a=0&b=12&c=2006&d=9&e=23&f=2007&g=w&ignore=.csv';
% s=urlread( url2Read);
% % changing the format of s f
% s=strread(s,'%s','delimiter',',');
% s=reshape(s,[],length(s)/7)';
% % calc SAR
% dateNum = datenum(s(2:end,1));
% open = str2double(s(2:end,2));
% high = str2double(s(2:end,3));
% low = str2double(s(2:end,4));
% close = str2double(s(2:end,5));
% [SAR,turnPoints,longshort]=parabolicSAR( high,low);
%
% % plot
% figure(1)
% title('parabolic SAR: JNJ');
% xlabel('date');
% ylabel('price');
%
% ylim = [min(high) max(high)];
% set( gca,'ylim',ylim);
%
% hold on;
% % plot stock;
% plot(dateNum,high,'b','LineWidth',2);
% % plot turn points
% line([dateNum(turnPoints) dateNum(turnPoints)]', [ ones(length(turnPoints),1)*ylim ]','Color',[0 0 0]);
%
% % plot SAR long in green
% index=find(longshort==1);
% plot(dateNum(index),SAR(index),'.g');
% % plot SAR short in red
% index=find(longshort==-1);
% plot(dateNum(index),SAR(index),'.r');
% hold off;
% legend('stock','turn points');
% datetick(gca,'x',20);

% INFO:
% The parabolic study is a “true reversal?indicator in that it is always in the market. Whenever a position is closed-out, it is also reversed. T
% he point at which a position is reversed is called a Stop and Reverse (SAR). A
% lthough stops are plotted for each bar, a trade is reversed only when the SAR is penetrated by a price.
%
% Formula:
% SARt+1=SARt+AF*(EPtrade-SARt)
%
% Where:
% SARt+1 = next periods SAR
% SARt = current SAR
% AF = begins at .02 and increases by .02 to a maximum of .20
% EP = extreme price (high if long; low if short)
%
%  The initial SAR or SIP (SAR Initial Point) of a long move is found by looking for the first bar with a higher high and a higher low than the previous bar.
%  The converse of this is used to find the SIP for a short move.
%  The acceleration factor changes as the trade progresses, starting at .02 and increasing in increments of .02 for each bar in which a new extreme occurs.
%
% see, J. Welles Wilder, Jr., New Concepts in Technical Trading Systems, McLeansville, NC: Trend Research, 1978, pp. 9-22.

% $License: BSD (use/copy/change/redistribute on own risk, mention the
% author) $
% History:
% 001: 01-May-2006 ,Natanel Eizenberg, First version.
% 002: 04-Nov-2012, Natanel Eizenberg, prepare for file exchange

% all values should be lined
if size(high,1)~=1; high=high'; end;
if size(low,1)~=1; low=low'; end;

type=1; %type=1 - high(i) & low(i), type=2 - maxHigh & minLow
% %filter high and low
% high=conv(high,[1 1 1 1 1 1])/6;
% high=high(5:161);
% low=conv(low,[1 1 1 1 1 1])/6;
% low=low(5:161);

% defults AFstart,  AFmax, AFdelta
if nargin==2
    AFstart=0.02;
    AFmax=0.2;
    AFdelta=0.02;
elseif nargin==3
    AFmax=0.2;
    AFdelta=0.02;
elseif nargin==4
    AFdelta=0.02;
end;

%memory allocation
SAR=zeros(size(high));
longshort=zeros(size(high));
turnPoints=zeros(size(high)); j=1;

% reset AF
AF=AFstart;

% SIP (SAR Initial Point) and first SAR
if high(1)<high(2)
    position=1;
    SAR(1)=min(low(1),low(2));
    maxHigh=max(high(1),high(2));
else
    position=-1;
    SAR(1)=max(high(1),high(2));
    minLow=min(low(1),low(2));
end;

% main loop
for i=2:length(high)

    % update AF
    if (AF<AFmax)
        if (position>0 && high(i)>maxHigh)
            maxHigh=high(i);
            AF=AF+AFdelta;
        elseif (position<0 && low(i)<minLow)
            minLow=low(i);
            AF=AF+AFdelta;
        end;
    end;

    % new SAR
    if position>0
        if type==1
            SAR(i)=AF*(high(i)-SAR(i-1))+SAR(i-1);
        else
            SAR(i)=AF*(maxHigh-SAR(i-1))+SAR(i-1);
        end;
        longshort(i)=1;
    else %strcmp(position,'short')
        if type==1
            SAR(i)=AF*(low(i)-SAR(i-1))+SAR(i-1);
        else
            SAR(i)=AF*(minLow-SAR(i-1))+SAR(i-1);
        end
        longshort(i)=-1;
    end;


    % check for turning point
    if strcmp(position,'long')
        if (SAR(i)>low(i) || SAR(i)>low(i-1))
            AF=AFstart; %reset AF
            minLow=min(low(i),low(i-1)); % new minmum low
            SARt=max(high(i),high(i-1)); %use SARt as last day SAR
            if type==1
                SAR(i)=AF*(low(i)-SARt)+SARt; % new SAR as short
            else
                SAR(i)=AF*(minLow-SARt)+SARt; % new SAR as short
            end
            position='short';
            turnPoints(j)=i; j=j+1;
            longshort(i)=-1;
        end;
    else %if strcmp(position,'short')
        if (SAR(i)<high(i) || SAR(i)<high(i-1))
            AF=AFstart;
            maxHigh=max(high(i),high(i-1)); % new maximum high
            SARt=min(low(i),low(i-1)); %use SARt as last day SAR
            if type==1
                SAR(i)=AF*(high(i)-SARt)+SARt; % new SAR as long
            else
                SAR(i)=AF*(maxHigh-SARt)+SARt; % new SAR as long
            end;
            position='long';
            turnPoints(j)=i; j=j+1;
            longshort(i)=1;
        end;
    end;

end;% main loop

% set first longshort
longshort(1)=longshort(2);

% set last point as turn point
if j==1 || turnPoints(j-1)~=length(high)
    turnPoints(j)=length(high);
end;

% clear zeros
turnPoints=turnPoints(turnPoints~=0);