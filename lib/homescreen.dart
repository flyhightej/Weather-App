import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/constants.dart' as k;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isLoaded = false;
  late num temperature;
  late num pressure;
  late num humidity;
  late num cover;
  late String cityName;
  TextEditingController controller = TextEditingController();

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration
        (
          image: DecorationImage(
              image: AssetImage('assets/wallpaper.jpg'),
              fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
           colors: [
              Color(0xffDE93D9), 
              Color(0xff6D7EEE),            
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),          
        ),
        child: Visibility(
          visible: isLoaded,
          replacement: const Center(child: CircularProgressIndicator(),
          ),
          child:  Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.85,
                height: MediaQuery.of(context).size.height*0.09,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(20,),),
                  ),
                  child: Center(
                    child: TextFormField(
                      onFieldSubmitted: (String s){
                       setState(() {
                         cityName = s;
                         getCityWeather(cityName);
                         isLoaded = false;
                         controller.clear();
                      });
                    },
                    controller: controller,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,                      
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search City',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 25,
                        color: Colors.white.withOpacity(0.7),                        
                      ),
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                    ),
                  ),),
               ),
               const SizedBox(
                height: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.pin_drop,
                        color: Colors.red,
                        size: 40,
                      ),
                      Text(
                        cityName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    ]
                  ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //Temperature Container
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.11,
                    margin: const EdgeInsets.symmetric(
                      vertical: 20
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 241, 231, 247).withOpacity(0.9),
                        borderRadius: const BorderRadius.all(Radius.circular(15),),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade900,
                            offset: const Offset(1, 2),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Image(
                            image: const AssetImage('assets/thermometer.png'),
                            width: MediaQuery.of(context).size.width*0.09,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Temperature: ${temperature.toInt()}°C',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),                       
                      ],
                    ),  
                  ),
                  
                  //Pressure Container
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.11,
                    margin: const EdgeInsets.symmetric(
                      vertical: 20
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 241, 231, 247).withOpacity(0.9),
                        borderRadius: const BorderRadius.all(Radius.circular(15),),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade900,
                            offset: const Offset(1, 2),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image(
                            image: const AssetImage('assets/barometer.png'),
                            width: MediaQuery.of(context).size.width*0.09,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Pressure: ${pressure.toInt()}hPa',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),                       
                      ],
                    ),  
                  ),

                  //Humidity Container
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.11,
                    margin: const EdgeInsets.symmetric(
                      vertical: 20
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 241, 231, 247).withOpacity(0.9),
                        borderRadius: const BorderRadius.all(Radius.circular(15),),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade900,
                            offset: const Offset(1, 2),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image(
                            image: const AssetImage('assets/humidity.png'),
                            width: MediaQuery.of(context).size.width*0.09,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Humidity: ${humidity.toInt()}%',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),                       
                      ],
                    ),  
                  ),

                  //Cloud Cover Container
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.11,
                    margin: const EdgeInsets.symmetric(
                      vertical: 20
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 241, 231, 247).withOpacity(0.9),
                        borderRadius: const BorderRadius.all(Radius.circular(15),),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade900,
                            offset: const Offset(1, 2),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Image(
                            image: const AssetImage('assets/cover.png'),
                            width: MediaQuery.of(context).size.width*0.09,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Cloud Cover: ${cover.toInt()}%',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),                       
                      ],
                    ),  
                  ),
            ],            
          ),
        )
      ),
    ));
  }

  getCurrentLocation() async{
     var p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
     );
     if(p != null){
        //print("Lat:${p?.latitude}, Long:${p?.longitude}");
         getCurrentCityWeather(p);
     }
     else{
    //    print("Data Unavailable");
     }
  }

  updateUI(var decodedData){
    setState(() {
      if(decodedData == null){
      temperature = 0;
      pressure = 0;
      humidity = 0;
      cover = 0;
      cityName = 'Not Available';      
    }
    else{
      temperature = decodedData['main']['temp']-273;
      pressure = decodedData['main']['pressure'];
      humidity = decodedData['main']['humidity'];
      cover = decodedData['clouds']['all'];
      cityName = decodedData['name'];
    }      
    });    
  }

  getCurrentCityWeather(Position position) async{
    // API call to get weather data
    var client = http.Client();
    var uri = '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if(response.statusCode == 200){
      var data = response.body;
      var decodeData = json.decode(data);
  //     print(data);
       updateUI(decodeData);
       setState(() {
          isLoaded = true;
       });
    }
    else{
  //   print(response.statusCode);
    }
  }

  getCityWeather(String cityName) async{
    var client = http.Client();
    var uri = '${k.domain}q=$cityName&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if(response.statusCode == 200){
      var data = response.body;
      var decodeData = json.decode(data);
  //     print(data);
       updateUI(decodeData);
       setState(() {
          isLoaded = true;
       });
    }
    else{
  //    print(response.statusCode);
    }
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

}