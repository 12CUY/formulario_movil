import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario de Ejemplo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FormularioPage(),
    );
  }
}

class FormularioPage extends StatefulWidget {
  @override
  _FormularioPageState createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _cedulaController = TextEditingController();
  TextEditingController _nombresController = TextEditingController();
  TextEditingController _apellidosController = TextEditingController();
  TextEditingController _fechaController = TextEditingController();
  TextEditingController _edadController = TextEditingController();
  
  String? _genero = 'Masculino';
  bool _estadoCivil = false; // Estado civil (casado o soltero)

  // Función para calcular la edad
  int calcularEdad(DateTime fechaNacimiento) {
    DateTime fechaActual = DateTime.now();
    int edad = fechaActual.year - fechaNacimiento.year;
    if (fechaNacimiento.month > fechaActual.month ||
        (fechaNacimiento.month == fechaActual.month && fechaNacimiento.day > fechaActual.day)) {
      edad--;
    }
    return edad;
  }

  // Función para mostrar el selector de fecha
  Future<void> _selectFecha(BuildContext context) async {
    DateTime? fecha = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fecha,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != fecha) {
      setState(() {
        _fechaController.text = formatter.format(picked);
        _edadController.text = calcularEdad(picked).toString();
      });
    }
  }

  // Función para mostrar el cuadro de diálogo con el mensaje de felicitaciones
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡Felicidades!"),
          content: Text("El formulario se ha enviado correctamente."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Cédula
              TextFormField(
                controller: _cedulaController,
                decoration: InputDecoration(
                  labelText: 'Cédula',
                  hintText: 'Ingrese su cédula',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su cédula';
                  }
                  return null;
                },
              ),
              // Nombres
              TextFormField(
                controller: _nombresController,
                decoration: InputDecoration(
                  labelText: 'Nombres',
                  hintText: 'Ingrese sus nombres',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre';
                  }
                  return null;
                },
              ),
              // Apellidos
              TextFormField(
                controller: _apellidosController,
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  hintText: 'Ingrese sus apellidos',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese sus apellidos';
                  }
                  return null;
                },
              ),
              // Fecha de Nacimiento
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  hintText: 'Seleccione su fecha de nacimiento',
                ),
                readOnly: true,
                onTap: () => _selectFecha(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione su fecha de nacimiento';
                  }
                  return null;
                },
              ),
              // Edad (se calcula automáticamente)
              TextFormField(
                controller: _edadController,
                decoration: InputDecoration(
                  labelText: 'Edad',
                  hintText: 'Edad calculada',
                ),
                readOnly: true,
              ),
              // Género
              ListTile(
                title: const Text('Género'),
                subtitle: Row(
                  children: <Widget>[
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Masculino',
                          groupValue: _genero,
                          onChanged: (value) {
                            setState(() {
                              _genero = value;
                            });
                          },
                        ),
                        const Text('Masculino'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Femenino',
                          groupValue: _genero,
                          onChanged: (value) {
                            setState(() {
                              _genero = value;
                            });
                          },
                        ),
                        const Text('Femenino'),
                      ],
                    ),
                  ],
                ),
              ),
              // Estado Civil
              CheckboxListTile(
                title: Text("Estado Civil (Casado)"),
                value: _estadoCivil,
                onChanged: (bool? value) {
                  setState(() {
                    _estadoCivil = value!;
                  });
                },
              ),
              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Muestra el mensaje de éxito
                        _showSuccessDialog(context);
                      }
                    },
                    child: Text('Siguiente'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Cerrar la aplicación o regresar
                      Navigator.of(context).pop();
                    },
                    child: Text('Salir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
