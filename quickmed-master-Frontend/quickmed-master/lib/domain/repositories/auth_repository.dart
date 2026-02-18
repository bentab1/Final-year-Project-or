import 'package:quickmed/data/models/models/user.dart';
import 'package:quickmed/data/models/request/register_request.dart';
import 'package:quickmed/data/models/response/register_response.dart';

import '../../data/models/request/LoginRequest.dart';
import '../../data/models/response/login_response.dart';

abstract class AuthRepository{

  Future<RegisterResponse>  registerUser(RegisterRequest request);
  Future<LoginResponse> loginUser(LoginRequest request);
  Future<UserData> getUser();
  Future<void> logout(String refreshToken);


}