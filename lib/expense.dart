import 'package:firebase_database/firebase_database.dart';


class Expense
{
    String key;
    String reason;
    double amount;

    Expense(this.amount,this.reason);
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
