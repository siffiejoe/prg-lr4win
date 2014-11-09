#ifndef LUACONFEXT_H_
#define LUACONFEXT_H_

/* Customizations appended to luaconf.h */

#ifdef liolib_c
/* large file support */
#  include <io.h>
#  define l_fseek(f,o,w) (_lseeki64(_fileno(f),o,w)<0?-1:0)
#  define l_ftell(f) _telli64(_fileno(f))
#  define l_seeknum __int64
#endif /* liolib_c */

#endif /* LUACONFEXT_H_ */

