function date=F_ReadXMLdate(xmlStr)
if any(regexpi(xmlStr,'today'))
    date = eval(xmlStr);
else
    date = datenum(xmlStr);
end
end