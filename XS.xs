// Copyright © 2015 Marcel Greter.
//
// This library is free software; you can redistribute it and/or modify
// it under the same terms as Perl itself, either Perl version 5.12.4 or,
// at your option, any later version of Perl 5 you may have available.

#if defined(COMPILER_GCC)
#define NOINLINE __attribute__((noinline))
#elif defined(COMPILER_MSVC)
#define NOINLINE __declspec(noinline)
#else
#define NOINLINE
#endif

#ifdef __cplusplus
extern "C" {
#endif
  #include "EXTERN.h"
  #include "perl.h"
  #define NO_XSLOCKS
  #include "XSUB.h"
#ifdef __cplusplus
}
#endif

#include "ppport.h"

#include <exception>
#include <stdexcept>
#include "sourcemap.hpp"
#include "document.hpp"
#include "mappings.hpp"

// add typedefs, not sure why perl doesn't add this?
typedef std::string              std__string;
typedef SourceMap::SrcMapDoc     SourceMap__SrcMapDoc;
typedef SourceMap::Mappings      SourceMap__Mappings;
typedef SourceMap::ColMap        SourceMap__ColMap;
typedef SourceMap::LineMap       SourceMap__LineMap;
typedef SourceMap::SrcMapPos     SourceMap__SrcMapPos;
typedef SourceMap::SrcMapIdx     SourceMap__SrcMapIdx;

typedef SourceMap::ColMapSP      SourceMap__ColMapSP;
typedef SourceMap::LineMapSP     SourceMap__LineMapSP;
typedef SourceMap::MappingsSP    SourceMap__MappingsSP;
typedef SourceMap::SrcMapDocSP   SourceMap__SrcMapDocSP;


SV* cpp_error = 0;

static inline void handle_error()
{
  try {
    throw;
  }
  catch (std::exception& e) {
    if (cpp_error) sv_2mortal(cpp_error);
    cpp_error = newSVpvf("Caught C++ exception of type or derived from 'std::exception': %s", e.what());
  }
  catch (...) {
    if (cpp_error) sv_2mortal(cpp_error);
    cpp_error = newSVpvf("Caught C++ exception of unknown type");
  }
}

static inline void check_error()
{
  if (cpp_error) {
    croak(SvPV_nolen(sv_2mortal(cpp_error)));
  }
}

// inlining breaks at least on windows, since any thrown exceptions will
// trigger undefined behavior for setjmp()/longjmp() and stack unwinding

NOINLINE SourceMap::SrcMapDocSP create_srcmap()
{
  try { return SourceMap::make_shared<SourceMap::SrcMapDoc>(); }
  catch (...) { handle_error(); }
}

NOINLINE SourceMap::SrcMapDocSP create_srcmap(const char* json)
{
  try { return SourceMap::make_shared<SourceMap::SrcMapDoc>(json); }
  catch (...) { handle_error(); }
}

NOINLINE const std::string get_token(SourceMap::SrcMapDocSP srcmap, size_t idx)
{
  try { return srcmap->getToken(idx); }
  catch (...) { handle_error(); }
}

NOINLINE const std::string get_source(SourceMap::SrcMapDocSP srcmap, size_t idx)
{
  try { return srcmap->getSource(idx); }
  catch (...) { handle_error(); }
}

NOINLINE const std::string get_content(SourceMap::SrcMapDocSP srcmap, size_t idx)
{
  try { return srcmap->getContent(idx); }
  catch (...) { handle_error(); }
}

NOINLINE void destroy_srcmap(SourceMap::SrcMapDocSP srcmap)
{
  try { /* delete srcmap; */ }
  catch (...) { handle_error(); }
}

NOINLINE SourceMap::MappingsSP create_mapping(size_t version)
{
  try { return SourceMap::make_shared<SourceMap::Mappings>(version); }
  catch (...) { handle_error(); }
}

NOINLINE void destroy_mapping(SourceMap::MappingsSP mapping)
{
  try { /* delete mapping; */ }
  catch (...) { handle_error(); }
}

NOINLINE SourceMap::LineMapSP create_row()
{
  try { return SourceMap::make_shared<SourceMap::LineMap>(); }
  catch (...) { handle_error(); }
}

NOINLINE void destroy_row(SourceMap::LineMapSP row)
{
  try { /* delete row; */ }
  catch (...) { handle_error(); }
}

NOINLINE SourceMap::ColMapSP create_entry()
{
  try { return SourceMap::make_shared<SourceMap::ColMap>(); }
  catch (...) { handle_error(); }
}

NOINLINE SourceMap::ColMapSP create_entry(size_t col)
{
  try { return SourceMap::make_shared<SourceMap::ColMap>(col); }
  catch (...) { handle_error(); }
}

NOINLINE SourceMap::ColMapSP create_entry(size_t col, size_t src_idx, size_t src_ln, size_t src_col)
{
  try { return SourceMap::make_shared<SourceMap::ColMap>(col, src_idx, src_ln, src_col); }
  catch (...) { handle_error(); }
}

NOINLINE SourceMap::ColMapSP create_entry(size_t col, size_t src_idx, size_t src_ln, size_t src_col, size_t tkn_idx)
{
  try { return SourceMap::make_shared<SourceMap::ColMap>(col, src_idx, src_ln, src_col, tkn_idx); }
  catch (...) { handle_error(); }
}

NOINLINE void destroy_entry(SourceMap::ColMapSP entry)
{
  try { /* delete entry; */ }
  catch (...) { handle_error(); }
}

NOINLINE SourceMap::LineMapSP get_linemap(SourceMap::MappingsSP map, size_t idx)
{
  try { return map->getLineMap(idx); }
  catch (...) { handle_error(); }
}

NOINLINE const SourceMap::ColMapSP get_colmap(SourceMap::LineMapSP row, size_t idx)
{
  try { return row->getColMap(idx); }
  catch (...) { handle_error(); }
}

NOINLINE void add_entry(SourceMap::LineMapSP line, SourceMap::ColMapSP entry)
{
  try { line->addEntry(entry); }
  catch (...) { handle_error(); }
}

NOINLINE void remap(SourceMap::SrcMapDocSP org, SourceMap::SrcMapDocSP other)
{
  try { org->remap(*other.get()); }
  catch (...) { handle_error(); }
}

SV* linemap_is_eq(SourceMap::LineMapSP lobj, SourceMap::LineMapSP robj, IV swap)
{
  std::cerr << "ASDADSASDASD\n";
  return newSVpv("asdaqwe", 0);
  return lobj.get() == robj.get() ? &PL_sv_yes : &PL_sv_yes;
}

/* ############################################################################ */
/* ############################################################################ */
MODULE=OCBNET::SourceMap::XS

INCLUDE: xsh/document.xsh
INCLUDE: xsh/map_col.xsh
INCLUDE: xsh/map_line.xsh
INCLUDE: xsh/mappings.xsh


