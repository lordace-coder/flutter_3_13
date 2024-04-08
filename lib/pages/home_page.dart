import 'package:flutter_3_13/models/video_provider.dart';
import 'package:flutter_3_13/pages/pages.dart';
import 'package:flutter_3_13/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<FileProvider>(context, listen: false).clearVideo();
  }
  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<FileProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Working with!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Gap(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageButton(
                    image: "assets/images/video_illus.jpeg",
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      final fileIsSelected = await videoProvider.getVideo();
                      if (fileIsSelected) {

                        // ignore: use_build_context_synchronously
                        navigateTo(
                            context,
                            VideoEditingPage(
                              video: videoProvider.file,
                            ));
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    caption: "videos",
                  ),
                  const Gap(25),
                  ImageButton(
                    image: "assets/images/audio_illus.jpeg",
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      final fileIsSelected = await videoProvider.getAudio();
                      if (fileIsSelected) {

                        // ignore: use_build_context_synchronously
                        navigateTo(
                            context,
                            AudioEditingPage(
                              file: videoProvider.file!,
                            ));
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    caption: "audio",
                  ),
                ],
              ),
              const Gap(30),
              GestureDetector(
                onTap: () {
                  //  todo implement
                  navigateTo(context, const ProjectPage());
                },
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "View Projects",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          if (loading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(
                    color: Colors.deepOrangeAccent),
              ),
            )
        ],
      ),
    );
  }
}

//helper function for page navigation
void navigateTo(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}
