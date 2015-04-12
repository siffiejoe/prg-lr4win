#!/usr/bin/env lua

local LR4WIN = assert( arg[ 1 ], "no root directory specified!" )
local nu_root = LR4WIN..[[\nu\packages]]
local nu_include = LR4WIN..[[\nu\include]]
local nu_lib = LR4WIN..[[\nu\lib]]
local preferred_runtime = "MSVCRT"

local lfs = require( "lfs" )
local pe = require( "pe-parser" )
local unpack = assert( table.unpack or unpack )
local SEP = assert( package.config:match( "^(.-)\n" ) )
local PRUNE, BAIL = {}, {}


local function collect( v, ... )
  if v == BAIL then
    return v, { n = select( '#', ... ), ... }
  else
    return v
  end
end

local function scandir( root, rpath, path, f )
  for name in lfs.dir( path ) do
    if name ~= "." and name ~= ".." then
      local npath = path..SEP..name
      local nrpath = rpath and rpath..SEP..name or name
      local mode, err = lfs.symlinkattributes( npath, "mode" )
      if mode == nil then
        return BAIL, { n=2, nil, err }
      end
      local ret, vals = collect( f( npath, mode, root, nrpath, name ) )
      if ret == BAIL then
        return ret, vals
      elseif mode == "directory" and ret ~= PRUNE then
        ret, vals = scandir( root, nrpath, npath, f )
        if ret == BAIL then
          return ret, vals
        end
      end
    end
  end
end

local function filewalk( root, f )
  local ret, vals = scandir( root, nil, root, f )
  if ret == BAIL then
    return unpack( vals, 1, vals.n )
  end
  return true
end


-- copy a single file named `from` to `to` (also a file name)
local function copyfile( from, to )
  local fromf, err = io.open( from, "rb" )
  if not fromf then
    return nil, err
  end
  local tof, err = io.open( to, "wb" )
  if not tof then
    fromf:close()
    return nil, err
  end
  local data = fromf:read( 4096 )
  while data do
    tof:write( data )
    data = fromf:read( 4096 )
  end
  tof:close()
  fromf:close()
  return true
end


-- recursive copy function (for include directories)
local function copydir( from, to )
  local function copyhandler( path, mode, root, rpath, name )
    if mode == "directory" then
      local topath = to..SEP..rpath
      local tomode, err = lfs.symlinkattributes( topath, "mode" )
      if tomode ~= "directory" then
        local ret, err = lfs.mkdir( topath )
        if not ret then
          return BAIL, ret, err
        end
      end
    elseif mode == "file" then
      local ret, err = copyfile( path, to..SEP..rpath )
      if not ret then
        return BAIL, ret, err
      end
    end
  end
  return filewalk( from, copyhandler )
end


-- check whether a file exists (can be opened)
local function fileexists( name )
  local f = io.open( name, "rb" )
  if f then
    f:close()
    return true
  end
  return false
end


-- return the set of all subdirectories in a path
local function subdirset( path )
  local t, i = {}, 1
  for sd in path:gmatch( "[^"..SEP.."]+" ) do
    t[ sd ], i = i, i+1
  end
  return t
end


local dlls = {}
local function pathhandler( path, mode, root, rpath, name )
  if mode == "file" then
    local ext = name:sub( -4 ):lower()
    if ext == ".dll" and not fileexists( nu_lib..SEP..name ) then
      local info, err = pe.parse( path )
      if not info then
        io.stderr:write( "Warning: Could not analyze '", path, "': ",
                         err, "\n" )
      elseif info.Machine then
        if pe.const.Machine[ info.Machine ] == "IMAGE_FILE_MACHINE_I386" then
          local darray = dlls[ name ] or {}
          darray[ #darray+1 ] = {
            path = path,
            dirset = subdirset( rpath ),
            msvcrt = pe.msvcrt( path ),
            info = info
          }
          dlls[ name ] = darray
        end
      end
    end
  elseif mode == "directory" and name == "include" then
    -- recursively copy contents to `nu_include`
    print( "Copying files from '"..path.."' to '"..nu_include.."' ..." )
    local res, err = copydir( path, nu_include )
    if not res then
      return BAIL, res, err
    end
    return PRUNE -- do not recurse into 'include' directory
  end
