MODULE=OCBNET::SourceMap::XS PACKAGE=OCBNET::SourceMap::XS::LineMap

SourceMap::LineMapSP
new( CLASS )
    const char*              CLASS
  CODE:
    RETVAL = create_row();
    check_error();
  OUTPUT: RETVAL

void
DESTROY( THIS )
    SourceMap::LineMapSP     THIS
  PROTOTYPE: $
  CODE:
    destroy_row(THIS);
    check_error();
  OUTPUT:

SV*
equals(lobj, robj, swap)
    SourceMap::LineMapSP     lobj
    SourceMap::LineMapSP     robj
    IV                       swap
  PROTOTYPE: $$;$
  CODE:
    RETVAL = (lobj.get() == robj.get())
             ? &PL_sv_yes : &PL_sv_no;
  OUTPUT: RETVAL

size_t
refcnt ( THIS )
    SourceMap::LineMapSP     THIS
  CODE:
#ifdef PANDA_REFCNT
    RETVAL = THIS->refcnt();
#else
    RETVAL = THIS.use_count();
#endif
  OUTPUT: RETVAL

size_t
getEntryCount( THIS )
    SourceMap::LineMapSP     THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->getEntryCount();
  OUTPUT: RETVAL

SourceMap::ColMapSP
getColMap( THIS, idx )
    SourceMap::LineMapSP     THIS
    size_t                   idx
  PROTOTYPE: $$
  CODE:
    const char* CLASS = "OCBNET::SourceMap::XS::ColMap";
    RETVAL = get_colmap(THIS, idx);
    check_error();
  OUTPUT: RETVAL

void
addEntry( THIS, entry )
    SourceMap::LineMapSP     THIS
    SourceMap::ColMapSP      entry
  PROTOTYPE: $$
  CODE:
    add_entry(THIS, entry);
    check_error();