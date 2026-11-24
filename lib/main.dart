import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const StarRankApp());
}

class StarRankApp extends StatelessWidget {
  const StarRankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StarRank',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0E17),
        primaryColor: const Color(0xFFFFD700),
      ),
      home: const AuthScreen(),
    );
  }
}

class UserModel {
  String id;
  String name;
  String username;
  int points;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.points,
  });
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _enterApp(String name, String username) {
    if (name.isEmpty) name = "Guest User";
    if (username.isEmpty) username = "user_${Random().nextInt(999)}";
    if (!username.startsWith('@')) username = '@$username';

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => MainHomeScreen(
          currentUserName: name,
          currentUsername: username,
        ),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animController,
                builder: (_, child) {
                  return Transform.scale(
                    scale: 1.0 + (_animController.value * 0.15),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          )
                        ],
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                        ),
                      ),
                      child: const Icon(Icons.star_rounded, size: 60, color: Colors.black),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                "STAR RANK",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Collect Stars, Gift Friends & Top the Leaderboard!",
                style: TextStyle(color: Colors.grey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Display Name",
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.amber),
                  filled: true,
                  fillColor: const Color(0xFF151A2C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                  hintText: "Username (e.g. elyas)",
                  prefixIcon: const Icon(Icons.alternate_email, color: Colors.amber),
                  filled: true,
                  fillColor: const Color(0xFF151A2C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _enterApp(_nameController.text, _userController.text),
                  child: const Text(
                    "Create Account & Enter",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.g_mobiledata, size: 32, color: Colors.redAccent),
                  label: const Text("Continue with Google", style: TextStyle(color: Colors.white)),
                  onPressed: () => _enterApp("Google Star", "google_user"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class MainHomeScreen extends StatefulWidget {
  final String currentUserName;
  final String currentUsername;

  const MainHomeScreen({
    super.key,
    required this.currentUserName,
    required this.currentUsername,
  });

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;
  int _myStars = 5;
  late List<UserModel> _users;

  final List<Map<String, dynamic>> _tasks = [
    {"title": "Follow Official Telegram Channel", "reward": 2, "done": false, "icon": Icons.send},
    {"title": "Follow Official Instagram Page", "reward": 2, "done": false, "icon": Icons.camera_alt},
    {"title": "Like Featured Post Today", "reward": 1, "done": false, "icon": Icons.favorite},
    {"title": "Invite a Friend to App", "reward": 5, "done": false, "icon": Icons.group_add},
    {"title": "Daily Check-in Bonus", "reward": 1, "done": false, "icon": Icons.calendar_today},
  ];

  @override
  void initState() {
    super.initState();
    _users = [
      UserModel(id: '1', name: widget.currentUserName, username: widget.currentUsername, points: 120),
      UserModel(id: '2', name: 'Aria King', username: '@aria_king', points: 450),
      UserModel(id: '3', name: 'Sara Art', username: '@sara_art', points: 390),
      UserModel(id: '4', name: 'Omid Pro', username: '@omid_pro', points: 280),
      UserModel(id: '5', name: 'Nazanin', username: '@nazanin99', points: 195),
    ];
    _sortUsers();
  }

  void _sortUsers() {
    _users.sort((a, b) => b.points.compareTo(a.points));
  }

  void _giftStarToUser(UserModel targetUser) {
    if (_myStars <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No stars left! Complete tasks to earn free stars."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final random = Random();
    int chanceRoll = random.nextInt(100);
    int earnedPoints;

    if (chanceRoll < 60) {
      earnedPoints = random.nextInt(20) + 10;
    } else if (chanceRoll < 90) {
      earnedPoints = random.nextInt(30) + 30;
    } else {
      earnedPoints = random.nextInt(41) + 60;
    }

    setState(() {
      _myStars -= 1;
      targetUser.points += earnedPoints;
      _sortUsers();
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151A2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, color: Colors.amber, size: 65),
            const SizedBox(height: 12),
            Text(
              "Star Gifted to ${targetUser.name}!",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber),
              ),
              child: Text(
                "+$earnedPoints Lucky Points!",
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              earnedPoints >= 60 ? "MEGA JACKPOT LUCKY ROLL!" : "Ranking updated live!",
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Awesome!"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121624),
        elevation: 0,
        title: const Text("STAR RANK", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                const SizedBox(width: 6),
                Text(
                  "$_myStars",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber),
                ),
              ],
            ),
          )
        ],
      ),
      body: _selectedIndex == 0 ? _buildRankingTab() : _buildTasksTab(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121624),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard_rounded), label: "Leaderboard"),
          BottomNavigationBarItem(icon: Icon(Icons.stars_rounded), label: "Free Stars"),
        ],
      ),
    );
  }

  Widget _buildRankingTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        final isTop3 = index < 3;
        Color rankColor = index == 0
            ? const Color(0xFFFFD700)
            : index == 1
                ? const Color(0xFFC0C0C0)
                : index == 2
                    ? const Color(0xFFCD7F32)
                    : Colors.white24;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF151A2C),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isTop3 ? rankColor : Colors.white10, width: isTop3 ? 1.5 : 1),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: rankColor.withOpacity(0.2),
                child: Text(
                  "#${index + 1}",
                  style: TextStyle(color: isTop3 ? rankColor : Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        if (index == 0) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.workspace_premium, color: Colors.amber, size: 18),
                        ]
                      ],
                    ),
                    Text(user.username, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      "${user.points} Points",
                      style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () => _giftStarToUser(user),
                icon: const Icon(Icons.star_rounded, size: 18),
                label: const Text("Gift", style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTasksTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        bool isDone = task["done"];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF151A2C),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDone ? Colors.green.withOpacity(0.5) : Colors.white10),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(task["icon"], color: Colors.amber),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task["title"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(
                      "+${task["reward"]} Free Stars",
                      style: const TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDone ? Colors.green : Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isDone
                    ? null
                    : () {
                        setState(() {
                          task["done"] = true;
                          _myStars += (task["reward"] as int);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("+${task["reward"]} Stars added to your balance!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                child: Text(isDone ? "Done ✓" : "Claim"),
              )
            ],
          ),
        );
      },
    );
  }
}
