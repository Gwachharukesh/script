enum EnvironmentType {
  orange(
      urlName: 'https://orange.dynamicerp.online',
      companyCode: 34,
      companyName: 'orange soru',
      appName: 'orange ball',
      bundleId: 'dynamic.school.orange'),

  adminUat(
      urlName: 'https://adminuat.mydynamicerp.com/',
      companyCode: 0,
      companyName: 'Dynamic Academic Erp',
      appName: 'Adminuat');

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
