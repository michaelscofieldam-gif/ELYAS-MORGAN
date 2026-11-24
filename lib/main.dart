import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const StarRankSuperApp());
}

// مدیریت زنده زبان و تم برنامه
final ValueNotifier<String> appLang = ValueNotifier<String>('fa');
final ValueNotifier<Color> appThemeColor = ValueNotifier<Color>(const Color(0xFFFFD700));

// دیکشنری ۷ زبان زنده دنیا (دری، انگلیسی، عربی، ترکی، روسی، فرانسوی، اسپانیایی)
const Map<String, Map<String, String>> langData = {
  'fa': {
    'app_name': 'استار رنک',
    'profile': 'پروفایل',
    'earn': 'دریافت ستاره',
    'rank': 'رنکینگ',
    'social': 'فالوئرها',
    'settings': 'تنظیمات',
    'points': 'پوینت',
    'stars': 'ستاره',
    'followers': 'دنبال‌کننده',
    'following': 'دنبال‌شده',
    'top_gifters': '۳ حامی برتر شما',
    'no_gifters': 'هنوز کسی برای شما گیفت نزده است',
    'spin_now': 'چرخش شانس!',
    'tasks': 'مأموریت‌های ستاره‌دار',
    'follow': 'دنبال کردن',
    'unfollow': 'دنبال شده',
    'gift': 'گیفت',
    'language': 'زبان برنامه (۷ زبان)',
    'theme': 'رنگ تم اپلیکیشن',
    'about': 'درباره سازنده',
    'logout': 'خروج از حساب',
  },
  'en': {
    'app_name': 'STAR RANK',
    'profile': 'Profile',
    'earn': 'Get Stars',
    'rank': 'Ranking',
    'social': 'Followers',
    'settings': 'Settings',
    'points': 'Points',
    'stars': 'Stars',
    'followers': 'Followers',
    'following': 'Following',
    'top_gifters': 'Top 3 Supporters',
    'no_gifters': 'No gifts received yet',
    'spin_now': 'SPIN WHEEL!',
    'tasks': 'Daily Star Missions',
    'follow': 'Follow',
    'unfollow': 'Following',
    'gift': 'Gift',
    'language': 'App Language (7 Languages)',
    'theme': 'App Theme Color',
    'about': 'About Creator',
    'logout': 'Sign Out',
  },
  'ar': {
    'app_name': 'ستار رانك',
    'profile': 'الملف الشخصي',
    'earn': 'كسب النجوم',
    'rank': 'التصنيف',
    'social': 'المتابعون',
    'settings': 'الإعدادات',
    'points': 'نقطة',
    'stars': 'نجمة',
    'followers': 'متابع',
    'following': 'يتابع',
    'top_gifters': 'أفضل ٣ داعمين لك',
    'no_gifters': 'لم تتلق أي هدايا بعد',
    'spin_now': 'أدر العجلة!',
    'tasks': 'مهام النجوم اليومية',
    'follow': 'متابعة',
    'unfollow': 'متابَع',
    'gift': 'إهداء',
    'language': 'لغة التطبيق',
    'theme': 'لون المظهر',
    'about': 'حول المطور',
    'logout': 'تسجيل الخروج',
  },
  'tr': {
    'app_name': 'STAR RANK',
    'profile': 'Profil',
    'earn': 'Yıldız Kazan',
    'rank': 'Sıralama',
    'social': 'Takipçiler',
    'settings': 'Ayarlar',
    'points': 'Puan',
    'stars': 'Yıldız',
    'followers': 'Takipçi',
    'following': 'Takip',
    'top_gifters': 'En İyi 3 Destekçi',
    'no_gifters': 'Henüz hediye yok',
    'spin_now': 'ÇARKI ÇEVİR!',
    'tasks': 'Yıldız Görevleri',
    'follow': 'Takip Et',
    'unfollow': 'Takip Ediliyor',
    'gift': 'Hediye',
    'language': 'Uygulama Dili',
    'theme': 'Tema Rengi',
    'about': 'Geliştirici Hakkında',
    'logout': 'Çıkış Yap',
  },
  'ru': {
    'app_name': 'STAR RANK',
    'profile': 'Профиль',
    'earn': 'Звезды',
    'rank': 'Рейтинг',
    'social': 'Подписчики',
    'settings': 'Настройки',
    'points': 'Очков',
    'stars': 'Звезд',
    'followers': 'Подписчики',
    'following': 'Подписки',
    'top_gifters': 'Топ-3 спонсора',
    'no_gifters': 'Пока нет подарков',
    'spin_now': 'КРУТИТЬ!',
    'tasks': 'Задания за звезды',
    'follow': 'Подписаться',
    'unfollow': 'Вы подписаны',
    'gift': 'Подарок',
    'language': 'Язык приложения',
    'theme': 'Цвет темы',
    'about': 'О создателе',
    'logout': 'Выйти',
  },
  'fr': {
    'app_name': 'STAR RANK',
    'profile': 'Profil',
    'earn': 'Étoiles',
    'rank': 'Classement',
    'social': 'Abonnés',
    'settings': 'Paramètres',
    'points': 'Points',
    'stars': 'Étoiles',
    'followers': 'Abonnés',
    'following': 'Abonnements',
    'top_gifters': 'Top 3 Donateurs',
    'no_gifters': 'Aucun cadeau reçu',
    'spin_now': 'TOURNER !',
    'tasks': 'Missions Étoiles',
    'follow': 'Suivre',
    'unfollow': 'Abonné',
    'gift': 'Offrir',
    'language': 'Langue',
    'theme': 'Couleur du thème',
    'about': 'À propos',
    'logout': 'Déconnexion',
  },
  'es': {
    'app_name': 'STAR RANK',
    'profile': 'Perfil',
    'earn': 'Estrellas',
    'rank': 'Ranking',
    'social': 'Seguidores',
    'settings': 'Ajustes',
    'points': 'Puntos',
    'stars': 'Estrellas',
    'followers': 'Seguidores',
    'following': 'Siguiendo',
    'top_gifters': 'Top 3 Apoyadores',
    'no_gifters': 'Sin regalos aún',
    'spin_now': '¡GIRAR!',
    'tasks': 'Misiones Diarias',
    'follow': 'Seguir',
    'unfollow': 'Siguiendo',
    'gift': 'Regalar',
    'language': 'Idioma',
    'theme': 'Color del tema',
    'about': 'Sobre el creador',
    'logout': 'Cerrar sesión',
  },
};

