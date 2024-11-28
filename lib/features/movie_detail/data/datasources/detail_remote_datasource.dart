import 'package:dio/dio.dart';
import '../../../../core/constants/env.dart';
import '../models/detail_model.dart';

import '../../../../core/data/models/failed_model.dart';

abstract class DetailRemoteDatasource {
  Future<DetailModel> getDetail(int id);
}

class DetailRemoteDatasourceImplementation extends DetailRemoteDatasource {
  final Dio dio;
  DetailRemoteDatasourceImplementation({required this.dio});

  @override
  Future<DetailModel> getDetail(int id) async {
    try {
      final response = await dio.get(
        "${Env.url}/movie/$id",
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Env.apiKey}'
          },
        ),
      );

      if (response.statusCode == 200) {
        return DetailModel.fromJson(response.data);
      } else {
        throw FailedModel.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
  }
}
