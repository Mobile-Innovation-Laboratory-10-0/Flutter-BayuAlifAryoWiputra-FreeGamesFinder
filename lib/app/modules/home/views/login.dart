import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:free_games_finder/app/modules/controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  // Gunakan Get.find karena AuthController sudah di-put di halaman Home
  final AuthController authController = Get.find<AuthController>(); 
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Background gelap ala gaming
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
              // Ikon / Logo
              const Icon(Icons.videogame_asset, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 16),
              const Text(
                "Welcome Gamer!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login untuk menyimpan game favoritmu",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Form Username
              TextField(
                controller: userController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Form Password
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Login Besar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (userController.text.isEmpty || passController.text.isEmpty) {
                    Get.snackbar("Peringatan", "Username dan Password tidak boleh kosong!", backgroundColor: Colors.orange, colorText: Colors.white);
                    return;
                  }

                  bool success = await authController.login(userController.text, passController.text);
                  if (success) {
                    Get.snackbar("Login Berhasil", "Selamat datang kembali, ${userController.text}!", backgroundColor: Colors.green, colorText: Colors.white);
                    Get.back(); // Otomatis lempar kembali ke halaman Home
                  } else {
                    Get.snackbar("Login Gagal", "Username atau Password salah.", backgroundColor: Colors.redAccent, colorText: Colors.white);
                  }
                },
                child: const Text(
                  "LOGIN", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                ),
              ),
              const SizedBox(height: 16),

              // Tombol Register Text
              TextButton(
                onPressed: () async {
                  if (userController.text.isEmpty || passController.text.isEmpty) {
                    Get.snackbar("Peringatan", "Isi dulu Username dan Password untuk mendaftar!", backgroundColor: Colors.orange, colorText: Colors.white);
                    return;
                  }

                  bool success = await authController.register(userController.text, passController.text);
                  if (success) {
                    Get.snackbar("Registrasi Sukses", "Akun berhasil dibuat! Silakan klik tombol LOGIN.", backgroundColor: Colors.green, colorText: Colors.white);
                  } else {
                    Get.snackbar("Registrasi Gagal", "Username ini sudah terdaftar. Coba yang lain.", backgroundColor: Colors.redAccent, colorText: Colors.white);
                  }
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