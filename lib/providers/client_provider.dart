import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:jawda/constansts.dart';
import 'package:jawda/models/client_payment.dart';
import 'package:jawda/services/dio_client.dart';
import '../models/client.dart';
class ClientProvider with ChangeNotifier {
  List<Client> _clients = List.empty();
  Client? _selectedClient ;
  Client? get selectedClient => _selectedClient;
   void setSelectedClient(Client? value) {
    _selectedClient = value;
    //update _clients for new value
    if (_selectedClient!= null) {
      _clients = _clients.map((client)  {
        if (client.id == _selectedClient!.id) {
          return value!;
        }
        return client;
      }).toList();
     
    }
    notifyListeners();
  }
  bool _loading = false;
  String? _errorMessage ;
  List<Client> get clients => _clients;
  bool get isLoading => _loading;
  String? get errorMessage => _errorMessage;
   List<ClientPayment> _payments = [];
    List<ClientPayment> get payments => _payments;
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
      _clients =  await  axiosList<Client>('client/all', {'name':filter,'load':'deducts'}, Client.fromJson, null);
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




  Future<void> addPayment(ClientPayment payment,context) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dio = DioClient.getDioInstance(context);
      final response = await dio.post(
        '/clientPayment',  // Replace with your API endpoint
        data:{
          'client_id':payment.clientId,
          'amount': payment.amount,
          'payment_date': DateFormat('yyyy-MM-dd').format(payment.paymentDate),
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) { // Assuming 201 Created on success
        final clientAsJson = response.data;
        final Client freshClient = Client.fromJson(clientAsJson);
        setSelectedClient(freshClient); // Notify listeners
        print('Payment added successfully');
      } else {
        _errorMessage = 'Failed to add payment: ${response.statusCode}';
        notifyListeners();
        print('Failed to add payment: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = 'Error adding payment: $e';
      notifyListeners();
      print('Error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
