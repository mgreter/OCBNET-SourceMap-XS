MODULE=OCBNET::SourceMap::XS PACKAGE=OCBNET::SourceMap::XS::SrcMapDoc

SourceMap::SrcMapDocSP
SourceMap::XS::SrcMapDoc::new( json=NO_INIT )
    const char*              json
  PROTOTYPE: $;$
  CODE:
    if (items > 1)
      RETVAL = create_srcmap(json);
    else
      RETVAL = create_srcmap();
    check_error();
  OUTPUT: RETVAL

void
DESTROY( THIS )
    SourceMap::SrcMapDocSP      THIS
  CODE:
    destroy_srcmap(THIS);
    check_error();
  OUTPUT:

size_t
refcnt ( THIS )
    SourceMap::SrcMapDocSP      THIS
  CODE:
#ifdef PANDA_REFCNT
    RETVAL = THIS->refcnt();
#else
    RETVAL = THIS.use_count();
#endif
  OUTPUT: RETVAL

std::string
getFile( THIS )
    SourceMap::SrcMapDocSP      THIS
  CODE:
    RETVAL = THIS->getFile();
  OUTPUT: RETVAL

std::string
getRoot( THIS )
    SourceMap::SrcMapDocSP      THIS
  CODE:
    RETVAL = THIS->getRoot();
  OUTPUT: RETVAL

std::string
getToken( THIS, idx )
    SourceMap::SrcMapDocSP      THIS
    size_t                   idx
  PROTOTYPE: $$
  CODE:
    RETVAL = get_token(THIS, idx);
    check_error();
  OUTPUT: RETVAL

std::string
getSource( THIS, idx )
    SourceMap::SrcMapDocSP      THIS
    size_t                   idx
  PROTOTYPE: $$
  CODE:
    RETVAL = get_source(THIS, idx);
    check_error();
  OUTPUT: RETVAL

std::string
getContent( THIS, idx )
    SourceMap::SrcMapDocSP      THIS
    size_t                   idx
  PROTOTYPE: $$
  CODE:
    RETVAL = get_content(THIS, idx);
    check_error();
  OUTPUT: RETVAL

size_t
getRowSize( THIS )
    SourceMap::SrcMapDocSP      THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->getRowSize();
  OUTPUT: RETVAL

size_t
getTokenSize( THIS )
    SourceMap::SrcMapDocSP      THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->getTokenSize();
  OUTPUT: RETVAL

size_t
getSourceSize( THIS )
    SourceMap::SrcMapDocSP      THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->getSourceSize();
  OUTPUT: RETVAL

char*
serialize( THIS )
    SourceMap::SrcMapDocSP      THIS
  PROTOTYPE: $
  CODE:
    RETVAL = THIS->serialize(true);
  OUTPUT: RETVAL

void
insert( THIS, row, entry, after=false )
    SourceMap::SrcMapDocSP      THIS
    size_t                   row
    SourceMap::ColMapSP       entry
    bool                     after
  PROTOTYPE: $$$;$
  CODE:
    THIS->insert(row, entry, after);

SourceMap::MappingsSP
getMap( THIS )
    SourceMap::SrcMapDocSP      THIS
  PROTOTYPE: $
  CODE:
    const char* CLASS = "OCBNET::SourceMap::XS::Mappings";
    RETVAL = THIS->getMap();
  OUTPUT: RETVAL

void
remap( THIS, srcmap )
    SourceMap::SrcMapDocSP      THIS
    SourceMap::SrcMapDocSP      srcmap
  PROTOTYPE: $$
  CODE:
    remap(THIS, srcmap);

