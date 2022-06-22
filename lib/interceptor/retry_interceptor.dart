import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_connectivity/interceptor/dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor{
  final DioConnectivityRequestRetrier requestRetrier;

  RetryOnConnectionChangeInterceptor({required this.requestRetrier});

  @override
  Future onError(DioError err,ErrorInterceptorHandler handler)async{
    if(_shouldRetry(err)){
      try{
        return requestRetrier.scheduleRequestRetry(err.requestOptions);

      } catch(e){
        return e;
      }
    }
    return err;
  }

  bool _shouldRetry(DioError err){
    return err.type==DioErrorType.other && err.error!=null && err.error is SocketException;
  }
}