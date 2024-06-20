class CastledInboxConfigs {
  emptyMessageViewText: string =
    'We have no updates. Please check again later.';
  emptyMessageViewTextColor: string = '#000000';
  inboxViewBackgroundColor: string = '#ffffff';
  navigationBarBackgroundColor: string = '#ffffff';
  navigationBarTitle: string = 'App Inbox';
  navigationBarTitleColor: string = '#ffffff';
  hideNavigationBar: boolean = false; //android
  hideBackButton: boolean = false;
  loaderTintColor: string = '#808080'; //ios

  // backButtonResourceId: number = -1; // android
  // backButtonImage: string = ''; // ios

  // Tabbar Configuraitions
  showCategoriesTab: boolean = true;
  tabBarDefaultBackgroundColor: string = '#ffffff';
  tabBarSelectedBackgroundColor: string = '#ffffff';
  tabBarDefaultTextColor: string = '#000000';
  tabBarSelectedTextColor: string = '#3366CC';
  tabBarIndicatorBackgroundColor: string = '#3366CC';
}
export default CastledInboxConfigs;
