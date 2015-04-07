#ifndef LUACONFEXT_H_
#define LUACONFEXT_H_

/* Customizations appended to luaconf.h */

#ifdef liolib_c
/* large file support */
#  define l_fseek(f,o,w) fseeko64(f,o,w)
#  define l_ftell(f) ftello64(f)
#  define l_seeknum off64_t
#endif /* liolib_c */

#endif /* LUACONFEXT_H_ */

