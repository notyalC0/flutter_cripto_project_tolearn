/*
import 'package:http/http.dart' as http;

void main() {
  getFromApi('conta');
  /* setConta('2500'); */
  /*  attConta('5000', '2'); */
  deleteConta('52');
}

Future getFromApi(String caminho) async {
  var url = 'http://localhost:8080/api/$caminho';
  var response = await http.get(Uri.parse(url));
  print(response.body);
}
/*
Future<http.Response> setConta(String saldo) {
  var url = 'http://localhost:8080/api/conta';

  return http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'saldo': saldo}),
  );
}
 */

/* Future<http.Response> attConta(String saldo, String id) async {
  var url = 'http://localhost:8080/api/conta/$id';
  return http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'saldo': saldo}),
  );
} */

Future<http.Response> deleteConta(String id) async {
  var url = 'http://localhost:8080/api/conta/$id';
  return http.delete(Uri.parse(url));
}
 */
