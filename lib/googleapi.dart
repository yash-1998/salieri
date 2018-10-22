import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class googleapii
{
    static FirebaseAuth _auth = FirebaseAuth.instance;
    static GoogleSignIn _googleSignIn = GoogleSignIn();

    FirebaseUser firebaseUser;

    googleapii(FirebaseUser user)
    {
        this.firebaseUser = user;
    }

    static Future<googleapii> signinwithgoogle() async
    {
        final GoogleSignInAccount googleuser = await _googleSignIn.signIn();
        assert(googleuser!=null);
        final GoogleSignInAuthentication googleAuth = await googleuser.authentication;

        final FirebaseUser user = await _auth.signInWithGoogle(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken
        );
        assert(user.email != null);
        assert(user.displayName != null);
        assert(await user.getIdToken() != null);
        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);
        return googleapii(user);
    }
}