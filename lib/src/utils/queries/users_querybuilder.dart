import 'package:flutter/material.dart';

String getDirectusUserId(String userUID) {
  String query = '/items/users'
      '?filter[user_id][_eq]=$userUID'
      '&fields[]=id';
  return query;
}

String getDirectusFcmToken(String userUID) {
  return '/items/users'
      '?filter[user_id][_eq]=$userUID'
      '&fields[]=fcm_token';
}
