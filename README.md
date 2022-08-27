# disable-warnings

:warning:
This plugin frequently disables warnings that do _not_ relate to call stacks.
I recommend that you avoid this plugin and use the appropriate GHC warnings flags (like `-Wno-redundant-constraints`) instead.

This is a small GHC plugin to disable warnings related to call stacks.
When using the [haskell-stack-trace-plugin](https://hackage.haskell.org/package/haskell-stack-trace-plugin) plugin,
it's very common to get unnecessary warnings.
Things like duplicate constraints, redundant constraints, and unused imports.
It would be relatively difficult to avoid generating these warnings.
This plugin simply removes the warnings after they've been generated.
It's not very robust, but it works.
Currently it only works with GHC 9.0,
but that limitation could easily be lifted.
