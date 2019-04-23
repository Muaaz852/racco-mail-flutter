class EmailData {

  EmailData({this.subject, this.receiverEmail, this.emailBody, this.attachments, this.acceptPrivacy});

  final String subject;
  final String receiverEmail;
  final String emailBody;
  final Map<String, String> attachments;
  final bool acceptPrivacy;
}