String tr(String key) => langData[appLang.value]?[key] ?? key;

// محاسبه درجه و نشان کاربر بر اساس پوینت
Map<String, dynamic> getRankBadge(int points) {
  if (points >= 5000) return {'title': 'LEGEND', 'color': Colors.redAccent, 'icon': Icons.local_fire_department};
  if (points >= 2000) return {'title': 'DIAMOND', 'color': Colors.cyanAccent, 'icon': Icons.diamond};
  if (points >= 800) return {'title': 'GOLD', 'color': Colors.amber, 'icon': Icons.workspace_premium};
  if (points >= 300) return {'title': 'SILVER', 'color': Colors.grey.shade300, 'icon': Icons.shield};
  return {'title': 'BRONZE', 'color': Colors.brown.shade300, 'icon': Icons.military_tech};
}
class StarRankSuperApp extends StatelessWidget {
  const StarRankSuperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: appLang,
      builder: (_, lang, __) {
        return ValueListenableBuilder<Color>(
          valueListenable: appThemeColor,
          builder: (_, themeColor, __) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'StarRank',
              theme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: const Color(0xFF0A0D14),
                primaryColor: themeColor,
                colorScheme: ColorScheme.dark(primary: themeColor),
              ),
              home: const AuthGate(),
            );
          },
        );
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData && snapshot.data != null) {
          return ProfileCheckGate(user: snapshot.data!);
        }
        return const AuthScreen();
      },
    );
  }
}

