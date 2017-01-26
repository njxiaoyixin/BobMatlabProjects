function mail2me(subject,content)
% Reading Config
Pref.Str2Num = 'never';
Pref.ReadSpec  = false;
Info=xml_read('SystemToolConfig.xml',Pref);

MailAddress = Info.Mail2Me.MailAddress;
Password    = Info.Mail2Me.Password;
SMTPServer  = Info.Mail2Me.SMTPServer;
setpref('Internet','E_mail',MailAddress);
setpref('Internet','SMTP_Server',SMTPServer);
setpref('Internet','SMTP_Username',MailAddress);
setpref('Internet','SMTP_Password',Password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
sendmail(MailAddress,subject,content);
end