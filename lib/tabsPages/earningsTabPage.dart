import 'package:flutter/material.dart';
import 'package:paramedic_app/AllScreens/HistoryScreen.dart';
import 'package:paramedic_app/DataHandler/appData.dart';
import 'package:provider/provider.dart';

class EarningsTabPage extends StatefulWidget {

  @override
  _EarningsTabPageState createState() => _EarningsTabPageState();
}

class _EarningsTabPageState extends State<EarningsTabPage> {
  var _isInit = true;
  var _isLoading = false;
  var earnings;
  @override
  void didChangeDependencies() {
   if(_isInit){
     setState(() {
       _isLoading = true;
     });

     Provider.of<AppData>(context, listen: false).fetchAllHistory().then((_) {
      setState(() {
        _isLoading = false;
      });
     });
   }
   _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          color: Colors.black87,
          width: double.infinity,
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Text('Total Earnings', style: TextStyle(color: Colors.white),),
                Text("\Ksh.${Provider.of<AppData>(context, listen: false).allEarnings}", style: TextStyle(color: Colors.white, fontSize: 50, fontFamily: 'Poppins-Bold'),)
              ],
            ),
          ),
        ),

        FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> HistoryScreen()));
          },
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              children: [
                Image.asset('images/ambulance.png', width: 70,),
                SizedBox(width: 16,),
                Text('Total Trips', style: TextStyle(fontSize: 16), ),
                Expanded(child: Container(child: Text(Provider.of<AppData>(context, listen: false).allTrips.toString(), textAlign: TextAlign.end, style: TextStyle(fontSize: 18),))),
              ],
            ),
          ),
        ),

        Divider(height: 2.0, thickness: 2.0,),
      ],
    );
  }
}
