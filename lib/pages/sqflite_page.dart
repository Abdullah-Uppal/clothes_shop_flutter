import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

Future<List<Employee>> fetchEmployeesFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<Employee>> employees = dbHelper.getEmployees();
  return employees;
}

class SQFlitePage extends StatefulWidget {
  const SQFlitePage({super.key});

  @override
  State<SQFlitePage> createState() => _SQFlitePageState();
}

class _SQFlitePageState extends State<SQFlitePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: Color.fromRGBO(0x1e, 0x2e, 0x3d, 1),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/sqflite/create');
        },
        child: const Icon(
          Icons.add,
        ),
        backgroundColor: Color.fromRGBO(0x1e, 0x2e, 0x3d, 1),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Employee>>(
          future: fetchEmployeesFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            snapshot.data![index].firstName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            snapshot.data![index].lastName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          new Divider()
                        ]);
                  });
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class CreateEmployeePage extends StatefulWidget {
  const CreateEmployeePage({super.key});

  @override
  State<CreateEmployeePage> createState() => _CreateEmployeePageState();
}

class _CreateEmployeePageState extends State<CreateEmployeePage> {
  Employee employee = new Employee("", "", "", "");

  String? firstname;
  String? lastname;
  String? emailId;
  String? mobileno;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: new Text('Saving Employee'), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.view_list),
          tooltip: 'Next choice',
          onPressed: () {
            context.pushReplacement('/sqflite');
          },
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (val) =>
                    val?.isEmpty ?? true ? "Enter FirstName" : null,
                onSaved: (val) => this.firstname = val,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (val) =>
                    (val?.length ?? 0) == 0 ? 'Enter LastName' : null,
                onSaved: (val) => lastname = val,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Mobile No'),
                validator: (val) =>
                    (val?.length ?? 0) == 0 ? 'Enter Mobile No' : null,
                onSaved: (val) => mobileno = val,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email Id'),
                validator: (val) =>
                    (val?.length ?? 0) == 0 ? 'Enter Email Id' : null,
                onSaved: (val) => emailId = val,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Save Employee'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    } else {
      return;
    }
    var employee = Employee(
      firstname ?? "",
      lastname ?? "",
      mobileno ?? "",
      emailId ?? "",
    );
    var dbHelper = DBHelper();
    dbHelper.saveEmployee(employee);
  }

  void _showSnackBar(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
}

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Employee(id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, mobileno TEXT,emailId TEXT )");
    print("Created tables");
  }

  void saveEmployee(Employee employee) async {
    var dbClient = await db;
    await dbClient!.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Employee(firstname, lastname, mobileno, emailId ) VALUES("${employee.firstName}","${employee.lastName}", "${employee.mobileNo}", "${employee.emailId}")');
    });
  }

  Future<List<Employee>> getEmployees() async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery('SELECT * FROM Employee');
    List<Employee> employees = [];
    for (int i = 0; i < list.length; i++) {
      employees.add(new Employee(list[i]["firstname"], list[i]["lastname"],
          list[i]["mobileno"], list[i]["emailId"]));
    }
    print(employees.length);
    return employees;
  }
}

class Employee {
  String firstName;
  String lastName;
  String mobileNo;
  String emailId;

  Employee(this.firstName, this.lastName, this.mobileNo, this.emailId);
  factory Employee.fromMap(Map map) {
    return Employee(
      map["firstName"],
      map["lastName"],
      map["mobileNo"],
      map["emailId"],
    );
  }
}
