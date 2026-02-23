import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:free_games_finder/app/modules/controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final AuthController authController = Get.put(AuthController());
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login / Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userController,
              decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () async {
                    bool success = await authController.register(userController.text, passController.text);
                    if (success) {
                      Get.snackbar("Sukses", "Akun berhasil dibuat! Silakan Login.");
                    } else {
                      Get.snackbar("Gagal", "Username sudah terdaftar.");
                    }
                  },
                  child: const Text("Register", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () async {
                    bool success = await authController.login(userController.text, passController.text);
                    if (success) {
                      Get.snackbar("Halo!", "Selamat datang ${userController.text}");
                    } else {
                      Get.snackbar("Error", "Username atau Password salah.");
                    }
                  },
                  child: const Text("Login", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}