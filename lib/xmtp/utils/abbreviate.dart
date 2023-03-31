String abbreviate(String hexEip) {
  return hexEip.isEmpty
      ? ""
      : "${hexEip.substring(0, 6)}…${hexEip.substring(38)}";
}
