import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_connectivity/interceptor/dio_connectivity_request_retrier.dart';
import 'package:dio_connectivity/interceptor/retry_interceptor.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Dio dio;
  String? postTitle;
  bool? isLoading;

  @override
  void initState(){
    super.initState();
    dio=Dio();
    postTitle='Press the button 👇';
    isLoading=false;

    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
          requestRetrier: DioConnectivityRequestRetrier(
            dio: dio,
            connectivity: Connectivity()
          )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if(isLoading!)
              CircularProgressIndicator()
            else
              Text(postTitle!,style:TextStyle(fontSize: 24),textAlign: TextAlign.center,),
    RaisedButton(onPressed: ()async{
      setState((){
        isLoading=true;
    });
      final response=await dio.get('https://jsonplaceholder.typicode.com/posts');
      setState((){
        postTitle=response.data[0]['title'] as String;
        isLoading=false;
    });
    },child:Text('REQUEST DATA'))


          ],
        ),
      ));
  }
}
