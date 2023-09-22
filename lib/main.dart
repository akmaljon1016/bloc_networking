import 'package:bloc_networking/network_bloc/network_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MaterialApp(
    home: BlocProvider(
      create: (context) => NetworkBloc(),
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NetworkBloc>(context).add(GetPost());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BloC+Networking"),
      ),
      body: RefreshIndicator(onRefresh: () async {
        BlocProvider.of<NetworkBloc>(context).add(GetPost());
      }, child: BlocBuilder<NetworkBloc, NetworkState>(
        builder: (context, state) {
          if (state is NetworkLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NetworkError) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 50,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(state.message),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {
                        BlocProvider.of<NetworkBloc>(context).add(GetPost());
                      },
                      child: Text("Qayta yuklash"),
                      color: Colors.green,
                    )
                  ]),
            );
          } else if (state is NetworkSuccess) {
            return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: Colors.green,
                    child: Text(state.posts[index].title ?? "pustoy"),
                  );
                });
          } else {
            return Container();
          }
        },
      )),
    );
  }
}
