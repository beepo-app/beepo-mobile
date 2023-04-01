List createKeywords(String userName) {
  List arrayName = [];
  String nameJoin = '';
  String userNameJoin = '';

  userName.toLowerCase().split('').forEach((letter) {
    nameJoin += letter;
    arrayName.add(nameJoin);
  });
  // username.toLowerCase().split('').forEach((letter) {
  //   userNameJoin += letter;
  //   arrayName.add(userNameJoin);
  // });
  return arrayName;
}
