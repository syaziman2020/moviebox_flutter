import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../entities/response/detail_response.dart';

abstract class DetailRepository {
  Future<Either<FailedResponse, DetailResponse?>> getDetail(int id);
}
