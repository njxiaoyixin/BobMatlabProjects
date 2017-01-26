% trader class sample

%-------------初始化模块--------------------
TC = 0.001;
InitialFund = 1000000;
s = trader(TC,InitialFund);
%初始化设定时间序列-注：可以使程序运行更快
ThisTimeSeries.TimeVec=HF.(Product_List{i}).TimeVec;
T1.PreSetTimeSeries(ThisTimeSeries)
T2.PreSetTimeSeries(ThisTimeSeries)

%手动设定trader的属性
s.SetProperties('InitialFund',1000000);

s.SetFx(Fx)
%-------------信息获取模块--------------------
%获取当前头寸
s.GetPosition;

%获取当前仓位浮动盈亏

%获取trader的属性
ts=s.GetProperties('TimeSeries');

%--------------交易模块------------------------
%买入
%i为可选变量，当设定了TimeSeries过后可以输入当前价格在TimeSeries当中的序列
s.buy(time,price,quantity,i);

%卖出
s.sell(time,price,quantity,i);

%平空头
s.closeshort(time,price,quantity,i);

%平多头
s.closelong(time,price,quantity,i);

%平掉当前头寸
coverall(obj,time,price,[],i)

%更新当前状态（每一个数据点过后都必须更新）
s.update(time,price,i)

%---------资金操作模块,注：初始资金不可以为0----
%增加资金
s.AddFund(ThisFund,i)

s.ExtractFund(obj,ThisFund,i)

%-------------清算模块------------------------
%当进行高频回测时，TimeSeries设定为一天的量，每天的交易测试完毕后进行清算(不可与DailyCalc混用)
% Date为可选变量，为结算的日期
s.DailyClearance(Date)

%所有的历史交易完成后，结算形成日收益率序列
s.DailyCalc;

%根据Daily的各项数据来计算交易报告
s.OutputCalc;


