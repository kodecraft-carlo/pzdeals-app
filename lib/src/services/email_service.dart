import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';

class EmailService {
  dynamic _smtpServer;
  String _email = '';
  String _password = '';
  List<String> _recipients = [];

  EmailService() {
    _initSmtp();
  }

  Future<void> _initSmtp() async {
    try {
      await _fetchSmtp();
    } catch (e) {
      debugPrint('Error initializing SMTP: $e');
      throw Exception('Failed to initialize SMTP');
    }
  }

  Future<void> _fetchSmtp() async {
    ApiClient apiClient = ApiClient();
    String querySmtp = '/items/smtp?filter[status][_eq]=1';
    try {
      Response responseSmtp = await apiClient.dio.get(querySmtp);
      if (responseSmtp.statusCode == 200) {
        final responseData = responseSmtp.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No SMTP Data Found');
        }

        final json = responseData[0];
        _email = json['email'];
        _password = json['password'];
        _smtpServer = gmail(_email, _password);
      } else {
        throw Exception('Failed to fetch SMTP data');
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to fetch SMTP data');
    } catch (e) {
      debugPrint('Error fetching SMTP: $e');
      throw Exception('Failed to fetch SMTP data');
    }
  }

  Future<void> _fetchRecipients() async {
    ApiClient apiClient = ApiClient();
    String queryRecipients = '/items/recipients';

    try {
      Response responseRecipients = await apiClient.dio.get(queryRecipients);
      if (responseRecipients.statusCode == 200) {
        final responseData = responseRecipients.data["data"];
        debugPrint('Recipients: $responseData');
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Recipients Data Found');
        }

        final json = responseData.map((e) => e['email']).toList();
        _recipients = List<String>.from(json);
      } else {
        throw Exception('Failed to fetch Recipients data');
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to fetch Recipients data');
    } catch (e) {
      debugPrint('Error fetching Recipients: $e');
      throw Exception('Failed to fetch Recipients data');
    }
  }

  Future<bool> sendEmailSoldOut(String productName, String productLink) async {
    await _fetchRecipients();
    if (_recipients.isEmpty) {
      debugPrint('No recipients found. Cannot send email.');
      return false;
    }
    final emailContent = await getEmailContent(1000);
    final msgBody = emailContent['message']
        .replaceAll('[product_name]', productName)
        .replaceAll('[link]', productLink);
    final message = Message()
      ..from = _email
      ..recipients.addAll(_recipients)
      ..subject = emailContent['subject'];
    message.html = msgBody;

    try {
      await send(message, _smtpServer);
      return true;
    } on MailerException catch (e) {
      debugPrint('Message not sent.');
      for (var p in e.problems) {
        debugPrint('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      debugPrint('Error sending soldout email: $e');
      throw Exception('Failed to send soldout email');
    }
    return false;
  }

  Future<bool> sendEmailStoreSubmission(String storeName) async {
    await _fetchRecipients();
    if (_recipients.isEmpty) {
      debugPrint('No recipients found. Cannot send email.');
      return false;
    }
    final emailContent = await getEmailContent(2000);
    final msgBody =
        emailContent['message'].replaceAll('[store_name]', storeName);
    final message = Message()
      ..from = _email
      ..recipients.addAll(_recipients)
      ..subject = emailContent['subject'];
    message.html = msgBody;

    try {
      await send(message, _smtpServer);
      return true;
    } on MailerException catch (e) {
      debugPrint('Message not sent.');
      for (var p in e.problems) {
        debugPrint('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      debugPrint('Error sending store request email: $e');
      throw Exception('Failed to send store request email');
    }
    return false;
  }

  Future<Map<String, dynamic>> getEmailContent(int messageId) async {
    ApiClient apiClient = ApiClient();
    debugPrint("getEmailContent called");
    String query = '/items/messages?filter[message_id][_eq]=$messageId';

    try {
      Response response = await apiClient.dio.get(query);
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Message Data Found');
        }

        final json = responseData[0];
        return {
          'subject': json['subject'],
          'message': json['message'],
        };
      } else {
        throw Exception('Failed to fetch email content');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch email content');
    } catch (e) {
      debugPrint('Error fetching collections: $e');
      throw Exception('Failed to fetch email content');
    }
  }
}
