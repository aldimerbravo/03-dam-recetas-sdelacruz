import 'package:flutter/material.dart';
import 'package:recetas_app/data/receta_db.dart';
import 'package:recetas_app/models/resena.dart';

class ResenaFormScreen extends StatefulWidget {
  final int recetaId;
  const ResenaFormScreen({super.key, required this.recetaId});

  @override
  State<ResenaFormScreen> createState() => _ResenaFormScreenState();
}

class _ResenaFormScreenState extends State<ResenaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _resenaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarResena();
  }

  // si la receta ya tiene reseña, la muestra en el campo
  Future<void> _cargarResena() async {
    final resena = await RecetaDb.instancia.obtenerPorReceta(widget.recetaId);
    if (resena != null && mounted) {
      _resenaCtrl.text = resena.texto;
    }
  }

  @override
  void dispose() {
    _resenaCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    await RecetaDb.instancia.guardar(
      Resena(recetaId: widget.recetaId, texto: _resenaCtrl.text.trim()),
    );
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reseña guardada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mi Reseña Personal:',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _resenaCtrl,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Escribe aquí tus notas o comentarios sobre la receta...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Escribe tu reseña antes de guardar'
                : null,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _guardar,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Guardar Reseña'),
            ),
          ),
        ],
      ),
    );
  }
}