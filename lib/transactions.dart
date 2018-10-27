import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class Transaction
{
    String key;
    String sender;
    String receiver;
    int amount;
    String reason;
    String groupid;
    var timestamp ;

    Transaction(this.sender, this.receiver, this.amount, this.reason,
        this.groupid, this.timestamp);

    Transaction.fromSnapShot(DataSnapshot snapshot)
        : key = snapshot.key,
            sender = snapshot.value['sender'],
            receiver= snapshot.value['receiver'],
            amount = snapshot.value['amount'],
            reason = snapshot.value['reason'],
            groupid= snapshot.value['groupid'],
            timestamp = snapshot.value['timestamp'];

    toJson()
    {
        return{
            'sender' : sender,
            'receiver' : receiver,
            'amount' : amount,
            'reason' :  reason,
            'groupid' : groupid,
            'timestamp' :timestamp
        };
    }
}