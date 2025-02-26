class ErrorResponse {
  int code;
  String message;

  ErrorResponse({required this.code, required this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(code: json['code'], message: json['message']);
  }
}