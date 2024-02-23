package io.castled.reactnative.testapp;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.NotificationManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.provider.Settings;

public class PushNotificationHelper {

  private static final int REQUEST_NOTIFICATION_PERMISSION = 101;

  public static void requestNotificationPermission(Activity activity) {
    NotificationManager notificationManager = (NotificationManager) activity.getSystemService(Context.NOTIFICATION_SERVICE);

    if (notificationManager.areNotificationsEnabled()) {
      // Notifications are already enabled
      return;
    }

    AlertDialog.Builder builder = new AlertDialog.Builder(activity);
    builder.setTitle("Permission Required");
    builder.setMessage("To receive push notifications, please enable them in your device settings.");
    builder.setPositiveButton("Settings", new DialogInterface.OnClickListener() {
      @Override
      public void onClick(DialogInterface dialog, int which) {
        Intent intent = new Intent();
        intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        Uri uri = Uri.fromParts("package", activity.getPackageName(), null);
        intent.setData(uri);
        activity.startActivityForResult(intent, REQUEST_NOTIFICATION_PERMISSION);
      }
    });
    builder.setNegativeButton("Cancel", null);
    builder.show();
  }

  // Call this method from your Activity's onActivityResult() to handle the result of the permission request
  public static void handleNotificationPermissionResult(Activity activity, int requestCode) {
    if (requestCode == REQUEST_NOTIFICATION_PERMISSION) {
      // Check if permission is granted
      NotificationManager notificationManager = (NotificationManager) activity.getSystemService(Context.NOTIFICATION_SERVICE);
      if (notificationManager.areNotificationsEnabled()) {
        // Permission granted, handle accordingly
      } else {
        // Permission denied, handle accordingly
      }
    }
  }
}
