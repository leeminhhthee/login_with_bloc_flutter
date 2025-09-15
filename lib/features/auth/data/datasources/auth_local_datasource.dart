import 'dart:convert';
import 'package:e_commerce_app/core/constants/app_assets.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<List<UserModel>> getUsers();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<List<UserModel>> getUsers() async {
    final jsonStr = await rootBundle.loadString(AppAssets.mockAuth);
    final List<dynamic> data = json.decode(jsonStr);
    return data.map((e) => UserModel.fromJson(e)).toList();
  }
}