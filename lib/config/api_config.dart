class ApiConfig {
  // Configuración del API
  static const String baseUrl = 'https://backend-api-modatext.vercel.app/api';
  static const String healthUrl = 'https://backend-api-modatext.vercel.app/health';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration requestTimeout = Duration(seconds: 10);
  
  // Configuración para desarrollo
  static const String devBaseUrl = 'https://backend-api-modatext.vercel.app/api';
  
  // Configuración para producción (cambiar según tu servidor)
  static const String prodBaseUrl = 'https://backend-api-modatext.vercel.app/api';
  
  // Método para obtener la URL base según el entorno
  static String getCurrentBaseUrl({bool isDevelopment = true}) {
    return isDevelopment ? devBaseUrl : prodBaseUrl;
  }
  
  // Headers por defecto
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Configuración de retry
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
