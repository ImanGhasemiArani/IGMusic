// ignore_for_file: avoid_function_literals_in_foreach_calls

import "extensions.dart";

List<String> exportData(String t, String ar, String al) {
  var re = RegExp(r'[^a-zA-Z0-9]');
  var re2 = RegExp(r'&ir|&com|&mp3|www');
  var arrT = t.replaceAll(".", "&").toLowerCase().replaceAll(re2, "").split(re);
  var arrAr =
      ar.replaceAll(".", "&").toLowerCase().replaceAll(re2, "").split(re);
  var arrAl =
      al.replaceAll(".", "&").toLowerCase().replaceAll(re2, "").split(re);
  arrAl.forEach((s) {
    if (arrT.contains(s) && arrAr.contains(s)) {
      arrT.remove(s);
      arrAr.remove(s);
    } else if (arrAr.contains(s)) {
      arrAr.remove(s);
    }
  });
  arrAr.forEach((s) {
    if (arrT.contains(s)) {
      arrT.remove(s);
    }
  });
  t = arrT.join(" ").toTitleCase();
  ar = arrAr.join(" ").toTitleCase();
  al = arrAl.join(" ").toTitleCase();

  return <String>[
    t.isNotEmpty ? t : "Unknown",
    ar.isNotEmpty ? ar : "Unknown",
    al.isNotEmpty ? al : "Unknown"
  ];
}