class ProfileCheckGate extends StatelessWidget {
  final User user;
  const ProfileCheckGate({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData && snapshot.data!.exists) {
          return MainShellScreen(currentUid: user.uid);
        }
        return SetupProfileScreen(user: user);
      },
    );
  }
}
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _loading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Error: $e"), backgroundColor: Colors.red));
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _emailAuth() async {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ایمیل معتبر و رمز حداقل ۶ رقمی وارد کنید")));
      return;
    }
    setState(() => _loading = true);
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text.trim(),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Auth Error: $e"), backgroundColor: Colors.red));
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final primary = appThemeColor.value;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) => Transform.scale(
                  scale: 1.0 + (_pulseCtrl.value * 0.12),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary.withOpacity(0.15),
                      boxShadow: [BoxShadow(color: primary.withOpacity(0.4), blurRadius: 30)],
                    ),
                    child: Icon(Icons.star_rounded, size: 65, color: primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("STAR RANK", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 3)),
              const SizedBox(height: 30),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email Address",
                  prefixIcon: Icon(Icons.email_outlined, color: primary),
                  filled: true,
                  fillColor: const Color(0xFF151A28),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password (min 6 chars)",
                  prefixIcon: Icon(Icons.lock_outline, color: primary),
                  filled: true,
                  fillColor: const Color(0xFF151A28),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              if (_loading)
                CircularProgressIndicator(color: primary)
              else ...[
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _emailAuth,
                    child: Text(_isLogin ? "Login" : "Create Real Account", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin ? "حساب ندارید؟ ثبت نام کنید" : "قبلاً حساب ساخته‌اید؟ وارد شوید", style: TextStyle(color: primary)),
                ),
                const Divider(height: 30, color: Colors.white12),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.g_mobiledata, size: 34, color: Colors.redAccent),
                    label: const Text("Continue with Real Google", style: TextStyle(color: Colors.white, fontSize: 15)),
                    onPressed: _signInWithGoogle,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class SetupProfileScreen extends StatefulWidget {
  final User user;
  const SetupProfileScreen({super.key, required this.user});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.user.displayName ?? "";
  }

  Future<void> _saveProfile() async {
    String name = _nameCtrl.text.trim();
    String uname = _userCtrl.text.trim().toLowerCase().replaceAll(' ', '_');
    if (name.isEmpty || uname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("لطفاً نام و یوزرنیم را وارد کنید")));
      return;
    }
    if (!uname.startsWith('@')) uname = '@$uname';

    setState(() => _saving = true);
    final query = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: uname).get();
    if (query.docs.isNotEmpty) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("این یوزرنیم قبلاً گرفته شده است!"), backgroundColor: Colors.red));
      }
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).set({
      'uid': widget.user.uid,
      'name': name,
      'username': uname,
      'photoUrl': widget.user.photoURL ?? '',
      'points': 100,
      'stars': 5,
      'followers': [],
      'following': [],
      'gifters': {},
      'completedTasks': [],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = appThemeColor.value;
    return Scaffold(
      appBar: AppBar(title: const Text("تکمیل پروفایل"), backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: primary.withOpacity(0.2),
              backgroundImage: widget.user.photoURL != null ? NetworkImage(widget.user.photoURL!) : null,
              child: widget.user.photoURL == null ? Icon(Icons.person, size: 45, color: primary) : null,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                hintText: "نام نمایشی شما",
                prefixIcon: Icon(Icons.badge, color: primary),
                filled: true,
                fillColor: const Color(0xFF151A28),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _userCtrl,
              decoration: InputDecoration(
                hintText: "یوزرنیم یکتا (مثلاً: elyas_star)",
                prefixIcon: Icon(Icons.alternate_email, color: primary),
                filled: true,
                fillColor: const Color(0xFF151A28),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 25),
            _saving
                ? CircularProgressIndicator(color: primary)
                : SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _saveProfile,
                      child: const Text("Save & Enter", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
class MainShellScreen extends StatefulWidget {
  final String currentUid;
  const MainShellScreen({super.key, required this.currentUid});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final primary = appThemeColor.value;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final myData = snapshot.data!.data() as Map<String, dynamic>;
        final pages = [
          ProfileTab(myData: myData, currentUid: widget.currentUid),
          EarnStarsTab(myData: myData, currentUid: widget.currentUid),
          RankingTab(myData: myData, currentUid: widget.currentUid),
          FollowersTab(myData: myData, currentUid: widget.currentUid),
          SettingsTab(myData: myData),
        ];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF0F131F),
            elevation: 0,
            title: Text(tr('app_name'), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primary),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, color: primary, size: 20),
                    const SizedBox(width: 4),
                    Text("${myData['stars'] ?? 0}", style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
          body: pages[_tabIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF0F131F),
            selectedItemColor: primary,
            unselectedItemColor: Colors.grey,
            currentIndex: _tabIndex,
            onTap: (i) => setState(() => _tabIndex = i),
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.person_rounded), label: tr('profile')),
              BottomNavigationBarItem(icon: const Icon(Icons.casino_rounded), label: tr('earn')),
              BottomNavigationBarItem(icon: const Icon(Icons.leaderboard_rounded), label: tr('rank')),
              BottomNavigationBarItem(icon: const Icon(Icons.group_rounded), label: tr('social')),
              BottomNavigationBarItem(icon: const Icon(Icons.settings_rounded), label: tr('settings')),
            ],
          ),
        );
      },
    );
  }
}
class ProfileTab extends StatelessWidget {
  final Map<String, dynamic> myData;
  final String currentUid;
  const ProfileTab({super.key, required this.myData, required this.currentUid});

