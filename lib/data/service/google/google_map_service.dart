// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:demo/common/model/google_address.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:demo/utils/https/https_client.dart';

class GoogleMapService {
  final String apiKey = DeviceUtils.isAndroid()
      ? dotenv.get('GOOGLE_API_ANDROID')
      : dotenv.get('GOOGLE_API_IOS'); // Replace with your API key
  HttpsClient httpsClient;
  GoogleMapService({
    required this.httpsClient,
  });

  Future<GoogleAddress> getAddressFromLatLng(double lat, double lng) async {
    debugPrint("Address received is ${lat} ${lng}");
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

    try {
      final response = await httpsClient.get(url);

      if (response?.statusCode == 200) {
        final data = response?.data;

        if (data['status'] == 'OK') {
          final results = data['results'][0];
          final formattedAddress = results['formatted_address'];
          final addressComponents = results['address_components'];
          String country = '';
          for (var component in addressComponents) {
            final types = component['types'] as List;
            if (types.contains('country')) {
              country = component['long_name'];
              break;
            }
          }

          return GoogleAddress(address: formattedAddress, country: country);
        } else {
          throw Exception('Error fetching address: ${data['status']}');
        }
      } else {
        throw Exception(
            'Failed to connect to the API: ${response?.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> searchLocation(String query) async {
    final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    try {
      final response = await httpsClient.get(
        url,
        queryParameters: {
          'input': query,
          'key': apiKey,
        },
      );

      if (response?.statusCode == 200) {
        final data = response?.data;
        if (data['status'] == 'OK') {
          return data['predictions'];
        } else {
          throw Exception('Error: ${data['status']}');
        }
      } else {
        throw Exception('Failed to fetch data: ${response?.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
