

class MessageApi{
  static String findTextToast(String text){
    if(text.contains("Password should be at least 6 characters")){
      //return tr(LocaleKeys.toast_short_password);
    }else if(text.contains("The email address is already in use by another account")){
      //return tr(LocaleKeys.toast_email_already_use);
    }
    else if(text.contains("Account Unsuccessfully created")){
     // return tr(LocaleKeys.toast_Unsuccessfully_created);
    }
    else if(text.contains("Account successfully created")){
      //return tr(LocaleKeys.toast_successfully_created);
    }
    else if(text.contains("The password is invalid or the user does not have a password")){
      //return tr(LocaleKeys.toast_password_invalid);
    }
    else if(text.contains("There is no user record corresponding to this identifier")){
      //return tr(LocaleKeys.toast_email_invalid);
    }
    else if(text.contains("Account successfully logged")){
      //return tr(LocaleKeys.toast_successfully_logged);
    }
    else if(text.contains("A network error")){
      //return tr(LocaleKeys.toast_network_error);
    }
    else if(text.contains("An internal error has occurred")){
      //return tr(LocaleKeys.toast_network_error);
    }else if(text.contains("field does not exist within the DocumentSnapshotPlatform")){
      //return tr(LocaleKeys.toast_Bad_data_fetch);
    }else if(text.contains("Account successfully logged")){
      //return tr(LocaleKeys.toast);
    }
    else if(text.contains("done_update")){
    //  return tr(LocaleKeys.done_update);
    }
    else if(text.contains("done_add")){
   //   return tr(LocaleKeys.done_add);
    }
    else if(text.contains("done_delete")){
     // return tr(LocaleKeys.done_delete);
    }

    else if(text.contains("done_logout")){
      return "Done Logout";
      // return "تم تسجيل الخروج بنجاح";
    }
    else if(text.contains("refresh_token_successful")){
      return "تم إعادة الاقتران بنجاح";
    }
    else if(text.contains("login_successful")){
      return "Login Successful";}
    else if(text.contains("diagnose_successful")){
      return "Diagnose Successful";
      // return "تم تسجيل الدخول بنجاح";
    }





    return text;
  }
}