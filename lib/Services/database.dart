import 'dart:async';
import 'dart:io';

import 'package:mlvapp/Models/anxq_model.dart';
import 'package:mlvapp/Models/dass_model.dart';
import 'package:mlvapp/Models/depq_model.dart';
import 'package:mlvapp/Models/dqa_model.dart';
import 'package:mlvapp/Models/gse_model.dart';
import 'package:mlvapp/Models/pa_model.dart';
import 'package:mlvapp/Models/streq_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? db;

  Future<Database> get database async => db ??= await initDatabase();

  final String gseTable = 'gse_test';
  final String dqaTable = 'dqa_test';
  final String dassTable = 'dass_test';
  final String depQTable = 'depq_test';

  final String anxQTable = 'anxq_test';
  final String strQTable = 'strq_test';
  final String paTable = 'pa_test';

  deleteDatabase() async {
    var dbPath = await getDatabasesPath();
    Directory path = await getApplicationDocumentsDirectory();

    databaseFactory.deleteDatabase(dbPath);
  }

  initDatabase() async {
    var dbPath = await getDatabasesPath();
    Directory path = await getApplicationDocumentsDirectory();

    //  String path = join(dbPath, 'mhelp.db');

    db = await openDatabase(
      path.toString(),
      version: 1,
      onCreate: (db, int version) async {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS $dqaTable (id INTEGER PRIMARY KEY, question TEXT, nott INTEGER, hardly INTEGER, moderately INTEGER, exactly INTEGER)');

        //  await db.execute(
        //     'CREATE TABLE IF NOT EXISTS $dqaTable (id INTEGER PRIMARY KEY,  question TEXT, nott INTEGER, hardly INTEGER, moderately INTEGER, exactly INTEGER)');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS $gseTable (id INTEGER PRIMARY KEY, question TEXT, nott INTEGER, hardly INTEGER, moderately INTEGER, exactly INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $dassTable (id INTEGER PRIMARY KEY, question TEXT, never INTEGER, sometimes INTEGER, often INTEGER, always INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $depQTable (id INTEGER PRIMARY KEY, question TEXT, never INTEGER, sometimes INTEGER, often INTEGER, always INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $anxQTable (id INTEGER PRIMARY KEY, question TEXT, never INTEGER, sometimes INTEGER, often INTEGER, always INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $strQTable (id INTEGER PRIMARY KEY, question TEXT, never INTEGER, sometimes INTEGER, often INTEGER, always INTEGER)');

        await db.execute(
            'CREATE TABLE IF NOT EXISTS $paTable (id INTEGER PRIMARY KEY, question TEXT, disagree_strongly INTEGER, disagree_moderately INTEGER,disagree_alittle INTEGER, neither_agree_or_disagree INTEGER, agree_a_little INTEGER, agree_strongly INTEGER )');
      },
    );

    //print(db);
    // deleteDass();
    // deleteGSEs();
    // deleteDqA();
    // deleteANXQ();
    // deleteDepQ();
    // deletePA();
    // deleteStrQ();

    if ((await countGSEData())! == 0) {
      _insertGseData();
    }

    if ((await countDQAData())! == 0) {
      _insertDQAData();
    }

    if ((await countDassData())! == 0) {
      _insertDassData();
    }

    // if ((await countDassData())! == 0) {
    //   _insertDassData();
    // }

    if ((await countDepQData())! == 0) {
      _insertDepQData();
    }

    if ((await countANXQData())! == 0) {
      _insertANXQData();
    }

    if ((await countStrQData())! == 0) {
      _insertStrQData();
    }

    if ((await countPAData())! == 0) {
      _insertPAData();
    }
  }

  ///gse
  Future<bool> insertGSE(GSETestModel gse) async {
    try {
      await db!.insert(gseTable, gse.toMap());
      // print("hii");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<GSETestModel>> getAllGseTests() async {
    final List<Map<String, dynamic>> maps = await db!.query(gseTable);
    //print(maps);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return GSETestModel(
        id: maps[i]['id'],
        question: maps[i]['question'],
        nott: maps[i]['nott'],
        hardly: maps[i]['hardly'],
        moderately: maps[i]['moderately'],
        exactly: maps[i]['exactly'],
      );
    });
  }

  Future<int?> countGSEData() async {
    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $gseTable'));

    return count;
  }

  Future<bool> deleteGSEs() async {
    await db!.execute("delete from $gseTable");

    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $gseTable'));
    //print(count);
    if (count == 0) {
      return true;
    } else {
      return false;
    }
  }

  /////////DQA
  Future<bool> insertDQA(DQATESTModel dqa) async {
    try {
      await db!.insert(dqaTable, dqa.toMap());
      // print("hii");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<DQATESTModel>> getAllDQATests() async {
    final List<Map<String, dynamic>> maps = await db!.query(dqaTable);
    print(maps);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return DQATESTModel(
        id: maps[i]['id'],
        question: maps[i]['question'],
        nott: maps[i]['nott'],
        hardly: maps[i]['hardly'],
        moderately: maps[i]['moderately'],
        exactly: maps[i]['exactly'],
      );
    });
  }

  Future<int?> countDQAData() async {
    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $dqaTable'));

    return count;
  }

  Future<bool> deleteDQAs() async {
    await db!.execute("delete from $dqaTable");

    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $dqaTable'));
    //print(count);
    if (count == 0) {
      return true;
    } else {
      return false;
    }
  }

  /////////////// Dass
  Future<bool> insertDass(DASSTestModel dass) async {
    try {
      await db!.insert(dassTable, dass.toMap());
      // print("hii");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<DASSTestModel>> getAllDass() async {
    final List<Map<String, dynamic>> maps = await db!.query(dassTable);
    print(maps);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return DASSTestModel(
          id: maps[i]['id'],
          question: maps[i]['question'],
          never: maps[i]['never'],
          sometimes: maps[i]['sometimes'],
          often: maps[i]['often'],
          always: maps[i]['always'],
          moderately: maps[i]['moderately']);
    });
  }

  Future<int?> countDassData() async {
    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $dassTable'));

    return count;
  }

  Future<bool> deleteDass() async {
    await db!.execute("delete from $dassTable");

    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $dassTable'));
    //print(count);
    if (count == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteDqA() async {
    await db!.execute("delete from $dqaTable");

    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $dqaTable'));
    //print(count);
    if (count == 0) {
      return true;
    } else {
      return false;
    }
  }

  ///////depQ

  Future<bool> insertDepQ(DepQTestModel depq) async {
    try {
      await db!.insert(depQTable, depq.toMap());
      // print("hii");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<DepQTestModel>> getAllDepQ() async {
    final List<Map<String, dynamic>> maps = await db!.query(depQTable);
    print(maps);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return DepQTestModel(
        id: maps[i]['id'],
        question: maps[i]['question'],
        never: maps[i]['never'],
        sometimes: maps[i]['sometimes'],
        often: maps[i]['often'],
        always: maps[i]['always'],
      );
    });
  }

  Future<int?> countDepQData() async {
    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $depQTable'));

    return count;
  }

  Future<bool> deleteDepQ() async {
    await db!.execute("delete from $depQTable");

    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $depQTable'));
    //print(count);
    if (count == 0) {
      return true;
    } else {
      return false;
    }
  }
//////ANXQ

  Future<bool> insertANXQ(ANXQTestModel anxq) async {
    try {
      await db!.insert(anxQTable, anxq.toMap());
      // print("hii");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<ANXQTestModel>> getAllANXQ() async {
    final List<Map<String, dynamic>> maps = await db!.query(anxQTable);
    //print(maps);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return ANXQTestModel(
        id: maps[i]['id'],
        question: maps[i]['question'],
        never: maps[i]['never'],
        sometimes: maps[i]['sometimes'],
        often: maps[i]['often'],
        always: maps[i]['always'],
      );
    });
  }

  Future<int?> countANXQData() async {
    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $anxQTable'));

    return count;
  }

  Future<bool> deleteANXQ() async {
    await db!.execute("delete from $anxQTable");

    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $anxQTable'));
    //print(count);
    if (count == 0) {
      return true;
    } else {
      return false;
    }
  }

  /////STRQ

  Future<bool> insertStrQ(strq) async {
    try {
      await db!.insert(strQTable, strq.toMap());
      // print("hii");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<StrQTestModel>> getAllStrQ() async {
    final List<Map<String, dynamic>> maps = await db!.query(strQTable);
    //print(maps);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return StrQTestModel(
        id: maps[i]['id'],
        question: maps[i]['question'],
        never: maps[i]['never'],
        sometimes: maps[i]['sometimes'],
        often: maps[i]['often'],
        always: maps[i]['always'],
      );
    });
  }

  Future<int?> countStrQData() async {
    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $strQTable'));

    return count;
  }

  Future<bool> deleteStrQ() async {
    await db!.execute("delete from $strQTable");

    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $strQTable'));
    //print(count);
    if (count == 0) {
      return true;
    } else {
      return false;
    }
  }

