
//  import 'dart:io';

// import 'package:apps/News/Features/Daily_%20news/data/models/articals.dart';
import 'package:apps/News/core/Constants/Constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import 'news_Api_Service.dart';
 @RestApi(baseUrl: newsAPIBaseURL)
abstract class NewsApiService {
  factory NewsApiService(Dio dio, {String baseUrl}) = _NewsApiService;
  @GET("/top-headlines")
    Future getNewsArticals({
      @Query("apiKey") String apiKey,
      @Query("country") String country,
      @Query("category") String category,
    });
}