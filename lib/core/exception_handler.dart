import 'dart:async';
import 'dart:io';

class ExceptionHandler {
  static String exceptionHandler(dynamic exception){
    if(exception is SocketException){
      return "No Internet connection. Please check your network.";
    }else if(exception is HttpException){
      return "Couldn't reach the server. Try again later.";
    }else if(exception is FormatException){
      return "Invalid response format from the server.";
    }else if(exception is TimeoutException){
      return "Request timed out. Please try again.";
    }else{
       return "Unexpected error occurred: ${exception.toString()}";
    }
  }
}