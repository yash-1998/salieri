import 'package:firebase_database/firebase_database.dart';


class Expense
{
    String key;
    String reason;
    var amount;

    Expense(this.reason,this.amount);
    Expense.fromSnapShot(DataSnapshot snapshot)
        :   key = snapshot.key,
            reason = snapshot.value['reason'],
            amount = snapshot.value['amount'];
    toJson()
    {
        return{
            'reason' : reason,
            'amount' : amount,
        };
    }
}
