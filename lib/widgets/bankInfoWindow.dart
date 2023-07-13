import 'package:barikoi_maplibre_map/utils/const.dart';
import 'package:flutter/material.dart';

import '../models/bank_model.dart';

class BankInfoWindow extends StatelessWidget {
  final Bank bank;

  BankInfoWindow({required this.bank});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(bank.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Text(bank.address),

          const Text("Office Time- 9AM - 4PM", style: TextStyle(fontSize: 12, color: Colors.blueAccent),),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: primaryColor,
                  border: Border.all(color: primaryColor)
                ),
                child: const Row(
                  children: [
                    Icon(Icons.directions, color: Colors.white, size: 14,),
                    SizedBox(width: 5,),
                    Text(
                      "Direction", style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(color: secondaryColor20LightTheme)
                ),
                child: const Row(
                  children: [
                    Icon(Icons.navigation, color: primaryColor,size: 13,),
                    SizedBox(width: 5,),
                    Text(
                      "Start", style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(color: secondaryColor20LightTheme)
                ),
                child: const Row(
                  children: [
                    Icon(Icons.phone, color: primaryColor,size: 13,),
                    SizedBox(width: 5,),
                    Text(
                      "Call", style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          )
          // Add other relevant information about the bank
        ],
      ),
    );
  }
}
