MODULE=OCBNET::SourceMap::XS PACKAGE=OCBNET::SourceMap::XS::Mappings

SourceMap::MappingsSP
new( CLASS, version=3 )
    const char*              CLASS
    size_t                   version
  PROTOTYPE: $;$
  CODE:
    RETVAL = create_mapping(version);
    check_error();
  OUTPUT: RETVAL

void
DESTROY( THIS )
    SourceMap::MappingsSP     THIS
  PROTOTYPE: $
  CODE:
    destroy_mapping(THIS);
    check_error();
  OUTPUT:

size_t
refcnt ( THIS )
    SourceMap::MappingsSP     THIS
  CODE:
#ifdef PANDA_REFCNT
    RETVAL = THIS->refcnt();
#else
    RETVAL = THIS.use_count();
#endif
  OUTPUT: RETVAL

void
addNewLine( THIS, len = 0 )
    SourceMap::MappingsSP     THIS
    size_t                   len
  PROTOTYPE: $;$
  CODE:
    THIS->addNewLine(len);

size_t
getRowCount( THIS )
    SourceMap::MappingsSP     THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->getRowCount();
  OUTPUT: RETVAL

size_t
getLastRowSize( THIS )
    SourceMap::MappingsSP     THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->getLastRowSize();
  OUTPUT: RETVAL

SourceMap::LineMapSP
getLineMap( THIS, idx )
    SourceMap::MappingsSP     THIS
    size_t                   idx
  PROTOTYPE: $$
  CODE:
    const char* CLASS = "OCBNET::SourceMap::XS::LineMap";
    RETVAL = get_linemap(THIS, idx);
    check_error();
  OUTPUT: RETVAL

