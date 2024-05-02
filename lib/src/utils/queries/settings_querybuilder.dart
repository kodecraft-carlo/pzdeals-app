String getUserSettings(String userId) {
  String query = '/items/notification_settings'
      '?filter[user_id][_eq]=$userId';
  return query;
}
