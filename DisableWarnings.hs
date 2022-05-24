module DisableWarnings where

import qualified Data.List as List
import qualified GHC.Data.Bag as Bag
import qualified GHC.Data.IOEnv as IOEnv
import qualified GHC.Plugins as Plugins
import qualified GHC.Tc.Types as Tc
import qualified GHC.Utils.Error as Error

plugin :: Plugins.Plugin
plugin = Plugins.defaultPlugin
  { Plugins.pluginRecompile = Plugins.purePlugin
  , Plugins.typeCheckResultAction = \_ _ _ -> do
    env <- IOEnv.getEnv
    let var = Tc.tcl_errs $ Tc.env_lcl env
    (warnings, errors) <- IOEnv.readMutVar var
    IOEnv.writeMutVar var (Bag.filterBag shouldKeep warnings, errors)
    pure $ Tc.env_gbl env
  }

shouldKeep :: Error.WarnMsg -> Bool
shouldKeep msgEnvelope =
  let shown = show msgEnvelope
  in
    case Error.errMsgReason msgEnvelope of
      Plugins.Reason Plugins.Opt_WarnDuplicateConstraints ->
        notInfixOf "HasCallStack" shown
      Plugins.Reason Plugins.Opt_WarnRedundantConstraints ->
        notInfixOf "HasCallStack" shown
      Plugins.Reason Plugins.Opt_WarnUnusedImports ->
        notInfixOf "GHC.Stack" shown
      _ -> True

notInfixOf :: Eq a => [a] -> [a] -> Bool
notInfixOf x = not . List.isInfixOf x
