import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jawda/constansts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart'; // Import your main screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final url = Uri(host: host, scheme: schema, path: "$path/login"); // Replace with your login endpoint

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': _usernameController.text,
            'password': _passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          final decodedData = json.decode(response.body);
          print(decodedData);
          // Assuming the response contains 'access_token' or similar
          final accessToken = decodedData['token']; // Adjust based on your API response

          // Store the token securely (e.g., using shared_preferences)
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', accessToken);

          // Navigate to the main screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          // Handle login failure (e.g., display an error message)
          print('Login failed: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid username or password')),
          );
        }
      } catch (error) {
        // Handle network errors, etc.
        print('Error during login: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during login')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background, // Use background color from theme
      body: Center(
        child: SingleChildScrollView( // Make the content scrollable
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: colorScheme.surface, // Use surface color from theme
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    labelStyle: TextStyle(color: colorScheme.onSurface), // Use onSurface color from theme
                  ),
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: colorScheme.onBackground), // Use onBackground color from theme
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: colorScheme.surface, // Use surface color from theme
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    labelStyle: TextStyle(color: colorScheme.onSurface), // Use onSurface color from theme
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  style: TextStyle(color: colorScheme.onBackground), // Use onBackground color from theme
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary, // Use primary color from theme
                    foregroundColor: colorScheme.onPrimary, // Use onPrimary color from theme
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}