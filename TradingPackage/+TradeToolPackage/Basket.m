classdef Basket < handle
    properties
        CreateTime    %���Ӵ���ʱ��
        BasketID      %���ӱ��
        Ticker        %����
        Exchange      %������
        OrderType     %Buy,Sell,BuyCover,SellCover,BuyCoverYesterday,SellCoverYesterday,BuyCoverToday,SellCoverToday
        Quantity      %����
        Symbol        %Ͷ����־(Ͷ�����ױ�������)
        RoundTime=2;  %��ѯʱ��(��)
        Round=10;     %��ѯ����
        Expiration    %��Ȩ������
        Strike        %��Ȩ��Ȩ��
    end
end