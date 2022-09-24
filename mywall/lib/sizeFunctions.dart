double heightProp(double height) {
  int screenHeight = 812;
  double myHeight = 816;
  //I/flutter (25946): 411.42857142857144

  double newH = (height * myHeight) / screenHeight;
  return newH;
}

double widthProp(double width) {
  int screenWidth = 375;
  double myWidth = 432;

  return (width * myWidth) / screenWidth;
}
