import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class Transaction
{
    String key;
    String sender;
    String receiver;
    double amount;
    String reason;
   // var timestamp ;

    Transaction(this.sender, this.receiver, this.amount, this.reason);

    Transaction.fromSnapShot(DataSnapshot snapshot)
        : key = snapshot.key,
            sender = snapshot.value['sender'],
            receiver= snapshot.value['receiver'],
            amount = snapshot.value['amount'],
            reason = snapshot.value['reason'];
           // timestamp = snapshot.value['timestamp'];

    toJson()
    {
        return{
            'sender' : sender,
            'receiver' : receiver,
            'amount' : amount,
            'reason' :  reason,
            //'timestamp' :timestamp
        };
    }
}