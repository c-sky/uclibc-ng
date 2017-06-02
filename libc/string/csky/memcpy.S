#include <features.h>
#if defined(__CSKY__) && (__CSKY__==2)
# if defined ( __cskyabiv2__ )
#  include "cskyv2/abiv2_memcpy.S"
# else
#  include "cskyv2/memcpy.S"
# endif
# else
#  include "cskyv1/memcpy.S"
# endif
