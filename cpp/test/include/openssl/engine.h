#ifndef ENGINE_STUB_H
#define ENGINE_STUB_H

#ifndef NULL
  #define NULL (0)
#endif

typedef void* ENGINE;

#ifdef  __cplusplus
extern "C" {
#endif

ENGINE *ENGINE_by_id(const char *id){ return NULL; }

int ENGINE_init(ENGINE *e) { return 1; }

int ENGINE_set_default(ENGINE *e, unsigned int flags) { return 1; }

# ifdef  __cplusplus
}
#endif

#endif
