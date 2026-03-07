import 'package:flutter/material.dart';
import 'package:tugas_tpm1/auth/auth_service.dart';

class TheTeam extends StatefulWidget {
  const TheTeam({super.key});

  @override
  State<TheTeam> createState() => _TheTeamState();
}

class _TheTeamState extends State<TheTeam> {
  final authService = AuthService();

  void logout() async {
    await authService.signOut();
  }

  final List<Map<String, String>> anggota = [
    {"nama": "Muhammad Ruhul Jadid", "nim": "123230046"},
    {"nama": "Aulia Putri Naharani", "nim": "123230047"},
    {"nama": "Gradiva Arya Wicaksana", "nim": "1232300xx"},
    {"nama": "Brian Zahran Putra", "nim": "123230195"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Team",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Logout
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Container(
          padding: EdgeInsets.all(30),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.web_stories),
                  SizedBox(width: 10),
                  Text(
                    "Anggota Kelompok",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              /// List Anggota
              ...anggota.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["nama"]!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item["nim"]!,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}