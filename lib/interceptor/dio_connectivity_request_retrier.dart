import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class DioConnectivityRequestRetrier{
  final Dio dio;
  final Connectivity connectivity;

  DioConnectivityRequestRetrier({required this.dio,required this.connectivity});

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions)async{
    late StreamSubscription streamSubscription;
    final responseCompleter=Completer<Response>();

    streamSubscription=connectivity.onConnectivityChanged.listen(
            (connectivityResult)async{
      if(connectivityResult!=ConnectivityResult.none){
        streamSubscription.cancel();
        responseCompleter.complete(
            dio.request(
                requestOptions.path,
                data: requestOptions.data,
                queryParameters:requestOptions.queryParameters,
                cancelToken: requestOptions.cancelToken,
                // options: requestOptions,
                onSendProgress: requestOptions.onSendProgress,
                onReceiveProgress: requestOptions.onReceiveProgress
            )
        );
      }
    });

    return responseCompleter.future;
  }
}