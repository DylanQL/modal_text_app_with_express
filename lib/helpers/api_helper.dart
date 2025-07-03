import '../services/api_service.dart';

class ApiHelper {
  static Future<bool> checkApiConnection() async {
    try {
      print('🔍 Verificando conexión al API...');
      
      // Intentar conectar al API
      final apiService = ApiService.instance;
      final isConnected = await apiService.verificarConectividad();
      
      if (isConnected) {
        print('✅ Conexión al API exitosa');
        return true;
      } else {
        print('❌ Error de conexión al API');
        return false;
      }
    } catch (e) {
      print('❌ Error de conexión al API: $e');
      return false;
    }
  }
  
  static Future<bool> initializeApi() async {
    try {
      print('🚀 Inicializando conexión al API...');
      
      final apiService = ApiService.instance;
      await apiService.initializeDatabase();
      
      print('✅ API inicializado correctamente');
      return true;
    } catch (e) {
      print('❌ Error al inicializar API: $e');
      return false;
    }
  }
  
  static Future<void> showSystemInfo() async {
    print('📱 === INFORMACIÓN DEL SISTEMA ===');
    print('SO: Flutter App');
    print('Tipo de conexión: API REST');
    
    print('\n🌐 === CONFIGURACIÓN DEL API ===');
    print('URL Base: ${ApiService.baseUrl}');
    
    final isConnected = await checkApiConnection();
    print('Estado de conexión: ${isConnected ? "Conectado ✅" : "Desconectado ❌"}');
    
    if (isConnected) {
      print('\n🏗️ Intentando inicializar API...');
      final isInitialized = await initializeApi();
      print('API: ${isInitialized ? "Inicializado ✅" : "Error de inicialización ❌"}');
    }
  }
  
  static Future<void> createExampleData() async {
    try {
      print('📝 Los datos de ejemplo se crean desde el backend...');
      
      final apiService = ApiService.instance;
      
      // Verificar si ya existen datos
      final productos = await apiService.obtenerProductos();
      
      if (productos.isNotEmpty) {
        print('⚠️ Ya existen ${productos.length} productos en la base de datos');
        return;
      }
      
      print('💡 Para crear datos de ejemplo, ejecuta el script de inicialización del backend');
      
    } catch (e) {
      print('❌ Error al verificar datos de ejemplo: $e');
    }
  }
  
  static void printInstructions() {
    print('\n📋 === INSTRUCCIONES DE CONFIGURACIÓN ===');
    print('1. Asegúrate de que el backend esté ejecutándose');
    print('2. Verifica que el servidor API esté disponible en:');
    print('   ${ApiService.baseUrl}');
    print('3. Opcionalmente, verifica el estado del servidor en:');
    print('   ${ApiService.baseUrl.replaceAll('/api', '')}/health');
    print('4. Reinicia la aplicación');
    print('\n🔧 === SOLUCIÓN DE PROBLEMAS ===');
    print('- Verifica que el backend esté corriendo: node server.js');
    print('- Verifica la URL del API en lib/services/api_service.dart');
    print('- Asegúrate de que el puerto 3000 esté disponible');
    print('- Revisa la conectividad de red');
  }
}
