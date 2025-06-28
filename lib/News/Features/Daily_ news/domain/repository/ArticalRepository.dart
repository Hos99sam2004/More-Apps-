import 'package:apps/News/Features/Daily_%20news/domain/entites/Artical.dart';
import 'package:apps/News/core/resources/data_state.dart';

abstract class Articalrepository {
  Future<DataState<List<ArticalEntity>>> getNewsArticals();
}
