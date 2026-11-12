class Resena {
  final int? id;
  final int recetaId;
  final String texto;

  const Resena({this.id, required this.recetaId, required this.texto});

  Map<String, Object?> toMap() {
    return {if (id != null) 'id': id, 'recetaId': recetaId, 'texto': texto};
  }

  factory Resena.fromMap(Map<String, Object?> mapa) {
    return Resena(
      id: mapa['id'] as int?,
      recetaId: mapa['recetaId'] as int,
      texto: mapa['texto'] as String,
    );
  }
}