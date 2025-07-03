class MovimientoKardex {
  final int? idMovimiento;
  final DateTime fecha;
  final String producto; // ID_GENERADO del producto
  final int cantidad;
  final String tipoMovimiento; // 'ENTRADA' o 'SALIDA'
  final String rack;
  final String nivel;
  final int stockResultado;

  MovimientoKardex({
    this.idMovimiento,
    required this.fecha,
    required this.producto,
    required this.cantidad,
    required this.tipoMovimiento,
    required this.rack,
    required this.nivel,
    required this.stockResultado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_movimiento': idMovimiento,
      'fecha': fecha.toUtc().toIso8601String(),
      'producto': producto,
      'cantidad': cantidad,
      'tipo_movimiento': tipoMovimiento,
      'rack': rack,
      'nivel': nivel,
      'stock_resultado': stockResultado,
    };
  }

  factory MovimientoKardex.fromMap(Map<String, dynamic> map) {
    DateTime fechaParsed;
    try {
      // Intentar parsear la fecha desde MySQL
      final fechaString = map['fecha'].toString();
      if (fechaString.contains('T')) {
        fechaParsed = DateTime.parse(fechaString).toLocal();
      } else {
        // Si es formato MySQL DATETIME, agregamos zona UTC
        fechaParsed = DateTime.parse('${fechaString}Z').toLocal();
      }
    } catch (e) {
      // Fallback a fecha actual si hay error
      fechaParsed = DateTime.now();
    }
    
    return MovimientoKardex(
      idMovimiento: map['id_movimiento'],
      fecha: fechaParsed,
      producto: map['producto'] ?? '',
      cantidad: map['cantidad'] ?? 0,
      tipoMovimiento: map['tipo_movimiento'] ?? '',
      rack: map['rack'] ?? '',
      nivel: map['nivel'] ?? '',
      stockResultado: map['stock_resultado'] ?? 0,
    );
  }

  MovimientoKardex copyWith({
    int? idMovimiento,
    DateTime? fecha,
    String? producto,
    int? cantidad,
    String? tipoMovimiento,
    String? rack,
    String? nivel,
    int? stockResultado,
  }) {
    return MovimientoKardex(
      idMovimiento: idMovimiento ?? this.idMovimiento,
      fecha: fecha ?? this.fecha,
      producto: producto ?? this.producto,
      cantidad: cantidad ?? this.cantidad,
      tipoMovimiento: tipoMovimiento ?? this.tipoMovimiento,
      rack: rack ?? this.rack,
      nivel: nivel ?? this.nivel,
      stockResultado: stockResultado ?? this.stockResultado,
    );
  }
}
