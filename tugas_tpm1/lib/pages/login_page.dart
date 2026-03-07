import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tugas_tpm1/auth/auth_service.dart';
import 'package:tugas_tpm1/pages/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Deklarasi var
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    //attemp login
    try {
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan';
      
      if (e is AuthException) {
        errorMessage = e.message; 
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Tidak bisa terhubung ke server';
      } else {
        errorMessage = e.toString();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
      print("ERROR AUTH: $e");  
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sign In to Your Account",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold
                ),
              ),

              Text("Enter your email and password to log in",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
                ),
              ),
        
              SizedBox(height: 20),
              Text("Email",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey
                ),
              ),
              _emailField(),

              SizedBox(height: 20),
              Text("Password",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey
                ),
              ),
              _passwordField(),

              // Button Login
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: login, 
        
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
        
                child: Text("Log in")
              ),

              SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(width: 8),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        )
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.blue,
                      shadowColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                    ),

                    child: Text("Sign Up"),
                  ),
                ],
              )
            ],
            
          )
        ),
      )
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailController,

      decoration: InputDecoration(
        hintText: 'email',
        hintStyle: TextStyle(
          color: Colors.grey, // warna hint text
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        
       focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
      )
    );
  }

  Widget _passwordField() {
    return  TextField(
      controller: _passwordController,

      obscureText: true,

      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(
          color: Colors.grey, // warna hint text
        ),

        border: OutlineInputBorder(),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

}