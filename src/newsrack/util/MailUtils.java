package newsrack.util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import newsrack.NewsRack;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class MailUtils
{
   private static Log _log = LogFactory.getLog(MailUtils.class);

   public static final String SMTP_PORT = "25";

   public static String        _adminEmail;
   public static String        _sysAdminEmail;
   public static String        _systemFrom;
   public static String        _smtpServer;
   public static String        _smtpPort;
   public static boolean       _smtpUseSSL;
   public static Authenticator _smtpAuth;

   public static void init()
   {
      _adminEmail = NewsRack.getProperty("email.admin.emailid");
      _systemFrom = NewsRack.getProperty("email.system.fromid");
      _smtpServer = NewsRack.getProperty("email.smtp.server");
      _smtpPort   = NewsRack.getProperty("email.smtp.port");
      if (_smtpPort == null)
         _smtpPort = SMTP_PORT;

      if (NewsRack.isTrue("email.smtp.auth")) {
         String smtpAuthUser   = NewsRack.getProperty("email.smtp.auth.user");
         String smtpAuthPasswd = NewsRack.getProperty("email.smtp.auth.passwd");
         _smtpAuth = new SMTPAuthenticator(smtpAuthUser, smtpAuthPasswd);
      }

      if (NewsRack.isTrue("email.smtp.ssl"))
         _smtpUseSSL = true;
   }

   public static void alertAdmin(String message)
   {
      try {
         sendEmail(_adminEmail, "NEWSRACK ALERT", message, _systemFrom);
         sendEmail(_sysAdminEmail,
                   "NEWSRACK ALERT",
                   "This is an automated message from NewsRack @ "
                   + NewsRack.getServerURL()
                   + "\n\n  Potential fatal error!\n"
                   + message
                   + "\n\n. Could you please alert the newsrack admin too?",
                   _systemFrom);
      }
      catch (MessagingException e) {
         _log.error("Error sending email! " + e);
      }
   }

   public static void sendEmail(String recipient, String subject, String message) throws MessagingException
   {
      sendEmail(new String[] {recipient}, subject, message, _systemFrom);
   }

   public static void sendEmail(String recipient, String subject, String message, String from) throws MessagingException
   {
      sendEmail(new String[] {recipient}, subject, message, from);
   }

   public static void sendEmail(String recipients[], String subject, String message, String from) throws MessagingException
   {
         // Set up mail properties and create a mail session
      Properties p = new Properties();
      p.put("mail.smtp.host", _smtpServer);
      p.put("mail.smtp.port", _smtpPort);
      if (_smtpAuth != null) {
         p.put("mail.smtp.auth",            "true");
         p.put("mail.smtps.auth",           "true");
         p.put("mail.smtp.starttls.enable", "true");
         if (_smtpUseSSL) {
            p.put("mail.smtp.socketFactory.port", "465");
            p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            p.put("mail.smtp.socketFactory.fallback", "false"); 
         }
      }

      Session session = Session.getDefaultInstance(p, _smtpAuth);

      // create a message
      Message msg = new MimeMessage(session);

      // set the from and to address
      InternetAddress addressFrom = new InternetAddress(from);
      msg.setFrom(addressFrom);

      InternetAddress[] addressTo = new InternetAddress[recipients.length]; 
      for (int i = 0; i < recipients.length; i++) {
         addressTo[i] = new InternetAddress(recipients[i]);
      }
      msg.setRecipients(Message.RecipientType.TO, addressTo);
     
      // Setting the Subject and Content Type
      msg.setSubject(subject);
      msg.setContent(message, "text/plain");
      Transport.send(msg);
   }

   /**
    * SimpleAuthenticator is used to do simple authentication
    * when the SMTP server requires it.
    */
   private static class SMTPAuthenticator extends javax.mail.Authenticator
   {
      String _smtpAuthUser;
      String _smtpAuthPasswd;

      public SMTPAuthenticator(String u, String p)
      {
         _smtpAuthUser = u;
         _smtpAuthPasswd = p;
      }

      public String toString() { return "user - " + _smtpAuthUser + ", passwd - " + _smtpAuthPasswd; }

      public PasswordAuthentication getPasswordAuthentication()
      {
//       System.out.println("AUTH: Returning auth - " + toString());
         return new PasswordAuthentication(_smtpAuthUser, _smtpAuthPasswd);
      }
   }

   public static void main(String[] args) throws Exception
   {
	   Properties nrProps = new Properties();
		nrProps.load(new java.io.FileInputStream(args[0]));

      _adminEmail    = nrProps.getProperty("email.admin.emailid");
      _sysAdminEmail = nrProps.getProperty("email.sysAdmin.emailid");
      _systemFrom    = nrProps.getProperty("email.system.fromid");
      _smtpServer    = nrProps.getProperty("email.smtp.server");
      _smtpPort      = nrProps.getProperty("email.smtp.port");
      if (_smtpPort == null)
         _smtpPort = SMTP_PORT;

      String smtpAuth = nrProps.getProperty("email.smtp.auth");
      if ((smtpAuth != null) && (smtpAuth.compareToIgnoreCase("true") == 0)) {
         String smtpAuthUser   = nrProps.getProperty("email.smtp.auth.user");
         String smtpAuthPasswd = nrProps.getProperty("email.smtp.auth.passwd");
         _smtpAuth = new SMTPAuthenticator(smtpAuthUser, smtpAuthPasswd);
      }

      String useSSL = nrProps.getProperty("email.smtp.ssl");
      if ((useSSL != null) && (useSSL.compareToIgnoreCase("true") == 0)) {
         _smtpUseSSL = true;
      }

      alertAdmin("Test mail!");
   }
}
