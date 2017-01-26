
DataFolder='H:\�����ڻ�����';
TargetFolder='H:\CQG����';
%��ȡ������Ϣ
[~,~,Raw]=xlsread([DataFolder,'/TickerInfo.xlsx']);
CodeMap.Name=Raw(2:end,1);
CodeMap.PrimeTicker=Raw(2:end,2);
CodeMap.Ticker2=Raw(2:end,3);
CodeMap.Ticker3=Raw(2:end,4);

%�������д��룬���ļ�������ѹ
for i=11:numel(CodeMap.Name)
    disp(CodeMap.Name{i})
    SubFolder=CodeMap.PrimeTicker{i};
    if exist([DataFolder,'/',SubFolder],'dir')
        for iYear = 2001:2015
            disp(iYear)
            s=dir([DataFolder,'/',SubFolder]);
            for k=1:numel(s)
                if numel(s(k).name)>=4 && ~isempty(regexpi(s(k).name,num2str(iYear), 'once'))
                    ss=dir([DataFolder,'/',SubFolder,'/',s(k).name]);
                    for kk=1:numel(ss)
                        if numel(ss(kk).name)>5 && strcmp(ss(kk).name(end-3:end),'.zip')
                            ThisSource=[DataFolder,'/',SubFolder,'/',s(k).name,'/',ss(kk).name];
                            ThisTarget=[TargetFolder,'/',num2str(iYear),'/',ss(kk).name(end-9:end-4)];
                            unzip(ThisSource,ThisTarget)
                            %��PrimeTicker���ĳ�Ticker2
                            sss=dir(ThisTarget);
                            for kkk=1:numel(sss)
                                if ~isempty(CodeMap.Ticker2{i}) && numel(sss(kkk).name)>3
                                    ThisTicker=sss(kkk).name(6:end-13);
                                    if strcmpi(ThisTicker,CodeMap.PrimeTicker{i}) && any(~isnan(CodeMap.Ticker2{i})) %�����primeticker��Ticker2��Ϊ��,��ĳ�ticker2
                                        NewName=[sss(kkk).name(1:5),CodeMap.Ticker2{i},sss(kkk).name(end-12:end)];
                                        movefile([ThisTarget,'/',sss(kkk).name],[ThisTarget,'/',NewName])
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end





