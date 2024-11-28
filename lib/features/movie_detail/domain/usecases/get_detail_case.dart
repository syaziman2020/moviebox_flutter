import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/response/failed_response.dart';
import '../entities/response/detail_response.dart';
import '../repositories/detail_repository.dart';

class GetDetailCase {
  final DetailRepository detailRepository;
  GetDetailCase(this.detailRepository);

  Future<Either<FailedResponse, DetailResponse?>> execute(int id) async {
    return await detailRepository.getDetail(id);
  }
}
