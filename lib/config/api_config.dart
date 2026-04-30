class ApiConfig {
  static const baseUrl = 'https://seendchat-server.onrender.com/api';
  static const wsUrl = 'wss://seendchat-server.onrender.com';
  static const profileLink = 'https://chat.seend.com/profile';
  static const groupLink = 'https://chat.seend.com/group';
  static const channelLink = 'https://chat.seend.com/channel';
  static const botLink = 'https://chat.seend.com/bot';

  static String profileUrl(String username) => '$profileLink/$username';
  static String groupUrl(String id) => '$groupLink/$id';
  static String channelUrl(String id) => '$channelLink/$id';
  static String botUrl(String username) => '$botLink/$username';
}
