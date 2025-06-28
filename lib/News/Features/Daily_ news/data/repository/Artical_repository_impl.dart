import 'package:apps/News/Features/Daily_%20news/data/models/articals.dart';
// import 'package:apps/News/Features/Daily_%20news/domain/entites/Artical.dart';
import 'package:apps/News/Features/Daily_%20news/domain/repository/ArticalRepository.dart';
import 'package:apps/News/core/resources/data_state.dart';

class ArticalRepositoryImpl implements Articalrepository{
  @override
  Future<DataState<List<ArticalsModel>>> getNewsArticals() {
    // TODO: implement getNewsArticals
    throw UnimplementedError();
  }

}