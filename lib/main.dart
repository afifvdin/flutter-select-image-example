import 'dart:io';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_select_image_example/utils/system_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ));

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PlatformFile> files = [];

  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result != null) {
      setState(() {
        files = result.files;
      });
    } else {}
  }

  getFileSize(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  removeFile(int index) {
    setState(() {
      files = files
          .asMap()
          .entries
          .where((file) => file.key != index)
          .map((file) => file.value)
          .toList();
    });
  }

  removeAllFile() {
    setState(() {
      files = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    systemUi();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Your Files',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.grey)),
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left, color: Colors.black),
            onPressed: () {},
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(
              height: 72,
            ),
            Transform.scale(
                scale: 1.1, child: Image.asset('assets/illustation.png')),
            const SizedBox(
              height: 24,
            ),
            Text(
              'Choose your file',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w800, fontSize: 20),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'File format must be JPG or PNG',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.grey[400]),
            ),
            const SizedBox(
              height: 24,
            ),
            GestureDetector(
              onTap: () async {
                pickFiles();
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: const [5, 5, 5],
                strokeWidth: 4,
                color: (Colors.blue[200])!,
                padding: EdgeInsets.zero,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue[50],
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.export,
                          color: Colors.blue[200],
                          size: 48,
                        ),
                        Text(
                          'Choose one or many files',
                          style: GoogleFonts.manrope(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        )
                      ]),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            files.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choosed files',
                        style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[400]),
                      ),
                      GestureDetector(
                        onTap: () {
                          removeAllFile();
                        },
                        child: Container(
                          child: Text(
                            'Remove all files',
                            style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.red[400]),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            files.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      children: files.asMap().entries.map((file) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    spreadRadius: 0)
                              ]),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image:
                                            FileImage(File(file.value.path!)),
                                        fit: BoxFit.cover)),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      file.value.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      getFileSize(file.value.size, 1),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[400],
                                          fontSize: 12),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            removeFile(file.key);
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            child: Text(
                                              'Remove',
                                              style: GoogleFonts.manrope(
                                                  color: Colors.red[400],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : const SizedBox(),
          ],
        ));
  }
}
