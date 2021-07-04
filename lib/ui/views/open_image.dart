import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class OpenImage extends StatefulWidget {
  final String url;
  const OpenImage({ Key key, this.url }) : super(key: key);

  @override
  _OpenImageState createState() => _OpenImageState();
}

class _OpenImageState extends State<OpenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text("الصورة"),
        centerTitle: true,
        actions: [TextButton(onPressed: (){

      }, child: Text("تحميل الصورة" ,  style: TextStyle(color: Colors.white,   )))],),

      body: PhotoView(
                    backgroundDecoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                      imageProvider:NetworkImage(widget.url),
                    loadingBuilder:
                        (BuildContext context, ImageChunkEvent event) =>
                            CircularProgressIndicator(),
                  ),
      
    );
  }
}