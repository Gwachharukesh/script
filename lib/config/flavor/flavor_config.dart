enum EnvironmentType {
  papaya(
      urlName: 'https://flutter.mydynamicerp.com',
      companyCode: 10,
      companyName: 'Pa pa Ya',
      appName: 'Pa pa Ya'),
  orange(
      urlName: 'https://flutter.mydynamicerp.com/',
      companyCode: 10,
      companyName: 'O for ornage',
      appName: 'O for ornage'),
  adminUat(
      urlName: 'https://adminuat.mydynamicerp.com/',
      companyCode: 0,
      companyName: 'Dynamic Academic Erp',
      appName: ''),

  mango(
      urlName: 'https://northpoint.mydynamicerp.com',
      companyCode: 1061,
      companyName: 'North Point English Boarding School',
      appName: 'kacha mango'),
  laptop(
      urlName: 'https://lumbinia.mydynamicerp.com',
      companyCode: 1016,
      companyName: 'Lumbini Aawasiya Madhyamik Vidhyalaya',
      appName: 'Acer Dell');

  final String urlName;
  final int companyCode;
  final String appName;

  final String companyName;

  const EnvironmentType({
    required this.urlName,
    required this.companyCode,
    required this.appName,
    required this.companyName,
  });
}
