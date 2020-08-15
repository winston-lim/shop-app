class HttpException implements Exception {
  final String message;
  // Exception() is a abstract class = we cannot directly instantiate it
  // implements Exception means we are forced to implement all of its methods
  // toString() is a method that can be used in ALL objects in dart.
  HttpException(this.message);
  @override
  String toString() {
    return message;
    // return super.toString(); //returns "instance of HttpException"
  }
}
