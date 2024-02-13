class Request {
  Request({required this.url, required this.data});
  String url;
  Map data;
}

class ResponseRequest {
  ResponseRequest({
    required this.status,
    this.data,
    this.message,
  });

  int status;
  Map<String, dynamic>? data;
  String? message;

  Map<String, dynamic> toJson() =>
      {"status": status, "data": data, "message": message};
}
