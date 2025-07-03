import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';
import '../models/movimiento_kardex.dart';

class ApiService {
  static ApiService? _instance;
  
  ApiService._();
  
  static ApiService get instance {
    _instance ??= ApiService._();
    return _instance!;
  }

  // URL base del API - CAMBIAR SEGÚN TU CONFIGURACIÓN
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Headers por defecto
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Manejo de respuestas HTTP
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  // ==== PRODUCTOS ====

  // Obtener todos los productos
  Future<List<Producto>> obtenerProductos({String? tipo}) async {
    try {
      String url = '$baseUrl/productos';
      if (tipo != null) {
        url += '?tipo=$tipo';
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );
      
      final data = _handleResponse(response);
      
      if (data['success'] && data['data'] != null) {
        return (data['data'] as List)
            .map((json) => Producto.fromMap(json))
            .toList();
      }
      
      return [];
    } catch (e) {
      print('Error al obtener productos: $e');
      throw Exception('Error al obtener productos: $e');
    }
  }

  // Obtener producto por código numérico
  Future<Producto?> obtenerProductoPorCodigo(String codigoNumerico) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/productos/codigo/$codigoNumerico'),
        headers: _headers,
      );
      
      final data = _handleResponse(response);
      
      if (data['success'] && data['data'] != null) {
        return Producto.fromMap(data['data']);
      }
      
      return null;
    } catch (e) {
      print('Error al obtener producto por código: $e');
      return null;
    }
  }

  // Obtener producto por ID
  Future<Producto?> obtenerProductoPorId(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/productos/$id'),
        headers: _headers,
      );
      
      final data = _handleResponse(response);
      
      if (data['success'] && data['data'] != null) {
        return Producto.fromMap(data['data']);
      }
      
      return null;
    } catch (e) {
      print('Error al obtener producto por ID: $e');
      return null;
    }
  }

  // Crear producto
  Future<Producto> insertarProducto(Producto producto) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/productos'),
        headers: _headers,
        body: json.encode(producto.toMap()),
      );
      
      final data = _handleResponse(response);
      
      if (data['success'] && data['data'] != null) {
        return Producto.fromMap(data['data']);
      }
      
      throw Exception('Error al crear producto');
    } catch (e) {
      print('Error al insertar producto: $e');
      throw Exception('Error al insertar producto: $e');
    }
  }

  // Actualizar producto
  Future<Producto> actualizarProducto(int id, Producto producto) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/productos/$id'),
        headers: _headers,
        body: json.encode(producto.toMap()),
      );
      
      final data = _handleResponse(response);
      
      if (data['success'] && data['data'] != null) {
        return Producto.fromMap(data['data']);
      }
      
      throw Exception('Error al actualizar producto');
    } catch (e) {
      print('Error al actualizar producto: $e');
      throw Exception('Error al actualizar producto: $e');
    }
  }

  // Eliminar producto
  Future<void> eliminarProducto(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/productos/$id'),
        headers: _headers,
      );
      
      final data = _handleResponse(response);
      
      if (!data['success']) {
        throw Exception('Error al eliminar producto');
      }
    } catch (e) {
      print('Error al eliminar producto: $e');
      throw Exception('Error al eliminar producto: $e');
    }
  }

  // Actualizar stock
  Future<Map<String, dynamic>> actualizarStock(
    String codigoNumerico, 
    int cantidad, 
    String tipoMovimiento
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/productos/stock/$codigoNumerico'),
        headers: _headers,
        body: json.encode({
          'cantidad': cantidad,
          'tipo_movimiento': tipoMovimiento,
        }),
      );
      
      final data = _handleResponse(response);
      
      if (data['success'] && data['data'] != null) {
        return data['data'];
      }
      
      throw Exception('Error al actualizar stock');
    } catch (e) {
      print('Error al actualizar stock: $e');
      throw Exception('Error al actualizar stock: $e');
    }
  }

  // ==== KARDEX ====

  // Obtener todos los movimientos kardex
  Future<List<MovimientoKardex>> obtenerKardex({String? tipoProducto}) async {
    try {
      String url = '$baseUrl/kardex';
      if (tipoProducto != null) {
        url += '?tipo=$tipoProducto';
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );
      
      final data = _handleResponse(response);
      
      if (data['success'] && data['data'] != null) {
        return (data['data'] as List)
            .map((json) => MovimientoKardex.fromMap(json))
            .toList();
      }
      
      return [];
    } catch (e) {
      print('Error al obtener kardex: $e');
      throw Exception('Error al obtener kardex: $e');
    }
  }

  // Obtener movimientos por producto
  Future<List<MovimientoKardex>> obtenerKardexPorProducto(String idGenerado) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kardex/producto/$idGenerado'),
        headers: _headers,
      );
      
      final data = _handleResponse(response);
      
      if (data['success'] && data['data'] != null) {
        return (data['data'] as List)
            .map((json) => MovimientoKardex.fromMap(json))
            .toList();
      }
      
      return [];
    } catch (e) {
      print('Error al obtener kardex por producto: $e');
      throw Exception('Error al obtener kardex por producto: $e');
    }
  }

  // Crear movimiento kardex
  Future<MovimientoKardex> insertarMovimientoKardex(MovimientoKardex movimiento) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kardex'),
        headers: _headers,
        body: json.encode(movimiento.toMap()),
      );
      
      final data = _handleResponse(response);
      
      if (data['success'] && data['data'] != null) {
        return MovimientoKardex.fromMap(data['data']);
      }
      
      throw Exception('Error al crear movimiento kardex');
    } catch (e) {
      print('Error al insertar movimiento kardex: $e');
      throw Exception('Error al insertar movimiento kardex: $e');
    }
  }

  // Obtener estadísticas
  Future<Map<String, dynamic>> obtenerEstadisticas({
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      String url = '$baseUrl/kardex/stats';
      
      List<String> params = [];
      if (fechaInicio != null) {
        params.add('fecha_inicio=${fechaInicio.toIso8601String()}');
      }
      if (fechaFin != null) {
        params.add('fecha_fin=${fechaFin.toIso8601String()}');
      }
      
      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );
      
      final data = _handleResponse(response);
      
      if (data['success'] && data['data'] != null) {
        return data['data'];
      }
      
      return {};
    } catch (e) {
      print('Error al obtener estadísticas: $e');
      throw Exception('Error al obtener estadísticas: $e');
    }
  }

  // ==== UTILIDADES ====

  // Verificar conectividad con el API
  Future<bool> verificarConectividad() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl.replaceAll('/api', '')}/health'),
        headers: _headers,
      ).timeout(const Duration(seconds: 10));
      
      final data = json.decode(response.body);
      return data['success'] == true;
    } catch (e) {
      print('Error de conectividad: $e');
      return false;
    }
  }

  // Inicializar base de datos (si es necesario)
  Future<void> initializeDatabase() async {
    // En el caso del API, la base de datos ya está inicializada
    // Solo verificamos la conectividad
    final isConnected = await verificarConectividad();
    if (!isConnected) {
      throw Exception('No se puede conectar con el API');
    }
  }
}
