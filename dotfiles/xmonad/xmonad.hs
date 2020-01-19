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
import XMonad.Layout
import XMonad.Layout.Reflect
import XMonad.Layout.OneBig
import XMonad.Layout.LayoutScreens



myLayout = Full |||  OneBig (2/3) (2/3)

myWorkspaces = ["web","email","code","music","5","6","7","dolphin","9"]

myFocusedBorderColor = "#66ff66"
myBorderWidth = 1

myKeys (XConfig {modMask = modm}) = M.fromList $ [
  ((modm, xK_p), spawn "krunner")
  , ((modm .|. shiftMask,                 xK_space), layoutScreens 4 (reflectVert $ reflectHoriz $ OneBig (2/3) (2/3)))
  , ((modm .|. controlMask .|. shiftMask, xK_space), rescreen)
  ]

myManageHook = composeAll . concat $
  [ [ className =? c --> doFloat | c <- myFloats]
  , [ className =? "Firefox" --> doShift "web"]
  , [ title =? "~ : cmus" --> doShift "music"]
  , [ className =? "konsole" --> doShift "code"]
  , [ className =? "Thunderbird" --> doShift "email"]
  , [ title =? "JDownloader" --> doShift "7"]
  , [ className =? "TelegramDesktop" --> doShift "7"]
  , [ className =? "Skype" --> doShift "6"]
  , [ className =? "dolphin" --> doShift "dolphin"]
  , [ className =? "Amarok" --> doShift "music"]
  , [ className =? "Xmessage" --> doFloat]
  , [ title =? t --> doFloat | t <- myOtherFloats]
  , [ className =? c --> doIgnore | c <- myIgnores]
  , [ title =? t --> doIgnore | t <- myOtherFloats]
  , [isFullscreen --> doFullFloat]
  , [isDialog --> doCenterFloat]
  ] where

    myFloats = ["Canvas", "XBoard", "gimp", "Gimp", "R_x11", "ij-ImageJ", "plasmashell"]
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

