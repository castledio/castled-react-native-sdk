package io.castled.reactnative.extensions

import com.facebook.react.bridge.ReadableMap
import io.castled.reactnative.consts.ConfigKeys
import io.castled.android.notifications.CastledConfigs

internal fun ReadableMap?.toMap(): Map<String, Any> {
    return this?.toHashMap() ?: emptyMap()
}

internal fun ReadableMap.toCastledConfigs(): CastledConfigs {
    return  CastledConfigs.Builder()
                .appId(getString(ConfigKeys.APP_ID)!!)
                .location(getString(ConfigKeys.LOCATION)?.let { CastledConfigs.CastledLocation.valueOf(it) } 
                    ?: CastledConfigs.CastledLocation.US)
                .enablePush(if (hasKey(ConfigKeys.ENABLE_PUSH)) getBoolean(ConfigKeys.ENABLE_PUSH) else false)
                .enablePushBoost(if (hasKey(ConfigKeys.ENABLE_PUSH_BOOST)) getBoolean(ConfigKeys.ENABLE_PUSH_BOOST) else false)
                .enableAppInbox(if (hasKey(ConfigKeys.ENABLE_APP_INBOX)) getBoolean(ConfigKeys.ENABLE_APP_INBOX) else false)
                .enableInApp(if (hasKey(ConfigKeys.ENABLE_IN_APP)) getBoolean(ConfigKeys.ENABLE_IN_APP) else false)
                .enableTracking(if (hasKey(ConfigKeys.ENABLE_TRACKING)) getBoolean(ConfigKeys.ENABLE_TRACKING) else false)
                .inAppFetchIntervalSec(if (hasKey(ConfigKeys.IN_APP_FETCH_INTERVAL)) getDouble(ConfigKeys.IN_APP_FETCH_INTERVAL).toLong() else 600L)
                .inBoxFetchIntervalSec(if (hasKey(ConfigKeys.APP_INBOX_FETCH_INTERVAL)) getDouble(ConfigKeys.APP_INBOX_FETCH_INTERVAL).toLong() else 600L)
                .xiaomiAppId(getString(ConfigKeys.XIAOMI_APP_ID))
                .xiaomiAppKey(getString(ConfigKeys.XIAOMI_APP_KEY))
                .xiaomiRegion(getString(ConfigKeys.XIAOMI_APP_REGION)?.let { CastledConfigs.XiaomiRegion.valueOf(it) })
                .build()    
}