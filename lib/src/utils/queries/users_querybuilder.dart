import 'package:flutter/material.dart';

String getDirectusUserId(String userUID) {
  String query = '/items/users'
      '?filter[user_id][_eq]=$userUID'
      '&fields[]=id';
  debugPrint('getDirectusUserId: $query');
  return query;
}

String getDirectusUserIdWithInstanceId(String userUID, String instanceID) {
  String query = '/items/users'
      '?filter[user_id][_eq]=$userUID'
      '&filter[instance_id][_eq]=$instanceID'
      '&fields[]=id';
  debugPrint('getDirectusUserIdWithInstanceId: $query');
  return query;
}

String getUserIdFromInstanceId(String instanceID) {
  String query = '/items/users'
      '?filter[instance_id][_eq]=$instanceID'
      '&fields[]=id';
  debugPrint('getUserIdFromInstanceId: $query');
  return query;
}

String getDirectusFcmToken(String userUID) {
  return '/items/users'
      '?filter[user_id][_eq]=$userUID'
      '&fields[]=fcm_token';
}
