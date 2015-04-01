local LR4WIN = [===[@@DIR@@]===]
rocks_trees = {
  { name = [[system]], root = LR4WIN..[[\luarocks]] },
}
variables = {
  MSVCRT = 'm',
  LUALIB = 'lua51.dll',
  SEVENZ = LR4WIN..[[\tools\7z.exe]],
  CP = LR4WIN..[[\tools\cp.exe]],
  FIND = LR4WIN..[[\tools\find.exe]],
  LS = LR4WIN..[[\tools\ls.exe]],
  MD5SUM = LR4WIN..[[\tools\md5sum.exe]],
  MKDIR = LR4WIN..[[\tools\mkdir.exe]],
  MV = LR4WIN..[[\tools\mv.exe]],
  PWD = LR4WIN..[[\tools\pwd.exe]],
  RMDIR = LR4WIN..[[\tools\rmdir.exe]],
  TEST = LR4WIN..[[\tools\test.exe]],
  UNAME = LR4WIN..[[\tools\uname.exe]],
  WGET = LR4WIN..[[\tools\wget.exe]],
}
external_deps_dirs = { LR4WIN..[[\3rdparty]], LR4WIN..[[\nu]] }
verbose = false

