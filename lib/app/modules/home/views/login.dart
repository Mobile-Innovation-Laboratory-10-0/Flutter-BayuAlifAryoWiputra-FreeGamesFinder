import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:free_games_finder/app/modules/controllers/auth_controller.dart';
import 'register.dart'; 

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final AuthController authController = Get.find<AuthController>(); 
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.videogame_asset, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 16),
              const Text(
                "Welcome Gamer!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 32),

              TextField(
                controller: userController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: passController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  String username = userController.text.trim();
                  String password = passController.text.trim();

                  if (username.isEmpty || password.isEmpty) {
                    Get.snackbar("Peringatan", "Jangan ada yang kosong ya!", backgroundColor: Colors.orange, colorText: Colors.white);
                    return;
                  }

                  bool success = await authController.login(username, password);
                  if (success) {                    Get.snackbar(
                      "Login Berhasil", 
                      "Halo $username! Selamat datang kembali.", 
                      backgroundColor: Colors.green, 
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                    
                    Get.until((route) => route.isFirst); 
                  } else {
                    Get.snackbar("Login Gagal", "Username atau Password salah.", backgroundColor: Colors.redAccent, colorText: Colors.white);
                  }
                },
                child: const Text("LOGIN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Get.to(() => RegisterView()); 
                },
                child: const Text("Belum punya akun? Register di sini", style: TextStyle(color: Colors.blueAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}