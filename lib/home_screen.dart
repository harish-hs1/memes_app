import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String?> imgUrl; // Define a Future for the image URL

  Future<String?> updateImg() async {
    final response = await get(Uri.parse("https://meme-api.com/gimme"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['url'];
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    imgUrl = updateImg(); // Fetch the initial image URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
             borderRadius: BorderRadius.only(
               bottomLeft: Radius.circular(35),
               bottomRight:Radius.circular(35),
             )
             ),
            centerTitle: true,
            title: const Text("Memes Hub",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 25 ),),
            backgroundColor: Colors.white,
          ),
          body: FutureBuilder<String?>(
            future: imgUrl, // Use the Future in the FutureBuilder
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white,));
              } else if (snapshot.hasError ||
                  // ignore: unrelated_type_equality_checks
                  snapshot.data == const Center(child: Text("image not found"))) {
                return const Center(child: Text('Error fetching the image URL'));
              } else {
                return PageView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        // const SizedBox(height: 40,),
                        Container(
                          margin: const EdgeInsets.all(35),
                          width: 270,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: const Center(
                            child: Text(
                              "Scroll For More Memes",
                              style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 40),
                        Container(
                          height: 600,
                          decoration: BoxDecoration(
                            color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                    ),

                            child: Image.network(snapshot.data!, height: 400)),
                        // Use the fetched imgUrl here
                        const Spacer(),
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white
                          ),
                          child: const Center(
                            child: Text(
                              "This App Is Developed By :",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Harish HS",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ],
                    );
                  },
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index) {
                    setState(() {
                      imgUrl = updateImg(); // Fetch a new image URL on page change
                    });
                  },
                );
              }
            },
          ),
    );
  }
}
