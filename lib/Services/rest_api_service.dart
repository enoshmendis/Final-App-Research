// rest_api_service.dart:
// We do call the rest API to get, store data on a remote database for that we need to write
//the rest API call at a single place and need to return the data if the rest call is a success
// or need to return custom error exception on the basis of 4xx, 5xx status code. We can make
//use of http package to make the rest API call in the flutter.

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

fetchProcessedData(File? filepath,
    {Function(String)? success,
    Function(String, String, String)? failed,
    error,
    completed}) async {
  String? data;

  data = await fetchData(filepath);
  try {
    success!(data);
  } catch (e) {
    failed!("", "Something went wrong", "Please try agian later");
    if (error != null) {
      error();
    }
  } finally {
    if (completed != null) {
      completed();
    }
  }
}

Future<String> fetchData(File? imagepath) async {
  try {
    var stream = new http.ByteStream(imagepath!.openRead());
    stream.cast();
    var length = await imagepath.length();

    final request = new http.MultipartRequest(
        "POST", Uri.parse("http://didula.pythonanywhere.com/emotionImage"));

    var multiport = new http.MultipartFile("file", stream, length);

    request.files.add(multiport);

    await request.send().then((response) {
      if (response.statusCode == 200) {
        // final String responceString = response.body;
        print("Uploaded!");
        print('response of /emotions is : ${response.request}');
        print('response of /emotions is : ${response.contentLength}');
        print('response of /emotions is : ${response.reasonPhrase}');
        print('response of /emotions is : ${response.isRedirect}');

        // return responceString;

      } else {
        print("API Calling Error ${response.statusCode}");
        print('response of request is : ${response.request}');
        print('response of contentLength is : ${response.contentLength}');
        print('response of reasonPhrase is : ${response.reasonPhrase}');
        print('response of isRedirect is : ${response.isRedirect}');
        return 'error';
      }
    });
    print('map of /emotions is : ');
    print('--------');
    print('--------');
    print('--------');
    print('--------');
    print('--------');
    print('--------');
    print('--------');
    print('--------');
  } catch (Exception) {
    print("Exception " + Exception.toString() + '100');
  }
  return '';
}