end

-- copy include files and collect all new DLLs (for i386) in the
-- nuget packages directory
assert( filewalk( nu_root, pathhandler ) )


-- check whether any value in a table fulfills the given predicate
local function any( t, pred )
  for _,v in pairs( t ) do
    if pred( v ) then return true end
  end
  return false
end

-- remove all values from a table that don't fulfill the predicate
local function remove_if_not( array, pred )
  for k,v in pairs( array ) do
    if not pred( v ) then array[ k ] = nil end
  end
end


local function has_msvcrt( dllinfo )
  return dllinfo.msvcrt
end

local function has_preferred_runtime( dllinfo )
  return dllinfo.msvcrt == preferred_runtime
end

local function is_native( dllinfo )
  return dllinfo.dirset.native
end


local function values( t )
  local a, i = {}, 1
  for _,v in pairs( t ) do
    a[ i ] = v
    i = i+1
  end
  return a
end

local function keys( t )
  local a, i = {}, 1
  for k in pairs( t ) do
    a[ i ] = k
    i = i+1
  end
  return a
end


local function prompt( p, opts )
  io.write( p, "\n" )
  for i,o in ipairs( opts ) do
    io.write( ("%2u) %s\n"):format( i, o.prompt ) )
  end
  io.write( " 0) none\n" )
  local i
  repeat
    io.write( "> " )
    local l = io.read( '*l' )
    if l then
      i = tonumber( l:match( "%d+" ) )
    else
      i = 0
    end
  until i and i >= 0 and i <= #opts
  if i > 0 then
    return opts[ i ].value
  else
    return nil
  end
end


for dll,data in pairs( dlls ) do
  -- if at least one of the DLLs is linked to a MSVCRT, remove all
  -- that are not (this takes care of DEBUG versions)
  if any( data, has_msvcrt ) then
    remove_if_not( data, has_msvcrt )
  end
  -- if at least one of the DLLs is linked to the preferred runtime
  -- version, remove all candidates not linked to that version
  if any( data, has_preferred_runtime ) then
    remove_if_not( data, has_preferred_runtime )
  end
  -- if at least one of the DLLs has a `native` directory in its path,
  -- remove all candidates that don't have
  if any( data, is_native ) then
    remove_if_not( data, is_native )
  end
  -- select lowest MSVCRT version available and remove all candidates
  --   with a higher version
  local lowest_msvcrt
  for _,data in pairs( data ) do
    if lowest_msvcrt == nil then
      lowest_msvcrt = data.msvcrt
    else
      if lowest_msvcrt > data.msvcrt then
        lowest_msvcrt = data.msvcrt
      end
    end
  end
  remove_if_not( data, function( dllinfo )
    return dllinfo.msvcrt == lowest_msvcrt
  end )
  -- if there's still more than one candidate left, we need help
  -- from the user, so we ask him/her and provide the non-common
  -- subdirectory names as hints.
  local candidates = values( data )
  local d
  if #candidates <= 1 then
    d = candidates[ 1 ].path
  else
    -- eliminate the common subdirectory names
    for dname in pairs( candidates[ 1 ].dirset ) do
      local remove_dname = true
      for i = 2, #candidates do
        if not candidates[ i ].dirset[ dname ] then
          remove_dname = false
          break
        end
      end
      if remove_dname then
        for i = 1, #candidates do
          candidates[ i ].dirset[ dname ] = nil
        end
      end
    end
    -- collect options
    local options = {}
    for i,c in ipairs( candidates ) do
      local tags = keys( c.dirset )
      table.sort( tags, function( a, b )
        return c.dirset[ a ] < c.dirset[ b ]
      end )
      options[ i ] = {
        prompt = table.concat( tags, ", " ),
        value = c.path
      }
    end
    d = prompt( "Multiple variants of '"..dll.."' available. Choose one:",
                options )
  end
  -- copy selected DLL to `nu_lib`
  if d ~= nil then
    print( "Copying DLL '"..d.."' to '"..nu_lib.."' ..." )
    local ret, err = copyfile( d, nu_lib..SEP..dll )
    if not ret then
      io.stderr:write( "Warning: Could not copy '", d, "': ", err, "\n" )
    end
  end
end
print( "Done." )

