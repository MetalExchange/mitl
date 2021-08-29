import 'package:sms_app/main.dart';
import 'package:validators/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class shaiziMessageParsing {
  List<String> messageArray = [];
  late List<String> timeSS;
  late List<String> znSS;
  late List<String> cuSS;
  late List<String> snSS;
  late List<String> pbSS;
  late List<String> niSS;
  late List<String> alSS;

  late int znStart;
  late int cuStart;
  late int alStart;
  late int niStart;
  late int pbStart;
  late int snStart;

  final _firestore = Firestore.instance ;

  List<int> finalPriceList = [
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1
  ];

  /*
  0/ 11 15 17
  1.  zn h
  2.     az
  3.  sn i
  4.     m
  5.  ni 
  6.  cu sd
  7.     r
  8.     a
  9.     br
  10.   al p
  11.        br
  12. Pb  





  */
  shaiziMessageParsing(String newMessage) {
    messageArray = messageFormatter(newMessage, messageArray);
    initialVariablesetter();
    priceSetter();
  //  We now have message information

  }

  Future<List< Map<String,dynamic> >> getMessagesPull(String metal) async{
    final messages = await _firestore.collection('metals'+metal+'times').getDocuments(); // gets a Future<DocumentSnapshot>
    List<Map<String,dynamic>> output = []
    for( var message in messages.documents){
      print(message.data);
      output.add(message.data);
    }
    return output ;
  }

  bool pushPrices(String metal){
    try{
      _firestore.collection('metals/'+metal+'/times').add({
        'LME' : , // fill suitable values here
        'MEX' : ,
        'Region1': ,
        'Region2': ,
        'Region3': ,
        'Region4': ,
        'time' : ,
      });
      return true;
    }
    catch(e){ //error occured in pushing
      return false;
    }
  }

//--------------------------------------------------------

  void priceSetter() {
    finalPriceList[1] = singlePriceReturn(znSS);
    finalPriceList[2] = singlePriceReturn(znSS);
    finalPriceList[3] = singlePriceReturn(snSS);
    finalPriceList[4] = singlePriceReturn(snSS);
    finalPriceList[5] = singlePriceReturn(niSS);
    finalPriceList[6] = singlePriceReturn(cuSS);
    finalPriceList[7] = singlePriceReturn(cuSS);
    finalPriceList[8] = singlePriceReturn(cuSS);
    finalPriceList[9] = singlePriceReturn(cuSS);
    finalPriceList[10] = singlePriceReturn(alSS);
    finalPriceList[11] = singlePriceReturn(alSS);
    finalPriceList[12] = singlePriceReturn(pbSS);
    // check the problem in case of prices unavailibility
    print(finalPriceList);
  }

//--------------------------------------------------------
  int singlePriceReturn(List<String> inputSring) {
    int tofindPrice = findPrice(inputSring);
    bool numericStoppedfalse = false;

    for (int i = 0; i < inputSring.length; i++) {
      if (isNumeric(inputSring[i])) {
        numericStoppedfalse = true;
        inputSring[i] = '*';
      } else if (numericStoppedfalse) {
        break;
      }
    }
    return tofindPrice;
  }

//---------------------------------------------------------------
  void initialVariablesetter() {
    znStart = searchInArray(messageArray, 'z', 'n');
    cuStart = searchInArray(messageArray, 'c', 'u');
    alStart = searchInArray(messageArray, 'a', 'l');
    niStart = searchInArray(messageArray, 'n', 'i');
    pbStart = searchInArray(messageArray, 'p', 'b');
    snStart = searchInArray(messageArray, 's', 'n');

    timeSS = messageArray.sublist(0, znStart);
    znSS = messageArray.sublist(znStart, snStart);
    snSS = messageArray.sublist(snStart, niStart);
    niSS = messageArray.sublist(niStart, cuStart);
    cuSS = messageArray.sublist(cuStart, alStart);
    alSS = messageArray.sublist(alStart, pbStart);
    pbSS = messageArray.sublist(pbStart);

    if (timeSS.join().contains("11")) {
      finalPriceList[0] = 11;
    } else if (timeSS.join().contains("15")) {
      finalPriceList[0] = 15;
    } else if (timeSS.join().contains("17")) {
      finalPriceList[0] = 17;
    }
  }

  List<String> messageFormatter(String msg, List<String> messageArray) {
    msg = msg.toLowerCase();
    msg = msg.replaceAll(' ', '');
    msg = msg.replaceAll('only', '');
    msg = msg.replaceAll('info', '');
    msg = msg.replaceAll('rates', '');
    msg = msg.replaceAll('+', '');
    msg = msg.replaceAll('gst', '');
    msg = msg.replaceAll('historical', '');
    msg = msg.replaceAll('price', '');
    msg = msg.replaceAll('extra', '');
    msg = msg.replaceAll('1.5%', '');

    int i = 0;
    while (i < msg.length) {
      messageArray.add(msg[i]);
      i++;
    }
    return messageArray;
  }

  int searchInArray(List<String> input, String first, String second) {
    int i = 0;
    while (i < input.length - 1) {
      if (input[i] == first && input[i + 1] == second) {
        return i;
      }
      i++;
    }
    return -1;
  }

  int findPrice(List<String> input) {
    String price = "";
    bool numericStoppedfalse = false;

    for (int i = 0; i < input.length; i++) {
      if (isNumeric(input[i])) {
        numericStoppedfalse = true;
        price = price + input[i];
      } else if (numericStoppedfalse) {
        break;
      }
    }
    if (price != "") {
      return int.parse(price);
    }
    return -1;
  }
}

class ccMessageParsing {}
