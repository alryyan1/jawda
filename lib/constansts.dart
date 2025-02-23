import 'package:shared_preferences/shared_preferences.dart';

const schema = 'https';
// const host = 'altohami.a.pinggy.link';
// const host = 'alroomy.a.pinggy.link';
// const host = '192.168.100.70';
// const host = '192.168.100.70';
const host = 'rain-laundry.com';
// const path = 'laravel-react-app/public/api';
const path = 'laundry-back-end/public/api';

getHeaders() async {
  final instance = await SharedPreferences.getInstance();
  final token = instance.getString('auth_token');
  return {
    'Authorization': 'Bearer ${token}',
    'Content-Type': 'application/json',
  };
}
