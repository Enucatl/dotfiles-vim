import System.IO

import XMonad
import XMonad.Util.Run(spawnPipe)
import XMonad.Config.Kde
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.WindowProperties (getProp32s)
import XMonad.Actions.WindowGo
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers
import Graphics.X11.ExtraTypes.XF86

myLayout = Full ||| tiled
    where
    tiled  = Tall 1 (3/100) 0.618

myWorkspaces = ["web","email","code","music","5","6","7","dolphin","9"]

myFocusedBorderColor = "#66ff66"
myBorderWidth = 0

myKeys (XConfig {modMask = modm}) = M.fromList $
  [ ((modm, xK_f), spawn "firefox")
  {-, ((modm, xK_t), spawn "thunderbird")-}
  {-, ((0, xF86XK_AudioPlay), spawn "cmus-remote -u")-}
  {-, ((0, xF86XK_AudioStop), spawn "cmus-remote -s")-}
  {-, ((0, xF86XK_Mail), spawn "cmus-remote --next")-}
  {-, ((0, xF86XK_HomePage), spawn "cmus-remote --prev")-}
  , ((modm, xK_p), spawn "krunner")
  {-, ((modm .|. shiftMask, xK_q), spawn "dbus-send --print-reply --dest=org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout int32:1 int32:0 int32:1")-}
  ]

myManageHook = composeAll . concat $
  [ [ className =? c --> doFloat | c <- myFloats]
  , [ className =? "Firefox" --> doShift "web"]
  , [ title =? "~ : ranger" --> doShift "dolphin"]
  , [ title =? "~ : cmus" --> doShift "music"]
  , [ className =? "konsole" --> doShift "code"]
  , [ className =? "Thunderbird" --> doShift "email"]
  , [ title =? "JDownloader" --> doShift "7"]
  , [ className =? "TelegramDesktop" --> doShift "7"]
  , [ className =? "Skype" --> doShift "6"]
  , [ className =? "Dolphin" --> doShift "dolphin"]
  , [ className =? "Amarok" --> doShift "music"]
  , [ className =? "Xmessage" --> doFloat]
  , [ title =? t --> doFloat | t <- myOtherFloats]
  , [ className =? c --> doIgnore | c <- myIgnores]
  , [ title =? t --> doIgnore | t <- myOtherFloats]
  , [isFullscreen --> doFullFloat]
  , [isDialog --> doCenterFloat]
  ] where

    myFloats = ["Canvas", "XBoard", "Gimp", "R_x11", "ij-ImageJ", "plasmashell"]
    myOtherFloats = []
    myIgnores = [] --["Qt-subapplication","Plasma"]
    myOtherIgnores = []

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad kde4Config {
        terminal = "konsole"
            , keys     = \c -> myKeys c `M.union` keys kde4Config c
            , modMask = mod4Mask
            , startupHook = startup
            , layoutHook = avoidStruts $ myLayout
            , manageHook = myManageHook <+> ((className =? "krunner") >>= return . not --> manageHook kde4Config) <+> (kdeOverride --> doFloat)
            , workspaces = myWorkspaces
            , focusedBorderColor = myFocusedBorderColor
            , borderWidth = myBorderWidth
    }

startup :: X()
startup = do
    setWMName "LG3D"

kdeOverride :: Query Bool
kdeOverride = ask >>= \w -> liftX $ do
    override <- getAtom "_KDE_NET_WM_WINDOW_TYPE_OVERRIDE"
    wt <- getProp32s "_NET_WM_WINDOW_TYPE" w
    return $ maybe False (elem $ fromIntegral override) wt
