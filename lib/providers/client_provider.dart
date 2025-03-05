import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/services/dio_client.dart';
import '../models/client.dart';
class ClientProvider with ChangeNotifier {
  List<Client> _clients = List.empty();
  bool _loading = false;
  String? _errorMessage ;
  List<Client> get clients => _clients;
  bool get isLoading => _loading;
  String? get errorMessage => _errorMessage;
Future<void> addClient(Client client,BuildContext context) async {
    try {
      final dio = DioClient.getDioInstance(context);

      final response = await dio.post(
        'client/create', // Assuming the endpoint for creating clients is /clients
        data: client.toJson(), // Pass the client data as JSON
      
      );

      if (response.statusCode == 201 || response.statusCode == 200) { // Assuming 201 Created on success
        notifyListeners();
      } else {
        _errorMessage = 'Failed to add client: ${response.statusCode}';
        notifyListeners();
        throw Exception('Failed to add client');
      }
    } catch (e) {
      _errorMessage = 'Error adding client: $e';
      notifyListeners();
      print('Error: $e');
      rethrow;
    }
  }

  Future<Client> getClient(int id,context)async {
    try {
      final dio = DioClient.getDioInstance(context);
      final response =  await dio.get('client/$id');
      final clientAsJson =  response.data;
      return Client.fromJson(clientAsJson);
    } catch (e) {
       throw Exception(e.toString());
    }
  }
  Future<List<Client>> getClients (String filter) async {
     _loading = true;
     _errorMessage = null;
     if(SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle){
     notifyListeners();

     }
     try {
      List<Client> _clients =  await  axiosList<Client>('client/all', {'name':filter}, Client.fromJson, null);
      return _clients;
     } catch (e) {
      throw Exception(
        'Failed to fetch clients: $e',
      );
       
     }
     finally {
      _loading = false;
      notifyListeners();

     }
  }

}
