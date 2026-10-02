import 'package:flutter/material.dart';

void main() => runApp(const StudentApp());

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Learning',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة الطالب')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('أهلاً بك 👋'),
              subtitle: Text('منصة التعلم للطلاب'),
            ),
          ),
          const SizedBox(height: 12),
          _nav(context, 'الاختبارات', Icons.quiz, const QuizPage()),
          _nav(context, 'الواجبات المنزلية', Icons.assignment, const HomeworkPage()),
          _nav(context, 'الحصص والسلايدات', Icons.video_library, const LessonsPage()),
        ],
      ),
    );
  }

  Widget _nav(BuildContext context, String title, IconData icon, Widget page) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        ),
      ),
    );
  }
}

class QuizQuestion {
  final String text;
  final List<String> options;
  final String correct;
  QuizQuestion(this.text, this.options, this.correct);
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final questions = [
    QuizQuestion('ما ناتج 2 + 2؟', ['3', '4', '5', '6'], '4'),
    QuizQuestion('ما ناتج 3 × 2؟', ['5', '6', '7', '8'], '6'),
    QuizQuestion('ما ناتج 10 ÷ 2؟', ['2', '4', '5', '8'], '5'),
  ];

  int index = 0;
  int score = 0;
  String? selected;
  bool answered = false;

  void choose(String answer) {
    if (answered) return;
    setState(() {
      selected = answer;
      answered = true;
      if (answer == questions[index].correct) score++;
    });
  }

  void next() {
    if (!answered) return;
    if (index == questions.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(score: score, total: questions.length),
        ),
      );
      return;
    }
    setState(() {
      index++;
      selected = null;
      answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[index];
    return Scaffold(
      appBar: AppBar(title: const Text('الاختبار')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LinearProgressIndicator(value: (index + 1) / questions.length),
          const SizedBox(height: 12),
          Text('السؤال ${index + 1} من ${questions.length}',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(q.text, style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          const SizedBox(height: 12),
          ...q.options.map((option) {
            final correct = option == q.correct;
            final wrongSelected = option == selected && !correct;
            Color? bg;
            if (answered && correct) bg = Colors.green.shade200;
            if (answered && wrongSelected) bg = Colors.red.shade200;
            return Card(
              color: bg,
              child: ListTile(
                title: Text(option),
                trailing: answered && correct
                    ? const Icon(Icons.check, color: Colors.green)
                    : answered && wrongSelected
                        ? const Icon(Icons.close, color: Colors.red)
                        : null,
                onTap: () => choose(option),
              ),
            );
          }),
          const SizedBox(height: 12),
          if (answered)
            Text(
              selected == q.correct ? 'إجابة صحيحة ✓' : 'إجابة خاطئة ✗',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: selected == q.correct ? Colors.green : Colors.red,
              ),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: answered ? next : null,
            child: Text(index == questions.length - 1 ? 'إنهاء الاختبار' : 'السؤال التالي'),
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final int total;
  const ResultPage({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final percent = ((score / total) * 100).round();
    return Scaffold(
      appBar: AppBar(title: const Text('النتيجة النهائية')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, size: 64),
                const SizedBox(height: 16),
                const Text('انتهى الاختبار', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('$score / $total', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                Text('$percent%'),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('العودة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeworkPage extends StatelessWidget {
  const HomeworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homework = [
      ('حل ورقة المعادلات', 'التسليم: 2026/10/05', false),
      ('مراجعة درس الدوال', 'التسليم: 2026/10/08', false),
      ('تدريب إضافي', 'تم التسليم ✓', true),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('الواجبات المنزلية')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: homework.length,
        itemBuilder: (_, i) {
          final h = homework[i];
          return Card(
            child: ListTile(
              leading: Icon(h.$3 ? Icons.check_circle : Icons.assignment),
              title: Text(h.$1),
              subtitle: Text(h.$2),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeworkDetailsPage(title: h.$1),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomeworkDetailsPage extends StatelessWidget {
  final String title;
  const HomeworkDetailsPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الواجب')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('أرفق صورة أو ملف الحل ثم اضغط على إرسال الواجب.'),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _message(context, 'سيتم ربط الكاميرا/Firebase Storage هنا.'),
            icon: const Icon(Icons.camera_alt),
            label: const Text('التقاط صورة للحل'),
          ),
          OutlinedButton.icon(
            onPressed: () => _message(context, 'سيتم ربط اختيار الملفات هنا.'),
            icon: const Icon(Icons.attach_file),
            label: const Text('اختيار ملف'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _message(context, 'تم تجهيز مكان إرسال الواجب.'),
            child: const Text('إرسال الواجب'),
          ),
        ],
      ),
    );
  }

  void _message(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = [
      ('الدرس الأول: المعادلات', 'حصة فيديو + سلايدات PDF'),
      ('الدرس الثاني: الدوال', 'حصة فيديو + سلايدات PDF'),
      ('الدرس الثالث: المتباينات', 'حصة فيديو + سلايدات PDF'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('الحصص والسلايدات')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: lessons.length,
        itemBuilder: (_, i) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.play_circle),
              title: Text(lessons[i].$1),
              subtitle: Text(lessons[i].$2),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonDetailsPage(title: lessons[i].$1),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LessonDetailsPage extends StatelessWidget {
  final String title;
  const LessonDetailsPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.play_arrow, color: Colors.white, size: 64),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _message(context, 'سيتم ربط رابط الفيديو الحقيقي هنا.'),
            icon: const Icon(Icons.play_arrow),
            label: const Text('مشاهدة الحصة'),
          ),
          OutlinedButton.icon(
            onPressed: () => _message(context, 'سيتم فتح PDF Viewer عند ربط ملف السلايدات.'),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('عرض السلايدات PDF'),
          ),
          OutlinedButton.icon(
            onPressed: () => _message(context, 'سيتم تنزيل ملف PDF من الرابط.'),
            icon: const Icon(Icons.download),
            label: const Text('تحميل السلايدات'),
          ),
        ],
      ),
    );
  }

  void _message(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