  @override
  Widget build(BuildContext context) {
    final primary = appThemeColor.value;
    int points = myData['points'] ?? 0;
    final badge = getRankBadge(points);
    List followers = myData['followers'] ?? [];
    List following = myData['following'] ?? [];
    Map<String, dynamic> giftersMap = Map<String, dynamic>.from(myData['gifters'] ?? {});

    // مرتب‌سازی حامیان بر اساس بیشترین پوینت گیفت داده‌شده و انتخاب ۳ نفر اول
    var sortedGifters = giftersMap.entries.toList()
      ..sort((a, b) => (b.value['points'] as int).compareTo(a.value['points'] as int));
    var top3 = sortedGifters.take(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF141927),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: primary.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: primary.withOpacity(0.2),
                  backgroundImage: (myData['photoUrl'] != null && myData['photoUrl'] != '')
                      ? NetworkImage(myData['photoUrl'])
                      : null,
                  child: (myData['photoUrl'] == null || myData['photoUrl'] == '')
                      ? Icon(Icons.person, size: 48, color: primary)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(myData['name'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(myData['username'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: (badge['color'] as Color).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: badge['color']),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badge['icon'], color: badge['color'], size: 18),
                      const SizedBox(width: 6),
                      Text(badge['title'], style: TextStyle(color: badge['color'], fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statBox("$points", tr('points'), primary),
                    _statBox("${followers.length}", tr('followers'), Colors.white),
                    _statBox("${following.length}", tr('following'), Colors.white),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: Text(tr('top_gifters'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          if (top3.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF141927), borderRadius: BorderRadius.circular(18)),
              child: Text(tr('no_gifters'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            )
          else
            ...List.generate(top3.length, (index) {
              final g = top3[index].value;
              Color medalColor = index == 0 ? Colors.amber : (index == 1 ? Colors.grey.shade300 : Colors.brown.shade300);
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF141927),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: medalColor.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.emoji_events_rounded, color: medalColor, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(g['name'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(g['username'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text("+${g['points']} ${tr('points')}", style: TextStyle(color: medalColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _statBox(String val, String label, Color color) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
class EarnStarsTab extends StatefulWidget {
  final Map<String, dynamic> myData;
  final String currentUid;
  const EarnStarsTab({super.key, required this.myData, required this.currentUid});

  @override
  State<EarnStarsTab> createState() => _EarnStarsTabState();
}

class _EarnStarsTabState extends State<EarnStarsTab> with SingleTickerProviderStateMixin {
  late AnimationController _wheelCtrl;
  double _currentAngle = 0;
  bool _spinning = false;

  final List<Map<String, dynamic>> _missions = [
    {'id': 'tg', 'title': 'Follow Official Telegram', 'reward': 3, 'icon': Icons.send},
    {'id': 'ig', 'title': 'Follow Instagram Page', 'reward': 3, 'icon': Icons.camera_alt},
    {'id': 'yt', 'title': 'Subscribe YouTube Channel', 'reward': 5, 'icon': Icons.play_circle_fill},
    {'id': 'rate', 'title': 'Rate App 5 Stars', 'reward': 4, 'icon': Icons.star_rate},
    {'id': 'share', 'title': 'Share App Link with Friends', 'reward': 6, 'icon': Icons.share},
  ];

  @override
  void initState() {
    super.initState();
    _wheelCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _wheelCtrl.dispose();
    super.dispose();
  }

  // سیستم شانس کاملاً تصادفی و نادر برای 1000 ستاره
  Future<void> _spinLuckyWheel() async {
    if (_spinning) return;
    setState(() => _spinning = true);

    final rand = Random();
    int roll = rand.nextInt(1000); // عدد بین 0 تا 999
    int wonStars = 0;
    String prizeLabel = "پوچ! (Empty)";

    if (roll < 350) {
      wonStars = 0; // ۳۵٪ شانس پوچ
      prizeLabel = "پوچ! دوباره امتحان کن";
    } else if (roll < 750) {
      wonStars = 1; // ۴۰٪ شانس ۱ ستاره
      prizeLabel = "+1 ستاره!";
    } else if (roll < 940) {
      wonStars = 5; // ۱۹٪ شانس ۵ ستاره
      prizeLabel = "+5 ستاره!";
    } else if (roll < 995) {
      wonStars = 180; // ۵.۵٪ شانس ۱۸۰ ستاره
      prizeLabel = "🔥 +180 ستاره طلایی!";
    } else {
      wonStars = 1000; // فقط ۰.۵٪ (نیم درصد!) شانس جک‌پات ۱۰۰۰ ستاره!
      prizeLabel = "👑 JACKPOT! +1000 ستاره!";
    }

    double extraSpins = (5 + rand.nextInt(5)) * 2 * pi;
    double targetAngle = _currentAngle + extraSpins + (rand.nextDouble() * 2 * pi);

    final anim = Tween<double>(begin: _currentAngle, end: targetAngle).animate(
      CurvedAnimation(parent: _wheelCtrl, curve: Curves.easeOutCubic),
    );

    void listener() {
      setState(() => _currentAngle = anim.value);
    }

    anim.addListener(listener);
    await _wheelCtrl.forward(from: 0);
    anim.removeListener(listener);

    if (wonStars > 0) {
      await FirebaseFirestore.instance.collection('users').doc(widget.currentUid).update({
        'stars': FieldValue.increment(wonStars),
      });
    }

    setState(() => _spinning = false);
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF141927),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(wonStars > 0 ? Icons.stars_rounded : Icons.sentiment_neutral, color: appThemeColor.value, size: 60),
              const SizedBox(height: 12),
              Text(prizeLabel, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: appThemeColor.value, foregroundColor: Colors.black),
                onPressed: () => Navigator.pop(ctx),
                child: const Text("OK"),
              )
            ],
          ),
        ),
      );
    }
  }

  Future<void> _completeMission(String id, int reward) async {
    List done = List.from(widget.myData['completedTasks'] ?? []);
    if (done.contains(id)) return;
    done.add(id);
    await FirebaseFirestore.instance.collection('users').doc(widget.currentUid).update({
      'completedTasks': done,
      'stars': FieldValue.increment(reward),
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = appThemeColor.value;
    List doneTasks = widget.myData['completedTasks'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF141927),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: primary.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Text("0 • 1 • 5 • 180 • 1000 ⭐", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Transform.rotate(
                  angle: _currentAngle,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [primary, Colors.purpleAccent, Colors.cyanAccent, Colors.redAccent, primary],
                      ),
                      boxShadow: [BoxShadow(color: primary.withOpacity(0.4), blurRadius: 25)],
                    ),
                    child: Center(
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF0A0D14)),
                        child: Icon(Icons.star_rounded, color: primary, size: 55),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _spinning ? null : _spinLuckyWheel,
                    icon: const Icon(Icons.casino),
                    label: Text(_spinning ? "..." : tr('spin_now'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          Align(alignment: Alignment.centerRight, child: Text(tr('tasks'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          const SizedBox(height: 12),
          ..._missions.map((m) {
            bool isDone = doneTasks.contains(m['id']);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF141927), borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Icon(m['icon'], color: primary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("+${m['reward']} ${tr('stars')}", style: TextStyle(color: primary, fontSize: 12)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: isDone ? Colors.green : primary, foregroundColor: Colors.black),
                    onPressed: isDone ? null : () => _completeMission(m['id'], m['reward']),
                    child: Text(isDone ? "✓" : "Claim"),
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
class RankingTab extends StatelessWidget {
  final Map<String, dynamic> myData;
  final String currentUid;
  const RankingTab({super.key, required this.myData, required this.currentUid});

  Future<void> _giftStar(BuildContext context, Map<String, dynamic> target) async {
    int myStars = myData['stars'] ?? 0;
    if (myStars <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ستاره‌ای نداری! از بخش دریافت ستاره چرخ شانس را بچرخان."), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final rand = Random();
    int chance = rand.nextInt(100);
    int luckyPoints = chance < 60
        ? rand.nextInt(20) + 10
        : (chance < 90 ? rand.nextInt(30) + 30 : rand.nextInt(41) + 60);

    final batch = FirebaseFirestore.instance.batch();
    final myRef = FirebaseFirestore.instance.collection('users').doc(currentUid);
    final targetRef = FirebaseFirestore.instance.collection('users').doc(target['uid']);

    batch.update(myRef, {'stars': FieldValue.increment(-1)});
    batch.update(targetRef, {
      'points': FieldValue.increment(luckyPoints),
      'gifters.$currentUid': {
        'name': myData['name'],
        'username': myData['username'],
        'points': FieldValue.increment(luckyPoints),
      }
    });
    await batch.commit();

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF141927),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, color: appThemeColor.value, size: 60),
              const SizedBox(height: 10),
              Text("+$luckyPoints ${tr('points')}!", style: TextStyle(color: appThemeColor.value, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text("گیفت برای ${target['name']} ثبت شد!", textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: appThemeColor.value, foregroundColor: Colors.black),
                onPressed: () => Navigator.pop(ctx),
                child: const Text("OK"),
              )
            ],
          ),
        ),
      );
    }
  }

  Future<void> _toggleFollow(String targetUid, bool isFollowing) async {
    final batch = FirebaseFirestore.instance.batch();
    final myRef = FirebaseFirestore.instance.collection('users').doc(currentUid);
    final targetRef = FirebaseFirestore.instance.collection('users').doc(targetUid);

    if (isFollowing) {
      batch.update(myRef, {'following': FieldValue.arrayRemove([targetUid])});
      batch.update(targetRef, {'followers': FieldValue.arrayRemove([currentUid])});
    } else {
      batch.update(myRef, {'following': FieldValue.arrayUnion([targetUid])});
      batch.update(targetRef, {'followers': FieldValue.arrayUnion([currentUid])});
    }
    await batch.commit();
  }

  void _openUserProfileSheet(BuildContext context, Map<String, dynamic> user) {
    final primary = appThemeColor.value;
    final badge = getRankBadge(user['points'] ?? 0);
    List myFollowing = myData['following'] ?? [];
    bool isFollowing = myFollowing.contains(user['uid']);
    Map<String, dynamic> giftersMap = Map<String, dynamic>.from(user['gifters'] ?? {});
    var top3 = (giftersMap.entries.toList()
          ..sort((a, b) => (b.value['points'] as int).compareTo(a.value['points'] as int)))
        .take(3)
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141927),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: primary.withOpacity(0.2),
              backgroundImage: (user['photoUrl'] != null && user['photoUrl'] != '') ? NetworkImage(user['photoUrl']) : null,
              child: (user['photoUrl'] == null || user['photoUrl'] == '') ? Icon(Icons.person, size: 40, color: primary) : null,
            ),
            const SizedBox(height: 10),
            Text(user['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("${user['username']} • ${badge['title']}", style: TextStyle(color: badge['color'], fontSize: 13)),
            const SizedBox(height: 12),
            Text("${user['points'] ?? 0} ${tr('points')} | ${(user['followers'] ?? []).length} ${tr('followers')}", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            if (user['uid'] != currentUid)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: isFollowing ? Colors.grey.shade800 : Colors.blueAccent),
                    onPressed: () {
                      _toggleFollow(user['uid'], isFollowing);
                      Navigator.pop(context);
                    },
                    icon: Icon(isFollowing ? Icons.check : Icons.person_add, color: Colors.white),
                    label: Text(isFollowing ? tr('unfollow') : tr('follow'), style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                      _giftStar(context, user);
                    },
                    icon: const Icon(Icons.star_rounded),
                    label: Text(tr('gift')),
                  ),
                ],
              ),
            if (top3.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text("Top Supporters: ${top3.map((e) => e.value['name']).join(', ')}", style: const TextStyle(color: Colors.amber, fontSize: 12)),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = appThemeColor.value;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').orderBy('points', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final user = docs[index].data() as Map<String, dynamic>;
            int pts = user['points'] ?? 0;
            final badge = getRankBadge(pts);

            return GestureDetector(
              onTap: () => _openUserProfileSheet(context, user),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF141927),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: index == 0 ? primary : Colors.white10, width: index == 0 ? 1.5 : 1),
                ),
                child: Row(
                  children: [
                    Text("#${index + 1}", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: index < 3 ? primary : Colors.grey)),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: (user['photoUrl'] != null && user['photoUrl'] != '') ? NetworkImage(user['photoUrl']) : null,
                      child: (user['photoUrl'] == null || user['photoUrl'] == '') ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(child: Text(user['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 6),
                              Icon(badge['icon'], color: badge['color'], size: 16),
                            ],
                          ),
                          Text("${user['username']} • $pts ${tr('points')}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 10)),
                      onPressed: () => _giftStar(context, user),
                      icon: const Icon(Icons.star_rounded, size: 18),
                      label: Text(tr('gift'), style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
class FollowersTab extends StatefulWidget {
  final Map<String, dynamic> myData;
  final String currentUid;
  const FollowersTab({super.key, required this.myData, required this.currentUid});

  @override
  State<FollowersTab> createState() => _FollowersTabState();
}

class _FollowersTabState extends State<FollowersTab> {
  bool _showFollowers = true;

  @override
  Widget build(BuildContext context) {
    final primary = appThemeColor.value;
    List targetIds = _showFollowers ? (widget.myData['followers'] ?? []) : (widget.myData['following'] ?? []);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showFollowers ? primary : const Color(0xFF141927),
                    foregroundColor: _showFollowers ? Colors.black : Colors.white,
                  ),
                  onPressed: () => setState(() => _showFollowers = true),
                  child: Text("${tr('followers')} (${(widget.myData['followers'] ?? []).length})"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_showFollowers ? primary : const Color(0xFF141927),
                    foregroundColor: !_showFollowers ? Colors.black : Colors.white,
                  ),
                  onPressed: () => setState(() => _showFollowers = false),
                  child: Text("${tr('following')} (${(widget.myData['following'] ?? []).length})"),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: targetIds.isEmpty
              ? const Center(child: Text("لیست خالی است", style: TextStyle(color: Colors.grey)))
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').where('uid', whereIn: targetIds.take(10).toList()).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final u = docs[i].data() as Map<String, dynamic>;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: (u['photoUrl'] != null && u['photoUrl'] != '') ? NetworkImage(u['photoUrl']) : null,
                            child: (u['photoUrl'] == null || u['photoUrl'] == '') ? const Icon(Icons.person) : null,
                          ),
                          title: Text(u['name'] ?? ''),
                          subtitle: Text(u['username'] ?? '', style: const TextStyle(color: Colors.grey)),
                          trailing: Text("${u['points'] ?? 0} ⭐", style: TextStyle(color: primary)),
                        );
                      },
                    );
                  },
                ),
        )
      ],
    );
  }
}

class SettingsTab extends StatelessWidget {
  final Map<String, dynamic> myData;
  const SettingsTab({super.key, required this.myData});

  @override
  Widget build(BuildContext context) {
    final primary = appThemeColor.value;
    final langs = {
      'fa': 'دری / فارسی',
      'en': 'English',
      'ar': 'العربية',
      'tr': 'Türkçe',
      'ru': 'Русский',
      'fr': 'Français',
      'es': 'Español',
    };
    final colors = [
      const Color(0xFFFFD700),
      const Color(0xFF00E5FF),
      const Color(0xFFD500F9),
      const Color(0xFF00E676),
      const Color(0xFFFF3D00),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(tr('language'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: langs.entries.map((e) {
            bool selected = appLang.value == e.key;
            return ChoiceChip(
              label: Text(e.value),
              selected: selected,
              selectedColor: primary,
              labelStyle: TextStyle(color: selected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
              onSelected: (_) => appLang.value = e.key,
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text(tr('theme'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: colors.map((c) {
            return GestureDetector(
              onTap: () => appThemeColor.value = c,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: c,
                child: appThemeColor.value == c ? const Icon(Icons.check, color: Colors.black) : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 30),
        ListTile(
          tileColor: const Color(0xFF141927),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: Icon(Icons.info_outline, color: primary),
          title: Text(tr('about')),
          subtitle: const Text("Developed by Elyas Morgan • StarRank v2.0"),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            onPressed: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: Text(tr('logout'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }
}
// ویجت اختصاصی قاب انیمیشنی نفرات اول، دوم و سوم
class AnimatedRankFrame extends StatefulWidget {
  final Widget child;
  final int rank; // 1, 2, 3 یا بالاتر
  final double size;

  const AnimatedRankFrame({
    super.key,
    required this.child,
    required this.rank,
    this.size = 90,
  });

  @override
  State<AnimatedRankFrame> createState() => _AnimatedRankFrameState();
}

class _AnimatedRankFrameState extends State<AnimatedRankFrame> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rank < 1 || widget.rank > 3) {
      return SizedBox(width: widget.size, height: widget.size, child: widget.child);
    }

    Color mainColor = widget.rank == 1
        ? const Color(0xFFFFD700)
        : (widget.rank == 2 ? const Color(0xFF00E5FF) : const Color(0xFFFF7043));
    Color accentColor = widget.rank == 1
        ? const Color(0xFFD50000)
        : (widget.rank == 2 ? const Color(0xFF3D5AFE) : const Color(0xFF8D6E63));

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        double floatOffset = widget.rank == 1 ? sin(_ctrl.value * pi) * -5 : 0;
        double glowSpread = 4 + (_ctrl.value * 8);

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: SizedBox(
            width: widget.size + 26,
            height: widget.size + 26,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // هاله نورانی پشت قاب
                Container(
                  width: widget.size + 8,
                  height: widget.size + 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: mainColor.withOpacity(0.55),
                        blurRadius: 18,
                        spreadRadius: glowSpread,
                      ),
                    ],
                  ),
                ),
                // تصویر پروفایل داخل قاب
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(width: widget.size, height: widget.size, child: widget.child),
                ),
                // نقاشی قاب سلطنتی و تیغه‌های کناری
                CustomPaint(
                  size: Size(widget.size + 24, widget.size + 24),
                  painter: _RoyalFramePainter(
                    mainColor: mainColor,
                    accentColor: accentColor,
                    rank: widget.rank,
                    shimmer: _ctrl.value,
                  ),
                ),
                // نشان رتبه در پایین قاب (#1, #2, #3)
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [accentColor, Colors.black]),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: mainColor, width: 1.5),
                    ),
                    child: Text(
                      widget.rank == 1 ? "👑 #1" : (widget.rank == 2 ? "💎 #2" : "🔥 #3"),
                      style: TextStyle(color: mainColor, fontWeight: FontWeight.w900, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
AnimatedRankFrame(
  rank: index + 1,
  size: 46,
  child: Container(
    color: const Color(0xFF1E2538),
    child: (user['photoUrl'] != null && user['photoUrl'] != '')
        ? Image.network(user['photoUrl'], fit: BoxFit.cover)
        : Icon(Icons.person, color: primary),
  ),
),
