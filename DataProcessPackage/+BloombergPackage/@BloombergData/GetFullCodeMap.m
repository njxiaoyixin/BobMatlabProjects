function CodeMap=GetFullCodeMap(~)
Pref.Str2Num = 'never';
CodeMap=xml_read('Config\BloombergCodeMap.xml',Pref);
end