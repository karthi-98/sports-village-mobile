import 'package:flutter/material.dart';
import 'package:sports_village/constants/themes/colors.dart';
import 'package:sports_village/constants/themes/text_theme.dart';
import 'package:sports_village/constants/widgets.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class SingleTournament extends StatefulWidget {
  const SingleTournament(
      {super.key,
      required this.heroTag,
      required this.title,
      required this.image});

  final String title;
  final String image;
  final String heroTag;

  @override
  State<SingleTournament> createState() => _SingleTournamentState();
}

class _SingleTournamentState extends State<SingleTournament> {
  @override
  Widget build(BuildContext context) {
    double? progresss;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: AppTextTheme.btext16Bold,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(10),
                child: Hero(
                    tag: widget.title, child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(widget.image)))),
            const SizedBox(
              height: 10,
            ),
            progresss != null
                ? const CircularProgressIndicator(
                    color: AppColors.whiteLeve1,
                  )
                : GestureDetector(
                    onTap: () {
                      FileDownloader.downloadFile(
                          url: widget.image.trim(),
                          onProgress: (name, progress) {
                            setState(() {
                              progresss = progress;
                            });
                          },
                          onDownloadCompleted: (value) {
                            var snackBar = const SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text('Poster downloaded to gallery'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            setState(() {
                              progresss = null;
                            });
                          });
                    },
                    child: buttonContainer("Download Poster"))
          ],
        ),
      ),
    );
  }
}
