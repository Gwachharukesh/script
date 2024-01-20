enum EnvironmentType {
  red(
      urlName: 'https://red.dynamicerp.online',
      companyCode: 10,
      companyName: 'red',
      appName: 'redisgood',
      bundleId: 'dynamic.school.red'),

  applecord(
      urlName: 'https://applecord.dynamicerp.com',
      companyCode: 444,
      companyName: 'fff',
      appName: 'aaa'),

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
      appName: '');

  final String urlName;
  final int companyCode;
  final String appName;

  final String companyName;
  final String? bundleId;

  const EnvironmentType(
      {required this.urlName,
      required this.companyCode,
      required this.appName,
      required this.companyName,
      this.bundleId});
}
