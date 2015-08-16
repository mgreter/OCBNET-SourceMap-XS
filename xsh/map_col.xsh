MODULE=OCBNET::SourceMap::XS PACKAGE=OCBNET::SourceMap::XS::ColMap

SourceMap::ColMapSP
new( CLASS, col=NO_INIT, src_idx=NO_INIT, src_ln=NO_INIT, src_col=NO_INIT, tkn_idx=NO_INIT )
    const char*              CLASS
    size_t                   col
    size_t                   src_idx
    size_t                   src_ln
    size_t                   src_col
    size_t                   tkn_idx
  PROTOTYPE: $;$$$$$
  CODE:
    if (items == 1)
      RETVAL = create_entry();
    else if (items == 2)
      RETVAL = create_entry(col);
    else if (items == 5)
      RETVAL = create_entry(col, src_idx, src_ln, src_col);
    else if (items == 6)
      RETVAL = create_entry(col, src_idx, src_ln, src_col, tkn_idx);
    else
      croak_xs_usage(cv, "CLASS, [col, [src_idx, src_ln, src_col, [tkn_idx]]]");
    check_error();
  OUTPUT: RETVAL

void
DESTROY( THIS )
    SourceMap::ColMapSP       THIS
  CODE:
    // destroy_entry(THIS);
    check_error();
  OUTPUT:

size_t
refcnt ( THIS )
    SourceMap::ColMapSP       THIS
  CODE:
#ifdef PANDA_REFCNT
    RETVAL = THIS->refcnt();
#else
    RETVAL = THIS.use_count();
#endif
  OUTPUT: RETVAL

size_t
getType( THIS )
    SourceMap::ColMapSP       THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->getType();
  OUTPUT: RETVAL

size_t
getCol( THIS )
    SourceMap::ColMapSP       THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->getCol();
  OUTPUT: RETVAL

size_t
getSource( THIS )
    SourceMap::ColMapSP       THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->getSource();
  OUTPUT: RETVAL

size_t
getSrcLine( THIS )
    SourceMap::ColMapSP       THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->getSrcLine();
  OUTPUT: RETVAL

size_t
getSrcCol( THIS )
    SourceMap::ColMapSP       THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->getSrcCol();
  OUTPUT: RETVAL

size_t
getToken( THIS )
    SourceMap::ColMapSP       THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->getToken();
  OUTPUT: RETVAL


void
setType( THIS, type )
    SourceMap::ColMapSP       THIS
    size_t                   type
  PROTOTYPE: $$
  CODE:
    THIS->setType(type);

void
setCol( THIS, col )
    SourceMap::ColMapSP       THIS
    size_t                   col
  PROTOTYPE: $$
  CODE:
    THIS->setCol(col);

void
setSource( THIS, src_idx )
    SourceMap::ColMapSP       THIS
    size_t                   src_idx
  PROTOTYPE: $$
  CODE:
    THIS->setSource(src_idx);

void
setSrcLine( THIS, src_ln )
    SourceMap::ColMapSP       THIS
    size_t                   src_ln
  PROTOTYPE: $$
  CODE:
    THIS->setSrcLine(src_ln);

void
setSrcCol( THIS, src_col )
    SourceMap::ColMapSP       THIS
    size_t                   src_col
  PROTOTYPE: $$
  CODE:
    THIS->setSrcCol(src_col);

void
setToken( THIS, tkn_idx )
    SourceMap::ColMapSP       THIS
    size_t                   tkn_idx
  PROTOTYPE: $$
  CODE:
    THIS->setToken(tkn_idx);


size_t
type( THIS, type=NO_INIT )
    SourceMap::ColMapSP       THIS
    size_t                   type
  PROTOTYPE: $;$
  CODE:
    if (items > 1)
      THIS->setType( type );
    RETVAL = THIS->getType();
  OUTPUT: RETVAL

size_t
col( THIS, col=NO_INIT )
    SourceMap::ColMapSP       THIS
    size_t                   col
  PROTOTYPE: $;$
  CODE:
    if (items > 1)
      THIS->setCol( col );
    RETVAL = THIS->getCol();
  OUTPUT: RETVAL

size_t
source( THIS, src_idx=NO_INIT )
    SourceMap::ColMapSP       THIS
    size_t                   src_idx
  PROTOTYPE: $;$
  CODE:
    if (items > 1)
      THIS->setSource( src_idx );
    RETVAL = THIS->getSource();
  OUTPUT: RETVAL

size_t
srcLine( THIS, src_ln=NO_INIT )
    SourceMap::ColMapSP       THIS
    size_t                   src_ln
  PROTOTYPE: $;$
  CODE:
    if (items > 1)
      THIS->setSrcLine( src_ln );
    RETVAL = THIS->getSrcLine();
  OUTPUT: RETVAL

size_t
srcCol( THIS, src_col=NO_INIT )
    SourceMap::ColMapSP       THIS
    size_t                   src_col
  PROTOTYPE: $;$
  CODE:
    if (items > 1)
      THIS->setSrcCol( src_col );
    RETVAL = THIS->getSrcCol();
  OUTPUT: RETVAL

size_t
token( THIS, tkn_idx=NO_INIT )
    SourceMap::ColMapSP       THIS
    size_t                   tkn_idx
  PROTOTYPE: $;$
  CODE:
    if (items > 1)
      THIS->setToken( tkn_idx );
    RETVAL = THIS->getToken();
  OUTPUT: RETVAL
