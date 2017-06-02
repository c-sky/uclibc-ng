#include <features.h>
#if defined(__CSKY__) && (__CSKY__==2)
# if defined ( __cskyabiv2__ )
#  include "cskyv2/abiv2_strcpy.S"
# else
#  include "cskyv2/strcpy.S"
# endif
# else
#  include "cskyv1/strcpy.S"
# endif
