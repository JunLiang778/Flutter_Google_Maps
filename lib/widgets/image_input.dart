import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart'as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {

  final Function onSelectImage;

  ImageInput(this.onSelectImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async { 
    final picker = ImagePicker();
    final imageFile = await picker.getImage( //this returns null if user doesnt take an image
      source: ImageSource.camera, //ImageSource.gallery
      maxWidth: 600, //crop image
    );
    setState(() {
      _storedImage = File(imageFile.path); //convert PickedFile -> File
    });

    if(imageFile==null){
      return;
    }

    //copy() copies the file in a new location, u need to enter a path on our device where we want to copy this
    //enter a path on our device where we wanna copy this to
    //this is tricky bc on ios & andriod, u cant write files to ANY place on the hard drive
    //there's a lot of restrictions regarding where u can write data to so u dont clutter up the hard drive of the movile device or start writing files into folders where u shouldnt have access 
    //both ios and andriod typically give u a certain PATH where u can store where ur APP RELATED DATA
    //that's a good thing bc since such path is clearly defined by both OS, that means whenever u delete ur app, these OS can erase all data from that path
    // to find the path to store data -> path_provider package (nth to do with provider package )
    //to construct the path -> path package 

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(_storedImage.path);//basename() is the file name (the part of a path after the last seperator)

    //copy() needs a path, which is a string, not a directory handle
    //appDir.path works but i dont wanna copy my image like this. Instead u also have to provide the name of the image it should have  
    final savedImage = await _storedImage.copy('${appDir.path}/${fileName}');
    //savedImage -> now we can work with other parts of our app (eg: store it on device database)
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          //image preview
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center, //center both vertically and horizontally
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