//////pa

  Future<bool> insertPA(pa) async {
    try {
      await db!.insert(paTable, pa.toMap());
      // print("hii");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<PATestModel>> getAllPA() async {
    final List<Map<String, dynamic>> maps = await db!.query(paTable);
    //print(maps);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return PATestModel(
        id: maps[i]['id'],
        question: maps[i]['question'],
        disagree_strongly: maps[i]['disagree_strongly'],
        disagree_moderately: maps[i]['disagree_moderately'],
        disagree_alittle: maps[i]['disagree_alittle'],
        neither_agree_or_disagree: maps[i]['neither_agree_or_disagree'],
        agree_a_little: maps[i]['agree_a_little'],
        agree_strongly: maps[i]['agree_strongly'],
      );
    });
  }

  Future<int?> countPAData() async {
    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $paTable'));

    return count;
  }

  Future<bool> deletePA() async {
    await db!.execute("delete from $paTable");

    int? count = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $paTable'));
    //print(count);
    if (count == 0) {
      return true;
    } else {
      return false;
    }
  }

  void _insertGseData() {
    //print('hi');
    DatabaseService().insertGSE(GSETestModel(
        question: '1. I can always manage to solve difficult problems if I try hard enough.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertGSE(GSETestModel(
        question: '2. If someone opposes me, I can find the means and ways to get what I want.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertGSE(GSETestModel(
        question: '3. It is easy for me to stick to my aims and accomplish my goals.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertGSE(GSETestModel(
        question: '4. I am confident that I could deal efficiently with unexpected events.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertGSE(GSETestModel(
        question: '5. Thanks to my resourcefulness, I know how to handle unforeseen situations.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertGSE(GSETestModel(
        question: '6. I can solve most problems if I invest the necessary effort.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertGSE(GSETestModel(
        question: '7. I can remain calm when facing difficulties because I can rely on my coping abilities.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertGSE(GSETestModel(
        question: '8. When I am confronted with a problem, I can usually find several solutions.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertGSE(GSETestModel(
        question: '9. If I am in trouble, I can usually think of a solution',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertGSE(GSETestModel(
        question: '10. I can usually handle whatever comes my way.', nott: 0, hardly: 0, moderately: 0, exactly: 0));
  }

  void _insertDQAData() {
    //print('hi');
    DatabaseService().insertDQA(DQATESTModel(
        question: '1. I can always manage to solve difficult problems if I try hard enough.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertDQA(DQATESTModel(
        question: '2. If someone opposes me, I can find the means and ways to get what I want.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertDQA(DQATESTModel(
        question: '3. It is easy for me to stick to my aims and accomplish my goals.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertDQA(DQATESTModel(
        question: '4. I am confident that I could deal efficiently with unexpected events.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertDQA(DQATESTModel(
        question: '5. Thanks to my resourcefulness, I know how to handle unforeseen situations.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertDQA(DQATESTModel(
        question: '6. I can solve most problems if I invest the necessary effort.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertDQA(DQATESTModel(
        question: '7. I can remain calm when facing difficulties because I can rely on my coping abilities.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertDQA(DQATESTModel(
        question: '8. When I am confronted with a problem, I can usually find several solutions.',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertDQA(DQATESTModel(
        question: '9. If I am in trouble, I can usually think of a solution',
        nott: 0,
        hardly: 0,
        moderately: 0,
        exactly: 0));
    DatabaseService().insertDQA(DQATESTModel(
        question: '10. I can usually handle whatever comes my way.', nott: 0, hardly: 0, moderately: 0, exactly: 0));
  }

  void _insertDassData() {
    //print('hi');
    DatabaseService().insertDass(DASSTestModel(
        question: '1. I found it hard to wind down.', never: 0, sometimes: 0, often: 0, always: 0, moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '2. I was aware of dryness of my mouth.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '3. I couldn’t seem to experience any positive feeling at all.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question:
            '4. I experienced breathing difficulty (eg, excessively rapid breathing, breathlessness in the absence of physical exertion).',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '5. I found it difficult to work up the initiative to do things.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '6. I tended to over-react to situations.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '7. I experienced trembling (eg, in the hands)',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '8. I felt that I was using a lot of nervous energy.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '9. I was worried about situations in which I might panic and make a fool of myself',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '10. I felt that I had nothing to look forward to.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '11. I found myself getting agitated.', never: 0, sometimes: 0, often: 0, always: 0, moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '12. I found it difficult to relax.', never: 0, sometimes: 0, often: 0, always: 0, moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '13. I felt down-hearted and blue.', never: 0, sometimes: 0, often: 0, always: 0, moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '14. I was intolerant of anything that kept me from getting on with what I was doing.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '15. I felt I was close to panic.', never: 0, sometimes: 0, often: 0, always: 0, moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '16. I was unable to become enthusiastic about anything.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '17. I felt I wasn’t worth much as a person.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '18. I felt that I was rather touchy.', never: 0, sometimes: 0, often: 0, always: 0, moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question:
            '19. I was aware of the action of my heart in the absence of physicalexertion (eg, sense of heart rate increase, heart missing a beat)',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '20. I felt scared without any good reason.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0,
        moderately: 0));
    DatabaseService().insertDass(DASSTestModel(
        question: '21. I felt that life was meaningless.', never: 0, sometimes: 0, often: 0, always: 0, moderately: 0));
  }

  void _insertDepQData() {
    //print('hi');
    DatabaseService().insertDepQ(DepQTestModel(
      question: '1. I  couldn’t seem to experience any positive feeling at all.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '2. I just couldn’t seem to get going.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '3. I felt that I had nothing to look forward to.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '4. I felt sad and depressed.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '5. I felt that I had lost interest in just about everything.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '6. I felt I wasn’t worth much as a person.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '7. I felt that life wasn’t worthwhile.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '8. I couldn’t seem to get any enjoyment out of the things I did.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '9. I felt down-hearted and blue.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '10. I was unable to become enthusiastic about anything.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '11. I felt I was pretty worthless.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '12. I could see nothing in the future to be hopeful about.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '13. I felt that life was meaningless.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertDepQ(DepQTestModel(
      question: '14. I found it difficult to work up the initiative to do things.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
  }

  void _insertANXQData() {
    //updated
    //print('hi');
    DatabaseService().insertANXQ(ANXQTestModel(
      question: '1. I was aware of dryness of my mouth.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertANXQ(ANXQTestModel(
        question:
            '2. I experienced breathing difficulty (eg, excessively rapid breathing, breathlessness in the absence of physical exertion).',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0));
    DatabaseService().insertANXQ(ANXQTestModel(
      question: '3. I had a feeling of shakiness (eg, legs going to give way).',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertANXQ(ANXQTestModel(
        question: '4. I found myself in situations that made me so anxious I was most relieved when they ended.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0));
    DatabaseService().insertANXQ(ANXQTestModel(
      question: '5. I had a feeling of faintness.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertANXQ(ANXQTestModel(
        question:
            '6. I perspired noticeably (eg, hands sweaty) in the absence of high temperatures or physical exertion.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0));
    DatabaseService().insertANXQ(ANXQTestModel(
      question: '7. I felt scared without any good reason.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertANXQ(ANXQTestModel(
      question: '8. I had difficulty in swallowing.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertANXQ(ANXQTestModel(
        question:
            '9. I was aware of the action of my heart in the absence of physical exertion (eg, sense of heart rate increase, heart missing a beat).',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0));
    DatabaseService().insertANXQ(ANXQTestModel(
      question: '10. I felt I was close to panic',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertANXQ(ANXQTestModel(
        question: '11. I feared that I would be "thrown" by some trivial but unfamiliar task',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0));
    DatabaseService().insertANXQ(ANXQTestModel(
      question: '12. I felt terrified.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertANXQ(ANXQTestModel(
        question: '13. I was worried about situations in which I might panic and make a fool of myself.',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0));
    DatabaseService().insertANXQ(ANXQTestModel(
      question: '14. I experienced trembling (eg, in the hands).',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
  }

  void _insertStrQData() {
    //updated
    //print('hi');
    DatabaseService().insertStrQ(StrQTestModel(
      question: '1. I found myself getting upset by quite trivial things.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertStrQ(StrQTestModel(
      question: '2. I tended to over-react to situations.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertStrQ(StrQTestModel(
      question: '3. I found it difficult to relax.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertStrQ(StrQTestModel(
      question: '4. I found myself getting upset rather easily.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertStrQ(StrQTestModel(
      question: '5. I felt that I was using a lot of nervous energy.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertStrQ(StrQTestModel(
        question:
            '6. I found myself getting impatient when I was delayed in any way (eg, elevators, traffic lights, being kept waiting).',
        never: 0,
        sometimes: 0,
        often: 0,
        always: 0));
    DatabaseService().insertStrQ(StrQTestModel(
      question: '7. I felt that I was rather touchy.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertStrQ(StrQTestModel(
      question: '8. I found it hard to wind down.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertStrQ(StrQTestModel(
      question: '9. I found that I was very irritable.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertStrQ(StrQTestModel(
      question: '10. I found it hard to calm down after something upset me.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertStrQ(StrQTestModel(
      question: '11. I found it difficult to tolerate interruptions to what I was doing.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertStrQ(StrQTestModel(
      question: '12. I was in a state of nervous tension.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertStrQ(StrQTestModel(
      question: '13. I was intolerant of anything that kept me from getting on with what I was doing.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
    DatabaseService().insertStrQ(StrQTestModel(
      question: '14. I found myself getting agitated.',
      never: 0,
      sometimes: 0,
      often: 0,
      always: 0,
    ));
  }

  void _insertPAData() {
    //updated
    //print('hi');
    DatabaseService().insertPA(PATestModel(
        question: '1. I see myself as Extraverted, enthusiastic.',
        agree_a_little: 0,
        agree_strongly: 0,
        disagree_alittle: 0,
        disagree_moderately: 0,
        disagree_strongly: 0,
        neither_agree_or_disagree: 0));
    DatabaseService().insertPA(PATestModel(
        question: '2. I see myself as Critical, quarrelsome.',
        agree_a_little: 0,
        agree_strongly: 0,
        disagree_alittle: 0,
        disagree_moderately: 0,
        disagree_strongly: 0,
        neither_agree_or_disagree: 0));
    DatabaseService().insertPA(PATestModel(
        question: '3. I see myself as Dependable, self-disciplined.',
        agree_a_little: 0,
        agree_strongly: 0,
        disagree_alittle: 0,
        disagree_moderately: 0,
        disagree_strongly: 0,
        neither_agree_or_disagree: 0));
    DatabaseService().insertPA(PATestModel(
        question: '4. I see myself as Anxious, easily upset.',
        agree_a_little: 0,
        agree_strongly: 0,
        disagree_alittle: 0,
        disagree_moderately: 0,
        disagree_strongly: 0,
        neither_agree_or_disagree: 0));
    DatabaseService().insertPA(PATestModel(
        question: '5. I see myself as Open to new experiences, complex.',
        agree_a_little: 0,
        agree_strongly: 0,
        disagree_alittle: 0,
        disagree_moderately: 0,
        disagree_strongly: 0,
        neither_agree_or_disagree: 0));
    DatabaseService().insertPA(PATestModel(
        question: '6. I see myself as Reserved, quiet.',
        agree_a_little: 0,
        agree_strongly: 0,
        disagree_alittle: 0,
        disagree_moderately: 0,
        disagree_strongly: 0,
        neither_agree_or_disagree: 0));
    DatabaseService().insertPA(PATestModel(
        question: '7. I see myself as Sympathetic, warm.',
        agree_a_little: 0,
        agree_strongly: 0,
        disagree_alittle: 0,
        disagree_moderately: 0,
        disagree_strongly: 0,
        neither_agree_or_disagree: 0));
    DatabaseService().insertPA(PATestModel(
        question: '8. I see myself as Disorganized, careless.',
        agree_a_little: 0,
        agree_strongly: 0,
        disagree_alittle: 0,
        disagree_moderately: 0,
        disagree_strongly: 0,
        neither_agree_or_disagree: 0));
    DatabaseService().insertPA(PATestModel(
        question: '9. I see myself as Calm, emotionally stable.',
        agree_a_little: 0,
        agree_strongly: 0,
        disagree_alittle: 0,
        disagree_moderately: 0,
        disagree_strongly: 0,
        neither_agree_or_disagree: 0));
    DatabaseService().insertPA(PATestModel(
        question: '10. I see myself as Conventional, uncreative.',
        agree_a_little: 0,
        agree_strongly: 0,
        disagree_alittle: 0,
        disagree_moderately: 0,
        disagree_strongly: 0,
        neither_agree_or_disagree: 0));
  }
}
