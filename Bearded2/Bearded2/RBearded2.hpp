// ----------------------------------------------------------------------------
// RBearded2.hpp
// ----------------------------------------------------------------------------

#ifndef __RBearded2_HPP__
#define __RBearded2_HPP__


#include "DBearded2.hpp"


// ----------------------------------------------------------------------------

class RBearded2 : public DBearded2
{
protected:
  /* AD_LIBNAME Bearded2 */
  /* AD_ALIAS RBd=RIBearded2, DBearded2 */
  /* AUTOINIT */
  /* AUTODEC */

#include "RBd_array_plans.hpp"

public:
  RBearded2(
#include "RBd_constructor_args.hpp"
  );

  virtual ~RBearded2();

};


#endif  //__RBearded2_HPP__
