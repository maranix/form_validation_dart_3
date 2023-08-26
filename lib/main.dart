import 'package:flutter/material.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: MyFormWidget(),
        ),
      ),
    );
  }
}

class MyFormWidget extends StatefulWidget {
  const MyFormWidget({super.key});

  @override
  State<MyFormWidget> createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
  late RegistrationForm _registrationForm;

  @override
  void initState() {
    super.initState();

    final formKey = GlobalKey<FormState>();

    _registrationForm = RegistrationForm(key: formKey);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registrationForm.key,
      child: Column(
        children: [
          TextFormField(),
          TextFormField(),
        ],
      ),
    );
  }
}

base class BaseForm {
  const BaseForm({
    required this.key,
  });

  final GlobalKey<FormState> key;

  bool validate() {
    if (key.currentState != null) {
      return key.currentState!.validate();
    } else {
      throw StateError('''
      $runtimeType:

      The current FormState is null this can occur if
          (1) there is no widget in the tree that matches this global key.
          (2) that widget is not a [StatefulWidget], or the associated [State] object is not a subtype of `T`.''');
    }
  }
}

interface class IModel<T> {
  Map<String, dynamic> toJson() {
    throw UnimplementedError('toJson() is not yet implemented');
  }

  T copyWith() {
    throw UnimplementedError('copyWith() is not yet implemented');
  }
}

final class RegistrationForm extends BaseForm
    implements IModel<RegistrationForm> {
  const RegistrationForm({
    required super.key,
    this.name = '',
    this.password = '',
  });

  final String name;
  final String password;

  String? validateName(String? value) {
    return null;
  }

  String? validatePassword(String? value) {
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
    };
  }

  @override
  RegistrationForm copyWith({
    GlobalKey<FormState>? key,
    String? name,
    String? password,
  }) {
    return RegistrationForm(
      key: key ?? this.key,
      name: name ?? this.name,
      password: password ?? this.password,
    );
  }
}

