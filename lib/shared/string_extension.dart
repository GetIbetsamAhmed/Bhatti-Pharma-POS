extension CapitalizeExtension on String {
  String capitalizeInitials() {
    String validName = this;
    if (isEmpty) {
      return this;
    } else {
      if (this[length - 1] == " ") {
//       print("True");
        validName = substring(0, length - 1);
      }
//     print(validName+"End");
      if (validName.contains(" ")) {
        List<String> names = validName.split(" ");
        // print(names);
        if (names[0] == "") {
          names.removeAt(0);
        } else if(names[names.length-1] == ""){
          names.removeAt(names.length-1);
        }  
        for (int i = 0; i < names.length; i++) {
          if (names[i] == "") {
            names.removeAt(i);
          }
          if (i < names.length - 1) {
            names[i] = "${names[i][0].toUpperCase() + names[i].substring(1)} ";
          } else {
            names[i] = names[i][0].toUpperCase() + names[i].substring(1);
          }
        }
        validName = "";
        for (String items in names) {
          validName += items;
        }
        return validName;
      } else {
        validName = validName[0].toUpperCase() + substring(1);
        if (validName[validName.length - 1] == " ") {
          return validName.substring(0, validName.length - 1);
        } else {
          return validName;
        }
      }
    }
  }
}
