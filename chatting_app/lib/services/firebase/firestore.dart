// for the image upload
import 'dart:io';
import 'package:chatting_app/services/firebase/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';



class ChangeProfilePic extends StatefulWidget {
  const ChangeProfilePic({super.key});

  @override
  State<ChangeProfilePic> createState() => _ChangeProfilePicState();
}

class _ChangeProfilePicState extends State<ChangeProfilePic> {
  final DatabaseAppFunctions _databaseAppFunctions = DatabaseAppFunctions();
  late File image;
  dynamic pickedImage;
  final imagePicker = ImagePicker();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple[700],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <SizedBox>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: TextButton(
              onPressed: (){
                uploadImageFromCameraToFirebase();
                if(mounted){
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Camera",
              style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: TextButton(
              onPressed: (){
                getImageFromPhotos();
                if(mounted){
                  Navigator.of(context).pop();
                }
                
              },
              child: const Text("Photos",
              style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getImageFromCamera() async{
  pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
     if(pickedImage != null){
      image = File(pickedImage.path);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref("avatar/${_databaseAppFunctions.currentUser!.uid}");
      await firebaseStorageRef.putFile(image).then((p0) async{
        try{
          String imageUri = await firebaseStorageRef.getDownloadURL();
          _databaseAppFunctions.usersCollection.doc(_databaseAppFunctions.currentUser!.uid).update({
              "pic":  imageUri,
            });
        }catch(e){
          return null;
        }
      });
     }
}


Future uploadImageFromCameraToFirebase() async{
    await Permission.camera.request().then((value){
      if(value.isGranted){
        getImageFromCamera();
      }
      else if(value.isDenied){
        showDialog(
          context: context,
        builder: (_)=> permissionDeniedDialog(context),
        );
      }
      else if(value.isPermanentlyDenied){
        showDialog(
          context: context,
        builder: (_)=> permissionDeniedDialog(context),
        );
      }
    }); 
  }



  getImageFromPhotos()async{
  pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
     if(pickedImage != null){
        image = File(pickedImage.path);
        var firebaseStorageRef = FirebaseStorage.instance.ref("avatar/${_databaseAppFunctions.currentUser!.uid}");
        await firebaseStorageRef.putFile(image).then((p0) async{
          try{
            String imageUri = await firebaseStorageRef.getDownloadURL();
            _databaseAppFunctions.usersCollection.doc(_databaseAppFunctions.currentUser!.uid).update({
              "pic": imageUri,
            });
          }catch(e){
            return null;
          }
        });
     }
}


  Widget permissionDeniedDialog(context){
  return AlertDialog(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: const Text("Open settings?",
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      ),
    ),
    actions: [
      TextButton(
        onPressed: ()=>openAppSettings(),
      child: const Text("Yes",style: TextStyle(color: Colors.white),),
      ),
      TextButton(
        onPressed: (){
          Navigator.of(context).pop();
        },
      child: const Text("No",style: TextStyle(color: Colors.white),),
      ),
    ],
  );
}
}