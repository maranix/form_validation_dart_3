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
  bool isValidated = false;
  late RegistrationForm _registrationForm;

  void _onNameChanged(String value) {
    _registrationForm = _registrationForm.copyWith(name: value);
  }

  void _onPasswordChanged(String value) {
    _registrationForm = _registrationForm.copyWith(password: value);
  }

  void _onValidate() {
    setState(() {
      isValidated = _registrationForm.validate();
    });
  }

  Future<Map<String, dynamic>> _onSubmit() async {
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );

    return _registrationForm.toJson();
  }

  @override
  void initState() {
    super.initState();

    _registrationForm = RegistrationForm(key: GlobalKey<FormState>());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registrationForm.key,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: _registrationForm.validateName,
              onChanged: _onNameChanged,
              decoration: const InputDecoration(
                label: Text('Name'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              validator: _registrationForm.validatePassword,
              onChanged: _onPasswordChanged,
              decoration: const InputDecoration(
                label: Text('Password'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            isValidated
                ? FutureBuilder(
                    future: _onSubmit(),
                    builder: (context, snapshot) {
                      return switch (snapshot.connectionState) {
                        ConnectionState.done => Text(snapshot.data.toString()),
                        ConnectionState.waiting => const Text('Waiting'),
                        ConnectionState.active => const Text('Active'),
                        ConnectionState.none => const Text('None')
                      };
                    },
                  )
                : ElevatedButton(
                    onPressed: _onValidate,
                    child: const Text('Submit'),
                  )
          ],
        ),
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

abstract interface class IModel<T> {
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
    if (value != null || value!.isNotEmpty) {
      final numRegEx = RegExp(r'^[0-9]');

      if (value.length < 3) {
        return 'Name cannot be less than 3 characters';
      }

      if (numRegEx.hasMatch(value)) {
        return 'Name cannot contain numbers';
      }
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value != null || value!.isNotEmpty) {
      if (value.length < 6) {
        return 'Password cannot be less than 6 characters';
      }
    }

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
