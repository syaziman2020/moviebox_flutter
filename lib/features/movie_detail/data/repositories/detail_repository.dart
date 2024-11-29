import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../../../../core/error/custom_exception.dart';
import '../datasources/detail_local_datasource.dart';
import '../datasources/detail_remote_datasource.dart';
import '../../domain/entities/response/detail_response.dart';
import '../../domain/repositories/detail_repository.dart';

import '../../../../core/data/models/failed_model.dart';

class DetailRepositoryImplementation extends DetailRepository {
  final Connectivity connectivity;
  final DetailRemoteDatasource detailRemoteDatasource;
  final DetailLocalDatasource detailLocalDatasource;
  DetailRepositoryImplementation({
    required this.connectivity,
    required this.detailRemoteDatasource,
    required this.detailLocalDatasource,
  });
  @override
  Future<Either<FailedResponse, DetailResponse?>> getDetail(int id) async {
    final connectivityResult = await connectivity.checkConnectivity();
    bool isOffline = connectivityResult.isEmpty ||
        connectivityResult.every((result) => result == ConnectivityResult.none);
    if (isOffline) {
      try {
        final localData = await detailLocalDatasource.getMovieDetail(id);
        return Right(localData);
      } on CacheException catch (e) {
        return Left(
          FailedResponse(
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        return const Left(
          FailedResponse(
            errorMessage: 'An unexpected error occurred',
          ),
        );
      }
    } else {
      try {
        final remoteData = await detailRemoteDatasource.getDetail(id);
        await detailLocalDatasource.saveMovieDetail(remoteData);
        return Right(remoteData);
      } on FailedModel catch (e) {
        return Left(
          FailedResponse(
            errorMessage: e.errorMessage,
          ),
        );
      } catch (e) {
        return const Left(
          FailedResponse(
            errorMessage: 'An unexpected error occurred',
          ),
        );
      }
    }
  }
}
