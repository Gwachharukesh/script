enum EnvironmentType {
  orange(
      urlName: 'https://orange.mydynamicerp.com',
      companyCode: 676,
      companyName: 'gfg',
      appName: 'asas',
      bundleId: 'y'),

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
