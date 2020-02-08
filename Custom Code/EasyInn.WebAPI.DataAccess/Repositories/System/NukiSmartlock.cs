using System;

namespace EasyInn.WebAPI.DataAccess.Repositories
{
    public class NukiSmartlock
    {
        public int smartlockId { get; set; }
        public int accountId { get; set; }
        public int type { get; set; }
        public int authId { get; set; }
        public string name { get; set; }
        public bool favorite { get; set; }
        public Config config { get; set; }
        public Advancedconfig advancedConfig { get; set; }
        public State state { get; set; }
        public int firmwareVersion { get; set; }
        public int hardwareVersion { get; set; }
        public int serverState { get; set; }
        public int adminPinState { get; set; }
        public bool virtualDevice { get; set; }
        public DateTime creationDate { get; set; }
        public DateTime updateDate { get; set; }
        public Webconfig webConfig { get; set; }
    }

    public class Config
    {
        public string name { get; set; }
        public float latitude { get; set; }
        public float longitude { get; set; }
        public bool autoUnlatch { get; set; }
        public bool pairingEnabled { get; set; }
        public bool buttonEnabled { get; set; }
        public bool ledEnabled { get; set; }
        public int ledBrightness { get; set; }
        public int timezoneOffset { get; set; }
        public int daylightSavingMode { get; set; }
        public bool fobPaired { get; set; }
        public int fobAction1 { get; set; }
        public int fobAction2 { get; set; }
        public int fobAction3 { get; set; }
        public bool singleLock { get; set; }
        public int advertisingMode { get; set; }
        public bool keypadPaired { get; set; }
        public int homekitState { get; set; }
        public int timezoneId { get; set; }
        public int capabilities { get; set; }
        public int operatingMode { get; set; }
    }

    public class Advancedconfig
    {
        public int totalDegrees { get; set; }
        public int singleLockedPositionOffsetDegrees { get; set; }
        public int unlockedToLockedTransitionOffsetDegrees { get; set; }
        public int unlockedPositionOffsetDegrees { get; set; }
        public int lockedPositionOffsetDegrees { get; set; }
        public bool detachedCylinder { get; set; }
        public int batteryType { get; set; }
        public int lngTimeout { get; set; }
        public int singleButtonPressAction { get; set; }
        public int doubleButtonPressAction { get; set; }
        public bool automaticBatteryTypeDetection { get; set; }
        public int unlatchDuration { get; set; }
        public int autoLockTimeout { get; set; }
    }

    public class State
    {
        public int mode { get; set; }
        public int state { get; set; }
        public int trigger { get; set; }
        public int lastAction { get; set; }
        public bool batteryCritical { get; set; }
        public int doorState { get; set; }
        public int ringToOpenTimer { get; set; }
        public bool nightMode { get; set; }
    }

    public class Webconfig
    {
        public bool batteryWarningPerMailEnabled { get; set; }
    }

}
