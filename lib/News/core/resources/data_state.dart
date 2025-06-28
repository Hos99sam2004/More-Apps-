// import 'package:dio/dio.dart';

import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;
  final  DioException? error;
  const DataState({this.data,this.error});
}
class DataSuccess<T> extends DataState<T>{
 const DataSuccess(T data):super(data: data);
}
class DataFailed<T> extends DataState<T>{
 const DataFailed(DioException error):super(error: error);
}

// 3364e8a9dba0443c83c37fd8cb523dde
// 3364e8a9dba0443c83c37fd8cb523dde