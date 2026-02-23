import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:free_games_finder/app/modules/controllers/auth_controller.dart';
import 'login.dart'; // Pastikan file login kamu di-import di sini

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final AuthController authController = Get.find<AuthController>(); 
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Tema gelap
      appBar: AppBar(
        title: const Text("Buat Akun", style: TextStyle(color: Colors.white)),
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
              const Icon(Icons.person_add, size: 80, color: Colors.greenAccent),
              const SizedBox(height: 16),
              const Text(
                "Daftar Akun Baru",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
                ),
              ),
              const SizedBox(height: 32),

              // Form Username
              TextField(
                controller: userController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Pilih Username",
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
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
                  labelText: "Buat Password",
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Register
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[700],
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

                  bool success = await authController.register(userController.text, passController.text);
                  if (success) {
                    // Tampilkan notifikasi berhasil
                    Get.snackbar(
                      "Pendaftaran Sukses! 🎉", 
                      "Akun kamu berhasil dibuat. Silakan login ya.", 
                      backgroundColor: Colors.green, 
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 3), // Tahan notif 3 detik
                    );
                    
                    // Lempar secara paksa ke halaman Login
                    Get.off(() => LoginView());
                  } else {
                    Get.snackbar("Gagal", "Username sudah dipakai. Cari nama lain ya.", backgroundColor: Colors.redAccent, colorText: Colors.white);
                  }
                },
                child: const Text(
                  "REGISTER", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}