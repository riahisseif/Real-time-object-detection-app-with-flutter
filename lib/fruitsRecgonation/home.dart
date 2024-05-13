import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

import '../main.dart';



class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   CameraImage imgCamera;
   CameraController cameraController;
  bool isWorking=false;
  String result='';

  //el but mte3 function hetha nhelou el camera en stram ya3ni fi live
  initCamera(){
    cameraController = CameraController(cameras[0],ResolutionPreset.medium);
    cameraController.initialize().then((value) {

      if(!mounted){
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {//start getting images
          if(!isWorking){//ya3ni sakert el cam
            isWorking=true,
            imgCamera=imageFromStream,
            runModelOnFrame()
          }

        });
      });
    });
  }

  loadModel() async{

    await Tflite.loadModel(

        model: "assets/modelfruits.tflite",
        labels: "assets/labelsfruits.txt"

    );

  }

  runModelOnFrame() async{

    if(imgCamera != null){
      var recognations =await Tflite.runModelOnFrame(//await tres importante
        bytesList: imgCamera.planes.map(( plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera.height,
        imageWidth: imgCamera.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1 ,//just one result for each frame(with mask or without mask
        threshold: 0.1,
        asynch: true,
      );
      result="";
      recognations.forEach((response) {
        result+=response["label"]  ;
      });
      setState(() {
        result;
      });
      isWorking=false;
    }

  }
  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/backg.jpg"),
                  fit: BoxFit.fill
              ),
            ),
            child:Column(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 100),
                          height: 220,
                          width: 320,
                          child: Image.asset("assets/frame.jpg"),

                        ),
                      ),
                      Center(
                        child: FlatButton(
                          onPressed: (){
                            initCamera();
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 35),
                              height: 360,
                              width: 400,
                              child: imgCamera==null ?Container(
                                height: 360,
                                width: 400,
                                child: Icon(Icons.photo_camera_front,size: 40,color: Colors.blueAccent,),
                              ):AspectRatio(aspectRatio: cameraController.value.aspectRatio,
                                child: CameraPreview(cameraController),)
                          ),

                        ),

                      )
                    ],

                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 55),
                      child: SingleChildScrollView(
                        child: Text(
                          result,
                          style: TextStyle(
                            backgroundColor: Colors.black38,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ]
            ) ,
          ),
        ),
      ),
    );
  }
}
